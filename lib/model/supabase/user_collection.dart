class UserCollection {
  final String id; // 고유 id
  final String user_id;
  final int record_id;
  final String? condition;
  final String? condition_note;
  final DateTime? purchase_date;
  final double purchase_price;
  final String? notes;
  final List<String>? tags;

  const UserCollection({
    required this.id,
    required this.user_id,
    required this.record_id,
    this.condition,
    this.condition_note,
    this.purchase_date,
    required this.purchase_price,
    this.notes,
    this.tags,
  });

  factory UserCollection.fromJson(Map<String, dynamic> json) {
    // tags 필드가 null이 아니면 List<String>으로 변환, 아니면 null 반환
    final List<dynamic>? tagsJson = json['tags'] as List<dynamic>?;
    final List<String>? tagsList =
        tagsJson != null ? tagsJson.map((e) => e as String).toList() : null;

    return UserCollection(
      id: json['id'] as String,
      user_id: json['user_id'] as String,
      record_id: json['record_id'] as int,
      condition: json['condition'] as String?,
      condition_note: json['condition_note'] as String?,
      purchase_date: json['purchase_date'] != null
          ? DateTime.parse(json['purchase_date'] as String)
          : null,
      purchase_price: (json['purchase_price'] as num).toDouble(),
      notes: json['notes'] as String?,
      tags: tagsList,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': user_id,
      'record_id': record_id,
      'condition_notes': condition_note,
      'condition': condition,
      'purchase_date': purchase_date?.toIso8601String(),
      'purchase_price': purchase_price,
      'notes': notes,
      'tags': tags ?? [],
    };
  }


  static List<UserCollection> sampleData = [
    UserCollection(
      id: "1",
      user_id: "1",
      record_id: 1,
      condition: "Good",
      condition_note: "Some scratches",
      purchase_date: DateTime(2021, 1, 1),
      purchase_price: 100,
      notes: "This is a note",
      tags: const ['rock', 'pop'],
    ),
    UserCollection(
      id: "2",
      user_id: "1",
      record_id: 2,
      condition: "Fair",
      condition_note: "Some scratches",
      purchase_date: DateTime(2021, 1, 1),
      purchase_price: 50,
      notes: "This is a note",
      tags: const ['jazz'],
    ),
    UserCollection(
      id: "3",
      user_id: "1",
      record_id: 3,
      condition: "Poor",
      condition_note: "Some scratches",
      purchase_date: DateTime(2021, 1, 1),
      purchase_price: 20,
      notes: "This is a note",
      tags: null,
    ),
  ];
}

// 간단한 리스트 비교 함수 (List<String> 비교용)
bool _listEquals(List<String>? list1, List<String>? list2) {
  if (identical(list1, list2)) return true;
  if (list1 == null || list2 == null) return false;
  if (list1.length != list2.length) return false;
  for (int i = 0; i < list1.length; i++) {
    if (list1[i] != list2[i]) return false;
  }
  return true;
}
