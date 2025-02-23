import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// ===== Models =====

class Record {
  String title;
  String artist;
  int? releaseYear;
  String? genre;
  String? coverImageURL;
  DateTime createdAt;
  DateTime updatedAt;

  // Additional metadata
  String? catalogNumber;
  String? label;
  String? format;
  String? country;
  String? style;
  String? condition;
  String? conditionNotes;
  String? notes;

  // Added fields for demonstration
  int price;
  bool trending;

  Record({
    required this.title,
    required this.artist,
    this.releaseYear,
    this.genre,
    this.coverImageURL,
    DateTime? createdAt,
    DateTime? updatedAt,
    this.catalogNumber,
    this.label,
    this.format,
    this.country,
    this.style,
    this.condition,
    this.conditionNotes,
    this.notes,
    this.price = 0,
    this.trending = false,
  })  : createdAt = createdAt ?? DateTime.now(),
        updatedAt = updatedAt ?? DateTime.now();

  static List<Record> sampleData = [
    Record(
      title: "Sample Album",
      artist: "Artist A",
      releaseYear: 2000,
      genre: "Rock",
      coverImageURL: "https://s.pstatic.net/dthumb.phinf/?src=%22https%3A%2F%2Fs.pstatic.net%2Fshop.phinf%2F20250217_3%2F17397898415832ySrH_PNG%2FED9994EBA9B4%252BECBAA1ECB298%252B2025-02-17%252B195422.png%22&type=ff364_236&service=navermain",
      price: 150,
      trending: true,
    ),
    Record(
      title: "Another Album",
      artist: "Artist B",
      releaseYear: 2010,
      genre: "Pop",
      coverImageURL: "https://s.pstatic.net/dthumb.phinf/?src=%22https%3A%2F%2Fs.pstatic.net%2Fshop.phinf%2F20250217_3%2F17397898415832ySrH_PNG%2FED9994EBA9B4%252BECBAA1ECB298%252B2025-02-17%252B195422.png%22&type=ff364_236&service=navermain",
      price: 200,
      trending: false,
    ),
  ];
}

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
  // Data model
  List<Record> records = [];
  CollectionAnalytics? analytics;

  // View states
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

    // Calculate genre distribution
    Map<String, int> genreCount = {};
    for (var record in records) {
      if (record.genre != null && record.genre!.isNotEmpty) {
        genreCount[record.genre!] = (genreCount[record.genre!] ?? 0) + 1;
      }
    }
    List<GenreAnalytics> genreAnalytics = genreCount.entries
        .map((e) => GenreAnalytics(name: e.key, count: e.value))
        .toList();

    // Calculate decade distribution (10-year bins)
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
          child: Icon(CupertinoIcons.add),
          onPressed: () {
            // Implement additional action (e.g., present a CupertinoActionSheet)
          },
        ),
      ),
      child: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              AnalyticsSection(analytics: analytics),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Row(
                  children: [
                    CupertinoButton(
                      padding: EdgeInsets.zero,
                      child: Icon(
                        showingSearchFilter
                            ? CupertinoIcons.line_horizontal_3_decrease
                            : CupertinoIcons.line_horizontal_3_decrease, // change if needed
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
                        isGridView
                            ? CupertinoIcons.square_grid_2x2
                            : CupertinoIcons.list_bullet,
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
                              builder: (context) => RecordDetailView(record: record)),
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

  SearchFilterBar({
    required this.searchText,
    required this.onSearchTextChanged,
    required this.selectedGenre,
    required this.onGenreChanged,
    required this.sortOption,
    required this.onSortOptionChanged,
    required this.genres,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
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
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: [
              DropdownButton<String>(
                value: selectedGenre,
                items: genres
                    .map((genre) => DropdownMenuItem(value: genre, child: Text(genre)))
                    .toList(),
                onChanged: (value) {
                  if (value != null) onGenreChanged(value);
                },
              ),
              SizedBox(width: 16),
              DropdownButton<SortOption>(
                value: sortOption,
                items: SortOption.values
                    .map((option) => DropdownMenuItem(
                  value: option,
                  child: Text(option.displayName),
                ))
                    .toList(),
                onChanged: (value) {
                  if (value != null) onSortOptionChanged(value);
                },
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
    return CupertinoButton(
      padding: EdgeInsets.zero,
      onPressed: () {
        Navigator.push(
          context,
          CupertinoPageRoute(builder: (context) => RecordDetailView(record: record)),
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
                Text("₩${record.price}",
                    style: TextStyle(fontSize: 14)),
              ],
            ),
          ),
          Icon(
            record.trending ? CupertinoIcons.arrow_up : CupertinoIcons.arrow_down,
            color: record.trending ? CupertinoColors.activeGreen : CupertinoColors.destructiveRed,
          ),
        ],
      ),
    );
  }
}

// ===== Edit Record View (Cupertino 스타일) =====

class EditRecordView extends StatefulWidget {
  final Record record;
  EditRecordView({required this.record});

  @override
  _EditRecordViewState createState() => _EditRecordViewState();
}

class _EditRecordViewState extends State<EditRecordView> {
  late TextEditingController titleController;
  late TextEditingController artistController;
  late TextEditingController releaseYearController;
  late TextEditingController genreController;
  late TextEditingController notesController;
  late TextEditingController catalogNumberController;
  late TextEditingController labelController;
  late TextEditingController formatController;
  late TextEditingController countryController;
  late TextEditingController styleController;
  late TextEditingController conditionController;
  late TextEditingController conditionNotesController;

  @override
  void initState() {
    super.initState();
    titleController = TextEditingController(text: widget.record.title);
    artistController = TextEditingController(text: widget.record.artist);
    releaseYearController =
        TextEditingController(text: widget.record.releaseYear?.toString() ?? "");
    genreController = TextEditingController(text: widget.record.genre ?? "");
    notesController = TextEditingController(text: widget.record.notes ?? "");
    catalogNumberController =
        TextEditingController(text: widget.record.catalogNumber ?? "");
    labelController = TextEditingController(text: widget.record.label ?? "");
    formatController = TextEditingController(text: widget.record.format ?? "");
    countryController = TextEditingController(text: widget.record.country ?? "");
    styleController = TextEditingController(text: widget.record.style ?? "");
    conditionController = TextEditingController(text: widget.record.condition ?? "NM");
    conditionNotesController =
        TextEditingController(text: widget.record.conditionNotes ?? "");
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text("레코드 수정"),
        trailing: CupertinoButton(
          padding: EdgeInsets.zero,
          child: Icon(CupertinoIcons.check_mark),
          onPressed: () {
            saveRecord();
            Navigator.pop(context);
          },
        ),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: ListView(
            children: [
              Text("기본 정보", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              CupertinoTextField(controller: titleController, placeholder: "앨범명"),
              SizedBox(height: 8),
              CupertinoTextField(controller: artistController, placeholder: "아티스트"),
              SizedBox(height: 8),
              CupertinoTextField(
                controller: releaseYearController,
                placeholder: "발매년도",
                keyboardType: TextInputType.number,
              ),
              SizedBox(height: 8),
              CupertinoTextField(controller: genreController, placeholder: "장르"),
              SizedBox(height: 16),
              Text("Discogs 메타데이터", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              CupertinoTextField(controller: catalogNumberController, placeholder: "카탈로그 번호"),
              SizedBox(height: 8),
              CupertinoTextField(controller: labelController, placeholder: "레이블"),
              SizedBox(height: 8),
              CupertinoTextField(controller: formatController, placeholder: "포맷"),
              SizedBox(height: 8),
              CupertinoTextField(controller: countryController, placeholder: "국가"),
              SizedBox(height: 8),
              CupertinoTextField(controller: styleController, placeholder: "스타일"),
              SizedBox(height: 16),
              Text("레코드 상태", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              // For a Cupertino-style segmented control, you might use CupertinoSegmentedControl
              DropdownButton<String>(
                value: conditionController.text,
                items: [
                  DropdownMenuItem(child: Text("M - Mint (완벽한 상태)"), value: "M"),
                  DropdownMenuItem(child: Text("NM - Near Mint (거의 새것)"), value: "NM"),
                  DropdownMenuItem(child: Text("VG+ - Very Good Plus (매우 좋음)"), value: "VG+"),
                  DropdownMenuItem(child: Text("VG - Very Good (좋음)"), value: "VG"),
                  DropdownMenuItem(child: Text("G+ - Good Plus (양호)"), value: "G+"),
                  DropdownMenuItem(child: Text("G - Good (보통)"), value: "G"),
                  DropdownMenuItem(child: Text("F - Fair (나쁨)"), value: "F"),
                ],
                onChanged: (value) {
                  setState(() {
                    conditionController.text = value ?? "NM";
                  });
                },
                // Cupertino doesn't have a built-in dropdown, so you might need a custom solution.
              ),
              SizedBox(height: 8),
              CupertinoTextField(
                controller: conditionNotesController,
                placeholder: "상태 설명",
                maxLines: 3,
              ),
              SizedBox(height: 16),
              Text("노트", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              CupertinoTextField(
                controller: notesController,
                placeholder: "노트",
                maxLines: 3,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void saveRecord() {
    setState(() {
      widget.record.title = titleController.text;
      widget.record.artist = artistController.text;
      widget.record.releaseYear = int.tryParse(releaseYearController.text);
      widget.record.genre = genreController.text;
      widget.record.notes = notesController.text;
      widget.record.catalogNumber = catalogNumberController.text;
      widget.record.label = labelController.text;
      widget.record.format = formatController.text;
      widget.record.country = countryController.text;
      widget.record.style = styleController.text;
      widget.record.condition = conditionController.text;
      widget.record.conditionNotes = conditionNotesController.text;
      widget.record.updatedAt = DateTime.now();
    });
  }
}

// ===== Analytics Section (Cupertino 스타일) =====

class AnalyticsSection extends StatefulWidget {
  final CollectionAnalytics? analytics;
  AnalyticsSection({this.analytics});
  @override
  _AnalyticsSectionState createState() => _AnalyticsSectionState();
}

class _AnalyticsSectionState extends State<AnalyticsSection> {
  int currentPage = 0;
  PageController _pageController = PageController();
  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    double cardWidth = MediaQuery.of(context).size.width - 32;
    double cardHeight = 340;
    Color primaryColor = Color(0xFF0036FF);
    return Column(
      children: [
        widget.analytics != null
            ? Container(
          height: cardHeight,
          child: PageView(
            controller: _pageController,
            onPageChanged: (index) {
              setState(() {
                currentPage = index;
              });
            },
            children: [
              AnalyticCard(
                title: "컬렉션 현황",
                width: cardWidth,
                height: cardHeight,
                child: CollectionSummaryView(analytics: widget.analytics!),
              ),
              AnalyticCard(
                title: "장르별 분포",
                width: cardWidth,
                height: cardHeight,
                child: GenreDistributionView(genres: widget.analytics!.genres),
              ),
              AnalyticCard(
                title: "연도별 분포",
                width: cardWidth,
                height: cardHeight,
                child: DecadeDistributionView(decades: widget.analytics!.decades),
              ),
            ],
          ),
        )
            : AnalyticCard(
          title: "컬렉션 분석",
          width: cardWidth,
          height: cardHeight,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(CupertinoIcons.music_note, size: 48, color: CupertinoColors.systemBlue),
                SizedBox(height: 8),
                Text(
                  "컬렉션을 추가하여\n분석을 시작해보세요",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16, color: CupertinoColors.systemGrey),
                ),
              ],
            ),
          ),
        ),
        if (widget.analytics != null)
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(3, (index) {
              return Container(
                margin: EdgeInsets.symmetric(horizontal: 4, vertical: 8),
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: currentPage == index ? primaryColor : Colors.grey.withOpacity(0.3),
                ),
              );
            }),
          ),
      ],
    );
  }
}

class AnalyticCard extends StatelessWidget {
  final String title;
  final double width;
  final double height;
  final Widget child;
  AnalyticCard({required this.title, required this.width, required this.height, required this.child});
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: CupertinoColors.systemBackground,
        borderRadius: BorderRadius.circular(16),
      ),
      width: width,
      height: height,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            child: Text(title, style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600)),
          ),
          Expanded(
              child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20), child: child)),
        ],
      ),
    );
  }
}

