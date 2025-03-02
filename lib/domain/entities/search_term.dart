class SearchTerm {
  final int? id;
  final String term;
  final DateTime timestamp;

  SearchTerm({
    this.id,
    required this.term,
    required this.timestamp,
  });
}
