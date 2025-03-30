// data/repositories/discogs_record_repository_impl.dart
import 'dart:developer';

import '../../domain/repositories/discogs_record_repository.dart';
import '../datasources/record_data_source.dart';
import '../models/discogs_search_response.dart';

class DiscogsRecordRepositoryImpl extends DiscogsRecordRepository {
  final RecordDataSource recordDataSource;

  DiscogsRecordRepositoryImpl({required this.recordDataSource});

  Future<void> addDiscogsRecord(DiscogsSearchItem item) async {
    // DiscogsSearchItem을 Record 형태의 JSON으로 변환
    final recordJson = _convertDiscogsSearchItemToRecordJson(item);
    log("recordJson: $recordJson");
    await recordDataSource.insertRecord(recordJson);
  }

  Map<String, dynamic> _convertDiscogsSearchItemToRecordJson(DiscogsSearchItem item) {
    return {
      "title": item.title,
      "release_year": item.year,
      "genre": item.genre,
      "cover_image": item.coverImage,
      "label": item.label,
      "format": item.format,
      "country": item.country,
      "style": item.style,
      "record_id": item.id,
    };
  }
}
