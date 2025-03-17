import 'package:flutter/cupertino.dart';

import '../model/record.dart';

class DJRecordCard extends StatelessWidget {
  final Record record;

  const DJRecordCard({Key? key, required this.record}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CupertinoButton(
      padding: EdgeInsets.zero,
      onPressed: () {
        // RecordDetailView로 네비게이션 (미리 구현되어 있다고 가정)
        // Navigator.push(
        //   context,
        //   CupertinoPageRoute(
        //     builder: (context) => RecordDetailView(record: record),
        //   ),
        // );
      },
      child: Container(
        width: 200,
        decoration: BoxDecoration(
          color: CupertinoColors.systemBackground.resolveFrom(context),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 레코드 커버 이미지
            if (record.coverImageURL != null)
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(
                  record.coverImageURL!,
                  width: 200,
                  height: 200,
                  fit: BoxFit.cover,
                ),
              ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 레코드 제목
                  Text(
                    record.title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  // 아티스트 이름
                  Text(
                    record.artist,
                    style: TextStyle(
                      fontSize: 14,
                      color: CupertinoColors.systemGrey.resolveFrom(context),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
