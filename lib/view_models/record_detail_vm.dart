import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:supabase_flutter/supabase_flutter.dart';
import '../model/discogs_record.dart';
import '../services/discogs_api_service.dart';

class RecordDetailViewModel extends ChangeNotifier {
  final DiscogsRecord baseRecord;
  final DiscogsApiService _apiService = DiscogsApiService();

  DiscogsRecord? detailedRecord;
  bool isLoading = true;
  String? errorMessage;

  RecordDetailViewModel({required this.baseRecord}) {
    fetchRecordDetails().then((_) {
      notifyListeners();
      updateRecordToDb();
    });
  }

  Future<void> fetchRecordDetails() async {
    try {
      // baseRecord의 id를 사용하여 상세 정보 불러오기
      // final record = await _apiService.getRecordDetails(baseRecord.id);
      // detailedRecord = record;

      final uri = Uri.parse(baseRecord.resourceUrl);
      debugPrint('Fetching Discogs record details: $uri');
      final response = await http.get(
        uri,
        headers: {
          'User-Agent': 'MyDiscogsApp/1.0',
          'Content-Type': 'application/json',
        },
      );

      final Map<String, dynamic> data = jsonDecode(response.body);
      detailedRecord = DiscogsRecord.fromJson(data);
      notifyListeners();
    } catch (e) {
      errorMessage = e.toString();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> updateRecordToDb() async {
    final supabase = Supabase.instance.client;

    if (detailedRecord == null) return;
    // 전체 JSON 생성
    final detailRecordJson = detailedRecord!.toJson();

    // cover_image와 format 키 제거
    detailRecordJson.remove('cover_image');
    detailRecordJson.remove('format');

    debugPrint('Updating record (without cover_image and format): $detailRecordJson');

    final response = await supabase
        .from('records')
        .update(detailRecordJson)
        .eq('record_id', baseRecord.id);

    debugPrint('Record updated: $response');
  }
}
