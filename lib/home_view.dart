import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'model/popular_record.dart';

// --- 데이터 모델 (실제 프로젝트에 맞게 정의) ---
class Article {
  final String id;
  final String title;
  final String? subtitle;
  final Uri coverImageURL;
  Article({
    required this.id,
    required this.title,
    this.subtitle,
    required this.coverImageURL,
  });
}

class DJPick {
  final String id;
  final String name;
  final String imageUrl;
  final int likes;
  DJPick({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.likes,
  });
}

class MusicTaste {
  final String id;
  final String title;
  final String subtitle;
  final String imageUrl;
  MusicTaste({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.imageUrl,
  });
}

// 임시 모델: Record
class Record {
  final String id;
  final String title;
  final String artist;
  final int releaseYear;
  final String genre;
  final Uri coverImageURL;
  final String? notes;
  final int lowestPrice;
  final int price;
  final num priceChange;
  final int sellersCount;
  final String recordDescription;
  final int rank;
  final int rankChange;
  final bool trending;
  Record({
    required this.id,
    required this.title,
    required this.artist,
    required this.releaseYear,
    required this.genre,
    required this.coverImageURL,
    this.notes,
    required this.lowestPrice,
    required this.price,
    required this.priceChange,
    required this.sellersCount,
    required this.recordDescription,
    required this.rank,
    required this.rankChange,
    required this.trending,
  });
  static List<Record> sampleData = [
    Record(
      id: "s1",
      title: "Sample Record 1",
      artist: "Artist 1",
      releaseYear: 2000,
      genre: "Pop",
      coverImageURL: Uri.parse("https://s.pstatic.net/dthumb.phinf/?src=%22https%3A%2F%2Fs.pstatic.net%2Fshop.phinf%2F20250217_3%2F17397898415832ySrH_PNG%2FED9994EBA9B4%252BECBAA1ECB298%252B2025-02-17%252B195422.png%22&type=ff364_236&service=navermain"),
      notes: "",
      lowestPrice: 100,
      price: 150,
      priceChange: 0,
      sellersCount: 3,
      recordDescription: "Description 1",
      rank: 1,
      rankChange: 0,
      trending: true,
    ),
    // 추가 샘플 데이터...
  ];
}

// 임시 Leaderboard 데이터 및 뷰
class LeaderboardData {
  static List<LeaderboardData> sampleData = [];
}

class LeaderboardView extends StatelessWidget {
  final List<LeaderboardData> data;
  const LeaderboardView({Key? key, required this.data}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: CupertinoColors.systemBackground,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Center(child: Text("Leaderboard View", style: TextStyle(color: CupertinoColors.black))),
    );
  }
}

// --- 메인 홈 뷰 ---
class HomeView extends StatelessWidget {
  // 샘플 데이터 (실제 ViewModel은 Provider, Riverpod 등으로 관리)
  final List<Article> articles = [
    Article(
      id: '1',
      title: '레코드로 듣는 재즈의 매력',
      subtitle: '아날로그 사운드의 따뜻함을 느껴보세요',
      coverImageURL: Uri.parse("https://s.pstatic.net/dthumb.phinf/?src=%22https%3A%2F%2Fs.pstatic.net%2Fshop.phinf%2F20250217_3%2F17397898415832ySrH_PNG%2FED9994EBA9B4%252BECBAA1ECB298%252B2025-02-17%252B195422.png%22&type=ff364_236&service=navermain"),
    ),
    // ... 추가 기사
  ];

  final List<DJPick> djPicks = [
    DJPick(
      id: 'dj1',
      name: "Sickmode",
      imageUrl: "https://s.pstatic.net/dthumb.phinf/?src=%22https%3A%2F%2Fs.pstatic.net%2Fshop.phinf%2F20250217_3%2F17397898415832ySrH_PNG%2FED9994EBA9B4%252BECBAA1ECB298%252B2025-02-17%252B195422.png%22&type=ff364_236&service=navermain",
      likes: 10,
    ),
    // ... 추가 DJPick
  ];

  final List<PopularRecord> popularRecords = [
    PopularRecord(
      id: 'rec1',
      title: "Kind of Blue",
      artist: "Miles Davis",
      price: 150000,
      imageUrl: "https://s.pstatic.net/dthumb.phinf/?src=%22https%3A%2F%2Fs.pstatic.net%2Fshop.phinf%2F20250217_3%2F17397898415832ySrH_PNG%2FED9994EBA9B4%252BECBAA1ECB298%252B2025-02-17%252B195422.png%22&type=ff364_236&service=navermain",
      trending: true,
    ),
    // ... 추가 PopularRecord
  ];

