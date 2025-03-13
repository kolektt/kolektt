class AlbumRecognitionResult {
  final String? bestGuessLabel;
  final List<String> partialMatchingImages;
  final String? fullDetectedText;

  AlbumRecognitionResult({
    required this.bestGuessLabel,
    required this.partialMatchingImages,
    required this.fullDetectedText,
  });
}
