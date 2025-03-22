import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:kolektt/data/datasources/discogs_remote_data_source.dart';
import 'package:kolektt/data/models/artist_release.dart';
import '../data/models/discogs_record.dart';

/// 아티스트 상세 정보를 관리하는 ViewModel
class ArtistDetailViewModel extends ChangeNotifier {
  final DiscogsRemoteDataSource remoteDataSource;

  late Artist _artist;
  ArtistRelease? _allReleases;
  ArtistRelease? _filteredReleases;
  int _selectedYear = -1;
  bool _isLoading = false;

  ArtistDetailViewModel({required this.remoteDataSource});

  // Getter / Setter
  bool get isLoading => _isLoading;
  set isLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  Artist get artist => _artist;
  set artist(Artist newArtist) {
    _artist = newArtist;
    // 새로운 아티스트가 설정되면 릴리즈 정보를 다시 불러옵니다.
    fetchArtistRelease();
  }

  String get releaseUrl => _artist.releasesUrl;
  ArtistRelease? get allReleases => _allReleases;
  ArtistRelease? get filteredReleases => _filteredReleases;
  int get selectedYear => _selectedYear;

  /// ViewModel의 상태를 초기화합니다.
  Future<void> reset() async {
    _allReleases = null;
    _filteredReleases = null;
    _selectedYear = -1;
    isLoading = false;
  }

  /// 아티스트의 상세 정보를 원격 데이터 소스에서 가져옵니다.
  Future<void> _fetchArtistDetail() async {
    isLoading = true;
    try {
      _artist = await remoteDataSource.getArtistByUrl(_artist.resourceUrl);
    } catch (e) {
      log('Error fetching artist details: $e');
    } finally {
      isLoading = false;
    }
  }

  /// 아티스트의 릴리즈 정보를 원격 데이터 소스에서 가져오고, 필터 초기화합니다.
  Future<void> fetchArtistRelease() async {
    isLoading = true;
    try {
      await _fetchArtistDetail();
      _allReleases = await remoteDataSource.getArtistReleaseByUrl(_artist.releasesUrl);
      _filteredReleases = _allReleases;
    } catch (e) {
      log('Error fetching artist releases: $e');
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  /// 선택한 연도에 따라 릴리즈 정보를 필터링합니다.
  Future<void> selectYear(int year) async {
    isLoading = true;
    try {
      _selectedYear = year;
      if (_allReleases != null) {
        _filteredReleases = ArtistRelease(
          pagination: _allReleases!.pagination,
          releases: _allReleases!.releases.where((release) => release.year == _selectedYear).toList(),
        );
      }
    } catch (e) {
      log('Error selecting year $_selectedYear: $e');
    } finally {
      isLoading = false;
      log('Selected year: $_selectedYear');
      notifyListeners();
    }
  }

  /// 연도 필터를 초기화하여 전체 릴리즈를 표시합니다.
  Future<void> clearYear() async {
    isLoading = true;
    _selectedYear = -1;
    try {
      _filteredReleases = _allReleases;
    } catch (e) {
      log('Error clearing year filter: $e');
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  /// 사용 가능한 연도 목록을 반환합니다.
  List<int> get years {
    if (_allReleases == null) return [];
    return _allReleases!.releases.map((release) => release.year).toSet().toList();
  }
}
