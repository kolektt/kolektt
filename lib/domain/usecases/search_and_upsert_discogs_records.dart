import '../../data/models/discogs_search_response.dart';
import '../repositories/discogs_repository.dart';
import '../repositories/discogs_storage_repository.dart';

class SearchAndUpsertDiscogsRecords {
  final DiscogsRepository discogsRepository;
  final DiscogsStorageRepository discogsStorageRepository;

  SearchAndUpsertDiscogsRecords({
    required this.discogsRepository,
    required this.discogsStorageRepository,
  });

  Future<List<DiscogsSearchItem>> call(String query, {String? type}) async {
    // Discogs API를 통해 검색 수행
    final results = await discogsRepository.searchDiscogs(query, type: type);
    // 검색 결과를 Supabase에 자동 upsert TODO: 이 부분은 추후 개선이 필요합니다.
    // for (final record in results) {
    //   await discogsStorageRepository.upsertDiscogsRecord(record);
    // }
    return results;
  }
}
