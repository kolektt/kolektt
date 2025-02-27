import '../discogs/discogs_record.dart';

class CollectionRecord {
  /// user_collections 테이블의 고유 id
  final String id;

  /// 연결된 DiscogsRecord (records 테이블의 데이터)
  final DiscogsRecord record;

  CollectionRecord({
    required this.id,
    required this.record,
  });

  static List<CollectionRecord> sampleData = [
    CollectionRecord(
      id: "0",
      record: DiscogsRecord.sampleData[0],
    )
  ];
}
