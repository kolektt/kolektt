import '../../data/models/discogs_record.dart' as data;
import '../../data/models/discogs_search_response.dart';
import '../entities/discogs_record.dart';
import '../value_objects/criteria.dart';

abstract class DiscogsRepository {
  Future<List<DiscogsSearchItem>> searchDiscogs(String query, {String? type});

  Future<DiscogsRecord> getReleaseById(int releaseId);

  Future<data.DiscogsRecord> getDomainReleaseById(int releaseId);

  /// 필터와 정렬 조건을 반영하여 DiscogsRecord를 조회합니다.
  Future<List<DiscogsRecord>> getDiscogsRecords({
    DiscogsFilterCriteria? filter,
    DiscogsSortCriteria? sort,
  });
}
