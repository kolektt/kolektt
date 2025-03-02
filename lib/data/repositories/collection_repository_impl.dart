import 'package:flutter/cupertino.dart';
import 'package:kolektt/model/local/collection_record.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../domain/entities/discogs_record.dart';
import '../../domain/repositories/collection_repositroy.dart';
import '../../model/supabase/user_collection.dart';

class CollectionRepositoryImpl implements CollectionRepository {
  final SupabaseClient supabase;

  CollectionRepositoryImpl({required this.supabase});

  @override
  Future<List<CollectionRecord>> fetchUserCollection(String userId) async {
    final response = await supabase
        .from('user_collections')
        .select('*, records(*)')
        .eq('user_id', userId.toString());

    List<CollectionRecord> _collectionRecords =
        (response as List).map<CollectionRecord>((item) {
      final recordId = item['record_id'];
      final recordJson = item['records'] as Map<String, dynamic>?;
      debugPrint('recordJson: $recordJson');
      if (recordJson != null) {
        recordJson['id'] = recordId;
        return CollectionRecord(
            record: DiscogsRecord(
                id: recordJson['id'],
                title: recordJson['title'],
                resourceUrl: '',
                artists: [],
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
                releaseYear: recordJson['release_year']),
            user_collection: UserCollection.fromJson(item));
      } else {
        return CollectionRecord.sampleData[0];
      }
    }).toList();

    return _collectionRecords;
  }
}
