class DiscogsRecord {
  final int id;
  final String title;
  final String artist;
  final int releaseYear;
  String resourceUrl;
  final List<dynamic> artists;
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
    required this.artists,
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
      artists: [],
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
}
