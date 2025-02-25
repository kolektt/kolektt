import 'package:flutter/cupertino.dart';

import '../view/home_view.dart';
import '../model/popular_record.dart';

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
        // 섹션 헤더
        const SectionHeader(title: "인기", showMore: false),
        const SizedBox(height: 16),
        // 장르 스크롤 뷰
        GenreScrollView(
          genres: genres,
          selectedGenre: selectedGenre,
        ),
        const SizedBox(height: 16),
        // 레코드 리스트
        RecordsList(records: records),
      ],
    );
  }
}
