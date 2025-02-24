class Record {
  final String id;
  String title;
  String artist;
  int? releaseYear;
  String? genre;
  String? coverImageURL;
  DateTime createdAt;
  DateTime updatedAt;

  // 추가 메타데이터
  String? catalogNumber;
  String? label;
  String? format;
  String? country;
  String? style;
  String? condition;
  String? conditionNotes;
  String? notes;

  // UI에서 사용되는 필드
  int price;
  bool trending;

  Record({
    required this.id,
    required this.title,
    required this.artist,
    this.releaseYear,
    this.genre,
    this.coverImageURL,
    DateTime? createdAt,
    DateTime? updatedAt,
    this.catalogNumber,
    this.label,
    this.format,
    this.country,
    this.style,
    this.condition,
    this.conditionNotes,
    this.notes,
    this.price = 0,
    this.trending = false,
  })  : createdAt = createdAt ?? DateTime.now(),
        updatedAt = updatedAt ?? DateTime.now();

  static List<Record> sampleData = [
    Record(
      id: "1",
      title: "Sample Album 1",
      artist: "Artist 1",
      releaseYear: 2000,
      genre: "Pop",
      coverImageURL: "https://via.placeholder.com/150",
      price: 150,
      trending: true,
    ),
    Record(
      id: "2",
      title: "Sample Album 2",
      artist: "Artist 2",
      releaseYear: 2010,
      genre: "Rock",
      coverImageURL: "https://via.placeholder.com/150",
      price: 200,
      trending: false,
    ),
  ];
}