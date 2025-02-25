import 'package:flutter/cupertino.dart';

import '../../components/dj_pick_section.dart';
import '../../components/home_toolbar.dart';
import '../../components/leaderboard_view.dart';
import '../../components/magazine_section.dart';
import '../../components/music_taste_section.dart';
import '../../components/popular_records_section.dart';
import '../../model/article.dart';
import '../../model/dj_pick.dart';
import '../../model/leader_board_data.dart';
import '../../model/music_taste.dart';
import '../../model/popular_record.dart';

// --- 메인 홈 뷰 ---
class HomeView extends StatelessWidget {
  // 샘플 데이터 (실제 ViewModel은 Provider, Riverpod 등으로 관리)
  final List<Article> articles = Article.sample;

  final List<DJPick> djPicks = [
    DJPick(
      id: 'dj1',
      name: "Sickmode",
      imageUrl:
          "https://s.pstatic.net/dthumb.phinf/?src=%22https%3A%2F%2Fs.pstatic.net%2Fshop.phinf%2F20250217_3%2F17397898415832ySrH_PNG%2FED9994EBA9B4%252BECBAA1ECB298%252B2025-02-17%252B195422.png%22&type=ff364_236&service=navermain",
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
