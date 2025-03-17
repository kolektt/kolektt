// datasource/collection_remote_data_source.dart

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

    List<CollectionRecord> _collectionRecords = response.map<CollectionRecord>((item) {
      final recordId = item['record_id'];
      final recordMap = item['records'];
      if (recordMap != null) {
        recordMap['id'] = recordId;
        return CollectionRecord(
          record: DiscogsRecord(
            id: recordMap['id'] ?? 0,
            title: recordMap['title'] ?? '',
            resourceUrl: '',
            notes: recordMap['notes'] ?? '',
            genre: parseToList(recordMap['genre']).join(", "),
            coverImage: recordMap['cover_image'] ?? '',
            catalogNumber: recordMap['catalog_number'] ?? '',
            label: parseToList(recordMap['label']).join(", "),
            format: parseToList(recordMap['format']).join(", "),
            country: recordMap['country'] ?? '',
            style: parseToList(recordMap['style']).join(", "),
            condition: item['condition'],
            conditionNotes: recordMap['condition_notes'] ?? '',
            recordId: recordMap['record_id'] ?? 0,
            artist: recordMap['artist'] ?? 'Unknown Artist',
            releaseYear: recordMap['release_year'] ?? 0,
          ),
          user_collection: UserCollection.fromJson(item),
        );
      } else {
        return CollectionRecord.sampleData[0];
      }
    }).toList();
    return _collectionRecords;
  }

  List<String> parseToList(dynamic value) {
    if (value is List) {
      return List<String>.from(value);
    } else if (value is String) {
      return [value];
    }
    return [];
  }

  Future<List<CollectionRecord>> filterUserCollection(String userId, UserCollectionClassification classification) async {
    // 기본 쿼리 생성: user_id 기준 필터 및 records 임베딩
    PostgrestFilterBuilder<List<Map<String, dynamic>>> query = supabase
        .from(tableName)
        .select('*, records(*)')
        .eq('user_id', userId.toString());

    // mediaCondition, genre, startYear, endYear, sortOption에 따라 필터링
    // `All`이 아닌 경우에만 필터링
    if (classification.mediaCondition != 'All') {
      query = query.eq('condition', classification.mediaCondition);
    }

    if (classification.genre != 'All') {
      query = query.ilike('records.genre', '%${classification.genre}%');
    }

    if (classification.startYear != 1900) {
      query = query.gte('records.release_year', classification.startYear);
    }

    if (classification.endYear != 2025) {
      query = query.lte('records.release_year', classification.endYear);
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

    // Order by sortOption
      collectionRecords.sort((a, b) {
      switch (classification.sortOption) {
        case '최신순':
          return b.record.releaseYear.compareTo(a.record.releaseYear);
        case '오래된순':
          return a.record.releaseYear.compareTo(b.record.releaseYear);
        case '이름순':
          return a.record.title.compareTo(b.record.title);
        default:
          return 0;
      }
    });
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
