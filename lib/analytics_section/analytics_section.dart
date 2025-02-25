import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../model/collection_analytics.dart';
import '../view/collection_view.dart';
import '../view/profile_view.dart';

// AnalyticsSection
class AnalyticsSection extends StatefulWidget {
  final CollectionAnalytics? analytics;

  const AnalyticsSection({Key? key, this.analytics}) : super(key: key);

  @override
  _AnalyticsSectionState createState() => _AnalyticsSectionState();
}

class _AnalyticsSectionState extends State<AnalyticsSection> {
  int currentPage = 0;

  @override
  Widget build(BuildContext context) {
    // 카드의 너비는 화면 너비에서 좌우 여백(16+16)을 뺀 값
    final double cardWidth = MediaQuery.of(context).size.width - 32;
    const double cardHeight = 340;

    return Padding(
      padding: const EdgeInsets.only(top: 4),
      child: widget.analytics != null
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
                  content: CollectionSummaryView(analytics: widget.analytics!),
                ),
                // 장르 분포 카드
                AnalyticCard(
                  title: "장르별 분포",
                  width: cardWidth,
                  height: cardHeight,
                  content: GenreDistributionView(genres: widget.analytics!.genres),
                ),
                // 연도별 분포 카드
                AnalyticCard(
                  title: "연도별 분포",
                  width: cardWidth,
                  height: cardHeight,
                  content: DecadeDistributionView(decades: widget.analytics!.decades),
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
      )
          : AnalyticCard(
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

// AnalyticCard
class AnalyticCard extends StatelessWidget {
  final String title;
  final double width;
  final double height;
  final Widget content;

  const AnalyticCard({
    Key? key,
    required this.title,
    required this.width,
    required this.height,
    required this.content,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: CupertinoColors.systemBackground,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 카드 타이틀 영역
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          // 카드 내용 영역 (남은 공간 채우기)
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: content,
            ),
          ),
        ],
      ),
    );
  }
}

// CollectionSummaryView
class CollectionSummaryView extends StatelessWidget {
  final CollectionAnalytics analytics;
  const CollectionSummaryView({Key? key, required this.analytics}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // primaryColor는 SwiftUI에서는 hex 값을 사용했으므로 여기서는 activeBlue로 대체
    final Color primaryColor = CupertinoColors.activeBlue;

    if (analytics.totalRecords == 0) {
      return Center(
        child: Text(
          "아직 레코드가 없습니다",
          style: const TextStyle(fontSize: 14, color: CupertinoColors.systemGrey),
        ),
      );
    } else {
      return Column(
        children: [
          // 상단 통계: 총 레코드, 인기 장르
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              StatisticCard(
                title: "총 레코드",
                value: "${analytics.totalRecords}장",
                icon: CupertinoIcons.collections, // record.circle와 유사
                color: primaryColor,
              ),
              StatisticCard(
                title: "인기 장르",
                value: analytics.mostCollectedGenre.isEmpty ? "없음" : analytics.mostCollectedGenre,
                icon: CupertinoIcons.music_note,
                color: primaryColor,
              ),
            ],
          ),
          const SizedBox(height: 16),
          // 하단 통계: 가장 많은 아티스트, 수집 기간
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              StatisticCard(
                title: "가장 많은 아티스트",
                value: analytics.mostCollectedArtist.isEmpty ? "없음" : analytics.mostCollectedArtist,
                icon: CupertinoIcons.person_2,
                color: primaryColor,
              ),
              StatisticCard(
                title: "수집 기간",
                value: analytics.oldestRecord == 0
                    ? "없음"
                    : "${analytics.oldestRecord} - ${analytics.newestRecord}",
                icon: CupertinoIcons.calendar,
                color: primaryColor,
              ),
            ],
          ),
        ],
      );
    }
  }
}

// StatisticCard
class StatisticCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;

  const StatisticCard({
    Key? key,
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // 카드의 너비는 AnalyticCard 내부의 두 카드가 좌우에 나란히 들어가므로, 적당히 계산하여 사용합니다.
    final double cardWidth = (MediaQuery.of(context).size.width - 32 - 16) / 2;
    return Container(
      width: cardWidth,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: CupertinoColors.systemBackground.withOpacity(0.5),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 16, color: color),
              const SizedBox(width: 8),
              Text(
                title,
                style: const TextStyle(fontSize: 14, color: CupertinoColors.systemGrey),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
