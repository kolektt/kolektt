import '../entities/search_term.dart';

abstract class RecentSearchRepository {
  /// 가장 최근의 검색어 목록을 가져옵니다.
  Future<List<SearchTerm>> getRecentSearchTerms();

  /// 새로운 검색어를 삽입합니다.
  Future<void> insertSearchTerm(SearchTerm searchTerm);

  /// 특정 검색어를 삭제합니다.
  Future<void> removeSearchTerm(String term);

  /// 모든 검색어를 삭제합니다.
  Future<void> clearRecentSearches();
}
