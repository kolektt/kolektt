// datasource/collection_remote_data_source.dart

import 'package:kolektt/exceptions/data_source_exception.dart';
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
    try {
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
          // records가 null인 경우, 기본 샘플 데이터를 리턴하거나 필요에 따라 예외 발생 처리
          return CollectionRecord.sampleData[0];
        }
      }).toList();
      return _collectionRecords;
    } catch (error) {
      // 여기서 에러 로깅 후 상위 레이어로 의미있는 예외 전달
      throw DataSourceException("Failed to fetch user collection", error);
    }
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
    try {
      // 기본 쿼리 생성: user_id 기준 필터 및 records 임베딩
      PostgrestFilterBuilder<List<Map<String, dynamic>>> query = supabase
          .from(tableName)
          .select('*, records(*)')
          .eq('user_id', userId.toString());

      // mediaCondition, genre, startYear, endYear, sortOption에 따라 필터링
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
                id: int.tryParse(recordJson['id']?.toString() ?? '') ?? 0,
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
                recordId: recordJson['record_id'] as int? ?? 0,
              ),
              user_collection: UserCollection.fromJson(item),
            ),
          );
        }
      }

      // 정렬 옵션에 따른 정렬
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
    } catch (error) {
      throw DataSourceException("Failed to filter user collection", error);
    }
  }

  Future<void> insertUserCollection(Map<String, dynamic> data) async {
    try {
      await supabase.from(tableName).insert(data).maybeSingle();
    } catch (error) {
      throw DataSourceException("Failed to insert user collection", error);
    }
  }

  Future<void> updateUserCollection(UserCollection data) async {
    try {
      await supabase.from(tableName).update(data.toJson()).eq('id', data.id);
    } catch (error) {
      throw DataSourceException("Failed to update user collection", error);
    }
  }

  Future<void> deleteUserCollection(String id) async {
    try {
      await supabase.from(tableName).delete().eq('id', id);
    } catch (error) {
      throw DataSourceException("Failed to delete user collection", error);
    }
  }
}
