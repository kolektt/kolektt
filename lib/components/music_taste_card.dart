import 'package:flutter/cupertino.dart';

import '../record_detail_view.dart';
import '../view_models/home_vm.dart';

class MusicTasteCard extends StatelessWidget {
  final MusicTaste musicTaste;
  const MusicTasteCard({Key? key, required this.musicTaste}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final double width = (MediaQuery.of(context).size.width - 48) / 2;
    return CupertinoButton(
      padding: EdgeInsets.zero,
      onPressed: () {
        Navigator.push(
          context,
          CupertinoPageRoute(
            builder: (_) => RecordDetailView(record: musicTaste.record!),
          ),
        );
      },
      child: Container(
        width: width,
        decoration: BoxDecoration(
          color: CupertinoColors.systemBackground,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min, // 내부 Column이 자식 크기에 맞춰짐
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
              child: Image.network(
                musicTaste.imageUrl,
                width: width,
                fit: BoxFit.cover,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              child: Column(
                mainAxisSize: MainAxisSize.min, // 텍스트 영역의 Column도 최소 크기로
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    musicTaste.title,
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    musicTaste.subtitle,
                    style: TextStyle(fontSize: 14, color: CupertinoColors.systemGrey),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
