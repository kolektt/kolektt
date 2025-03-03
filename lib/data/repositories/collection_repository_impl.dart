// repository/collection_repository_impl.dart
import 'package:flutter/cupertino.dart';
import 'package:kolektt/model/local/collection_record.dart';

import '../../domain/entities/discogs_record.dart';
import '../../domain/repositories/collection_repositroy.dart';
import '../../model/supabase/user_collection.dart';
import '../datasources/collection_remote_data_source.dart';

class CollectionRepositoryImpl implements CollectionRepository {
  final CollectionRemoteDataSource remoteDataSource;

  CollectionRepositoryImpl({required this.remoteDataSource});

  @override
  Future<List<CollectionRecord>> fetchUserCollection(String userId) async {
    final collectionJsonList = await remoteDataSource.fetchUserCollection(userId);

    List<CollectionRecord> _collectionRecords =
        collectionJsonList.map<CollectionRecord>((item) {
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

  @override
  Future<void> insertUserCollection(Map<String, dynamic> data) {
    return remoteDataSource.insertUserCollection(data);
  }
}
