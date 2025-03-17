import 'package:kolektt/model/supabase/user_collection.dart';

import '../../data/models/user_collection_classification.dart';
import '../../domain/entities/discogs_record.dart';

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

  static Future<UserCollectionClassification> getUniqueProperties(
      List<CollectionRecord> collections) async {
    List<String> mediaConditions = ["All"];
    List<String> sleeveConditions = ["All"];
    List<String> genres = ["All"];
    List<String> sortOptions = ["최신순", "오래된순", "이름순"];

    // 각 컬렉션의 record 리스트를 순회하며 값 추출
    for (var collection in collections) {
      final records = collection.record;
      for (var mediaCondition in records.condition.split(", ")) {
        mediaConditions.add(mediaCondition);
      }
      for (var sleeveCondition in records.conditionNotes.split(", ")) {
        sleeveConditions.add(sleeveCondition);
      }
      for (var genre in records.genre.split(", ")) {
        genres.add(genre);
      }
    }

    return UserCollectionClassification(
      mediaConditions: mediaConditions.toSet().toList(),
      sleeveConditions: sleeveConditions.toSet().toList(),
      genres: genres.toSet().toList(),
      sortOptions: sortOptions.toSet().toList(),
      mediaCondition: 'All',
      sleeveCondition: 'All',
      genre: 'All',
      startYear: 1900,
      endYear: 2025,
      sortOption: '최신순',
    );
  }
}
