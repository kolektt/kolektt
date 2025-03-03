import 'collection_record.dart';

/// 컬렉션을 장르, 레이블, 아티스트 별로 분류한 결과를 담는 클래스
class CollectionClassification {
  final Map<String, List<CollectionRecord>> genreClassification;
  final Map<String, List<CollectionRecord>> labelClassification;
  final Map<String, List<CollectionRecord>> artistClassification;

  CollectionClassification({
    required this.genreClassification,
    required this.labelClassification,
    required this.artistClassification,
  });
}

/// [collections] 리스트를 순회하며, DiscogsRecord의 [genres], [labels], [artists] 정보를 기준으로 분류한 결과를 리턴합니다.
CollectionClassification classifyCollections(
    List<CollectionRecord> collections) {
  final Map<String, List<CollectionRecord>> genreMap = {};
  final Map<String, List<CollectionRecord>> labelMap = {};
  final Map<String, List<CollectionRecord>> artistMap = {};

  for (var collection in collections) {
    final discogsRecord = collection.record;

    // 장르 분류: List<String> 형식
    for (var genre in discogsRecord.genre.split(", ")) {
      if (genre.isNotEmpty) {
        genreMap.putIfAbsent(genre, () => []).add(collection);
      }
    }

    // 레이블 분류: List<Label> 형식
    for (var label in discogsRecord.label.split(", ")) {
      if (label.isNotEmpty) {
        labelMap.putIfAbsent(label, () => []).add(collection);
      }
    }

    // 아티스트 분류: List<Artist> 형식
    for (var artist in discogsRecord.artist.split(", ")) {
      if (artist.isNotEmpty) {
        artistMap.putIfAbsent(artist, () => []).add(collection);
      }
    }
  }

  return CollectionClassification(
    genreClassification: genreMap,
    labelClassification: labelMap,
    artistClassification: artistMap,
  );
}
