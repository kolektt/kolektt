// repository/collection_repository_impl.dart
import 'package:kolektt/model/local/collection_record.dart';

import '../../domain/repositories/collection_repositroy.dart';
import '../../model/supabase/user_collection.dart';
import '../datasources/collection_remote_data_source.dart';
import '../models/user_collection_classification.dart';

class CollectionRepositoryImpl implements CollectionRepository {
  final CollectionRemoteDataSource remoteDataSource;

  CollectionRepositoryImpl({required this.remoteDataSource});

  @override
  Future<List<CollectionRecord>> fetchUserCollection(String userId) async {
    List<CollectionRecord> _collectionRecords = await remoteDataSource.fetchUserCollection(userId);
    return _collectionRecords;
  }

  @override
  Future<void> insertUserCollection(Map<String, dynamic> data) {
    return remoteDataSource.insertUserCollection(data);
  }

  @override
  Future<void> updateUserCollection(UserCollection data) {
    return remoteDataSource.updateUserCollection(data);
  }

  @override
  Future<void> deleteUserCollection(String id) {
    return remoteDataSource.deleteUserCollection(id);
  }

  @override
  Future<UserCollectionClassification> fetchUniqueProperties(String userId) async {
    List<CollectionRecord> _collectionRecords = await remoteDataSource.fetchUserCollection(userId);
    UserCollectionClassification result = await CollectionRecord.getUniqueProperties(_collectionRecords);

    // 빈 문자열 제거
    result.genres.remove("");
    result.artists.remove("");
    result.labels.remove("");
    return result;
  }

  @override
  Future<List<CollectionRecord>> filterUserCollection(String userId, UserCollectionClassification classification) async {
    return await remoteDataSource.filterUserCollection(userId, classification);
  }
}
