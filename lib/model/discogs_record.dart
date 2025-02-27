class DiscogsRecord {
  final int id;
  final String status;
  final int year;
  final String resourceUrl;
  final String uri;
  final List<Artist> artists;
  final String artistsSort;
  final List<Label> labels;
  final List<dynamic> series;
  final List<Company> companies;
  final List<Format> formats;
  final String dataQuality;
  final Community community;
  final int formatQuantity;
  final String dateAdded;
  final String dateChanged;
  final int numForSale;
  final double lowestPrice;
  final int masterId;
  final String masterUrl;
  final String title;
  final String country;
  final String released;
  final String notes;
  final String releasedFormatted;
  final List<Identifier> identifiers;
  final List<Video> videos;
  final List<String> genres;
  final List<String> styles;
  final List<Track> tracklist;
  final List<Artist> extraartists;
  final List<ImageInfo> images;
  final String thumb;
  final String coverImage;
  final int estimatedWeight;
  final bool blockedFromSale;

  DiscogsRecord({
    required this.id,
    required this.status,
    required this.year,
    required this.resourceUrl,
    required this.uri,
    required this.artists,
    required this.artistsSort,
    required this.labels,
    required this.series,
    required this.companies,
    required this.formats,
    required this.dataQuality,
    required this.community,
    required this.formatQuantity,
    required this.dateAdded,
    required this.dateChanged,
    required this.numForSale,
    required this.lowestPrice,
    required this.masterId,
    required this.masterUrl,
    required this.title,
    required this.country,
    required this.released,
    required this.notes,
    required this.releasedFormatted,
    required this.identifiers,
    required this.videos,
    required this.genres,
    required this.styles,
    required this.tracklist,
    required this.extraartists,
    required this.images,
    required this.thumb,
    required this.coverImage,
    required this.estimatedWeight,
    required this.blockedFromSale,
  });

  factory DiscogsRecord.fromJson(Map<String, dynamic> json) {
    return DiscogsRecord(
      id: json['id'] is int
          ? json['id']
          : int.tryParse(json['id'].toString()) ?? 0,
      status: json['status'] ?? '',
      year: json['year'] is int
          ? json['year']
          : int.tryParse(json['year'].toString()) ?? 0,
      resourceUrl: json['resource_url'] ?? '',
      uri: json['uri'] ?? '',
      artists: (json['artists'] as List<dynamic>?)
          ?.map((e) => Artist.fromJson(e))
          .toList() ??
          [],
      artistsSort: json['artists_sort'] ?? '',
      labels: (json['labels'] as List<dynamic>?)
          ?.map((e) => Label.fromJson(e))
          .toList() ??
          [],
      series: json['series'] as List<dynamic>? ?? [],
      companies: (json['companies'] as List<dynamic>?)
          ?.map((e) => Company.fromJson(e))
          .toList() ??
          [],
      formats: (json['formats'] as List<dynamic>?)
          ?.map((e) => Format.fromJson(e))
          .toList() ??
          [],
      dataQuality: json['data_quality'] ?? '',
      community: json['community'] != null
          ? Community.fromJson(json['community'])
          : Community.empty(),
      formatQuantity: json['format_quantity'] is int
          ? json['format_quantity']
          : int.tryParse(json['format_quantity'].toString()) ?? 0,
      dateAdded: json['date_added'] ?? '',
      dateChanged: json['date_changed'] ?? '',
      numForSale: json['num_for_sale'] is int
          ? json['num_for_sale']
          : int.tryParse(json['num_for_sale'].toString()) ?? 0,
      lowestPrice: json['lowest_price'] is double
          ? json['lowest_price']
          : double.tryParse(json['lowest_price'].toString()) ?? 0.0,
      masterId: json['master_id'] is int
          ? json['master_id']
          : int.tryParse(json['master_id'].toString()) ?? 0,
      masterUrl: json['master_url'] ?? '',
      title: json['title'] ?? '',
      country: json['country'] ?? '',
      released: json['released'] ?? '',
      notes: json['notes'] ?? '',
      releasedFormatted: json['released_formatted'] ?? '',
      identifiers: (json['identifiers'] as List<dynamic>?)
          ?.map((e) => Identifier.fromJson(e))
          .toList() ??
          [],
      videos: (json['videos'] as List<dynamic>?)
          ?.map((e) => Video.fromJson(e))
          .toList() ??
          [],
      genres: (json['genres'] as List<dynamic>?)
          ?.map((e) => e.toString())
          .toList() ??
          [],
      styles: (json['styles'] as List<dynamic>?)
          ?.map((e) => e.toString())
          .toList() ??
          [],
      tracklist: (json['tracklist'] as List<dynamic>?)
          ?.map((e) => Track.fromJson(e))
          .toList() ??
          [],
      extraartists: (json['extraartists'] as List<dynamic>?)
          ?.map((e) => Artist.fromJson(e))
          .toList() ??
          [],
      images: (json['images'] as List<dynamic>?)
          ?.map((e) => ImageInfo.fromJson(e))
          .toList() ??
          [],
      thumb: json['thumb'] ?? '',
      coverImage: json['cover_image'] ?? '',
      estimatedWeight: json['estimated_weight'] is int
          ? json['estimated_weight']
          : int.tryParse(json['estimated_weight'].toString()) ?? 0,
      blockedFromSale: json['blocked_from_sale'] ?? false,
    );
  }

  /// Supabase나 PostgreSQL에 insert할 때 사용하려는 가정 하에,
  /// `records` 테이블 컬럼에 맞춰 key를 구성합니다.
  Map<String, dynamic> toJson() {
    return {
      // PostgreSQL `records` 테이블 구조에 맞춤
      'record_id': id,  // 테이블에서는 TEXT 형식이므로 필요에 따라 toString() 처리 가능
      'title': title,
      'artist': artists.isNotEmpty ? artists.join(', ') : '',
      'release_year': year,
      'genre': genres.isNotEmpty ? genres.join(', ') : '',
      'cover_image': coverImage,
      'catalog_number': labels.isNotEmpty ? labels[0].catno : '',
      'label': labels.isNotEmpty ? labels[0].name : '',
      'format': formats.isNotEmpty ? formats[0].text : '',
      'country': country,
      'style': styles.isNotEmpty ? styles.join(', ') : '',
      // condition / condition_notes 는 필요 시 직접 셋팅
      'condition': '',
      'condition_notes': '',
      'notes': notes,
      // created_at, updated_at은 DB에서 DEFAULT나 TRIGGER를 통해 자동 처리
      // 'search_vector' 역시 DB에서 자동 생성 혹은 트리거로 관리 가능
    };
  }

  static List<DiscogsRecord> sampleData = [
    DiscogsRecord(
      title: "Sample Album 1",
      id: 1,
      year: 2000,
      resourceUrl: "https://www.discogs.com/release/1",
      uri: "https://api.discogs.com/releases/1",
      status: 'Accepted',
      artists: [],
      artistsSort: '',
      labels: [],
      series: [],
      companies: [],
      formats: [],
      dataQuality: '',
      community: Community.empty(),
      formatQuantity: 0,
      dateAdded: '',
      dateChanged: '',
      numForSale: 0,
      lowestPrice: 0.0,
      masterId: 0,
      masterUrl: '',
      country: '',
      released: '',
      notes: '',
      releasedFormatted: '',
      identifiers: [],
      videos: [],
      genres: [],
      styles: [],
      tracklist: [],
      extraartists: [],
      images: [
        ImageInfo(
            uri: "",
            type: '',
            resourceUrl: '',
            uri150: '',
            width: 100,
            height: 100)
      ],
      thumb: '',
      coverImage: '',
      estimatedWeight: 0,
      blockedFromSale: false,
    ),
    DiscogsRecord(
      title: "Sample Album 1",
      id: 1,
      year: 2000,
      resourceUrl: "https://www.discogs.com/release/1",
      uri: "https://api.discogs.com/releases/1",
      status: 'Accepted',
      artists: [],
      artistsSort: '',
      labels: [],
      series: [],
      companies: [],
      formats: [],
      dataQuality: '',
      community: Community.empty(),
      formatQuantity: 0,
      dateAdded: '',
      dateChanged: '',
      numForSale: 0,
      lowestPrice: 0.0,
      masterId: 0,
      masterUrl: '',
      country: '',
      released: '',
      notes: '',
      releasedFormatted: '',
      identifiers: [],
      videos: [],
      genres: [],
      styles: [],
      tracklist: [],
      extraartists: [],
      images: [
        ImageInfo(
            uri: "",
            type: '',
            resourceUrl: '',
            uri150: '',
            width: 100,
            height: 100)
      ],
      thumb: '',
      coverImage: '',
      estimatedWeight: 0,
      blockedFromSale: false,
    ),
    DiscogsRecord(
      title: "Sample Album 1",
      id: 1,
      year: 2000,
      resourceUrl: "https://www.discogs.com/release/1",
      uri: "https://api.discogs.com/releases/1",
      status: 'Accepted',
      artists: [],
      artistsSort: '',
      labels: [],
      series: [],
      companies: [],
      formats: [],
      dataQuality: '',
      community: Community.empty(),
      formatQuantity: 0,
      dateAdded: '',
      dateChanged: '',
      numForSale: 0,
      lowestPrice: 0.0,
      masterId: 0,
      masterUrl: '',
      country: '',
      released: '',
      notes: '',
      releasedFormatted: '',
      identifiers: [],
      videos: [],
      genres: [],
      styles: [],
      tracklist: [],
      extraartists: [],
      images: [
        ImageInfo(
            uri: "",
            type: '',
            resourceUrl: '',
            uri150: '',
            width: 100,
            height: 100)
      ],
      thumb: '',
      coverImage: '',
      estimatedWeight: 0,
      blockedFromSale: false,
    ),
    DiscogsRecord(
      title: "Sample Album 1",
      id: 1,
      year: 2000,
      resourceUrl: "https://www.discogs.com/release/1",
      uri: "https://api.discogs.com/releases/1",
      status: 'Accepted',
      artists: [],
      artistsSort: '',
      labels: [],
      series: [],
      companies: [],
      formats: [],
      dataQuality: '',
      community: Community.empty(),
      formatQuantity: 0,
      dateAdded: '',
      dateChanged: '',
      numForSale: 0,
      lowestPrice: 0.0,
      masterId: 0,
      masterUrl: '',
      country: '',
      released: '',
      notes: '',
      releasedFormatted: '',
      identifiers: [],
      videos: [],
      genres: [],
      styles: [],
      tracklist: [],
      extraartists: [],
      images: [
        ImageInfo(
            uri: "",
            type: '',
            resourceUrl: '',
            uri150: '',
            width: 100,
            height: 100)
      ],
      thumb: '',
      coverImage: '',
      estimatedWeight: 0,
      blockedFromSale: false,
    ),
    DiscogsRecord(
      title: "Sample Album 1",
      id: 1,
      year: 2000,
      resourceUrl: "https://www.discogs.com/release/1",
      uri: "https://api.discogs.com/releases/1",
      status: 'Accepted',
      artists: [],
      artistsSort: '',
      labels: [],
      series: [],
      companies: [],
      formats: [],
      dataQuality: '',
      community: Community.empty(),
      formatQuantity: 0,
      dateAdded: '',
      dateChanged: '',
      numForSale: 0,
      lowestPrice: 0.0,
      masterId: 0,
      masterUrl: '',
      country: '',
      released: '',
      notes: '',
      releasedFormatted: '',
      identifiers: [],
      videos: [],
      genres: [],
      styles: [],
      tracklist: [],
      extraartists: [],
      images: [
        ImageInfo(
            uri: "",
            type: '',
            resourceUrl: '',
            uri150: '',
            width: 100,
            height: 100)
      ],
      thumb: '',
      coverImage: '',
      estimatedWeight: 0,
      blockedFromSale: false,
    ),
  ];
}

