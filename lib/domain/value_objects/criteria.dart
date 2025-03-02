enum SortOrder { ascending, descending }

class DiscogsFilterCriteria {
  final String? artist;
  final String? genre;
  final String? label;

  // 필요한 조건 추가

  DiscogsFilterCriteria({this.artist, this.genre, this.label});
}

class DiscogsSortCriteria {
  final String sortBy; // 예: 'releaseYear', 'title' 등
  final SortOrder sortOrder;

  DiscogsSortCriteria({required this.sortBy, required this.sortOrder});
}
