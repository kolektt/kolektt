import 'package:flutter/cupertino.dart';
import 'package:kolektt/data/repositories/collection_repository_impl.dart';
import 'package:kolektt/model/local/collection_record.dart';
import 'package:kolektt/repository/profile_repository.dart';
import 'package:kolektt/repository/sale_repository.dart';

import '../domain/repositories/collection_repository.dart';
import '../model/local/purchase_with_profile.dart';
import '../model/local/sales_listing_with_profile.dart';
import '../repository/purchase_repository.dart';

class ProfileViewModel extends ChangeNotifier {
  CollectionRepository collectionRepository;
  ProfileRepository _profileRepository = ProfileRepository();
  PurchaseRepository _purchaseRepository = PurchaseRepository();
  SaleRepository _saleRepository = SaleRepository();

  List<CollectionRecord> _collectionRecords = [];

  get collectionRecords => _collectionRecords;

  List<PurchaseWithProfile> _myPurchasesWithProfile = [];

  List<PurchaseWithProfile> get myPurchases => _myPurchasesWithProfile;

  SalesListingWithProfile _mySales = SalesListingWithProfile(
    salesListing: [],
    profiles: [],
  );

  SalesListingWithProfile get mySales => _mySales;

  String? _errorMessage;

  String? get errorMessage => _errorMessage;

  bool _isLoading = false;

  bool get isLoading => _isLoading;

  String? _userId;

  ProfileViewModel(
      {required CollectionRepositoryImpl this.collectionRepository}) {
    fetchAll();
  }

  Future<void> fetchAll() async {
    _userId = _profileRepository.getCurrentUserId();
    if (_userId == null) {
      _errorMessage = '사용자 정보를 찾을 수 없습니다.';
      notifyListeners();
      return;
    }
    await Future.wait([
      fetchUserCollectionsWithRecords(),
      fetchMySales(),
      fetchMyPurchases(),
    ]);
    notifyListeners();
  }

  void setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void setErrorMessage(String? message) {
    _errorMessage = message;
    notifyListeners();
  }

  void clearErrorMessage() {
    _errorMessage = null;
    notifyListeners();
  }

  void clearAll() {
    _errorMessage = null;
    _isLoading = false;
    notifyListeners();
  }

  Future<void> fetchUserCollectionsWithRecords() async {
    _isLoading = true;
    notifyListeners();

    try {
      _collectionRecords =
          await collectionRepository.fetchUserCollection(_userId!);
    } catch (e) {
      _errorMessage = '컬렉션을 불러오는 중 오류가 발생했습니다: $e';
      debugPrint('Error fetching user collection: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchMySales() async {
    _isLoading = true;
    notifyListeners();

    try {
      _mySales.salesListing = await _saleRepository.getSaleBySellerId(_userId!);

      // _mySales.salesListing 갯수 만큼 myProfile을 추가
      final myProfile = await _profileRepository.getCurrentProfile();
      _mySales.profiles = List.generate(
        _mySales.salesListing.length,
        (index) => myProfile!,
      );
      debugPrint('fetchMySales: $_mySales');
    } catch (e) {
      _errorMessage = '판매 목록을 불러오는 중 오류가 발생했습니다: $e';
      debugPrint('Error fetching my sales: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> deleteSale(String id) async {
    _isLoading = true;
    notifyListeners();

    try {
      await _saleRepository.deleteSale(id);
      _mySales.salesListing.removeWhere((element) => element.id == id);
    } catch (e) {
      _errorMessage = '판매 목록을 삭제하는 중 오류가 발생했습니다: $e';
      debugPrint('Error deleting my sales: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchMyPurchases() async {
    setLoading(true);

    try {
      final purchase_history =
          await _purchaseRepository.getPurchaseByBuyerId(_userId!);
      for (final purchase in purchase_history) {
        final seller_profile =
            await _profileRepository.getProfileById(purchase.seller_id);
        final buyer_profile =
            await _profileRepository.getProfileById(purchase.buyer_id);

        _myPurchasesWithProfile
            .add(PurchaseWithProfile(purchase, seller_profile, buyer_profile));
      }
    } catch (e) {
      _errorMessage = '구매 목록을 불러오는 중 오류가 발생했습니다: $e';
      debugPrint('Error fetching my purchases: $e');
    } finally {
      setLoading(false);
    }
  }
}
