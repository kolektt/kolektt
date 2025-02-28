import 'package:flutter/cupertino.dart';
import 'package:kolektt/components/preview_player_view.dart';

import '../view/collection/collection_record_detail_view.dart';

class PreviewSlideView extends StatelessWidget {
  final String? url;
  final VoidCallback onAddPreview;

  PreviewSlideView({this.url, required this.onAddPreview});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      child: url != null
          ? CupertinoButton(
        onPressed: () {
          showCupertinoModalPopup(
            context: context,
            builder: (context) => PreviewPlayerView(url: url!),
          );
        },
        color: CupertinoColors.systemBlue.withOpacity(0.1),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              CupertinoIcons.play_circle_fill,
              size: 60,
              color: CupertinoColors.systemBlue,
            ),
            SizedBox(height: 16),
            Text(
              '미리듣기 재생',
              style: TextStyle(
                color: CupertinoColors.systemBlue,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      )
          : CupertinoButton(
        onPressed: onAddPreview,
        color: CupertinoColors.systemGrey6,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              CupertinoIcons.plus_circle,
              size: 60,
              color: CupertinoColors.systemGrey,
            ),
            SizedBox(height: 16),
            Text(
              '미리듣기 추가',
              style: TextStyle(
                color: CupertinoColors.systemGrey,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
