// datasource/collection_remote_data_source.dart
import 'dart:developer';

import 'package:supabase_flutter/supabase_flutter.dart';

import '../../domain/entities/discogs_record.dart';
import '../../model/local/collection_record.dart';
import '../../model/supabase/user_collection.dart';
import '../models/user_collection_classification.dart';

class CollectionRemoteDataSource {
  static const String tableName = 'user_collections';
  final SupabaseClient supabase;

  CollectionRemoteDataSource({required this.supabase});

  Future<List<CollectionRecord>> fetchUserCollection(String userId) async {
    final response = await supabase
        .from(tableName)
        .select('*, records(*)')
        .eq('user_id', userId.toString());
    List<CollectionRecord> _collectionRecords =
        response.map<CollectionRecord>((item) {
      final recordId = item['record_id'];
      final recordJson = item['records'] as Map<String, dynamic>?;
      if (recordJson != null) {
        recordJson['id'] = recordId;
        return CollectionRecord(
          record: DiscogsRecord(
            id: recordJson['id'] ?? 0,
            title: recordJson['title'] ?? '',
            resourceUrl: '',
            notes: recordJson['notes'] ?? '',
            genre: recordJson['genre'] ?? '',
            coverImage: recordJson['cover_image'] ?? '',
            catalogNumber: recordJson['catalog_number'] ?? '',
            label: recordJson['label'] ?? '',
            format: recordJson['format'] ?? '',
            country: recordJson['country'] ?? '',
            style: recordJson['style'] ?? '',
            condition: recordJson['condition'] ?? '',
            conditionNotes: recordJson['condition_notes'] ?? '',
            recordId: recordJson['record_id'] ?? 0,
            artist: recordJson['artist'] ?? 'Unknown Artist',
            releaseYear: recordJson['release_year'] ?? 0,
          ),
          user_collection: UserCollection.fromJson(item),
        );
      } else {
        return CollectionRecord.sampleData[0];
      }
    }).toList();
    return _collectionRecords;
  }

  Future<List<CollectionRecord>> filterUserCollection(String userId, UserCollectionClassification classification) async {
    // 기본 쿼리 생성: user_id 기준 필터 및 records 임베딩
    var query = supabase
        .from(tableName)
        .select('*, records(*)')
        .eq('user_id', userId.toString());

    // classification에 값이 있을 경우, records 테이블의 컬럼으로 ilike 조건 추가
    if (classification.genres.isNotEmpty) {
      final genreFilter = classification.genres.first;
      // 값이 여러 개 포함될 수 있으므로 ilike 연산자로 부분 일치 처리
      query = query.ilike('records.genre', '%$genreFilter%');
    }

    if (classification.labels.isNotEmpty) {
      final labelFilter = classification.labels.first;
      query = query.ilike('records.label', '%$labelFilter%');
    }

    if (classification.artists.isNotEmpty) {
      final artistFilter = classification.artists.first;
      query = query.ilike('records.artist', '%$artistFilter%');
    }

    final response = await query;

    List<CollectionRecord> collectionRecords = [];
    for (var item in response) {
      final recordId = item['record_id'];
      final recordJson = item['records'] as Map<String, dynamic>?;
      if (recordJson != null) {
        recordJson['id'] = recordId;
        collectionRecords.add(
          CollectionRecord(
            record: DiscogsRecord(
              id: int.tryParse(recordJson['id']?.toString() ?? '') ?? 0,  // Convert to int
              title: recordJson['title'] ?? '',
              artist: recordJson['artist'] ?? 'Unknown Artist',
              releaseYear: recordJson['release_year'] ?? 0,
              resourceUrl: recordJson['resource_url'] ?? '',
              notes: recordJson['notes'] ?? '',
              genre: recordJson['genre'] ?? '',
              coverImage: recordJson['cover_image'] ?? '',
              catalogNumber: recordJson['catalog_number'] ?? '',
              label: recordJson['label'] ?? '',
              format: recordJson['format'] ?? '',
              country: recordJson['country'] ?? '',
              style: recordJson['style'] ?? '',
              condition: recordJson['condition'] ?? '',
              conditionNotes: recordJson['condition_notes'] ?? '',
              recordId: recordJson['record_id'] as int? ?? 0,  // Keep as int
            ),
            user_collection: UserCollection.fromJson(item),
          ),
        );
      }
    }
    return collectionRecords;
  }

  Future<void> insertUserCollection(Map<String, dynamic> data) async {
    await supabase.from(tableName).insert(data).maybeSingle();
  }

  Future<void> updateUserCollection(UserCollection data) async {
    await supabase.from(tableName).update(data.toJson()).eq('id', data.id);
  }

  Future<void> deleteUserCollection(String id) async {
    await supabase.from(tableName).delete().eq('id', id);
  }
}
