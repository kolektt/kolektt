import '../../model/local/collection_record.dart';

abstract class CollectionRepository {
  Future<List<CollectionRecord>> fetchUserCollection(String userId);
  Future<void> insertUserCollection(Map<String, dynamic> data);
  Future<void> deleteUserCollection(String id);
}
