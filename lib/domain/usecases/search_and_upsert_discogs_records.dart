import '../entities/discogs_record.dart';
import '../repositories/discogs_repository.dart';
import '../repositories/discogs_storage_repository.dart';

class SearchAndUpsertDiscogsRecords {
  final DiscogsRepository discogsRepository;
  final DiscogsStorageRepository discogsStorageRepository;

  SearchAndUpsertDiscogsRecords({
    required this.discogsRepository,
    required this.discogsStorageRepository,
  });

  Future<List<DiscogsRecord>> call(String query, {String? type}) async {
    // Discogs API를 통해 검색 수행
    final results = await discogsRepository.searchDiscogs(query, type: type);
    // 검색 결과를 Supabase에 자동 upsert
    for (final record in results) {
      await discogsStorageRepository.upsertDiscogsRecord(record);
    }
    return results;
  }
}
