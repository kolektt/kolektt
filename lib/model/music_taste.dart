import 'record.dart';

class MusicTaste {
  final String title;
  final String subtitle;
  final String imageUrl;
  final Record record;

  MusicTaste({
    required this.title,
    required this.subtitle,
    required this.imageUrl,
    required String id,
    required this.record,
  });

  static List<MusicTaste> sample = [
    MusicTaste(
      title: "Yesterday",
      subtitle: "The Beatles",
      imageUrl: "https://s.pstatic.net/dthumb.phinf/?src=%22https%3A%2F%2Fs.pstatic.net%2Fshop.phinf%2F20250217_3%2F17397898415832ySrH_PNG%2FED9994EBA9B4%252BECBAA1ECB298%252B2025-02-17%252B195422.png%22&type=ff364_236&service=navermain",
      record: Record.sampleData[0],
      id: '',
    ),
    MusicTaste(
      id: 'mt1',
      title: "Yesterday",
      subtitle: "The Beatles",
      imageUrl:
      "https://s.pstatic.net/dthumb.phinf/?src=%22https%3A%2F%2Fs.pstatic.net%2Fshop.phinf%2F20250217_3%2F17397898415832ySrH_PNG%2FED9994EBA9B4%252BECBAA1ECB298%252B2025-02-17%252B195422.png%22&type=ff364_236&service=navermain",
      record: Record.sampleData[0],
    ),
    MusicTaste(
      id: 'mt2',
      title: "Take Five",
      subtitle: "Dave Brubeck",
      imageUrl: "https://s.pstatic.net/dthumb.phinf/?src=%22https%3A%2F%2Fs.pstatic.net%2Fshop.phinf%2F20250217_3%2F17397898415832ySrH_PNG%2FED9994EBA9B4%252BECBAA1ECB298%252B2025-02-17%252B195422.png%22&type=ff364_236&service=navermain",
      record: Record.sampleData[1],
    )
  ];
}