class CollectionSummaryView extends StatelessWidget {
  final CollectionAnalytics analytics;
  CollectionSummaryView({required this.analytics});
  @override
  Widget build(BuildContext context) {
    Color primaryColor = Color(0xFF0036FF);
    if (analytics.totalRecords == 0) {
      return Center(
        child: Text("아직 레코드가 없습니다", style: TextStyle(fontSize: 14, color: CupertinoColors.systemGrey)),
      );
    } else {
      return Column(
        children: [
          Row(
            children: [
              Expanded(
                child: StatisticCard(
                  title: "총 레코드",
                  value: "${analytics.totalRecords}장",
                  icon: CupertinoIcons.music_note,
                  color: primaryColor,
                ),
              ),
              SizedBox(width: 8),
              Expanded(
                child: StatisticCard(
                  title: "인기 장르",
                  value: analytics.mostCollectedGenre.isEmpty ? "없음" : analytics.mostCollectedGenre,
                  icon: CupertinoIcons.music_mic,
                  color: primaryColor,
                ),
              ),
            ],
          ),
          SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: StatisticCard(
                  title: "가장 많은 아티스트",
                  value: analytics.mostCollectedArtist.isEmpty ? "없음" : analytics.mostCollectedArtist,
                  icon: CupertinoIcons.person_2,
                  color: primaryColor,
                ),
              ),
              SizedBox(width: 8),
              Expanded(
                child: StatisticCard(
                  title: "수집 기간",
                  value: analytics.oldestRecord == 0 ? "없음" : "${analytics.oldestRecord} - ${analytics.newestRecord}",
                  icon: CupertinoIcons.calendar,
                  color: primaryColor,
                ),
              ),
            ],
          ),
        ],
      );
    }
  }
}

class StatisticCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;
  StatisticCard({required this.title, required this.value, required this.icon, required this.color});
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: CupertinoColors.white.withOpacity(0.5),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 16, color: color),
              SizedBox(width: 8),
              Text(title, style: TextStyle(fontSize: 14, color: CupertinoColors.systemGrey)),
            ],
          ),
          SizedBox(height: 8),
          Text(value,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
              maxLines: 1,
              overflow: TextOverflow.ellipsis),
        ],
      ),
    );
  }
}

/// fl_chart를 이용한 장르 분포 뷰 (Cupertino 스타일)
class GenreDistributionView extends StatelessWidget {
  final List<GenreAnalytics> genres;
  const GenreDistributionView({Key? key, required this.genres}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    Color primaryColor = const Color(0xFF0036FF);
    if (genres.isEmpty) {
      return Center(
        child: Text(
          "아직 장르 데이터가 없습니다",
          style: TextStyle(fontSize: 14, color: CupertinoColors.systemGrey),
        ),
      );
    }
    List<GenreAnalytics> sortedGenres = List.from(genres)
      ..sort((a, b) => b.count.compareTo(a.count));
    List<GenreAnalytics> topGenres = sortedGenres.take(6).toList();
    double maxY = topGenres.map((e) => e.count).reduce((a, b) => a > b ? a : b).toDouble() + 2;
    return Container(
      height: 200,
      padding: EdgeInsets.symmetric(horizontal: 8),
      child: BarChart(
        BarChartData(
          alignment: BarChartAlignment.spaceAround,
          maxY: maxY,
          barTouchData: BarTouchData(
            enabled: true,
            touchTooltipData: BarTouchTooltipData(
              getTooltipItem: (group, groupIndex, rod, rodIndex) {
                final genre = topGenres[group.x.toInt()];
                return BarTooltipItem(
                  "${genre.count}장",
                  TextStyle(color: CupertinoColors.white, fontSize: 12),
                );
              },
            ),
          ),
          titlesData: FlTitlesData(
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                interval: 1,
                getTitlesWidget: (double value, TitleMeta meta) {
                  int index = value.toInt();
                  if (index < topGenres.length) {
                    String label = topGenres[index].name == "기타" ? "미분류" : topGenres[index].name;
                    return SideTitleWidget(
                      space: 4,
                      meta: meta,
                      child: Text(
                        label,
                        style: TextStyle(fontSize: 12, color: CupertinoColors.systemGrey),
                      ),
                    );
                  }
                  return SizedBox.shrink();
                },
              ),
            ),
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 28,
                interval: 1,
                getTitlesWidget: (double value, TitleMeta meta) {
                  return Text(
                    value.toInt().toString(),
                    style: TextStyle(fontSize: 12, color: CupertinoColors.systemGrey),
                  );
                },
              ),
            ),
            topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
            rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          ),
          borderData: FlBorderData(show: false),
          gridData: FlGridData(show: false),
          barGroups: topGenres.asMap().entries.map((entry) {
            int index = entry.key;
            final genre = entry.value;
            return BarChartGroupData(
              x: index,
              barRods: [
                BarChartRodData(
                  toY: genre.count.toDouble(),
                  width: 20,
                  borderRadius: BorderRadius.circular(4),
                  color: primaryColor,
                ),
              ],
            );
          }).toList(),
        ),
      ),
    );
  }
}

