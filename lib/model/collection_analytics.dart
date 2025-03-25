import 'artist_analytics.dart';
import 'decade_analytics.dart';
import 'genre_analytics.dart';

class CollectionAnalytics {
  final int totalRecords;
  final List<GenreAnalytics> genres;
  final List<DecadeAnalytics> decades;
  final List<ArtistAnalytics> artists; // Add this line
  final String mostCollectedGenre;
  final String mostCollectedArtist;
  final int oldestRecord;
  final int newestRecord;

  CollectionAnalytics({
    required this.totalRecords,
    required this.genres,
    required this.decades,
    required this.mostCollectedGenre,
    required this.mostCollectedArtist,
    required this.oldestRecord,
    required this.newestRecord,
    required this.artists, // Add this
  });
}
