import '../../data/models/discogs_search_response.dart';
import '../repositories/discogs_repository.dart';

class SearchArtist {
  final DiscogsRepository discogsRepository;

  SearchArtist(this.discogsRepository);

  Future<List<DiscogsSearchItem>> call(String query) async {
    return await discogsRepository.searchDiscogs(query, type: 'artist');
  }
}
