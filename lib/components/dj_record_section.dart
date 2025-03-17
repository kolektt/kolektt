import 'package:flutter/cupertino.dart';

import '../model/interview_content.dart';
import 'dj_record_card.dart';

class DJRecordSection extends StatelessWidget {
  final InterviewContent content;

  const DJRecordSection({Key? key, required this.content}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 섹션 타이틀
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Text(
            '추천 레코드',
            style: CupertinoTheme.of(context)
                .textTheme
                .navTitleTextStyle
                .copyWith(fontSize: 18),
          ),
        ),
        // 수평 스크롤 레코드 카드 리스트
        SizedBox(
          height: 280,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: content.records.length,
            separatorBuilder: (context, index) => const SizedBox(width: 20),
            itemBuilder: (context, index) {
              return DJRecordCard(record: content.records[index]);
            },
          ),
        ),
      ],
    );
  }
}