  final List<MusicTaste> musicTastes = [
    MusicTaste(
      id: 'mt1',
      title: "Yesterday",
      subtitle: "The Beatles",
      imageUrl: "https://s.pstatic.net/dthumb.phinf/?src=%22https%3A%2F%2Fs.pstatic.net%2Fshop.phinf%2F20250217_3%2F17397898415832ySrH_PNG%2FED9994EBA9B4%252BECBAA1ECB298%252B2025-02-17%252B195422.png%22&type=ff364_236&service=navermain",
    ),
    // ... 추가 MusicTaste
  ];

  final List<String> genres = ["All", "Pop", "Jazz", "Japan", "Soul", "Rock"];
  final ValueNotifier<String> selectedGenre = ValueNotifier<String>("All");

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text("Kolektt"),
        trailing: HomeToolbar(),
      ),
      child: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: Column(
            mainAxisSize: MainAxisSize.min, // Use min to wrap content tightly
            children: [
              MagazineSection(articles: articles),
              SizedBox(height: 24),
              DJPickSection(djPicks: djPicks),
              SizedBox(height: 24),
              ValueListenableBuilder<String>(
                valueListenable: selectedGenre,
                builder: (context, genre, _) => PopularRecordsSection(
                  genres: genres,
                  selectedGenre: selectedGenre,
                  records: popularRecords,
                ),
              ),
              SizedBox(height: 24),
              MusicTasteSection(musicTastes: musicTastes),
              SizedBox(height: 24),
              LeaderboardView(data: LeaderboardData.sampleData),
            ],
          ),
        ),
      ),
    );
  }
}

// --- 섹션별 컴포넌트 ---

