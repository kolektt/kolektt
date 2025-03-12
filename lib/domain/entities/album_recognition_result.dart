class AlbumRecognitionResult {
  final String? bestGuessLabel;
  final List<String> partialMatchingImages;

  AlbumRecognitionResult({
    required this.bestGuessLabel,
    required this.partialMatchingImages,
  });
}