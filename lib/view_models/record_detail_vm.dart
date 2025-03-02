import 'package:flutter/foundation.dart';
import 'package:kolektt/domain/repositories/discogs_repository.dart';
import 'package:kolektt/model/local/sales_listing_with_profile.dart';
import 'package:kolektt/repository/profile_repository.dart';

import '../domain/entities/discogs_record.dart';
import '../model/supabase/sales_listings.dart';
import '../repository/sale_repository.dart';

class RecordDetailViewModel extends ChangeNotifier {
  final DiscogsRepository discogsRepository;
  final SaleRepository _saleRepository = SaleRepository();
  final ProfileRepository _profileRepository = ProfileRepository();

  final String recordResourceUrl;

  DiscogsRecord? detailedRecord;
  bool isLoading = true;
  String? errorMessage;

  bool _fetchingSellers = true;

  bool get fetchingSellers => _fetchingSellers;

  SalesListingWithProfile? _salesListingWithProfile =
      SalesListingWithProfile(salesListing: [], profiles: []);

  SalesListingWithProfile? get salesListingWithProfile => _salesListingWithProfile;

  RecordDetailViewModel(
      {required this.recordResourceUrl, required this.discogsRepository}) {
    fetchRecordDetails(int.parse(recordResourceUrl.split("/").last)).then((_) {
      updateRecordToDb();
      notifyListeners();
    }).then((_) {
      getSellers();
      notifyListeners();
    });
  }

  Future<void> fetchRecordDetails(int id) async {
    try {
      detailedRecord = await discogsRepository.getReleaseById(id);
      debugPrint('Detailed record: $detailedRecord');
      notifyListeners();
    } catch (e) {
      errorMessage = e.toString();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> updateRecordToDb() async {
    // TODO: Supabase로 업데이트하는 로직 추가
    // final supabase = Supabase.instance.client;
    //
    // if (detailedRecord == null) return;
    // // 전체 JSON 생성
    // final detailRecordJson = detailedRecord!.toJson();
    //
    // // cover_image와 format 키 제거
    // detailRecordJson.remove('cover_image');
    // detailRecordJson.remove('format');
    //
    // debugPrint('Updating record (without cover_image and format): $detailRecordJson');
    //
    // final response = await supabase
    //     .from('records')
    //     .update(detailRecordJson)
    //     .eq('record_id', _baseRecord.id);
    //
    // debugPrint('Record updated: $response');
  }

  Future<void> getSellers() async {
    if (detailedRecord == null) return;
    try {
      _fetchingSellers = true;
      notifyListeners();

      List<SalesListing> _salesListing =
          await _saleRepository.getSaleByRecordId(detailedRecord!.id);
      debugPrint("SalesListing: $_salesListing");
      debugPrint("detailedRecord!.id ${_salesListing[0]}");

      if (_salesListing.isEmpty) {
        _fetchingSellers = false;
        notifyListeners();
        return;
      }

      // ProfileRepository를 사용하여 판매자 정보 가져오기
      final sellers_list = _salesListing.map((e) => e.userId).toList();
      debugPrint("Sellers list: $sellers_list");
      final sellers =
          await _profileRepository.getProfilesByUserIds(sellers_list);

      debugPrint("Sellers: $sellers");

      // SalesListing에 판매자 정보 추가한 새 리스트 생성
      _salesListingWithProfile!.salesListing = _salesListing;
      _salesListingWithProfile!.profiles = sellers;
      notifyListeners();

      debugPrint('Sellers item: ${_salesListingWithProfile?.profiles.length}');
    } catch (e) {
      debugPrint('Error getting sellers: $e');
    } finally {
      _fetchingSellers = false;
      notifyListeners();
    }
  }
}
