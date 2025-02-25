import 'package:flutter/cupertino.dart';

import '../components/statistic_card.dart';
import '../model/collection_analytics.dart';

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
