import 'package:kolektt/model/supabase/user_collection.dart';

import '../discogs/discogs_record.dart';

class CollectionRecord {
  /// 연결된 DiscogsRecord (records 테이블의 데이터)
  final DiscogsRecord record;
  final UserCollection user_collection;

  CollectionRecord({
    required this.record,
    required this.user_collection,
  });

  static List<CollectionRecord> sampleData = [
    CollectionRecord(
      record: DiscogsRecord.sampleData[0],
      user_collection: UserCollection.sampleData[0],
    )
  ];
}
