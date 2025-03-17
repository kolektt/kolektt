class DiscogsRecord {
  final int id;
  final String title;
  final String artist;
  final int releaseYear;
  String resourceUrl;
  final String notes;
  final String genre;
  final String coverImage;
  final String catalogNumber;
  final String label;
  final String format;
  final String country;
  final String style;
  final String condition;
  final String conditionNotes;
  final int recordId;

  DiscogsRecord({
    required this.id,
    required this.title,
    required this.resourceUrl,
    required this.notes,
    required this.genre,
    required this.coverImage,
    required this.catalogNumber,
    required this.label,
    required this.format,
    required this.country,
    required this.style,
    required this.condition,
    required this.conditionNotes,
    required this.recordId,
    required this.artist,
    required this.releaseYear,
  });

  static List<DiscogsRecord> sampleData = [
    DiscogsRecord(
      id: 1,
      title: 'Sample Record',
      resourceUrl: 'https://www.discogs.com/release/1',
      notes: '',
      genre: '',
      coverImage: '',
      catalogNumber: '',
      label: '',
      format: '',
      country: '',
      style: '',
      condition: '',
      conditionNotes: '',
      recordId: 1,
      artist: '',
      releaseYear: 2021,
    )
  ];

  // From Json
  factory DiscogsRecord.fromJson(Map<String, dynamic> json) {
    return DiscogsRecord(
      id: json['id'],
      title: json['title'],
      artist: json['artist'],
      releaseYear: json['release_year'],
      resourceUrl: json['resource_url'],
      notes: json['notes'],
      genre: json['genre'],
      coverImage: json['cover_image'],
      catalogNumber: json['catalog_number'],
      label: json['label'],
      format: json['format'],
      country: json['country'],
      style: json['style'],
      condition: json['condition'],
      conditionNotes: json['condition_notes'],
      recordId: json['record_id'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'record_id': recordId.toString(),
      'title': title,
      'artist': artist,
      'release_year': releaseYear,
      'genre': genre,
      'cover_image': coverImage,
      'catalog_number': catalogNumber,
      'label': label,
      'format': format,
      'country': country,
      'style': style,
      'condition': condition ?? '',
      'condition_notes': conditionNotes ?? '',
      'notes': notes ?? '',
    };
  }
}
