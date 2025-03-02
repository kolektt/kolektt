class DiscogsRecord {
  final int id;
  final String status;
  final int year;
  String resourceUrl;
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
          : int.tryParse(json['id']?.toString() ?? '') ?? 0,
      status: json['status'] ?? '',
      year: json['year'] is int
          ? json['year']
          : int.tryParse(json['year']?.toString() ?? '') ?? 0,
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
          : int.tryParse(json['format_quantity']?.toString() ?? '') ?? 0,
      dateAdded: json['date_added'] ?? '',
      dateChanged: json['date_changed'] ?? '',
      numForSale: json['num_for_sale'] is int
          ? json['num_for_sale']
          : int.tryParse(json['num_for_sale']?.toString() ?? '') ?? 0,
      lowestPrice: json['lowest_price'] is double
          ? json['lowest_price']
          : double.tryParse(json['lowest_price']?.toString() ?? '') ?? 0.0,
      masterId: json['master_id'] is int
          ? json['master_id']
          : int.tryParse(json['master_id']?.toString() ?? '') ?? 0,
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
          : int.tryParse(json['estimated_weight']?.toString() ?? '') ?? 0,
      blockedFromSale: json['blocked_from_sale'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'record_id': id.toString(),
      'title': title,
      'artist': artists.isNotEmpty
          ? artists.map((artist) => artist.name).join(', ')
          : '',
      'release_year': year,
      'genre': genres.isNotEmpty ? genres.join(', ') : '',
      'cover_image': coverImage,
      'catalog_number': labels.isNotEmpty ? labels[0].catno : '',
      'label': labels.isNotEmpty ? labels[0].name : '',
      'format': formats.isNotEmpty ? formats[0].text : '',
      'country': country,
      'style': styles.isNotEmpty ? styles.join(', ') : '',
      'condition': '', // 조건 정보가 별도로 없다면 기본값 사용
      'condition_notes': '',
      'notes': notes,
    };
  }

  // Sample data 예시
  static List<DiscogsRecord> sampleData = [
    DiscogsRecord(
      id: 123456,
      status: "Accepted",
      year: 2020,
      resourceUrl: "https://api.discogs.com/releases/123456",
      uri: "https://www.discogs.com/release/123456-Sample-Album",
      artists: [
        Artist(
          name: "Sample Artist",
          anv: "Sample Anv",
          join: "",
          role: "Main",
          tracks: "",
          id: 1,
          resourceUrl: "https://api.discogs.com/artists/1",
          thumbnailUrl: "https://example.com/thumb_artist.jpg",
        ),
      ],
      artistsSort: "Sample Artist",
      labels: [
        Label(
          name: "Sample Label",
          catno: "SL001",
          entityType: "1",
          entityTypeName: "Label",
          id: 101,
          resourceUrl: "https://api.discogs.com/labels/101",
          thumbnailUrl: "https://example.com/thumb_label.jpg",
        ),
      ],
      series: [],
      companies: [],
      formats: [
        Format(
          name: "Vinyl",
          qty: "1",
          descriptions: ["LP", "Album", "Stereo"],
          text: "Vinyl",
        ),
      ],
      dataQuality: "High",
      community: Community(
        have: 100,
        want: 20,
        rating: Rating(count: 50, average: 4.5),
        submitter: Artist(
          name: "Submitter",
          anv: "",
          join: "",
          role: "Submitter",
          tracks: "",
          id: 2,
          resourceUrl: "https://api.discogs.com/artists/2",
          thumbnailUrl: "https://example.com/thumb_submitter.jpg",
        ),
        contributors: [
          Artist(
            name: "Contributor",
            anv: "",
            join: "",
            role: "Contributor",
            tracks: "",
            id: 3,
            resourceUrl: "https://api.discogs.com/artists/3",
            thumbnailUrl: "https://example.com/thumb_contributor.jpg",
          )
        ],
        dataQuality: "High",
        status: "Accepted",
      ),
      formatQuantity: 1,
      dateAdded: "2020-01-01T00:00:00Z",
      dateChanged: "2020-01-02T00:00:00Z",
      numForSale: 10,
      lowestPrice: 25.0,
      masterId: 5555,
      masterUrl: "https://api.discogs.com/masters/5555",
      title: "Sample Album",
      country: "US",
      released: "2020-01-01",
      notes: "Sample album notes",
      releasedFormatted: "01 Jan 2020",
      identifiers: [
        Identifier(type: "Barcode", value: "1234567890123"),
      ],
      videos: [
        Video(
          uri: "https://www.youtube.com/watch?v=example",
          title: "Sample Video",
          description: "Sample video description",
          duration: 240,
          embed: true,
        ),
      ],
      genres: ["Electronic"],
      styles: ["Ambient"],
      tracklist: [
        Track(
          position: "A1",
          type: "track",
          title: "Track 1",
          extraartists: [],
          duration: "3:30",
        ),
      ],
      extraartists: [],
      images: [
        ImageInfo(
          type: "primary",
          uri: "https://example.com/image.jpg",
          resourceUrl: "https://example.com/image.jpg",
          uri150: "https://example.com/image150.jpg",
          width: 600,
          height: 600,
        ),
      ],
      thumb: "https://example.com/thumb.jpg",
      coverImage: "https://example.com/cover.jpg",
      estimatedWeight: 300,
      blockedFromSale: false,
    ),
  ];
}

// 하위 클래스들 (간략 예시)
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
          : int.tryParse(json['id']?.toString() ?? '') ?? 0,
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
          : int.tryParse(json['id']?.toString() ?? '') ?? 0,
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
          : int.tryParse(json['id']?.toString() ?? '') ?? 0,
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
          : int.tryParse(json['have']?.toString() ?? '') ?? 0,
      want: json['want'] is int
          ? json['want']
          : int.tryParse(json['want']?.toString() ?? '') ?? 0,
      rating: Rating.fromJson(json['rating'] ?? {}),
      submitter: json['submitter'] != null
          ? Artist.fromJson(json['submitter'])
          : Artist(
              name: '',
              anv: '',
              join: '',
              role: '',
              tracks: '',
              id: 0,
              resourceUrl: '',
              thumbnailUrl: ''),
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
          thumbnailUrl: ''),
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
          : int.tryParse(json['count']?.toString() ?? '') ?? 0,
      average: json['average'] is double
          ? json['average']
          : double.tryParse(json['average']?.toString() ?? '') ?? 0.0,
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
          : int.tryParse(json['duration']?.toString() ?? '') ?? 0,
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
          : int.tryParse(json['width']?.toString() ?? '') ?? 0,
      height: json['height'] is int
          ? json['height']
          : int.tryParse(json['height']?.toString() ?? '') ?? 0,
    );
  }
}
