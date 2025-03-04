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
    final genres = <String>{};
    final labels = <String>{};
    final artists = <String>{};

    // 각 컬렉션의 record 리스트를 순회하며 값 추출
    for (var collection in collections) {
      final records = collection.record;
      for (var genre in records.genre.split(", ")) {
        genres.add(genre);
      }
      for (var label in records.label.split(", ")) {
        labels.add(label);
      }
      for (var artist in records.artist.split(", ")) {
        artists.add(artist);
      }
    }
    return UserCollectionClassification(
        genres: genres, labels: labels, artists: artists);
  }
}
