import 'dart:developer';

import 'package:supabase_flutter/supabase_flutter.dart';

import '../../domain/repositories/discogs_storage_repository.dart';
import '../models/discogs_search_response.dart';

class DiscogsStorageRepositoryImpl implements DiscogsStorageRepository {
  final SupabaseClient supabase;

  DiscogsStorageRepositoryImpl({required this.supabase});

  @override
  Future<void> upsertDiscogsRecord(DiscogsSearchItem record) async {
    final response = await supabase.from('records').upsert({
      'title': record.title,
      'release_year': record.year,
      'genre': record.genre,
      'cover_image': record.coverImage,
      'label': record.label,
      'format': record.format,
      'country': record.country,
      'style': record.style,
      'record_id': record.id,
    }, onConflict: 'record_id').select();
  }
}