/// fl_chart를 이용한 연도 분포 뷰 (Cupertino 스타일)
class DecadeDistributionView extends StatelessWidget {
  final List<DecadeAnalytics> decades;
  const DecadeDistributionView({Key? key, required this.decades}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    Color primaryColor = const Color(0xFF0036FF);
    if (decades.isEmpty) {
      return Center(
        child: Text(
          "아직 연도 데이터가 없습니다",
          style: TextStyle(fontSize: 14, color: CupertinoColors.systemGrey),
        ),
      );
    }
    List<DecadeAnalytics> sortedDecades = List.from(decades)
      ..sort((a, b) => a.decade.compareTo(b.decade));
    double maxY = sortedDecades.map((e) => e.count).reduce((a, b) => a > b ? a : b).toDouble() + 2;
    return Container(
      height: 200,
      padding: EdgeInsets.symmetric(horizontal: 8),
      child: BarChart(
        BarChartData(
          alignment: BarChartAlignment.spaceAround,
          maxY: maxY,
          barTouchData: BarTouchData(
            enabled: true,
            touchTooltipData: BarTouchTooltipData(
              getTooltipItem: (group, groupIndex, rod, rodIndex) {
                final decade = sortedDecades[group.x.toInt()];
                return BarTooltipItem(
                  "${decade.count}장",
                  TextStyle(color: CupertinoColors.white, fontSize: 12),
                );
              },
            ),
          ),
          titlesData: FlTitlesData(
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                interval: 1,
                getTitlesWidget: (double value, TitleMeta meta) {
                  int index = value.toInt();
                  if (index < sortedDecades.length) {
                    String label = sortedDecades[index].decade;
                    return SideTitleWidget(
                      space: 4,
                      meta: meta,
                      child: Text(
                        label,
                        style: TextStyle(fontSize: 12, color: CupertinoColors.systemGrey),
                      ),
                    );
                  }
                  return SizedBox.shrink();
                },
              ),
            ),
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 28,
                interval: 1,
                getTitlesWidget: (double value, TitleMeta meta) {
                  return Text(
                    value.toInt().toString(),
                    style: TextStyle(fontSize: 12, color: CupertinoColors.systemGrey),
                  );
                },
              ),
            ),
            topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
            rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          ),
          borderData: FlBorderData(show: false),
          gridData: FlGridData(show: false),
          barGroups: sortedDecades.asMap().entries.map((entry) {
            int index = entry.key;
            final decade = entry.value;
            return BarChartGroupData(
              x: index,
              barRods: [
                BarChartRodData(
                  toY: decade.count.toDouble(),
                  width: 20,
                  borderRadius: BorderRadius.circular(4),
                  color: primaryColor,
                ),
              ],
            );
          }).toList(),
        ),
      ),
    );
  }
}

