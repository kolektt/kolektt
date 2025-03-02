import 'package:supabase_flutter/supabase_flutter.dart';

import '../../domain/entities/discogs_record.dart';
import '../../domain/repositories/discogs_storage_repository.dart';
import '../../domain/value_objects/criteria.dart';

class DiscogsStorageRepositoryImpl implements DiscogsStorageRepository {
  final SupabaseClient supabase;

  DiscogsStorageRepositoryImpl({required this.supabase});

  @override
  Future<void> upsertDiscogsRecord(DiscogsRecord record) async {
    final response = await supabase.from('records').upsert({
      'id': record.id,
      'title': record.title,
      'artist': record.artist,
      'release_year': record.releaseYear,
      'genre': record.genre,
      'cover_image': record.coverImage,
      'catalog_number': record.catalogNumber,
      'label': record.label,
      'format': record.format,
      'country': record.country,
      'style': record.style,
      'condition': record.condition,
      'condition_notes': record.conditionNotes,
      'notes': record.notes,
      'record_id': record.recordId,
      // 필요한 경우 추가 필드를 매핑합니다.
    });
    if (response.error != null) {
      throw Exception('Upsert failed: ${response.error!.message}');
    }
  }
}
