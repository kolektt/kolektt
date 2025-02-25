import 'package:flutter/cupertino.dart';
import 'package:kolektt/components/section_header.dart';

import '../model/music_taste.dart';
import '../view_models/home_vm.dart';
import 'music_taste_card.dart';

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
