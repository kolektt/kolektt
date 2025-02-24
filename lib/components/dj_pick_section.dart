import 'package:flutter/cupertino.dart';

import '../home/djs_pick_detail_view.dart';
import '../home/home_view.dart';
import '../home/magzine_detail_view.dart';
import '../home_view.dart';
import '../model/record.dart';
import '../view_models/home_vm.dart';

class DJPickSection extends StatelessWidget {
  final List<DJPick> djPicks;

  const DJPickSection({Key? key, required this.djPicks}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 상단 헤더 (제목과 "더보기" 버튼)
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Row(
            children: [
              const Text(
                "DJ's",
                style: TextStyle(
                  fontSize: 20, // SwiftUI의 title2와 유사한 크기
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Spacer(),
              CupertinoButton(
                padding: EdgeInsets.zero,
                onPressed: () {
                  Navigator.push(
                    context,
                    CupertinoPageRoute(builder: (_) => const DJsPickListView()),
                  );
                },
                child: Row(
                  children: const [
                    Text(
                      "더보기",
                      style: TextStyle(
                        fontSize: 14,
                        color: CupertinoColors.systemGrey,
                      ),
                    ),
                    SizedBox(width: 4),
                    Icon(
                      CupertinoIcons.right_chevron,
                      size: 12,
                      color: CupertinoColors.systemGrey,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        // 수평 스크롤 영역
        SizedBox(
          // 카드 높이에 맞게 고정 (필요에 따라 조정)
          height: 280,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: djPicks.length,
            separatorBuilder: (_, __) => const SizedBox(width: 16),
            itemBuilder: (context, index) {
              final djPick = djPicks[index];
              // SwiftUI 코드의 NavigationLink에서 전달하는 DJ 객체 생성
              final dj = DJ(
                id: djPick.id.toString(), // djPick.id가 UUID 등일 경우 toString() 사용
                name: djPick.name,
                title: "DJ",
                imageURL: Uri.parse(djPick.imageUrl), // String 타입의 URL
                yearsActive: 5,
                recordCount: djPick.likes * 100,
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
              );

              return CupertinoButton(
                padding: EdgeInsets.zero,
                onPressed: () {
                  Navigator.push(
                    context,
                    CupertinoPageRoute(builder: (_) => DJsPickDetailView(dj: dj)),
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