class RecognitionResult {
  final String title;
  final String artist;
  final int? releaseYear;
  final String? genre;

  RecognitionResult({
    required this.title,
    required this.artist,
    this.releaseYear,
    this.genre,
  });
}
