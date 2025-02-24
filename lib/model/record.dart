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
      coverImageURL: "https://s.pstatic.net/dthumb.phinf/?src=%22https%3A%2F%2Fs.pstatic.net%2Fshop.phinf%2F20250217_3%2F17397898415832ySrH_PNG%2FED9994EBA9B4%252BECBAA1ECB298%252B2025-02-17%252B195422.png%22&type=ff364_236&service=navermain",
      price: 150,
      trending: true,
    ),
    Record(
      id: "2",
      title: "Sample Album 2",
      artist: "Artist 2",
      releaseYear: 2010,
      genre: "Rock",
      coverImageURL: "https://s.pstatic.net/dthumb.phinf/?src=%22https%3A%2F%2Fs.pstatic.net%2Fshop.phinf%2F20250217_3%2F17397898415832ySrH_PNG%2FED9994EBA9B4%252BECBAA1ECB298%252B2025-02-17%252B195422.png%22&type=ff364_236&service=navermain",
      price: 200,
      trending: false,
    ),
  ];
}