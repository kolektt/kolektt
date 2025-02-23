import 'package:flutter/material.dart';

import '../model/popular_record.dart';

/// 샘플 데이터 모델 정의 (실제 프로젝트에서는 별도 파일로 관리)
enum ArticleContentType { text, image, relatedRecords }

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

class Article {
  final String id;
  final String title;
  final String subtitle;
  final String category;
  final Uri coverImageURL;
  final String authorName;
  final String authorTitle;
  final Uri authorImageURL;
  final DateTime date;
  final List<ArticleContent> contents;

  Article({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.category,
    required this.coverImageURL,
    required this.authorName,
    required this.authorTitle,
    required this.authorImageURL,
    required this.date,
    required this.contents,
  });
}

class Record {
  final String id;
  final String title;
  final String artist;
  final int releaseYear;
  final String genre;
  final Uri coverImageURL;
  final String notes;
  final int lowestPrice;
  final int price;
  final int priceChange;
  final int sellersCount;
  final String recordDescription;
  final int rank;
  final int rankChange;
  final bool trending;

  Record({
    required this.id,
    required this.title,
    required this.artist,
    required this.releaseYear,
    required this.genre,
    required this.coverImageURL,
    required this.notes,
    required this.lowestPrice,
    required this.price,
    required this.priceChange,
    required this.sellersCount,
    required this.recordDescription,
    required this.rank,
    required this.rankChange,
    required this.trending,
  });

  // 예제용 샘플 데이터
  static List<Record> sampleData = [
    Record(
      id: 'sample1',
      title: 'Sample Record 1',
      artist: 'Artist 1',
      releaseYear: 2000,
      genre: 'Pop',
      coverImageURL: Uri.parse('https://via.placeholder.com/150'),
      notes: '',
      lowestPrice: 100,
      price: 150,
      priceChange: 0,
      sellersCount: 3,
      recordDescription: 'Description 1',
      rank: 1,
      rankChange: 0,
      trending: true,
    ),
    Record(
      id: 'sample2',
      title: 'Sample Record 2',
      artist: 'Artist 2',
      releaseYear: 1990,
      genre: 'Rock',
      coverImageURL: Uri.parse('https://via.placeholder.com/150'),
      notes: '',
      lowestPrice: 120,
      price: 180,
      priceChange: 0,
      sellersCount: 2,
      recordDescription: 'Description 2',
      rank: 2,
      rankChange: 0,
      trending: false,
    ),
  ];
}

class RecordShop {
  final String title;
  final String subtitle;
  final String imageUrl;
  final String location;

  RecordShop({
    required this.title,
    required this.subtitle,
    required this.imageUrl,
    required this.location,
  });
}

class MusicTaste {
  final String title;
  final String subtitle;
  final String imageUrl;
  final Record record;

  MusicTaste({
    required this.title,
    required this.subtitle,
    required this.imageUrl,
    required this.record,
  });
}

class DJPick {
  final String name;
  final String imageUrl;
  final int likes;

  DJPick({
    required this.name,
    required this.imageUrl,
    required this.likes,
  });
}

/// Flutter의 HomeViewModel (ChangeNotifier 기반)
class HomeViewModel extends ChangeNotifier {
  List<Article> articles = [];
  List<RecordShop> recordShops = [];
  List<DJPick> djPicks = [
    DJPick(name: "Sickmode", imageUrl: "https://example.com/dj1.jpg", likes: 10),
    DJPick(name: "Zedd", imageUrl: "https://example.com/dj2.jpg", likes: 15),
    DJPick(name: "Skrillex", imageUrl: "https://example.com/dj3.jpg", likes: 20),
    DJPick(name: "Diplo", imageUrl: "https://example.com/dj4.jpg", likes: 25),
    DJPick(name: "Calvin Harris", imageUrl: "https://example.com/dj5.jpg", likes: 30),
    DJPick(name: "David Guetta", imageUrl: "https://example.com/dj6.jpg", likes: 35),
    DJPick(name: "Martin Garrix", imageUrl: "https://example.com/dj7.jpg", likes: 40),
    DJPick(name: "Avicii", imageUrl: "https://example.com/dj8.jpg", likes: 45),
  ];
  List<PopularRecord> popularRecords = [];
  List<MusicTaste> musicTastes = [];
  String selectedGenre = "All";

  final List<String> genres = ["All", "Pop", "Jazz", "Japan", "Soul", "Rock"];

  HomeViewModel() {
    loadData();
  }