class Artist {
  final String name;
  final String anv;
  final String join;
  final String role;
  final String tracks;
  final int id;
  final String resourceUrl;
  final String thumbnailUrl;

  Artist({
    required this.name,
    required this.anv,
    required this.join,
    required this.role,
    required this.tracks,
    required this.id,
    required this.resourceUrl,
    required this.thumbnailUrl,
  });

  factory Artist.fromJson(Map<String, dynamic> json) {
    return Artist(
      name: json['name'] ?? '',
      anv: json['anv'] ?? '',
      join: json['join'] ?? '',
      role: json['role'] ?? '',
      tracks: json['tracks'] ?? '',
      id: json['id'] is int
          ? json['id']
          : int.tryParse(json['id'].toString()) ?? 0,
      resourceUrl: json['resource_url'] ?? '',
      thumbnailUrl: json['thumbnail_url'] ?? '',
    );
  }
}

class Label {
  final String name;
  final String catno;
  final String entityType;
  final String entityTypeName;
  final int id;
  final String resourceUrl;
  final String thumbnailUrl;

  Label({
    required this.name,
    required this.catno,
    required this.entityType,
    required this.entityTypeName,
    required this.id,
    required this.resourceUrl,
    required this.thumbnailUrl,
  });

  factory Label.fromJson(Map<String, dynamic> json) {
    return Label(
      name: json['name'] ?? '',
      catno: json['catno'] ?? '',
      entityType: json['entity_type']?.toString() ?? '',
      entityTypeName: json['entity_type_name'] ?? '',
      id: json['id'] is int
          ? json['id']
          : int.tryParse(json['id'].toString()) ?? 0,
      resourceUrl: json['resource_url'] ?? '',
      thumbnailUrl: json['thumbnail_url'] ?? '',
    );
  }
}

