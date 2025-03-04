// datasource/collection_remote_data_source.dart
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../domain/entities/discogs_record.dart';
import '../../model/local/collection_record.dart';
import '../../model/supabase/user_collection.dart';

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
            id: recordJson['id'],
            title: recordJson['title'],
            resourceUrl: '',
            notes: recordJson['notes'],
            genre: recordJson['genre'],
            coverImage: recordJson['cover_image'],
            catalogNumber: recordJson['catalog_number'],
            label: recordJson['label'],
            format: recordJson['format'],
            country: recordJson['country'],
            style: recordJson['style'],
            condition: recordJson['condition'],
            conditionNotes: recordJson['condition_notes'],
            recordId: recordJson['record_id'],
            artist: recordJson['artist'],
            releaseYear: recordJson['release_year'],
          ),
          user_collection: UserCollection.fromJson(item),
        );
      } else {
        return CollectionRecord.sampleData[0];
      }
    }).toList();
    return _collectionRecords;
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
