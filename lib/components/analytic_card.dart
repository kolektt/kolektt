import 'package:flutter/cupertino.dart';

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
