import '../../data/models/discogs_search_response.dart';

abstract class DiscogsStorageRepository {
  /// DiscogsRecord를 Supabase DB에 upsert합니다.
  Future<void> upsertDiscogsRecord(DiscogsSearchItem record);
}
