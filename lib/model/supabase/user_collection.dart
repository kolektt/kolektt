class UserCollection {
  final int id; // 고유 id 추가
  final String user_id;
  final int record_id;
  final String? condition;
  final String? condition_note;
  final DateTime? purchase_date;
  final int purchase_price;
  final String? notes;

  UserCollection({
    required this.id,
    required this.user_id,
    required this.record_id,
    this.condition,
    this.condition_note,
    this.purchase_date,
    required this.purchase_price,
    this.notes,
  });

  factory UserCollection.fromJson(Map<String, dynamic> json) {
    return UserCollection(
      id: json['id'], // 테이블의 고유 id
      user_id: json['user_id'],
      record_id: json['record_id'],
      condition: json['condition'],
      condition_note: json['condition_note'],
      purchase_date: json['purchase_date'] != null
          ? DateTime.parse(json['purchase_date'])
          : null,
      purchase_price: json['purchase_price'],
      notes: json['notes'],
    );
  }

  static List<UserCollection> sampleData = [
    UserCollection(
      id: 1,
      user_id: "1",
      record_id: 1,
      condition: "Good",
      condition_note: "Some scratches",
      purchase_date: DateTime(2021, 1, 1),
      purchase_price: 100,
      notes: "This is a note",
    ),
    UserCollection(
      id: 2,
      user_id: "1",
      record_id: 2,
      condition: "Fair",
      condition_note: "Some scratches",
      purchase_date: DateTime(2021, 1, 1),
      purchase_price: 50,
      notes: "This is a note",
    ),
    UserCollection(
      id: 3,
      user_id: "1",
      record_id: 3,
      condition: "Poor",
      condition_note: "Some scratches",
      purchase_date: DateTime(2021, 1, 1),
      purchase_price: 20,
      notes: "This is a note",
    ),
  ];
}

