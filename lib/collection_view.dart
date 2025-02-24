import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kolektt/profile_view.dart';
import 'package:kolektt/record_detail_view.dart';

import 'analytics_section/analytics_section.dart';
import 'model/record.dart';

// ===== Models =====


class GenreAnalytics {
  final String name;
  final int count;
  GenreAnalytics({required this.name, required this.count});
}

class DecadeAnalytics {
  final String decade;
  final int count;
  DecadeAnalytics({required this.decade, required this.count});
}

class CollectionAnalytics {
  int totalRecords;
  String mostCollectedGenre;
  String mostCollectedArtist;
  int oldestRecord;
  int newestRecord;
  List<GenreAnalytics> genres;
  List<DecadeAnalytics> decades;

  CollectionAnalytics({
    required this.totalRecords,
    required this.mostCollectedGenre,
    required this.mostCollectedArtist,
    required this.oldestRecord,
    required this.newestRecord,
    required this.genres,
    required this.decades,
  });
}

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
              onPressed: () {},
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
                        Navigator.push(
                          context,
                          CupertinoPageRoute(
                            builder: (context) => RecordDetailView(record: record),
                          ),
                        );
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

// ===== Search Filter Bar (Cupertino 스타일) =====

class SearchFilterBar extends StatelessWidget {
  final String searchText;
  final ValueChanged<String> onSearchTextChanged;
  final String selectedGenre;
  final ValueChanged<String> onGenreChanged;
  final SortOption sortOption;
  final ValueChanged<SortOption> onSortOptionChanged;
  final List<String> genres;

  const SearchFilterBar({
    Key? key,
    required this.searchText,
    required this.onSearchTextChanged,
    required this.selectedGenre,
    required this.onGenreChanged,
    required this.sortOption,
    required this.onSortOptionChanged,
    required this.genres,
  }) : super(key: key);

  Future<void> _showGenrePicker(BuildContext context) async {
    int initialIndex = genres.indexOf(selectedGenre);
    if (initialIndex < 0) initialIndex = 0;

    final selected = await showCupertinoModalPopup<String>(
      context: context,
      builder: (context) {
        return Container(
          height: 250,
          color: CupertinoColors.systemBackground.resolveFrom(context),
          child: Column(
            children: [
              // 취소 버튼
              Container(
                alignment: Alignment.centerRight,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: CupertinoButton(
                  padding: EdgeInsets.zero,
                  onPressed: () => Navigator.pop(context),
                  child: const Text("취소"),
                ),
              ),
              Expanded(
                child: CupertinoPicker(
                  scrollController: FixedExtentScrollController(initialItem: initialIndex),
                  itemExtent: 32,
                  onSelectedItemChanged: (int index) {
                    // 선택이 변경될 때마다 즉시 반영하지 않고, 취소 버튼을 누른 후 처리할 수도 있음.
                    // 여기서는 즉시 선택하도록 Navigator.pop 사용
                    Navigator.pop(context, genres[index]);
                  },
                  children: genres.map((genre) => Center(child: Text(genre))).toList(),
                ),
              ),
            ],
          ),
        );
      },
    );

    if (selected != null) {
      onGenreChanged(selected);
    }
  }

