import '../../data/models/discogs_search_response.dart';

abstract class DiscogsRecordRepository {
  Future<void> addDiscogsRecord(DiscogsSearchItem item);
}