class Company {
  final String name;
  final String catno;
  final String entityType;
  final String entityTypeName;
  final int id;
  final String resourceUrl;

  Company({
    required this.name,
    required this.catno,
    required this.entityType,
    required this.entityTypeName,
    required this.id,
    required this.resourceUrl,
  });

  factory Company.fromJson(Map<String, dynamic> json) {
    return Company(
      name: json['name'] ?? '',
      catno: json['catno'] ?? '',
      entityType: json['entity_type']?.toString() ?? '',
      entityTypeName: json['entity_type_name'] ?? '',
      id: json['id'] is int
          ? json['id']
          : int.tryParse(json['id'].toString()) ?? 0,
      resourceUrl: json['resource_url'] ?? '',
    );
  }
}

class Format {
  final String name;
  final String qty;
  final List<String> descriptions;
  final String text;

  Format({
    required this.name,
    required this.qty,
    required this.descriptions,
    required this.text,
  });

  factory Format.fromJson(Map<String, dynamic> json) {
    return Format(
      name: json['name'] ?? '',
      qty: json['qty'] ?? '',
      descriptions: (json['descriptions'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
      text: json['text'] ?? '',
    );
  }
}

class Community {
  final int have;
  final int want;
  final Rating rating;
  final Artist submitter;
  final List<Artist> contributors;
  final String dataQuality;
  final String status;

  Community({
    required this.have,
    required this.want,
    required this.rating,
    required this.submitter,
    required this.contributors,
    required this.dataQuality,
    required this.status,
  });

  factory Community.fromJson(Map<String, dynamic> json) {
    return Community(
      have: json['have'] is int
          ? json['have']
          : int.tryParse(json['have'].toString()) ?? 0,
      want: json['want'] is int
          ? json['want']
          : int.tryParse(json['want'].toString()) ?? 0,
      rating: Rating.fromJson(json['rating'] ?? {}),
      submitter: Artist.fromJson(json['submitter'] ?? {}),
      contributors: (json['contributors'] as List<dynamic>?)
              ?.map((e) => Artist.fromJson(e))
              .toList() ??
          [],
      dataQuality: json['data_quality'] ?? '',
      status: json['status'] ?? '',
    );
  }

  factory Community.empty() {
    return Community(
      have: 0,
      want: 0,
      rating: Rating(count: 0, average: 0),
      submitter: Artist(
        name: '',
        anv: '',
        join: '',
        role: '',
        tracks: '',
        id: 0,
        resourceUrl: '',
        thumbnailUrl: '',
      ),
      contributors: [],
      dataQuality: '',
      status: '',
    );
  }
}

class Rating {
  final int count;
  final double average;

  Rating({
    required this.count,
    required this.average,
  });

  factory Rating.fromJson(Map<String, dynamic> json) {
    return Rating(
      count: json['count'] is int
          ? json['count']
          : int.tryParse(json['count'].toString()) ?? 0,
      average: json['average'] is double
          ? json['average']
          : double.tryParse(json['average'].toString()) ?? 0.0,
    );
  }
}

class Identifier {
  final String type;
  final String value;

  Identifier({
    required this.type,
    required this.value,
  });

  factory Identifier.fromJson(Map<String, dynamic> json) {
    return Identifier(
      type: json['type'] ?? '',
      value: json['value'] ?? '',
    );
  }
}

class Video {
  final String uri;
  final String title;
  final String description;
  final int duration;
  final bool embed;

  Video({
    required this.uri,
    required this.title,
    required this.description,
    required this.duration,
    required this.embed,
  });

  factory Video.fromJson(Map<String, dynamic> json) {
    return Video(
      uri: json['uri'] ?? '',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      duration: json['duration'] is int
          ? json['duration']
          : int.tryParse(json['duration'].toString()) ?? 0,
      embed: json['embed'] ?? false,
    );
  }
}

class Track {
  final String position;
  final String type;
  final String title;
  final List<Artist> extraartists;
  final String duration;

  Track({
    required this.position,
    required this.type,
    required this.title,
    required this.extraartists,
    required this.duration,
  });

  factory Track.fromJson(Map<String, dynamic> json) {
    return Track(
      position: json['position'] ?? '',
      type: json['type_'] ?? '',
      title: json['title'] ?? '',
      extraartists: (json['extraartists'] as List<dynamic>?)
              ?.map((e) => Artist.fromJson(e))
              .toList() ??
          [],
      duration: json['duration'] ?? '',
    );
  }
}

class ImageInfo {
  final String type;
  final String uri;
  final String resourceUrl;
  final String uri150;
  final int width;
  final int height;

  ImageInfo({
    required this.type,
    required this.uri,
    required this.resourceUrl,
    required this.uri150,
    required this.width,
    required this.height,
  });

  factory ImageInfo.fromJson(Map<String, dynamic> json) {
    return ImageInfo(
      type: json['type'] ?? '',
      uri: json['uri'] ?? '',
      resourceUrl: json['resource_url'] ?? '',
      uri150: json['uri150'] ?? '',
      width: json['width'] is int
          ? json['width']
          : int.tryParse(json['width'].toString()) ?? 0,
      height: json['height'] is int
          ? json['height']
          : int.tryParse(json['height'].toString()) ?? 0,
    );
  }
}
