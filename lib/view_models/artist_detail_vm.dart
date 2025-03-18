import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:kolektt/data/datasources/discogs_remote_data_source.dart';
import 'package:kolektt/data/models/artist_release.dart';

import '../data/models/discogs_record.dart';

class ArtistDetailViewModel extends ChangeNotifier {
  final DiscogsRemoteDataSource remoteDataSource;
  late Artist _artist;
  ArtistRelease? _allReleases;
  ArtistRelease? _filterRelease;
  int _selectedYear = -1;
  bool _isLoading = false;

  ArtistDetailViewModel({required this.remoteDataSource});

  bool get isLoading => _isLoading;
  set isLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  Artist get artist => _artist;
  String get releaseUrl => _artist.releasesUrl;
  ArtistRelease? get allReleases => _allReleases;
  ArtistRelease? get filterRelease => _filterRelease;
  int get selectedYear => _selectedYear;

  set artist(Artist artist) {
    _artist = artist;
    fetchArtistRelease();
  }

  Future<void> reset() async {
    _allReleases = null;
    _filterRelease = null;
    _selectedYear = -1;
    isLoading = false;
  }

  Future<void> _fetchArtistDetail() async {
    isLoading = true;
    try {
      _artist = await remoteDataSource.getArtistByUrl(_artist.resourceUrl);
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
      _allReleases = await remoteDataSource.getArtistReleaseByUrl(_artist.releasesUrl);
      _filterRelease = _allReleases;
    } catch (e) {
      log(e.toString());
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> selectYear(int year) async {
    isLoading = true;
    try {
      _selectedYear = year;
      if (_allReleases != null) {
        _filterRelease = ArtistRelease(
          pagination: _allReleases!.pagination,
          releases: _allReleases!.releases.where((release) => release.year == _selectedYear).toList(),
        );
      }
    } catch (e) {
      log(e.toString());
    } finally {
      isLoading = false;
      debugPrint('Selected year: $_selectedYear');
      notifyListeners();
    }
  }

  Future<void> clearYear() async {
    isLoading = true;
    _selectedYear = -1;
    try {
      _filterRelease = _allReleases;
    } catch (e) {
      log(e.toString());
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  List<int> get years {
    if (_allReleases == null) return [];
    return _allReleases!.releases.map((release) => release.year).toSet().toList();
  }
}
