// repository/collection_repository_impl.dart
import 'package:kolektt/model/local/collection_record.dart';

import '../../domain/entities/collection_entry.dart';
import '../../domain/repositories/collection_repository.dart';
import '../../model/supabase/user_collection.dart';
import '../datasources/collection_remote_data_source.dart';
import '../models/user_collection_classification.dart';

class CollectionRepositoryImpl implements CollectionRepository {
  final CollectionRemoteDataSource remoteDataSource;

  CollectionRepositoryImpl({required this.remoteDataSource});

  @override
  Future<List<CollectionRecord>> fetch(String userId) async {
    List<CollectionRecord> _collectionRecords = await remoteDataSource.fetchUserCollection(userId);
    return _collectionRecords;
  }

  @override
  Future<void> insert(CollectionEntry data) {
    return remoteDataSource.insertUserCollection(data.toJson());
  }

  @override
  Future<void> update(UserCollection data) {
    return remoteDataSource.updateUserCollection(data);
  }

  @override
  Future<void> delete(String id) {
    return remoteDataSource.deleteUserCollection(id);
  }

  @override
  Future<UserCollectionClassification> fetchUniqueProperties(String userId) async {
    List<CollectionRecord> _collectionRecords = await remoteDataSource.fetchUserCollection(userId);
    UserCollectionClassification result = await CollectionRecord.getUniqueProperties(_collectionRecords);

    // 빈 문자열 제거
    result.genres.remove("");
    return result;
  }

  @override
  Future<List<CollectionRecord>> fetchFilter(String userId, UserCollectionClassification classification) async {
    return await remoteDataSource.filterUserCollection(userId, classification);
  }
}
