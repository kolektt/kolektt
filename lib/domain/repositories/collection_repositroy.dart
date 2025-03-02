import '../../model/local/collection_record.dart';

abstract class CollectionRepository {
  Future<List<CollectionRecord>> fetchUserCollection(String userId);
}
