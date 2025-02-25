import 'dart:core';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../model/article.dart';
import '../model/article_content.dart';
import '../model/article_content_type.dart';
import '../model/dj_pick.dart';
import '../model/music_taste.dart';
import '../model/popular_record.dart';
import '../model/record.dart';
import '../model/record_shop.dart';

/// Flutter의 HomeViewModel (ChangeNotifier 기반)
class HomeViewModel extends ChangeNotifier {
  List<Article> articles = [];
  List<RecordShop> recordShops = [];
  List<DJPick> djPicks = [
    DJPick(name: "Sickmode", imageUrl: "https://example.com/dj1.jpg", likes: 10, id: ''),
    DJPick(name: "Zedd", imageUrl: "https://example.com/dj2.jpg", likes: 15, id: ''),
    DJPick(name: "Skrillex", imageUrl: "https://example.com/dj3.jpg", likes: 20, id: ''),
    DJPick(name: "Diplo", imageUrl: "https://example.com/dj4.jpg", likes: 25, id: ''),
    DJPick(name: "Calvin Harris", imageUrl: "https://example.com/dj5.jpg", likes: 30, id: ''),
    DJPick(name: "David Guetta", imageUrl: "https://example.com/dj6.jpg", likes: 35, id: ''),
    DJPick(name: "Martin Garrix", imageUrl: "https://example.com/dj7.jpg", likes: 40, id: ''),
    DJPick(name: "Avicii", imageUrl: "https://example.com/dj8.jpg", likes: 45, id: ''),
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
        imageUrl: "https://s.pstatic.net/dthumb.phinf/?src=%22https%3A%2F%2Fs.pstatic.net%2Fshop.phinf%2F20250217_3%2F17397898415832ySrH_PNG%2FED9994EBA9B4%252BECBAA1ECB298%252B2025-02-17%252B195422.png%22&type=ff364_236&service=navermain",
        record: Record.sampleData[0],
        id: '',
      ),
      MusicTaste(
        title: "Take Five",
        subtitle: "Dave Brubeck",
        imageUrl: "https://example.com/taste2.jpg",
        record: Record.sampleData[1],
        id: '',
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
          coverImageURL:
              "https://s.pstatic.net/dthumb.phinf/?src=%22https%3A%2F%2Fs.pstatic.net%2Fshop.phinf%2F20250217_3%2F17397898415832ySrH_PNG%2FED9994EBA9B4%252BECBAA1ECB298%252B2025-02-17%252B195422.png%22&type=ff364_236&service=navermain",
          notes: "프린스의 상징적인 앨범을 레코드로 소장하세요.",
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
          // price: 200,
          // priceChange: 0,
          // sellersCount: 4,
          // recordDescription: "프린스의 상징적인 앨범을 레코드로 소장하세요.",
          // rank: 3,
          // rankChange: 0,
          // trending: true,
        ),
        id: '',
      ),
    ];

    // 상태 갱신 알림
    notifyListeners();
  }
}
