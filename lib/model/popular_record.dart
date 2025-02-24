class PopularRecord {
  final String id;
  final String title;
  final String artist;
  final int price;
  final String imageUrl;
  final bool trending;
  PopularRecord({
    required this.id,
    required this.title,
    required this.artist,
    required this.price,
    required this.imageUrl,
    required this.trending,
  });

  static List<PopularRecord> sample = [
    PopularRecord(
      id: 'rec1',
      title: "Kind of Blue",
      artist: "Miles Davis",
      price: 150000,
      imageUrl: "https://s.pstatic.net/dthumb.phinf/?src=%22https%3A%2F%2Fs.pstatic.net%2Fshop.phinf%2F20250217_3%2F17397898415832ySrH_PNG%2FED9994EBA9B4%252BECBAA1ECB298%252B2025-02-17%252B195422.png%22&type=ff364_236&service=navermain",
      trending: true,
    ),
    PopularRecord(
      id: 'rec2',
      title: "A Love Supreme",
      artist: "John Coltrane",
      price: 200000,
      imageUrl: "https://s.pstatic.net/dthumb.phinf/?src=%22https%3A%2F%2Fs.pstatic.net%2Fshop.phinf%2F20250217_3%2F17397898415832ySrH_PNG%2FED9994EBA9B4%252BECBAA1ECB298%252B2025-02-17%252B195422.png%22&type=ff364_236&service=navermain",
      trending: true,
    ),
    PopularRecord(
      id: 'rec3',
      title: "Blue Train",
      artist: "John Coltrane",
      price: 180000,
      imageUrl: "https://s.pstatic.net/dthumb.phinf/?src=%22https%3A%2F%2Fs.pstatic.net%2Fshop.phinf%2F20250217_3%2F17397898415832ySrH_PNG%2FED9994EBA9B4%252BECBAA1ECB298%252B2025-02-17%252B195422.png%22&type=ff364_236&service=navermain",
      trending: true,
    ),
    PopularRecord(
      id: 'rec4',
      title: "Time Out",
      artist: "Dave Brubeck",
      price: 170000,
      imageUrl: "https://s.pstatic.net/dthumb.phinf/?src=%22https%3A%2F%2Fs.pstatic.net%2Fshop.phinf%2F20250217_3%2F17397898415832ySrH_PNG%2FED9994EBA9B4%252BECBAA1ECB298%252B2025-02-17%252B195422.png%22&type=ff364_236&service=navermain",
      trending: true,
    )
  ];
}
