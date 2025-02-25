import 'article_content_type.dart';
import 'record.dart';

class ArticleContent {
  final String id;
  final ArticleContentType type;
  final String text;
  final Uri? imageURL;
  final String? caption;
  final List<Record> records;

  ArticleContent({
    required this.id,
    required this.type,
    required this.text,
    this.imageURL,
    this.caption,
    required this.records,
  });
}
