import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../components/analytic_card.dart';
import '../components/genre_distribution_view.dart';
import '../model/collection_analytics.dart';
import '../view/collectino_summary_view.dart';
import 'decade_distribution_view.dart';

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
