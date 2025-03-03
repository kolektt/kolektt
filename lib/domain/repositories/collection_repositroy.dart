import '../../model/local/collection_record.dart';
import '../../model/supabase/user_collection.dart';

abstract class CollectionRepository {
  Future<List<CollectionRecord>> fetchUserCollection(String userId);
  Future<void> insertUserCollection(Map<String, dynamic> data);
  Future<void> updateUserCollection(UserCollection data);
  Future<void> deleteUserCollection(String id);
}
