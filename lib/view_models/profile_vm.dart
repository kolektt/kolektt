import 'package:flutter/cupertino.dart';
import 'package:kolektt/model/local/collection_record.dart';
import 'package:kolektt/repository/collection_repository.dart';
import 'package:kolektt/repository/profile_repository.dart';
import 'package:kolektt/repository/sale_repository.dart';

import '../model/local/sales_listing_with_profile.dart';

class ProfileViweModel extends ChangeNotifier {
  ProfileRepository _profileRepository = ProfileRepository();
  SaleRepository _saleRepository = SaleRepository();
  CollectionRepository _collectionRepository = CollectionRepository();

  List<CollectionRecord> _collectionRecords = [];

  get collectionRecords => _collectionRecords;

  SalesListingWithProfile _mySales = SalesListingWithProfile(
    salesListing: [],
    profiles: [],
  );

  SalesListingWithProfile get mySales => _mySales;

  String? _errorMessage;

  String? get errorMessage => _errorMessage;

  bool _isLoading = false;

  bool get isLoading => _isLoading;

  ProfileViweModel() {
    fetchUserCollectionsWithRecords();
    fetchMySales();
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
      final userId = _profileRepository.getCurrentUserId();

      _collectionRecords =
          await _collectionRepository.fetchUserCollection(userId);
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
      final userId = _profileRepository.getCurrentUserId();
      _mySales.salesListing = await _saleRepository.getSaleBySellerId(userId);

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
}
