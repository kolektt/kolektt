class Record {
  final int id;
  final String title;
  final String artist;
  final String release_year;
  final String genre;
  final String coverImage;
  final String catalog_number;
  final String label;
  final String format;
  final String country;
  final String style;
  final String condition;
  final String condition_notes;
  final String notes;
  final int record_id;
  final String created_at;
  final String updated_at;

  Record({
    required this.id,
    required this.title,
    required this.artist,
    required this.release_year,
    required this.genre,
    required this.coverImage,
    required this.catalog_number,
    required this.label,
    required this.format,
    required this.country,
    required this.style,
    required this.condition,
    required this.condition_notes,
    required this.notes,
    required this.record_id,
    required this.created_at,
    required this.updated_at,
  });

  factory Record.fromJson(Map<String, dynamic> json) {
    return Record(
      id: json['id'],
      title: json['title'],
      artist: json['artist'],
      release_year: json['release_year'],
      genre: json['genre'],
      coverImage: json['coverImage'],
      catalog_number: json['catalog_number'],
      label: json['label'],
      format: json['format'],
      country: json['country'],
      style: json['style'],
      condition: json['condition'],
      condition_notes: json['condition_notes'],
      notes: json['notes'],
      record_id: json['record_id'],
      created_at: json['created_at'],
      updated_at: json['updated_at'],
    );
  }
}
