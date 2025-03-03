// data/repositories/discogs_record_repository_impl.dart
import '../../domain/repositories/discogs_record_repository.dart';
import '../datasources/record_data_source.dart';
import '../models/discogs_search_response.dart';

class DiscogsRecordRepositoryImpl extends DiscogsRecordRepository {
  final RecordDataSource recordDataSource;

  DiscogsRecordRepositoryImpl({required this.recordDataSource});

  Future<void> addDiscogsRecord(DiscogsSearchItem item) async {
    // DiscogsSearchItem을 Record 형태의 JSON으로 변환
    final recordJson = _convertDiscogsSearchItemToRecordJson(item);
    await recordDataSource.insertRecord(recordJson);
  }

  Map<String, dynamic> _convertDiscogsSearchItemToRecordJson(
      DiscogsSearchItem item) {
    return item.toJson();
  }
}
