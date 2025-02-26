import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kolektt/view/auto_album_detection_view.dart';

import '../components/analytics_section.dart';
import '../components/record_card_view.dart';
import '../components/record_list_item_view.dart';
import '../components/search_filter_bar.dart';
import '../model/collection_analytics.dart';
import '../model/decade_analytics.dart';
import '../model/genre_analytics.dart';
import '../model/record.dart';


// ===== Enum for Sort Option =====

enum SortOption { dateAdded, title, artist, year }

extension SortOptionExtension on SortOption {
  String get displayName {
    switch (this) {
      case SortOption.dateAdded:
        return "추가된 날짜";
      case SortOption.title:
        return "제목";
      case SortOption.artist:
        return "아티스트";
      case SortOption.year:
        return "발매년도";
      default:
        return "";
    }
  }
}

// ===== Main Collection View (Cupertino Style) =====

class CollectionView extends StatefulWidget {
  @override
  _CollectionViewState createState() => _CollectionViewState();
}

class _CollectionViewState extends State<CollectionView> {
  // 데이터 모델
  List<Record> records = [];
  CollectionAnalytics? analytics;

  // 화면 전환 상태
  bool showingCamera = false;
  bool showingBarcodeScanner = false;
  bool showingCatNoInput = false;
  bool showingManualInput = false;
  bool isGridView = true;
  bool showingSearchFilter = false;

  String searchText = "";
  String selectedGenre = "전체";
  SortOption sortOption = SortOption.dateAdded;

  @override
  void initState() {
    super.initState();
    if (records.isEmpty) {
      addSampleData();
    }
    updateAnalytics();
  }

  void addSampleData() {
    setState(() {
      records.addAll(Record.sampleData);
    });
  }

  void updateAnalytics() {
    int total = records.length;
    int oldest = records.isNotEmpty
        ? records.map((r) => r.releaseYear ?? 0).reduce((a, b) => a < b ? a : b)
        : 0;
    int newest = records.isNotEmpty
        ? records.map((r) => r.releaseYear ?? 0).reduce((a, b) => a > b ? a : b)
        : 0;

    Map<String, int> genreCount = {};
    for (var record in records) {
      if (record.genre != null && record.genre!.isNotEmpty) {
        genreCount[record.genre!] = (genreCount[record.genre!] ?? 0) + 1;
      }
    }
    List<GenreAnalytics> genreAnalytics = genreCount.entries
        .map((e) => GenreAnalytics(name: e.key, count: e.value))
        .toList();

    Map<String, int> decadeCount = {};
    for (var record in records) {
      if (record.releaseYear != null && record.releaseYear! > 0) {
        int decadeStart = (record.releaseYear! ~/ 10) * 10;
        String decadeStr = "${decadeStart}s";
        decadeCount[decadeStr] = (decadeCount[decadeStr] ?? 0) + 1;
      }
    }
    List<DecadeAnalytics> decadeAnalytics = decadeCount.entries
        .map((e) => DecadeAnalytics(decade: e.key, count: e.value))
        .toList();

    setState(() {
      analytics = CollectionAnalytics(
        totalRecords: total,
        mostCollectedGenre: genreAnalytics.isNotEmpty
            ? genreAnalytics.reduce((a, b) => a.count > b.count ? a : b).name
            : "",
        mostCollectedArtist: records.isNotEmpty ? records[0].artist : "",
        oldestRecord: oldest,
        newestRecord: newest,
        genres: genreAnalytics,
        decades: decadeAnalytics,
      );
    });
  }

  List<Record> get filteredRecords {
    List<Record> result = List.from(records);
    if (searchText.isNotEmpty) {
      result = result
          .where((r) =>
      r.title.toLowerCase().contains(searchText.toLowerCase()) ||
          r.artist.toLowerCase().contains(searchText.toLowerCase()))
          .toList();
    }
    if (selectedGenre != "전체") {
      result = result.where((r) => r.genre == selectedGenre).toList();
    }
    result.sort((a, b) {
      switch (sortOption) {
        case SortOption.dateAdded:
          return b.createdAt.compareTo(a.createdAt);
        case SortOption.title:
          return a.title.compareTo(b.title);
        case SortOption.artist:
          return a.artist.compareTo(b.artist);
        case SortOption.year:
          return (b.releaseYear ?? 0).compareTo(a.releaseYear ?? 0);
      }
    });
    return result;
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text("컬렉션"),
        trailing: CupertinoButton(
          padding: EdgeInsets.zero,
          child: IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  CupertinoPageRoute(
                    builder: (context) => AutoAlbumDetectionScreen(),
                  ),
                );
              },
              icon: Icon(
                CupertinoIcons.add_circled_solid,
                size: 32,
                color: CupertinoColors.black,
              )),
          onPressed: () {
            // 추가 메뉴 처리 (CupertinoActionSheet 등을 사용)
          },
        ),
      ),
      child: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Analytics 섹션
              AnalyticsSection(analytics: analytics),
              // 컨트롤 섹션 (검색 필터 & 그리드/리스트 전환)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Row(
                  children: [
                    CupertinoButton(
                      padding: EdgeInsets.zero,
                      child: Icon(
                        showingSearchFilter
                            ? CupertinoIcons.chevron_up
                            : CupertinoIcons.chevron_down,
                        color: CupertinoColors.black,
                      ),
                      onPressed: () {
                        setState(() {
                          showingSearchFilter = !showingSearchFilter;
                        });
                      },
                    ),
                    CupertinoButton(
                      padding: EdgeInsets.zero,
                      child: Icon(
                        isGridView ? CupertinoIcons.square_grid_2x2_fill : CupertinoIcons.list_bullet,
                        color: CupertinoColors.black,
                      ),
                      onPressed: () {
                        setState(() {
                          isGridView = !isGridView;
                        });
                      },
                    ),
                    Spacer(),
                  ],
                ),
              ),
              if (showingSearchFilter)
                SearchFilterBar(
                  searchText: searchText,
                  onSearchTextChanged: (text) {
                    setState(() {
                      searchText = text;
                    });
                  },
                  selectedGenre: selectedGenre,
                  onGenreChanged: (genre) {
                    setState(() {
                      selectedGenre = genre;
                    });
                  },
                  sortOption: sortOption,
                  onSortOptionChanged: (option) {
                    setState(() {
                      sortOption = option;
                    });
                  },
                  genres: ["전체"] +
                      records
                          .map((r) => r.genre ?? "")
                          .where((g) => g.isNotEmpty)
                          .toSet()
                          .toList()
                        ..sort(),
                ),
              // 레코드 목록 (그리드/리스트)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: isGridView
                    ? GridView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: filteredRecords.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    childAspectRatio: 0.75,
                  ),
                  itemBuilder: (context, index) {
                    Record record = filteredRecords[index];
                    return GestureDetector(
                      onTap: () {
                        // Navigator.push(
                        //   context,
                        //   CupertinoPageRoute(
                        //     builder: (context) => RecordDetailView(record: record),
                        //   ),
                        // );
                      },
                      child: RecordCardView(record: record),
                    );
                  },
                )
                    : ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: filteredRecords.length,
                  itemBuilder: (context, index) {
                    Record record = filteredRecords[index];
                    return RecordListItemView(record: record);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void addRecord(String title, String artist, int? year, String? genre, String? notes) {
    setState(() {
      Record newRecord = Record(
        title: title,
        artist: artist,
        releaseYear: year,
        genre: genre,
        notes: notes,
        id: '',
        coverImageURL: '',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );
      records.add(newRecord);
      updateAnalytics();
    });
  }
}
