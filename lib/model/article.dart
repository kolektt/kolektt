import 'package:intl/intl.dart';

import 'article_content.dart';
import 'article_content_type.dart';
import 'record.dart';

class Article {
  final String id;
  final String title;
  final String? subtitle;
  final String category;
  final String coverImageURL;
  final String authorName;
  final String authorTitle;
  final String authorImageURL;
  final DateTime date;
  final List<ArticleContent> contents;

  Article({
    required this.id,
    required this.title,
    this.subtitle,
    required this.category,
    required this.coverImageURL,
    required this.authorName,
    required this.authorTitle,
    required this.authorImageURL,
    required this.date,
    required this.contents,
  });

  String get formattedDate {
    final formatter = DateFormat('yyyy.MM.dd');
    return formatter.format(date);
  }

  static List<Article> get sample => [
    Article(
      id: "1",
      title: "레코드로 듣는 재즈의 매력",
      subtitle: "아날로그 사운드의 따뜻함을 느껴보세요",
      category: "Feature",
      coverImageURL: "https://s.pstatic.net/dthumb.phinf/?src=%22https%3A%2F%2Fs.pstatic.net%2Fshop.phinf%2F20250217_3%2F17397898415832ySrH_PNG%2FED9994EBA9B4%252BECBAA1ECB298%252B2025-02-17%252B195422.png%22&type=ff364_236&service=navermain",
      authorName: "김재즈",
      authorTitle: "음악 칼럼니스트",
      authorImageURL: "https://example.com/author.jpg",
      date: DateTime.now(),
      contents: [
        ArticleContent(
          id: "1",
          type: ArticleContentType.text,
          text: "레코드는 단순한 음악 매체가 아닙니다. 그것은 음악을 경험하는 특별한 방식이자, 예술 작품 그 자체입니다.",
          imageURL: null,
          caption: null,
          records: Record.sampleData,
        ),
        ArticleContent(
          id: "2",
          type: ArticleContentType.image,
          text: "",
          imageURL: Uri.parse("https://s.pstatic.net/dthumb.phinf/?src=%22https%3A%2F%2Fs.pstatic.net%2Fshop.phinf%2F20250217_3%2F17397898415832ySrH_PNG%2FED9994EBA9B4%252BECBAA1ECB298%252B2025-02-17%252B195422.png%22&type=ff364_236&service=navermain"),
          caption: "빈티지 레코드 플레이어",
          records: Record.sampleData,
        ),
        ArticleContent(
          id: "3",
          type: ArticleContentType.text,
          text: "특히 재즈 음악은 레코드로 들을 때 그 진가를 발휘합니다. 아날로그 사운드의 따뜻함과 풍부한 음색이 재즈의 즉흥성과 완벽한 조화를 이룹니다.",
          imageURL: null,
          caption: null,
          records: Record.sampleData,
        ),
        ArticleContent(
          id: "4",
          type: ArticleContentType.relatedRecords,
          text: "",
          imageURL: null,
          caption: null,
          records: Record.sampleData,
        ),
      ],
    ),
    Article(
      id: "2",
      title: "LP 관리의 모든 것",
      subtitle: "소중한 레코드를 오래도록 보관하는 방법",
      category: "Guide",
      coverImageURL: "https://s.pstatic.net/dthumb.phinf/?src=%22https%3A%2F%2Fs.pstatic.net%2Fshop.phinf%2F20250217_3%2F17397898415832ySrH_PNG%2FED9994EBA9B4%252BECBAA1ECB298%252B2025-02-17%252B195422.png%22&type=ff364_236&service=navermain",
      authorName: "박컬렉터",
      authorTitle: "레코드 수집가",
      authorImageURL: "https://example.com/author2.jpg",
      date: DateTime.now().subtract(Duration(days: 1)),
      contents: [
        ArticleContent(
          id: "1",
          type: ArticleContentType.text,
          text: "레코드는 적절한 관리만 해준다면 수십 년이 지나도 처음과 같은 음질을 유지할 수 있습니다.",
          imageURL: null,
          caption: null,
          records: Record.sampleData,
        ),
      ],
    ),
  ];
}
