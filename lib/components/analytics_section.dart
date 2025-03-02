import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kolektt/model/local/collection_record.dart';

import '../model/collection_analytics.dart';
import '../model/decade_analytics.dart';
import '../data/models/discogs_record.dart';
import '../model/genre_analytics.dart';
import '../components/analytic_card.dart';
import '../view/collectino_summary_view.dart';
import '../components/genre_distribution_view.dart';
import 'decade_distribution_view.dart';

class AnalyticsSection extends StatefulWidget {
  // 컬렉션의 DiscogsRecord 리스트를 입력받습니다.
  final List<CollectionRecord> records;

  const AnalyticsSection({Key? key, required this.records}) : super(key: key);

  @override
  _AnalyticsSectionState createState() => _AnalyticsSectionState();
}

class _AnalyticsSectionState extends State<AnalyticsSection> {
  late CollectionAnalytics analytics;
  int currentPage = 0;
  bool hasData = false;

  @override
  void initState() {
    super.initState();
    _analyzeCollection();
  }

  void _analyzeCollection() {
    final records = widget.records;
    int totalRecords = records.length;

    // 1. 장르별 집계 (각 레코드의 첫번째 장르 기준)
    Map<String, int> genreCounts = {};
    for (final record in records) {
      if (record.record.genres.isNotEmpty) {
        String genre = record.record.genres[0];
        genreCounts[genre] = (genreCounts[genre] ?? 0) + 1;
      }
    }
    String mostCollectedGenre = genreCounts.isNotEmpty
        ? genreCounts.entries.reduce((a, b) => a.value > b.value ? a : b).key
        : '';

    // 2. 아티스트별 집계 (각 레코드의 첫번째 아티스트 기준)
    Map<String, int> artistCounts = {};
    for (final record in records) {
      if (record.record.artists.isNotEmpty) {
        String artist = record.record.artists[0].name;
        artistCounts[artist] = (artistCounts[artist] ?? 0) + 1;
      }
    }
    String mostCollectedArtist = artistCounts.isNotEmpty
        ? artistCounts.entries.reduce((a, b) => a.value > b.value ? a : b).key
        : '';

    // 3. 연대별 집계 (record.year 기준)
    Map<String, int> decadeCounts = {};
    for (final record in records) {
      if (record.record.year > 0) {
        int decadeStart = (record.record.year ~/ 10) * 10;
        String decadeLabel = "${decadeStart}'s";
        decadeCounts[decadeLabel] = (decadeCounts[decadeLabel] ?? 0) + 1;
      }
    }

    // 4. 가장 오래된/최신 레코드 연도 계산
    int oldestRecord = records.isNotEmpty
        ? records.map((r) => r.record.year).reduce((a, b) => a < b ? a : b)
        : 0;
    int newestRecord = records.isNotEmpty
        ? records.map((r) => r.record.year).reduce((a, b) => a > b ? a : b)
        : 0;

    // 5. CollectionAnalytics 객체 생성
    analytics = CollectionAnalytics(
      totalRecords: totalRecords,
      mostCollectedGenre: mostCollectedGenre,
      mostCollectedArtist: mostCollectedArtist,
      oldestRecord: oldestRecord,
      newestRecord: newestRecord,
      genres: genreCounts.entries
          .map((entry) => GenreAnalytics(name: entry.key, count: entry.value))
          .toList(),
      decades: decadeCounts.entries
          .map((entry) => DecadeAnalytics(decade: entry.key, count: entry.value))
          .toList(),
    );

    setState(() {
      hasData = totalRecords > 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    // 카드 너비: 화면 너비에서 좌우 여백(16*2)을 뺀 값
    final double cardWidth = MediaQuery.of(context).size.width - 32;
    const double cardHeight = 340;

    return Padding(
      padding: const EdgeInsets.only(top: 4),
      child: hasData
          ? Column(
        children: [
          SizedBox(
            height: cardHeight,
            child: PageView(
              onPageChanged: (int page) {
                setState(() {
                  currentPage = page;
                });
              },
              children: [
                // 컬렉션 현황 카드
                AnalyticCard(
                  title: "컬렉션 현황",
                  width: cardWidth,
                  height: cardHeight,
                  content: CollectionSummaryView(analytics: analytics),
                ),
                // 장르별 분포 카드
                AnalyticCard(
                  title: "장르별 분포",
                  width: cardWidth,
                  height: cardHeight,
                  content: GenreDistributionView(genres: analytics.genres),
                ),
                // 연도별 분포 카드
                AnalyticCard(
                  title: "연도별 분포",
                  width: cardWidth,
                  height: cardHeight,
                  content: DecadeDistributionView(decades: analytics.decades),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          // 페이지 인디케이터
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(3, (index) {
              return AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                margin: const EdgeInsets.symmetric(horizontal: 4),
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: currentPage == index
                      ? CupertinoColors.activeBlue
                      : Colors.grey.withOpacity(0.3),
                ),
              );
            }),
          ),
        ],
      ) : AnalyticCard(
        title: "컬렉션 분석",
        width: cardWidth,
        height: cardHeight,
        content: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              CupertinoIcons.music_note_list,
              size: 48,
              color: CupertinoColors.activeBlue,
            ),
            const SizedBox(height: 16),
            const Text(
              "컬렉션을 추가하여\n분석을 시작해보세요",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 18,
                color: CupertinoColors.systemGrey,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