class MagazineSection extends StatelessWidget {
  final List<Article> articles;
  const MagazineSection({Key? key, required this.articles}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 280,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: articles.length,
        separatorBuilder: (_, __) => SizedBox(width: 16),
        itemBuilder: (context, index) {
          final article = articles[index];
          return CupertinoButton(
            padding: EdgeInsets.zero,
            onPressed: () {
              Navigator.push(
                context,
                CupertinoPageRoute(builder: (_) => MagazineDetailView(article: article)),
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
                      article.coverImageURL.toString(),
                      width: 280,
                      height: 180,
                      fit: BoxFit.cover,
                    ),
                  ),
                  SizedBox(height: 12),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          article.title,
                          style: CupertinoTheme.of(context).textTheme.navTitleTextStyle,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        SizedBox(height: 8),
                        if (article.subtitle != null)
                          Text(
                            article.subtitle!,
                            style: CupertinoTheme.of(context).textTheme.textStyle.copyWith(color: CupertinoColors.systemGrey),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                      ],
                    ),
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

class DJPickSection extends StatelessWidget {
  final List<DJPick> djPicks;
  const DJPickSection({Key? key, required this.djPicks}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: [
              Text(
                "DJ's",
                style: CupertinoTheme.of(context).textTheme.navTitleTextStyle,
              ),
              Spacer(),
              CupertinoButton(
                padding: EdgeInsets.zero,
                onPressed: () {
                  Navigator.push(context, CupertinoPageRoute(builder: (_) => DJsPickListView()));
                },
                child: Row(
                  children: [
                    Text("더보기", style: CupertinoTheme.of(context).textTheme.textStyle.copyWith(fontSize: 14)),
                    Icon(CupertinoIcons.chevron_right, size: 16),
                  ],
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 300,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: djPicks.length,
            separatorBuilder: (_, __) => SizedBox(width: 16),
            itemBuilder: (context, index) {
              final dj = djPicks[index];
              return CupertinoButton(
                padding: EdgeInsets.zero,
                onPressed: () {
                  Navigator.push(
                    context,
                    CupertinoPageRoute(
                      builder: (_) => DJsPickDetailView(
                        dj: DJ(
                          id: dj.id,
                          name: dj.name,
                          title: "DJ",
                          imageURL: Uri.parse(dj.imageUrl),
                          yearsActive: 5,
                          recordCount: dj.likes * 100,
                          interviewContents: [
                            InterviewContent(
                              id: "1",
                              type: InterviewContentType.text,
                              text: "음악은 저에게 있어서 삶 그 자체입니다. 제가 선별한 레코드들을 통해 여러분도 음악의 진정한 매력을 느끼실 수 있기를 바랍니다.",
                              records: [],
                            ),
                            InterviewContent(
                              id: "2",
                              type: InterviewContentType.quote,
                              text: "좋은 음악은 시대를 초월하여 우리의 마음을 울립니다.",
                              records: [],
                            ),
                            InterviewContent(
                              id: "3",
                              type: InterviewContentType.recordHighlight,
                              text: "이번 주 추천 레코드",
                              records: Record.sampleData,
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
                child: DJPickCard(dj: dj),
              );
            },
          ),
        ),
      ],
    );
  }
}

class PopularRecordsSection extends StatelessWidget {
  final List<String> genres;
  final ValueNotifier<String> selectedGenre;
  final List<PopularRecord> records;
  const PopularRecordsSection({
    Key? key,
    required this.genres,
    required this.selectedGenre,
    required this.records,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionHeader(title: "인기", showMore: false),
        GenreScrollView(genres: genres, selectedGenre: selectedGenre),
        RecordsList(records: records),
      ],
    );
  }
}

class MusicTasteSection extends StatelessWidget {
  final List<MusicTaste> musicTastes;
  const MusicTasteSection({Key? key, required this.musicTastes}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionHeader(
          title: "추천",
          showMore: true,
          onShowMore: () {
            // 더보기 액션 구현
          },
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: GridView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: musicTastes.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: 0.8,
            ),
            itemBuilder: (context, index) {
              final taste = musicTastes[index];
              return MusicTasteCard(musicTaste: taste);
            },
          ),
        ),
      ],
    );
  }
}

// --- 보조 컴포넌트 ---
class SectionHeader extends StatelessWidget {
  final String title;
  final bool showMore;
  final VoidCallback? onShowMore;
  const SectionHeader({
    Key? key,
    required this.title,
    this.showMore = false,
    this.onShowMore,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          Text(title, style: CupertinoTheme.of(context).textTheme.navTitleTextStyle),
          Spacer(),
          if (showMore)
            CupertinoButton(
              padding: EdgeInsets.zero,
              onPressed: onShowMore,
              child: Row(
                children: [
                  Text("더보기", style: TextStyle(fontSize: 14)),
                  Icon(CupertinoIcons.chevron_right, size: 16),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

class GenreScrollView extends StatelessWidget {
  final List<String> genres;
  final ValueNotifier<String> selectedGenre;
  const GenreScrollView({Key? key, required this.genres, required this.selectedGenre}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40,
      child: ValueListenableBuilder<String>(
        valueListenable: selectedGenre,
        builder: (context, genre, _) => ListView.separated(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          itemCount: genres.length,
          separatorBuilder: (_, __) => SizedBox(width: 10),
          itemBuilder: (context, index) {
            final title = genres[index];
            return GenreButton(
              title: title,
              isSelected: genre == title,
              onPressed: () {
                selectedGenre.value = title;
              },
            );
          },
        ),
      ),
    );
  }
}

class RecordsList extends StatelessWidget {
  final List<PopularRecord> records;
  const RecordsList({Key? key, required this.records}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final displayed = records.take(5).toList();
    return Column(
      children: List.generate(displayed.length, (index) {
        final record = displayed[index];
        return PopularRecordRow(record: record, rank: index + 1);
      }),
    );
  }
}

class HomeToolbar extends StatelessWidget {
  const HomeToolbar({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        CupertinoButton(
          padding: EdgeInsets.zero,
          child: Icon(CupertinoIcons.search),
          onPressed: () {
            showCupertinoModalPopup(context: context, builder: (_) => SearchView());
          },
        ),
        CupertinoButton(
          padding: EdgeInsets.zero,
          child: Icon(CupertinoIcons.bell),
          onPressed: () {
            showCupertinoModalPopup(context: context, builder: (_) => NotificationsView());
          },
        ),
      ],
    );
  }
}

class GenreButton extends StatelessWidget {
  final String title;
  final bool isSelected;
  final VoidCallback onPressed;
  const GenreButton({Key? key, required this.title, required this.isSelected, required this.onPressed}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return CupertinoButton(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      color: isSelected ? CupertinoColors.black : CupertinoColors.systemGrey4,
      borderRadius: BorderRadius.circular(20),
      onPressed: onPressed,
      child: Text(
        title,
        style: TextStyle(color: isSelected ? CupertinoColors.white : CupertinoColors.black),
      ),
    );
  }
}

class DJPickCard extends StatelessWidget {
  final DJPick dj;
  const DJPickCard({Key? key, required this.dj}) : super(key: key);
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
          ClipRRect(
            borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
            child: Image.network(
              dj.imageUrl,
              width: 160,
              height: 200,
              fit: BoxFit.cover,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(dj.name, style: CupertinoTheme.of(context).textTheme.textStyle.copyWith(fontSize: 16)),
                SizedBox(height: 8),
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

class PopularRecordRow extends StatelessWidget {
  final PopularRecord record;
  final int rank;
  const PopularRecordRow({Key? key, required this.record, required this.rank}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return CupertinoButton(
      padding: EdgeInsets.zero,
      onPressed: () {
        Navigator.push(
          context,
          CupertinoPageRoute(
            builder: (_) => RecordDetailView(
              record: Record(
                id: record.id,
                title: record.title,
                artist: record.artist,
                releaseYear: 2024,
                genre: "Jazz",
                coverImageURL: Uri.parse(record.imageUrl),
                notes: "",
                lowestPrice: record.price,
                price: record.price,
                priceChange: 0,
                sellersCount: 3,
                recordDescription: "A beautiful collection of timeless classics",
                rank: rank,
                rankChange: 2,
                trending: record.trending,
              ),
            ),
          ),
        );
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        child: Row(
          children: [
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
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis),
                  Text(record.artist,
                      style: TextStyle(fontSize: 14, color: CupertinoColors.systemGrey),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis),
                  Text("₩${record.price}", style: TextStyle(fontSize: 14)),
                ],
              ),
            ),
            Icon(
              record.trending ? CupertinoIcons.arrow_up : CupertinoIcons.arrow_down,
              color: record.trending ? CupertinoColors.activeGreen : CupertinoColors.destructiveRed,
            ),
          ],
        ),
      ),
    );
  }
}

class MusicTasteCard extends StatelessWidget {
  final MusicTaste musicTaste;
  const MusicTasteCard({Key? key, required this.musicTaste}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final double width = (MediaQuery.of(context).size.width - 48) / 2;
    return CupertinoButton(
      padding: EdgeInsets.zero,
      onPressed: () {
        Navigator.push(
          context,
          CupertinoPageRoute(builder: (_) => RecordDetailView(record: null)),
        );
      },
      child: Container(
        width: width,
        decoration: BoxDecoration(
          color: CupertinoColors.systemBackground,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
              child: Image.network(
                musicTaste.imageUrl,
                width: width,
                height: width,
                fit: BoxFit.cover,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(musicTaste.title,
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis),
                  Text(musicTaste.subtitle,
                      style: TextStyle(fontSize: 14, color: CupertinoColors.systemGrey),
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

class GenreTag extends StatelessWidget {
  final String text;
  const GenreTag({Key? key, required this.text}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: CupertinoColors.systemGrey4,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        text,
        style: TextStyle(fontSize: 12),
      ),
    );
  }
}

// --- 임시 상세 페이지 및 기타 뷰 ---
class MagazineDetailView extends StatelessWidget {
  final Article article;
  const MagazineDetailView({Key? key, required this.article}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(middle: Text(article.title)),
      child: Center(child: Text("Magazine Detail View")),
    );
  }
}

class DJsPickListView extends StatelessWidget {
  const DJsPickListView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(middle: Text("DJ's List")),
      child: Center(child: Text("All DJ Picks")),
    );
  }
}

enum InterviewContentType { text, quote, recordHighlight }

class InterviewContent {
  final String id;
  final InterviewContentType type;
  final String text;
  final List<Record> records;
  InterviewContent({
    required this.id,
    required this.type,
    required this.text,
    required this.records,
  });
}

class DJ {
  final String id;
  final String name;
  final String title;
  final Uri imageURL;
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

class DJsPickDetailView extends StatelessWidget {
  final DJ dj;
  const DJsPickDetailView({Key? key, required this.dj}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(middle: Text(dj.name)),
      child: Center(child: Text("DJ Pick Detail View")),
    );
  }
}

class RecordDetailView extends StatelessWidget {
  final Record? record;
  const RecordDetailView({Key? key, required this.record}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(middle: Text(record?.title ?? "Record Detail")),
      child: Center(child: Text("Record Detail View")),
    );
  }
}

class CollectionRecordDetailView extends StatelessWidget {
  final Record record;
  const CollectionRecordDetailView({Key? key, required this.record}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(middle: Text(record.title)),
      child: Center(child: Text("Collection Record Detail View")),
    );
  }
}

// 임시 Search 및 Notifications 뷰
class SearchView extends StatelessWidget {
  const SearchView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(middle: Text("Search")),
      child: Center(child: Text("Search View")),
    );
  }
}

class NotificationsView extends StatelessWidget {
  const NotificationsView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(middle: Text("Notifications")),
      child: Center(child: Text("Notifications View")),
    );
  }
}
