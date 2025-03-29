import '../../data/models/user_collection_classification.dart';
import '../../model/local/collection_record.dart';
import '../../model/supabase/user_collection.dart';

abstract class CollectionRepository {
  Future<List<CollectionRecord>> fetch(String userId);
  Future<void> insert(Map<String, dynamic> data);
  Future<void> update(UserCollection data);
  Future<void> delete(String id);
  Future<UserCollectionClassification> fetchUniqueProperties(String userId);
  Future<List<CollectionRecord>> fetchFilter(String userId, UserCollectionClassification classification);
}
