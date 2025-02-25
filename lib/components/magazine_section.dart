import 'package:flutter/cupertino.dart';

import '../model/article.dart';
import '../view/home/magzine_detail_view.dart';

class MagazineSection extends StatelessWidget {
  final List<Article> articles;
  const MagazineSection({Key? key, required this.articles}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 280,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: articles.length,
        separatorBuilder: (_, __) => SizedBox(width: 16),
        itemBuilder: (context, index) {
          final article = articles[index];
          return CupertinoButton(
            padding: EdgeInsets.zero,
            onPressed: () {
              Navigator.push(
                context,
                CupertinoPageRoute(builder: (_) => MagazineDetailView(article: article)),
              );
            },
            child: Container(
              width: 280,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 커버 이미지
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.network(
                      article.coverImageURL.toString(),
                      width: 280,
                      height: 180,
                      fit: BoxFit.cover,
                    ),
                  ),
                  SizedBox(height: 12),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          article.title,
                          style: CupertinoTheme.of(context).textTheme.navTitleTextStyle,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        SizedBox(height: 8),
                        if (article.subtitle != null)
                          Text(
                            article.subtitle!,
                            style: CupertinoTheme.of(context).textTheme.textStyle.copyWith(color: CupertinoColors.systemGrey),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
