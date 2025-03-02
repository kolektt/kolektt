import '../entities/discogs_record.dart';

abstract class DiscogsStorageRepository {
  /// DiscogsRecord를 Supabase DB에 upsert합니다.
  Future<void> upsertDiscogsRecord(DiscogsRecord record);
}
