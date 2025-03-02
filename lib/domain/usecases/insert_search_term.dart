import '../entities/search_term.dart';
import '../repositories/recent_search_repository.dart';

class InsertSearchTerm {
  final RecentSearchRepository repository;

  InsertSearchTerm(this.repository);

  Future<void> call(SearchTerm searchTerm) async {
    await repository.insertSearchTerm(searchTerm);
  }
}