  Future<void> _showSortOptionPicker(BuildContext context) async {
    final options = SortOption.values;
    int initialIndex = options.indexOf(sortOption);

    final selected = await showCupertinoModalPopup<SortOption>(
      context: context,
      builder: (context) {
        return Container(
          height: 250,
          color: CupertinoColors.systemBackground.resolveFrom(context),
          child: Column(
            children: [
              Container(
                alignment: Alignment.centerRight,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: CupertinoButton(
                  padding: EdgeInsets.zero,
                  onPressed: () => Navigator.pop(context),
                  child: const Text("취소"),
                ),
              ),
              Expanded(
                child: CupertinoPicker(
                  scrollController: FixedExtentScrollController(initialItem: initialIndex),
                  itemExtent: 32,
                  onSelectedItemChanged: (int index) {
                    Navigator.pop(context, options[index]);
                  },
                  children: options
                      .map((option) => Center(child: Text(option.displayName)))
                      .toList(),
                ),
              ),
            ],
          ),
        );
      },
    );

    if (selected != null) {
      onSortOptionChanged(selected);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // 검색 바
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: CupertinoTextField(
            placeholder: "앨범 또는 아티스트 검색",
            prefix: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Icon(CupertinoIcons.search, color: CupertinoColors.systemGrey),
            ),
            onChanged: onSearchTextChanged,
          ),
        ),
        // 장르 및 정렬 옵션
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: [
              // 장르 선택 버튼
              Expanded(
                child: CupertinoButton(
                  padding: EdgeInsets.zero,
                  onPressed: () => _showGenrePicker(context),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        selectedGenre,
                        style: const TextStyle(fontSize: 16),
                      ),
                      const SizedBox(width: 4),
                      const Icon(CupertinoIcons.chevron_down, size: 16),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 16),
              // 정렬 옵션 선택 버튼
              Expanded(
                child: CupertinoButton(
                  padding: EdgeInsets.zero,
                  onPressed: () => _showSortOptionPicker(context),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        sortOption.displayName,
                        style: const TextStyle(fontSize: 16),
                      ),
                      const SizedBox(width: 4),
                      const Icon(CupertinoIcons.chevron_down, size: 16),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// ===== Record List Item View (Cupertino 스타일) =====

class RecordListItemView extends StatelessWidget {
  final Record record;
  RecordListItemView({required this.record});

  @override
  Widget build(BuildContext context) {
    Color primaryColor = Color(0xFF0036FF);
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: CupertinoButton(
        padding: EdgeInsets.zero,
        onPressed: () {
          Navigator.push(
            context,
            CupertinoPageRoute(
              builder: (context) => RecordDetailView(record: record),
            ),
          );
        },
        child: Row(
          children: [
            Image.network(
              record.coverImageURL ?? "https://via.placeholder.com/60",
              width: 60,
              height: 60,
              fit: BoxFit.cover,
            ),
            SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(record.title,
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis),
                  Text(record.artist,
                      style: TextStyle(fontSize: 14, color: CupertinoColors.systemGrey),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis),
                  // Text("₩${record.lowestPrice}",
                  //     style: TextStyle(fontSize: 14)),
                ],
              ),
            ),
            Icon(
              CupertinoIcons.arrow_up,
              color: CupertinoColors.activeGreen,
            ),
          ],
        ),
      ),
    );
  }
}


// ===== CatNo Input View (Cupertino Alert) =====

class CatNoInputView extends StatefulWidget {
  final Function(String) onSubmit;
  CatNoInputView({required this.onSubmit});
  @override
  _CatNoInputViewState createState() => _CatNoInputViewState();
}

class _CatNoInputViewState extends State<CatNoInputView> {
  TextEditingController _controller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return CupertinoAlertDialog(
      title: Text("CatNo로 검색"),
      content: Column(
        children: [
          Text("앨범의 CatNo를 입력해주세요"),
          CupertinoTextField(
            controller: _controller,
            placeholder: "예시: 88985456371, SRCS-9198",
          ),
        ],
      ),
      actions: [
        CupertinoDialogAction(
          child: Text("취소"),
          onPressed: () => Navigator.pop(context),
        ),
        CupertinoDialogAction(
          child: Text("검색"),
          onPressed: () {
            widget.onSubmit(_controller.text);
            Navigator.pop(context);
          },
        ),
      ],
    );
  }
}

// ===== Add Record View (Cupertino 스타일) =====

class AddRecordView extends StatefulWidget {
  final Function(String, String, int?, String?, String?) onSave;
  AddRecordView({required this.onSave});
  @override
  _AddRecordViewState createState() => _AddRecordViewState();
}

class _AddRecordViewState extends State<AddRecordView> {
  TextEditingController titleController = TextEditingController();
  TextEditingController artistController = TextEditingController();
  TextEditingController yearController = TextEditingController();
  TextEditingController genreController = TextEditingController();
  TextEditingController notesController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text("수동 입력"),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: ListView(
            children: [
              CupertinoTextField(controller: titleController, placeholder: "앨범명"),
              SizedBox(height: 8),
              CupertinoTextField(controller: artistController, placeholder: "아티스트"),
              SizedBox(height: 8),
              CupertinoTextField(
                controller: yearController,
                placeholder: "발매년도",
                keyboardType: TextInputType.number,
              ),
              SizedBox(height: 8),
              CupertinoTextField(controller: genreController, placeholder: "장르"),
              SizedBox(height: 8),
              CupertinoTextField(
                controller: notesController,
                placeholder: "노트",
                maxLines: 3,
              ),
              SizedBox(height: 16),
              CupertinoButton.filled(
                child: Text("저장"),
                onPressed: () {
                  int? year = int.tryParse(yearController.text);
                  widget.onSave(
                      titleController.text, artistController.text, year, genreController.text, notesController.text);
                  Navigator.pop(context);
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
