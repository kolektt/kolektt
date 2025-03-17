import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:kolektt/data/datasources/discogs_remote_data_source.dart';
import 'package:kolektt/data/models/artist_release.dart';

import '../data/models/discogs_record.dart';

class ArtistDetailViewModel extends ChangeNotifier {
  final DiscogsRemoteDataSource remoteDataSource;
  late Artist _artist;
  ArtistRelease? _artistRelease = null;
  ArtistRelease? _filterRelease = null;

  int _selectedYear = -1;

  bool _isLoading = false;

  ArtistDetailViewModel({required this.remoteDataSource});

  bool get isLoading => _isLoading;

  set isLoading(bool isLoading) {
    _isLoading = isLoading;
    notifyListeners();
  }

  Artist get artist => _artist;

  String get releaseUrl => _artist.releasesUrl;

  ArtistRelease? get artistRelease => _artistRelease;

  set artistRelease(ArtistRelease? artistRelease) {
    _artistRelease = artistRelease;
    notifyListeners();
  }

  ArtistRelease? get filterRelease => _filterRelease;

  set filterRelease(ArtistRelease? filterRelease) {
    _filterRelease = filterRelease;
    notifyListeners();
  }

  List<int> get years {
    if (_artistRelease == null) {
      return [];
    }
    return _artistRelease!.releases.map((release) => release.year).toSet().toList();
  }

  int get selectedYear => _selectedYear;

  set artist(Artist artist) {
    _artist = artist;
    fetchArtistRelease();
  }

  Future<void> _fetchArtistDetail() async {
    isLoading = true;
    try {
      final url = _artist.resourceUrl;
      _artist = await remoteDataSource.getArtistByUrl(url);
    } catch (e) {
      log(e.toString());
    } finally {
      isLoading = false;
    }
  }

  Future<void> fetchArtistRelease() async {
    isLoading = true;
    try {
      await _fetchArtistDetail();
      final url = _artist.releasesUrl;
      debugPrint('Fetching artist release: ${_artist.toJson()}');
      _artistRelease = await remoteDataSource.getArtistReleaseByUrl(url);
      _filterRelease = _artistRelease;
    } catch (e) {
      log(e.toString());
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> selectYear(int year) async {
    isLoading = true;
    _selectedYear = year;
    try {
      final url = _artist.releasesUrl;
      _artistRelease = await remoteDataSource.getArtistReleaseByUrl(url);
      _filterRelease = ArtistRelease(
        pagination: _artistRelease!.pagination,
        releases: _artistRelease!.releases.where((release) => release.year == _selectedYear).toList(),
      );
    } catch (e) {
      log(e.toString());
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> clearYear() async {
    isLoading = true;
    _selectedYear = -1;
    try {
      final url = _artist.releasesUrl;
      _artistRelease = await remoteDataSource.getArtistReleaseByUrl(url);
      _filterRelease = _artistRelease;
    } catch (e) {
      log(e.toString());
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
