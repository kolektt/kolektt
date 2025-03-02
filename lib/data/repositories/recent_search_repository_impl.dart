import '../../domain/entities/search_term.dart';
import '../../domain/repositories/recent_search_repository.dart';
import '../datasources/recent_search_local_data_source.dart';

class RecentSearchRepositoryImpl implements RecentSearchRepository {
  final RecentSearchLocalDataSource localDataSource;

  RecentSearchRepositoryImpl({required this.localDataSource});

  @override
  Future<List<SearchTerm>> getRecentSearchTerms() async {
    return await localDataSource.getRecentSearchTerms();
  }

  @override
  Future<void> insertSearchTerm(SearchTerm searchTerm) async {
    // 도메인 엔티티를 모델로 변환하여 저장
    await localDataSource.insertSearchTerm(searchTerm.term);
  }

  @override
  Future<void> removeSearchTerm(String term) async {
    await localDataSource.removeSearchTerm(term);
  }

  @override
  Future<void> clearRecentSearches() async {
    await localDataSource.clearRecentSearches();
  }
}
