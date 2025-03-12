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
    // Create a map with only the fields that exist in your database schema
    return {
      'title': item.title,
      'release_year': item.year,
      'genre': item.genre ?? '',
      'cover_image': item.coverImage ?? '',
      'label': item.label ?? '',
      'format': item.format ?? '',
      'country': item.country ?? '',
      'style': item.style ?? '',
      'record_id': item.id,
      // Fix: Extract artist name from title or use a default value
      'artist': _extractArtistFromTitle(item.title),
      // Remove or comment out any fields that don't exist in your database
      // 'barcode': item.barcode, // This field is causing the error
    };
  }

  // Helper method to extract artist from title (Format: "Artist - Title")
  String _extractArtistFromTitle(String title) {
    // Check if title contains a hyphen (common format: "Artist - Title")
    if (title.contains(' - ')) {
      return title.split(' - ')[0].trim();
    }
    // If no hyphen, return the whole title or a default value
    return title;
  }
}