  void loadData() {
    // 매거진 샘플 데이터
    articles = [
      Article(
        id: "1",
        title: "레코드로 듣는 재즈의 매력",
        subtitle: "아날로그 사운드의 따뜻함을 느껴보세요",
        category: "Feature",
        coverImageURL: Uri.parse("https://example.com/jazz-cover.jpg"),
        authorName: "김재즈",
        authorTitle: "음악 칼럼니스트",
        authorImageURL: Uri.parse("https://example.com/author.jpg"),
        date: DateTime.now(),
        contents: [
          ArticleContent(
            id: "1",
            type: ArticleContentType.text,
            text: "레코드는 단순한 음악 매체가 아닙니다. 그것은 음악을 경험하는 특별한 방식이자, 예술 작품 그 자체입니다.",
            imageURL: null,
            caption: null,
            records: [],
          ),
          ArticleContent(
            id: "2",
            type: ArticleContentType.image,
            text: "",
            imageURL: Uri.parse("https://example.com/record-player.jpg"),
            caption: "빈티지 레코드 플레이어",
            records: [],
          ),
          ArticleContent(
            id: "3",
            type: ArticleContentType.text,
            text: "특히 재즈 음악은 레코드로 들을 때 그 진가를 발휘합니다. 아날로그 사운드의 따뜻함과 풍부한 음색이 재즈의 즉흥성과 완벽한 조화를 이룹니다.",
            imageURL: null,
            caption: null,
            records: [],
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
        coverImageURL: Uri.parse("https://example.com/lp-care.jpg"),
        authorName: "박컬렉터",
        authorTitle: "레코드 수집가",
        authorImageURL: Uri.parse("https://example.com/author2.jpg"),
        date: DateTime.now().subtract(Duration(days: 1)),
        contents: [
          ArticleContent(
            id: "1",
            type: ArticleContentType.text,
            text: "레코드는 적절한 관리만 해준다면 수십 년이 지나도 처음과 같은 음질을 유지할 수 있습니다.",
            imageURL: null,
            caption: null,
            records: [],
          ),
        ],
      ),
    ];

    // 레코드 샵 샘플 데이터
    recordShops = [
      RecordShop(
        title: "A perfect day in Seoul Record shop",
        subtitle: "한국에서 최고의 레코드 매장 만나기",
        imageUrl: "https://example.com/seoul1.jpg",
        location: "Seoul",
      ),
      RecordShop(
        title: "A perfect day in Yokohama",
        subtitle: "요코하마의 숨은 레코드 매장",
        imageUrl: "https://example.com/yokohama1.jpg",
        location: "Yokohama",
      ),
    ];

    // 인기 레코드 샘플 데이터
    popularRecords = [
      PopularRecord(
        title: "Kind of Blue",
        artist: "Miles Davis",
        price: 150000,
        imageUrl: "https://example.com/record1.jpg",
        trending: true, id: '',
      ),
      PopularRecord(
        title: "Abbey Road",
        artist: "The Beatles",
        price: 180000,
        imageUrl: "https://example.com/record2.jpg",
        trending: false, id: '',
      ),
      PopularRecord(
        title: "Thriller",
        artist: "Michael Jackson",
        price: 165000,
        imageUrl: "https://example.com/record3.jpg",
        trending: true, id: '',
      ),
      PopularRecord(
        title: "Blue Train",
        artist: "John Coltrane",
        price: 145000,
        imageUrl: "https://example.com/record4.jpg",
        trending: true, id: '',
      ),
      PopularRecord(
        title: "Purple Rain",
        artist: "Prince",
        price: 175000,
        imageUrl: "https://example.com/record5.jpg",
        trending: false, id: '',
      ),
    ];

    // 음악 취향 샘플 데이터
    musicTastes = [
      MusicTaste(
        title: "Yesterday",
        subtitle: "The Beatles",
        imageUrl: "https://example.com/taste1.jpg",
        record: Record.sampleData[0],
      ),
      MusicTaste(
        title: "Take Five",
        subtitle: "Dave Brubeck",
        imageUrl: "https://example.com/taste2.jpg",
        record: Record.sampleData[1],
      ),
      MusicTaste(
        title: "Purple Rain",
        subtitle: "Prince",
        imageUrl: "https://example.com/taste3.jpg",
        record: Record(
          id: UniqueKey().toString(),
          title: "Purple Rain",
          artist: "Prince",
          releaseYear: 1984,
          genre: "Pop/Rock",
          coverImageURL: Uri.parse("https://example.com/taste3.jpg"),
          notes: "프린스의 상징적인 앨범을 레코드로 소장하세요.",
          lowestPrice: 200,
          price: 200,
          priceChange: 0,
          sellersCount: 4,
          recordDescription: "프린스의 상징적인 앨범을 레코드로 소장하세요.",
          rank: 3,
          rankChange: 0,
          trending: true,
        ),
      ),
    ];

    // 상태 갱신 알림
    notifyListeners();
  }
}
