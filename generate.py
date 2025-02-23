#!/usr/bin/env python3
import os

# 생성할 파일 경로와 내용을 딕셔너리로 정의합니다.
files = {
    "lib/main.dart": r'''import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

void main() => runApp(MyApp());

/// 앱 엔트리 포인트 (CupertinoApp 사용)
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CupertinoApp(
      title: 'Kolektt',
      theme: CupertinoThemeData(
        primaryColor: CupertinoColors.activeBlue,
      ),
      home: HomeView(),
    );
  }
}

/// HomeView: SwiftUI의 NavigationView+ScrollView를 CupertinoPageScaffold와 SingleChildScrollView로 변환
class HomeView extends StatefulWidget {
  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  String selectedGenre = "전체";

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text('Kolektt'),
        trailing: HomeToolbar(),
      ),
      child: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(vertical: 16),
          child: Column(
            children: [
              MagazineSection(articles: DummyData.articles),
              SizedBox(height: 24),
              DJPickSection(djPicks: DummyData.djPicks),
              SizedBox(height: 24),
              PopularRecordsSection(
                genres: DummyData.genres,
                selectedGenre: selectedGenre,
                onGenreChanged: (genre) {
                  setState(() {
                    selectedGenre = genre;
                  });
                },
                records: DummyData.popularRecords,
              ),
              SizedBox(height: 24),
              MusicTasteSection(musicTastes: DummyData.musicTastes),
              SizedBox(height: 24),
              LeaderboardView(data: DummyData.leaderboardData),
            ],
          ),
        ),
      ),
    );
  }
}

/// MagazineSection: 가로 스크롤로 기사 목록 표시
class MagazineSection extends StatelessWidget {
  final List<Article> articles;
  const MagazineSection({required this.articles});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 250,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: 16),
        itemCount: articles.length,
        separatorBuilder: (_, __) => SizedBox(width: 16),
        itemBuilder: (context, index) {
          final article = articles[index];
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                CupertinoPageRoute(
                    builder: (context) => MagazineDetailView(article: article)),
              );
            },
            child: Container(
              width: 280,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 커버 이미지
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.network(
                      article.coverImageURL,
                      width: 280,
                      height: 180,
                      fit: BoxFit.cover,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    article.title,
                    style:
                        TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  if (article.subtitle != null)
                    Text(
                      article.subtitle!,
                      style: TextStyle(
                          fontSize: 14, color: CupertinoColors.systemGrey),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

/// DJPickSection: DJ 카드들을 가로 스크롤로 표시
class DJPickSection extends StatelessWidget {
  final List<DJPick> djPicks;
  const DJPickSection({required this.djPicks});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 헤더
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: [
              Text(
                "DJ's",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              Spacer(),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    CupertinoPageRoute(
                        builder: (context) => DJsPickListView()),
                  );
                },
                child: Row(
                  children: [
                    Text("더보기",
                        style: TextStyle(
                            fontSize: 14,
                            color: CupertinoColors.systemGrey)),
                    Icon(CupertinoIcons.right_chevron,
                        size: 14, color: CupertinoColors.systemGrey),
                  ],
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 16),
        Container(
          height: 300,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.symmetric(horizontal: 16),
            itemCount: djPicks.length,
            separatorBuilder: (_, __) => SizedBox(width: 16),
            itemBuilder: (context, index) {
              final djPick = djPicks[index];
              return GestureDetector(
                onTap: () {
                  final dj = DJ(
                    id: djPick.id,
                    name: djPick.name,
                    title: "DJ",
                    imageURL: djPick.imageUrl,
                    yearsActive: 5,
                    recordCount: djPick.likes * 100,
                    interviewContents: [
                      InterviewContent(
                        id: "1",
                        type: InterviewContentType.text,
                        text:
                            "음악은 저에게 있어서 삶 그 자체입니다. 제가 선별한 레코드들을 통해 여러분도 음악의 진정한 매력을 느끼실 수 있기를 바랍니다.",
                        records: [],
                      ),
                      InterviewContent(
                        id: "2",
                        type: InterviewContentType.quote,
                        text:
                            "좋은 음악은 시대를 초월하여 우리의 마음을 울립니다.",
                        records: [],
                      ),
                      InterviewContent(
                        id: "3",
                        type: InterviewContentType.recordHighlight,
                        text: "이번 주 추천 레코드",
                        records: DummyData.records,
                      ),
                    ],
                  );
                  Navigator.push(
                    context,
                    CupertinoPageRoute(
                        builder: (context) => DJsPickDetailView(dj: dj)),
                  );
                },
                child: DJPickCard(dj: djPick),
              );
            },
          ),
        ),
      ],
    );
  }
}

/// PopularRecordsSection: 인기 레코드 섹션 (헤더, 장르 필터, 레코드 리스트)
class PopularRecordsSection extends StatelessWidget {
  final List<String> genres;
  final String selectedGenre;
  final Function(String) onGenreChanged;
  final List<PopularRecord> records;

  const PopularRecordsSection({
    required this.genres,
    required this.selectedGenre,
    required this.onGenreChanged,
    required this.records,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionHeader(title: "인기"),
        GenreScrollView(
          genres: genres,
          selectedGenre: selectedGenre,
          onGenreChanged: onGenreChanged,
        ),
        RecordsList(records: records),
      ],
    );
  }
}

/// MusicTasteSection: 추천 레코드 (2열 그리드)
class MusicTasteSection extends StatelessWidget {
  final List<MusicTaste> musicTastes;
  const MusicTasteSection({required this.musicTastes});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionHeader(
          title: "추천",
          showMore: true,
          onMore: () {
            // 더보기 액션 구현
          },
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: GridView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: musicTastes.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: 1,
            ),
            itemBuilder: (context, index) {
              return MusicTasteCard(musicTaste: musicTastes[index]);
            },
          ),
        ),
      ],
    );
  }
}

/// GenreScrollView: 장르 버튼들을 가로 스크롤로 표시
class GenreScrollView extends StatelessWidget {
  final List<String> genres;
  final String selectedGenre;
  final Function(String) onGenreChanged;
  const GenreScrollView({
    required this.genres,
    required this.selectedGenre,
    required this.onGenreChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: 16),
        itemCount: genres.length,
        separatorBuilder: (_, __) => SizedBox(width: 10),
        itemBuilder: (context, index) {
          final genre = genres[index];
          return GenreButton(
            title: genre,
            isSelected: selectedGenre == genre,
            onTap: () => onGenreChanged(genre),
          );
        },
      ),
    );
  }
}

/// RecordsList: 인기 레코드 목록 (최대 5개)
class RecordsList extends StatelessWidget {
  final List<PopularRecord> records;
  const RecordsList({required this.records});

  @override
  Widget build(BuildContext context) {
    final displayRecords = records.take(5).toList();
    return Column(
      children: displayRecords.asMap().entries.map((entry) {
        int index = entry.key;
        PopularRecord record = entry.value;
        return PopularRecordRow(record: record, rank: index + 1);
      }).toList(),
    );
  }
}

/// HomeToolbar: 상단 툴바 (검색, 알림 버튼)
class HomeToolbar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        CupertinoButton(
          padding: EdgeInsets.zero,
          child: Icon(CupertinoIcons.search),
          onPressed: () {
            Navigator.push(context,
                CupertinoPageRoute(builder: (_) => SearchView()));
          },
        ),
        CupertinoButton(
          padding: EdgeInsets.zero,
          child: Icon(CupertinoIcons.bell),
          onPressed: () {
            Navigator.push(context,
                CupertinoPageRoute(builder: (_) => NotificationsView()));
          },
        ),
      ],
    );
  }
}

/// SectionHeader: 섹션 제목 및 (선택적) 더보기 버튼
class SectionHeader extends StatelessWidget {
  final String title;
  final bool showMore;
  final VoidCallback? onMore;
  const SectionHeader({required this.title, this.showMore = false, this.onMore});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          Text(title,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          Spacer(),
          if (showMore)
            GestureDetector(
              onTap: onMore,
              child: Row(
                children: [
                  Text("더보기",
                      style: TextStyle(
                          fontSize: 14, color: CupertinoColors.systemGrey)),
                  Icon(CupertinoIcons.right_chevron,
                      size: 14, color: CupertinoColors.systemGrey),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

/// DJPickCard: DJ 카드 컴포넌트
class DJPickCard extends StatelessWidget {
  final DJPick dj;
  const DJPickCard({required this.dj});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 160,
      decoration: BoxDecoration(
        color: CupertinoColors.systemBackground,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // DJ 이미지
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.network(
              dj.imageUrl,
              width: 160,
              height: 200,
              fit: BoxFit.cover,
            ),
          ),
          Padding(
            padding: EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(dj.name,
                    style:
                        TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                SizedBox(height: 4),
                Row(
                  children: [
                    GenreTag(text: "House"),
                    SizedBox(width: 8),
                    GenreTag(text: "Techno"),
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

/// GenreTag: 작은 태그 스타일 (예: House, Techno)
class GenreTag extends StatelessWidget {
  final String text;
  const GenreTag({required this.text});
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: CupertinoColors.systemGrey6,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(text, style: TextStyle(fontSize: 12)),
    );
  }
}

/// PopularRecordRow: 인기 레코드 리스트 행
class PopularRecordRow extends StatelessWidget {
  final PopularRecord record;
  final int rank;
  const PopularRecordRow({required this.record, required this.rank});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Record recordObj = Record(
          id: UniqueKey().toString(),
          title: record.title,
          artist: record.artist,
          releaseYear: 2024,
          genre: "Jazz",
          coverImageURL: record.imageUrl,
          notes: null,
          lowestPrice: record.price.toInt(),
          price: record.price.toInt(),
          priceChange: 0.0,
          sellersCount: 3,
          recordDescription:
              "A beautiful collection of timeless classics",
          rank: rank,
          rankChange: 2,
          trending: record.trending,
        );
        Navigator.push(
          context,
          CupertinoPageRoute(
              builder: (_) => RecordDetailView(record: recordObj)),
        );
      },
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        child: Row(
          children: [
            // 순위 표시
            Column(
              children: [
                Text("$rank",
                    style:
                        TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                Row(
                  children: [
                    Icon(
                      record.trending
                          ? CupertinoIcons.arrow_up
                          : CupertinoIcons.arrow_down,
                      size: 14,
                      color:
                          record.trending ? Colors.green : Colors.red,
                    ),
                    Text(record.trending ? "+2" : "-2",
                        style: TextStyle(
                            fontSize: 12,
                            color: record.trending
                                ? Colors.green
                                : Colors.red)),
                  ],
                ),
              ],
            ),
            SizedBox(width: 16),
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(
                record.imageUrl,
                width: 60,
                height: 60,
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(record.title,
                      style: TextStyle(
                          fontSize: 16, fontWeight: FontWeight.bold),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis),
                  Text(record.artist,
                      style: TextStyle(
                          fontSize: 14,
                          color: CupertinoColors.systemGrey),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis),
                  PriceText(price: record.price.toInt()),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// MusicTasteCard: 추천 레코드 카드
class MusicTasteCard extends StatelessWidget {
  final MusicTaste musicTaste;
  const MusicTasteCard({required this.musicTaste});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            CupertinoPageRoute(
                builder: (_) => RecordDetailView(record: musicTaste.record)));
      },
      child: Container(
        decoration: BoxDecoration(
          color: CupertinoColors.systemBackground,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 앨범 커버
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(
                musicTaste.imageUrl,
                width: (MediaQuery.of(context).size.width - 48) / 2,
                height: (MediaQuery.of(context).size.width - 48) / 2,
                fit: BoxFit.cover,
              ),
            ),
            Padding(
              padding:
                  EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(musicTaste.title,
                      style: TextStyle(
                          fontWeight: FontWeight.bold),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis),
                  Text(musicTaste.subtitle,
                      style: TextStyle(
                          color: CupertinoColors.systemGrey),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// GenreButton: 장르 선택 버튼
class GenreButton extends StatelessWidget {
  final String title;
  final bool isSelected;
  final VoidCallback onTap;
  const GenreButton(
      {required this.title, required this.isSelected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding:
            EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected
              ? CupertinoColors.black
              : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
          border: isSelected
              ? null
              : Border.all(
                  color: Colors.grey.withOpacity(0.3)),
        ),
        child: Text(
          title,
          style: TextStyle(
              fontSize: 14,
              color: isSelected
                  ? CupertinoColors.white
                  : CupertinoColors.black),
        ),
      ),
    );
  }
}

/// PriceText: 가격 표시 위젯
class PriceText extends StatelessWidget {
  final int price;
  const PriceText({required this.price});

  @override
  Widget build(BuildContext context) {
    return Text(
      "$price원",
      style: TextStyle(
          fontSize: 14, color: CupertinoColors.activeBlue),
    );
  }
}

/// ----- 더미 데이터 및 모델 -----

class Article {
  final String title;
  final String? subtitle;
  final String coverImageURL;
  Article({required this.title, this.subtitle, required this.coverImageURL});
}

class DJPick {
  final String id;
  final String name;
  final String imageUrl;
  final int likes;
  DJPick(
      {required this.id,
      required this.name,
      required this.imageUrl,
      required this.likes});
}

class PopularRecord {
  final String id;
  final String title;
  final String artist;
  final double price;
  final String imageUrl;
  final bool trending;
  PopularRecord(
      {required this.id,
      required this.title,
      required this.artist,
      required this.price,
      required this.imageUrl,
      required this.trending});
}

class MusicTaste {
  final String id;
  final String title;
  final String subtitle;
  final String imageUrl;
  final Record record;
  MusicTaste(
      {required this.id,
      required this.title,
      required this.subtitle,
      required this.imageUrl,
      required this.record});
}

class Record {
  final String id;
  final String title;
  final String artist;
  final int? releaseYear;
  final String? genre;
  final String coverImageURL;
  final String? notes;
  final int lowestPrice;
  final int? price;
  final double? priceChange;
  final int sellersCount;
  final String? recordDescription;
  final int? rank;
  final int? rankChange;
  final bool trending;
  Record({
    required this.id,
    required this.title,
    required this.artist,
    this.releaseYear,
    this.genre,
    required this.coverImageURL,
    this.notes,
    required this.lowestPrice,
    this.price,
    this.priceChange,
    required this.sellersCount,
    this.recordDescription,
    this.rank,
    this.rankChange,
    required this.trending,
  });
}

class LeaderboardData {
  final List<LeaderboardUser> sellers;
  final List<LeaderboardUser> buyers;
  LeaderboardData({required this.sellers, required this.buyers});
}

class LeaderboardUser {
  final String id;
  final String name;
  final int amount;
  final int rank;
  LeaderboardUser(
      {required this.id, required this.name, required this.amount, required this.rank});
}

class InterviewContent {
  final String id;
  final InterviewContentType type;
  final String text;
  final List<Record> records;
  InterviewContent(
      {required this.id,
      required this.type,
      required this.text,
      required this.records});
}

enum InterviewContentType {
  text,
  quote,
  recordHighlight,
}

class DJ {
  final String id;
  final String name;
  final String title;
  final String imageURL;
  final int yearsActive;
  final int recordCount;
  final List<InterviewContent> interviewContents;
  DJ({
    required this.id,
    required this.name,
    required this.title,
    required this.imageURL,
    required this.yearsActive,
    required this.recordCount,
    required this.interviewContents,
  });
}

/// 더미 데이터 제공 클래스
class DummyData {
  static List<Article> articles = [
    Article(
        title: "레코드로 듣는 재즈의 매력",
        subtitle: "아날로그 사운드의 따뜻함을 느껴보세요",
        coverImageURL: "https://example.com/jazz-cover.jpg"),
  ];

  static List<DJPick> djPicks = [
    DJPick(
        id: "1",
        name: "Sickmode",
        imageUrl: "https://example.com/dj1.jpg",
        likes: 10),
    DJPick(
        id: "2",
        name: "Zedd",
        imageUrl: "https://example.com/dj2.jpg",
        likes: 15),
  ];

  static List<String> genres = ["전체", "Rock", "Jazz", "Classical", "Hip-Hop", "Electronic"];

  static List<PopularRecord> popularRecords = [
    PopularRecord(
        id: "1",
        title: "Abbey Road",
        artist: "The Beatles",
        price: 180000,
        imageUrl: "https://example.com/record1.jpg",
        trending: true),
    PopularRecord(
        id: "2",
        title: "Thriller",
        artist: "Michael Jackson",
        price: 165000,
        imageUrl: "https://example.com/record2.jpg",
        trending: false),
  ];

  static List<MusicTaste> musicTastes = [
    MusicTaste(
      id: "1",
      title: "Yesterday",
      subtitle: "The Beatles",
      imageUrl: "https://example.com/taste1.jpg",
      record: Record(
        id: "r1",
        title: "Yesterday",
        artist: "The Beatles",
        releaseYear: 1965,
        genre: "Pop",
        coverImageURL: "https://example.com/taste1.jpg",
        notes: "클래식한 비틀즈의 명곡",
        lowestPrice: 150,
        price: 150,
        priceChange: 0,
        sellersCount: 5,
        recordDescription: "클래식한 비틀즈의 명곡",
        rank: 1,
        rankChange: 0,
        trending: true,
      ),
    ),
  ];

  static List<Record> records = [
    Record(
      id: "r1",
      title: "Abbey Road",
      artist: "The Beatles",
      releaseYear: 1969,
      genre: "Rock",
      coverImageURL: "https://example.com/abbey-road.jpg",
      notes: "",
      lowestPrice: 150000,
      price: 150000,
      priceChange: 0,
      sellersCount: 3,
      recordDescription: "",
      rank: 1,
      rankChange: 0,
      trending: true,
    ),
  ];

  static LeaderboardData leaderboardData = LeaderboardData(
    sellers: [
      LeaderboardUser(id: "u1", name: "김판매", amount: 1250000, rank: 1),
      LeaderboardUser(id: "u2", name: "이레코드", amount: 980000, rank: 2),
    ],
    buyers: [
      LeaderboardUser(id: "u3", name: "홍구매", amount: 2100000, rank: 1),
      LeaderboardUser(id: "u4", name: "강컬렉터", amount: 1850000, rank: 2),
    ],
  );
}

/// ----- 임시 상세 화면들 -----

class MagazineDetailView extends StatelessWidget {
  final Article article;
  const MagazineDetailView({required this.article});
  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(middle: Text(article.title)),
      child: Center(child: Text("Magazine Detail View")),
    );
  }
}

class DJsPickListView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(middle: Text("DJ's Pick List")),
      child: Center(child: Text("DJ's Pick List View")),
    );
  }
}

class DJsPickDetailView extends StatelessWidget {
  final DJ dj;
  const DJsPickDetailView({required this.dj});
  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(middle: Text(dj.name)),
      child: Center(child: Text("DJ Detail View")),
    );
  }
}

class RecordDetailView extends StatelessWidget {
  final Record record;
  const RecordDetailView({required this.record});
  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(middle: Text(record.title)),
      child: Center(child: Text("Record Detail View")),
    );
  }
}

class SearchView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(middle: Text("Search")),
      child: Center(child: Text("Search View")),
    );
  }
}

class NotificationsView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(middle: Text("Notifications")),
      child: Center(child: Text("Notifications View")),
    );
  }
}

class LeaderboardView extends StatelessWidget {
  final LeaderboardData data;
  const LeaderboardView({required this.data});
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(16),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: CupertinoColors.systemBackground,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("리더보드",
              style:
                  TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          SizedBox(height: 8),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: data.sellers
                  .map((user) => LeaderboardCard(user: user))
                  .toList(),
            ),
          ),
        ],
      ),
    );
  }
}

class LeaderboardCard extends StatelessWidget {
  final LeaderboardUser user;
  const LeaderboardCard({required this.user});
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            CupertinoPageRoute(
                builder: (_) => UserProfileView(user: user)));
      },
      child: Container(
        width: 100,
        margin: EdgeInsets.only(right: 12),
        padding: EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: CupertinoColors.systemBackground,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 10)],
        ),
        child: Column(
          children: [
            CircleAvatar(
              radius: 30,
              backgroundColor: CupertinoColors.systemGrey,
              child: Icon(CupertinoIcons.person),
            ),
            SizedBox(height: 8),
            Text(user.name, style: TextStyle(fontSize: 14)),
            Text("${user.amount}원",
                style: TextStyle(fontSize: 12, color: CupertinoColors.systemGrey)),
          ],
        ),
      ),
    );
  }
}

class UserProfileView extends StatelessWidget {
  final LeaderboardUser user;
  const UserProfileView({required this.user});
  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(middle: Text(user.name)),
      child: Center(child: Text("User Profile View")),
    );
  }
}
''',
}

def create_file(file_path, content):
    directory = os.path.dirname(file_path)
    if directory and not os.path.exists(directory):
        os.makedirs(directory)
        print(f"Created directory: {directory}")
    with open(file_path, "w", encoding="utf-8") as f:
        f.write(content)
    print(f"Created file: {file_path}")

def main():
    for path, content in files.items():
        create_file(path, content)
    print("모든 파일이 생성되었습니다.")

if __name__ == '__main__':
    main()

