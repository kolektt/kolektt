import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:kolektt/domain/entities/search_term.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../data/models/discogs_search_response.dart';
import '../domain/entities/discogs_record.dart';
import '../domain/repositories/recent_search_repository.dart';
import '../domain/usecases/search_and_upsert_discogs_records.dart';
import '../view/record_detail_view.dart';

enum SortOption { latest, popularity, priceLow, priceHigh }

final List<String> genres = ["전체", "House", "Techno", "Disco", "Jazz", "Hip-Hop"];

class SearchViewModel extends ChangeNotifier {
  final RecentSearchRepository recentSearchRepository;
  final TextEditingController searchController = TextEditingController();

  String selectedGenre = '전체';
  SortOption sortOption = SortOption.latest;
  List<DiscogsSearchItem> results = [];
  bool isLoading = false;
  String? errorMessage;
  List<SearchTerm> _recentSearchTerms = [];
  List<SearchTerm> get recentSearchTerms =>
      _recentSearchTerms..sort((a, b) => b.timestamp.compareTo(a.timestamp));

  // 추천 검색어
  final List<SearchTerm> suggestedSearchTerms = [
    SearchTerm(term: "Aphex Twin", timestamp: DateTime.now()),
    SearchTerm(term: "Boards of Canada", timestamp: DateTime.now()),
    SearchTerm(term: "Autechre", timestamp: DateTime.now()),
    SearchTerm(term: "Squarepusher", timestamp: DateTime.now()),
    SearchTerm(term: "Radiohead", timestamp: DateTime.now()),
    SearchTerm(term: "Four Tet", timestamp: DateTime.now()),
  ];

  // final DiscogsRepositoryImpl _apiService = DiscogsRepositoryImpl();
  final SearchAndUpsertDiscogsRecords searchAndUpsertUseCase;

  // 디바운싱을 위한 타이머
  Timer? _debounceTimer;
  // 검색 임계값
  static const int searchDebounceTimeMs = 500;

  SearchViewModel({
    required this.searchAndUpsertUseCase,
    required this.recentSearchRepository,
  }) {
    loadRecentSearches();
    searchController.addListener(_onSearchControllerChanged);
  }

  @override
  void dispose() {
    _debounceTimer?.cancel();
    searchController.removeListener(_onSearchControllerChanged);
    searchController.dispose();
    super.dispose();
  }

  void _onSearchControllerChanged() {
    final searchText = searchController.text;
    if (searchText.isEmpty) {
      results = [];
      notifyListeners();
    }
  }

  String get searchText => searchController.text;

  Future<void> loadRecentSearches() async {
    try {
      _recentSearchTerms = await recentSearchRepository.getRecentSearchTerms();
      notifyListeners();
    } catch (e) {
      debugPrint('Failed to load recent searches: $e');
    }
  }

  Future<void> search() async {
    if (searchText.isEmpty) {
      results = [];
      notifyListeners();
      return;
    }

    // 로딩 시작
    isLoading = true;
    notifyListeners();

    try {
      // (1) API로부터 결과를 가져옴
      results = await searchAndUpsertUseCase.call(searchText, type: 'release');
      debugPrint('Search results: ${results}');

      // (2) UI 업데이트
      //     - 장르 필터, 정렬 등
      // _applyGenreFilter();
      // _applySorting();

      // (3) 로딩 끝
      isLoading = false;
      notifyListeners();

    } catch (e) {
      // 에러 처리
      errorMessage = e.toString();
      results = [];
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> updateSearchText(String text) async {
    // 검색 컨트롤러 업데이트
    if (searchController.text != text) {
      searchController.text = text;
      searchController.selection = TextSelection.fromPosition(
        TextPosition(offset: text.length),
      );
    }

    // 디바운싱 적용
    _debounceTimer?.cancel();
    _debounceTimer = Timer(Duration(milliseconds: searchDebounceTimeMs), () async {
    });

    notifyListeners();
  }

  Future<void> updateSelectedGenre(String genre) async {
    if (selectedGenre != genre) {
      selectedGenre = genre;

      // 검색 결과가 있으면 필터 적용
      if (results.isNotEmpty) {
        if (genre != '전체') {
          final filteredResults = results.where((record) =>
          record.genre[0].contains(genre) ?? false
          ).toList();

          // 필터링 후 정렬 적용
          results = filteredResults;
          // _applySorting();
        } else {
          // 전체 선택 시 원래 검색결과로 복원 후 다시 검색
          await search();
          return;
        }
      }

      notifyListeners();
    }
  }

  void updateSortOption(SortOption option) {
    if (sortOption != option) {
      sortOption = option;

      // 검색 결과가 있으면 정렬 적용
      if (results.isNotEmpty) {
        // _applySorting();
        notifyListeners();
      }
    }
  }

  // void _applySorting() {
  //   switch (sortOption) {
  //     case SortOption.latest:
  //       results.sort((a, b) => (b.year ?? 0).compareTo(a.year ?? 0));
  //       break;
  //     case SortOption.popularity:
  //       results.sort((a, b) => (b.community.have ?? 0).compareTo(a.community.have ?? 0));
  //       break;
  //     case SortOption.priceLow:
  //       results.sort((a, b) => (a.lowestPrice ?? 0).compareTo(b.lowestPrice ?? 0));
  //       break;
  //     case SortOption.priceHigh:
  //       results.sort((a, b) => (b.lowestPrice ?? 0).compareTo(a.lowestPrice ?? 0));
  //       break;
  //   }
  // }

  String getSortOptionDisplayName([SortOption? option]) {
    option = option ?? sortOption;

    switch (option) {
      case SortOption.latest:
        return "최신순";
      case SortOption.popularity:
        return "인기순";
      case SortOption.priceLow:
        return "가격 낮은순";
      case SortOption.priceHigh:
        return "가격 높은순";
    }
  }

  Future<void> clearRecentSearches() async {
    try {
      await recentSearchRepository.clearRecentSearches();
      _recentSearchTerms = [];
      notifyListeners();
    } catch (e) {
      debugPrint('Failed to clear recent searches: $e');
    }
  }

  Future<void> removeSearchTerm(String term) async {
    try {
      await recentSearchRepository.removeSearchTerm(term);
      await loadRecentSearches();
    } catch (e) {
      debugPrint('Failed to remove search term: $e');
    }
  }

  void onRecordSelected(DiscogsSearchItem record, BuildContext context) {
    Navigator.of(context).push(
      CupertinoPageRoute(
        builder: (context) => RecordDetailView(recordResourcelUrl: record.resourceUrl),
      ),
    );
  }
}
