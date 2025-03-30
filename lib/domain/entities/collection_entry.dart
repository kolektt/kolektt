/// 컬렉션 추가 시 사용되는 데이터 모델 클래스
class CollectionEntry {
  final int recordId;
  final String condition;
  final double purchasePrice;
  final DateTime purchaseDate;
  final String notes;
  final List<String> tags;

  CollectionEntry({
    required this.recordId,
    required this.condition,
    required this.purchasePrice,
    required this.purchaseDate,
    required this.notes,
    required this.tags,
  });

  /// DB 삽입에 사용할 Map 형식으로 변환
  Map<String, dynamic> toJson() {
    return {
      'record_id': recordId,
      'condition': condition,
      'purchase_price': purchasePrice,
      'purchase_date': purchaseDate.toIso8601String(),
      'notes': notes,
      'tags': tags,
    };
  }
}
