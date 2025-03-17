class UserCollectionClassification {
  // 사용 가능한 옵션 목록들
  final List<String> mediaConditions;
  final List<String> sleeveConditions;
  final List<String> genres;
  final List<String> sortOptions;

  // 선택된 값들
  final String mediaCondition;
  final String sleeveCondition;
  final String genre;
  final int startYear;
  final int endYear;
  final String sortOption;

  const UserCollectionClassification({
    required this.mediaConditions,
    required this.sleeveConditions,
    required this.genres,
    required this.sortOptions,
    required this.mediaCondition,
    required this.sleeveCondition,
    required this.genre,
    required this.startYear,
    required this.endYear,
    required this.sortOption,
  });

  /// 초기값 및 기본 옵션들을 설정한 인스턴스를 반환하는 팩토리 생성자
  factory UserCollectionClassification.initial() {
    return UserCollectionClassification(
      mediaConditions: ['All'],
      sleeveConditions: ['All'],
      genres: ['All'],
      sortOptions: ['최신순', '오래된순', '이름순'],
      mediaCondition: 'All',
      sleeveCondition: 'All',
      genre: 'All',
      startYear: 1900,
      endYear: 2025,
      sortOption: '최신순',
    );
  }

  /// copyWith 메서드를 이용해 선택된 필드나 옵션 목록 일부를 변경할 수 있습니다.
  UserCollectionClassification copyWith({
    List<String>? mediaConditions,
    List<String>? sleeveConditions,
    List<String>? genres,
    List<String>? sortOptions,
    String? mediaCondition,
    String? sleeveCondition,
    String? genre,
    int? startYear,
    int? endYear,
    String? sortOption,
  }) {
    return UserCollectionClassification(
      mediaConditions: mediaConditions ?? this.mediaConditions,
      sleeveConditions: sleeveConditions ?? this.sleeveConditions,
      genres: genres ?? this.genres,
      sortOptions: sortOptions ?? this.sortOptions,
      mediaCondition: mediaCondition ?? this.mediaCondition,
      sleeveCondition: sleeveCondition ?? this.sleeveCondition,
      genre: genre ?? this.genre,
      startYear: startYear ?? this.startYear,
      endYear: endYear ?? this.endYear,
      sortOption: sortOption ?? this.sortOption,
    );
  }

  /// JSON 직렬화 예시 (필요한 경우 사용)
  factory UserCollectionClassification.fromJson(Map<String, dynamic> json) {
    return UserCollectionClassification(
      mediaConditions: List<String>.from(json['mediaConditions'] as List),
      sleeveConditions: List<String>.from(json['sleeveConditions'] as List),
      genres: List<String>.from(json['genres'] as List),
      sortOptions: List<String>.from(json['sortOptions'] as List),
      mediaCondition: json['mediaCondition'] as String,
      sleeveCondition: json['sleeveCondition'] as String,
      genre: json['genre'] as String,
      startYear: json['startYear'] as int,
      endYear: json['endYear'] as int,
      sortOption: json['sortOption'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'mediaConditions': mediaConditions,
      'sleeveConditions': sleeveConditions,
      'genres': genres,
      'sortOptions': sortOptions,
      'mediaCondition': mediaCondition,
      'sleeveCondition': sleeveCondition,
      'genre': genre,
      'startYear': startYear,
      'endYear': endYear,
      'sortOption': sortOption,
    };
  }

  @override
  String toString() {
    return 'UserCollectionClassification('
        'mediaConditions: $mediaConditions, '
        'sleeveConditions: $sleeveConditions, '
        'genres: $genres, '
        'sortOptions: $sortOptions, '
        'mediaCondition: $mediaCondition, '
        'sleeveCondition: $sleeveCondition, '
        'genre: $genre, '
        'startYear: $startYear, '
        'endYear: $endYear, '
        'sortOption: $sortOption'
        ')';
  }
}
