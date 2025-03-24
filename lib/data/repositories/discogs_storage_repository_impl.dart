import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../domain/repositories/discogs_storage_repository.dart';
import '../models/discogs_search_response.dart';

class DiscogsStorageRepositoryImpl implements DiscogsStorageRepository {
  final SupabaseClient supabase;

  DiscogsStorageRepositoryImpl({required this.supabase});

  @override
  Future<void> upsertDiscogsRecord(DiscogsSearchItem record) async {
    debugPrint('upsertDiscogsRecord: ${record.toJson()}');
    final response = await supabase.from('records').upsert({
      'title': record.title,
      'release_year': record.year,
      'genre': record.genre.toList().join(', '),
      'cover_image': record.coverImage,
      'label': record.label.toList().join(', '),
      'format': record.format.toList().join(', '),
      'country': record.country,
      'style': record.style.toList().join(', '),
      'record_id': record.id,
    }, onConflict: 'record_id').select();
  }
}
