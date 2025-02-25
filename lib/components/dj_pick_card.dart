import 'package:flutter/cupertino.dart';

import '../model/dj_pick.dart';
import '../view_models/home_vm.dart';
import 'genre_tag.dart';

class DJPickCard extends StatelessWidget {
  final DJPick dj;
  const DJPickCard({Key? key, required this.dj}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 160,
      decoration: BoxDecoration(
        color: CupertinoColors.systemBackground,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
            child: Image.network(
              dj.imageUrl,
              width: 160,
              height: 200,
              fit: BoxFit.cover,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(dj.name, style: CupertinoTheme.of(context).textTheme.textStyle.copyWith(fontSize: 16)),
                SizedBox(height: 8),
                Row(
                  children: [
                    GenreTag(text: "House"),
                    SizedBox(width: 8),
                    GenreTag(text: "Techno"),
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
