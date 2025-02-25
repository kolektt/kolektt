import 'package:flutter/cupertino.dart';

import '../model/record.dart';

class InstagramStyleRecordCard extends StatelessWidget {
  final Record record;

  const InstagramStyleRecordCard({Key? key, required this.record})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min, // 자식 위젯 크기에 맞게 최소한의 공간만 사용
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AspectRatio(
          aspectRatio: 1,
          child: Image.network(
            record.coverImageURL.toString(),
            fit: BoxFit.cover,
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 6),
          child: Column(
            mainAxisSize: MainAxisSize.min, // 여기서도 최소 크기로 설정
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                record.title,
                style: const TextStyle(fontSize: 12),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              Text(
                record.artist,
                style: const TextStyle(
                  fontSize: 10,
                  color: CupertinoColors.systemGrey,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