class RecordCardView extends StatelessWidget {
  final Record record;
  RecordCardView({required this.record});
  @override
  Widget build(BuildContext context) {
    double cardWidth = (MediaQuery.of(context).size.width - 48) / 2;
    double imageHeight = 160;
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: CupertinoColors.systemBackground,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.vertical(top: Radius.circular(8)),
            child: Image.network(
              record.coverImageURL ?? "https://s.pstatic.net/dthumb.phinf/?src=%22https%3A%2F%2Fs.pstatic.net%2Fshop.phinf%2F20250217_3%2F17397898415832ySrH_PNG%2FED9994EBA9B4%252BECBAA1ECB298%252B2025-02-17%252B195422.png%22&type=ff364_236&service=navermain",
              width: cardWidth,
              height: imageHeight,
              fit: BoxFit.cover,
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 4, vertical: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(record.title,
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis),
                Text(record.artist,
                    style: TextStyle(fontSize: 12, color: CupertinoColors.systemGrey),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis),
                Row(
                  children: [
                    if (record.releaseYear != null)
                      Text("${record.releaseYear}",
                          style: TextStyle(fontSize: 11, color: CupertinoColors.systemGrey)),
                    if (record.releaseYear != null && record.genre != null)
                      Text(" • ", style: TextStyle(fontSize: 11, color: CupertinoColors.systemGrey)),
                    if (record.genre != null)
                      Text(record.genre!,
                          style: TextStyle(fontSize: 11, color: CupertinoColors.systemGrey),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis),
                  ],
                ),
              ],
            ),
          ),
        ],
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
      navigationBar: CupertinoNavigationBar(middle: Text("수동 입력")),
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
                  widget.onSave(titleController.text, artistController.text, year, genreController.text, notesController.text);
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

// ===== Record Detail View (Cupertino 스타일) =====

class RecordDetailView extends StatelessWidget {
  final Record record;
  RecordDetailView({required this.record});
  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(middle: Text(record.title)),
      child: Center(child: Text("상세 정보 페이지")),
    );
  }
}
