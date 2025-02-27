import 'package:flutter/cupertino.dart';

import '../model/discogs_record.dart';

class RecordCardView extends StatelessWidget {
  final DiscogsRecord record;
  RecordCardView({required this.record});
  @override
  Widget build(BuildContext context) {
    double cardWidth = (MediaQuery.of(context).size.width - 48) / 2;
    double imageHeight = 160;
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: CupertinoColors.systemBackground,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.vertical(top: Radius.circular(8)),
            child: Image.network(
              record.images[0].uri,
              width: cardWidth,
              height: imageHeight,
              fit: BoxFit.cover,
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 4, vertical: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(record.title,
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis),
                Text(record.artists.map((artist) => artist.name).join(', '),
                    style: TextStyle(fontSize: 12, color: CupertinoColors.systemGrey),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis),
                Row(
                  children: [
                    Text("${record.year}",
                        style: TextStyle(fontSize: 11, color: CupertinoColors.systemGrey)),
                    Text(" • ", style: TextStyle(fontSize: 11, color: CupertinoColors.systemGrey)),
                    Text(record.genres.join(', '),
                        style: TextStyle(fontSize: 11, color: CupertinoColors.systemGrey),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
