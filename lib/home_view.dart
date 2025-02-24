import 'package:flutter/cupertino.dart';
import 'package:kolektt/view_models/home_vm.dart';

import 'components/dj_pick_section.dart';
import 'components/leaderboard_view.dart';
import 'components/music_taste_card.dart';
import 'components/popular_records_section.dart';
import 'home/djs_pick_detail_view.dart';
import 'home/home_view.dart';
import 'home/magzine_detail_view.dart' show MagazineDetailView;
import 'model/popular_record.dart';
import 'model/record.dart';
import 'record_detail_view.dart';


// --- 메인 홈 뷰 ---
class HomeView extends StatelessWidget {
  // 샘플 데이터 (실제 ViewModel은 Provider, Riverpod 등으로 관리)
  final List<Article> articles = Article.sample;

  final List<DJPick> djPicks = [
    DJPick(
      id: 'dj1',
      name: "Sickmode",
      imageUrl: "https://s.pstatic.net/dthumb.phinf/?src=%22https%3A%2F%2Fs.pstatic.net%2Fshop.phinf%2F20250217_3%2F17397898415832ySrH_PNG%2FED9994EBA9B4%252BECBAA1ECB298%252B2025-02-17%252B195422.png%22&type=ff364_236&service=navermain",
      likes: 10,
    ),
    // ... 추가 DJPick
  ];

  final List<PopularRecord> popularRecords = PopularRecord.sample;

  final List<MusicTaste> musicTastes = MusicTaste.sample;

  final List<String> genres = ["All", "Pop", "Jazz", "Japan", "Soul", "Rock"];
  final ValueNotifier<String> selectedGenre = ValueNotifier<String>("All");

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      // CupertinoSliverNavigationBar는 CustomScrollView 내부에서 동작합니다.
      child: SafeArea(
        child: CustomScrollView(
          slivers: [
            CupertinoSliverNavigationBar(
              // largeTitle에 큰 제목을 지정
              largeTitle: Text(
                "Kolektt",
              ),
              trailing: HomeToolbar(),
            ),
            // 나머지 컨텐츠를 SliverToBoxAdapter로 감쌉니다.
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 16),
                child: Column(
                  children: [
                    MagazineSection(articles: articles),
                    const SizedBox(height: 24),
                    DJPickSection(djPicks: djPicks),
                    const SizedBox(height: 24),
                    ValueListenableBuilder<String>(
                      valueListenable: selectedGenre,
                      builder: (context, genre, _) => PopularRecordsSection(
                        genres: genres,
                        selectedGenre: selectedGenre,
                        records: popularRecords,
                      ),
                    ),
                    const SizedBox(height: 24),
                    MusicTasteSection(musicTastes: musicTastes),
                    const SizedBox(height: 24),
                    LeaderboardView(data: LeaderboardData.sample),
                  ],
                ),
              ),
            ),
          ],
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
          Text(title, style: CupertinoTheme.of(context).textTheme.navLargeTitleTextStyle),
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
      mainAxisSize: MainAxisSize.min,
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
                coverImageURL: record.imageUrl,
                notes: "",
                price: record.price,
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
