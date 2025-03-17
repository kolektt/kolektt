class ArtistRelease {
  final Pagination pagination;
  final List<Release> releases;

  ArtistRelease({
    required this.pagination,
    required this.releases,
  });

  factory ArtistRelease.fromJson(Map<String, dynamic> json) {
    return ArtistRelease(
      pagination: Pagination.fromJson(json['pagination']),
      releases: (json['releases'] as List)
          .map((item) => Release.fromJson(item))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'pagination': pagination.toJson(),
      'releases': releases.map((release) => release.toJson()).toList(),
    };
  }
}

class Pagination {
  final int page;
  final int pages;
  final int perPage;
  final int items;
  final Map<String, dynamic> urls; // 빈 오브젝트이므로 Map 형태로 처리

  Pagination({
    required this.page,
    required this.pages,
    required this.perPage,
    required this.items,
    required this.urls,
  });

  factory Pagination.fromJson(Map<String, dynamic> json) {
    return Pagination(
      page: json['page'],
      pages: json['pages'],
      perPage: json['per_page'],
      items: json['items'],
      urls: json['urls'] as Map<String, dynamic>,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'page': page,
      'pages': pages,
      'per_page': perPage,
      'items': items,
      'urls': urls,
    };
  }
}

class Release {
  final int id;
  final String title;
  final String type;
  final int? mainRelease; // 선택적 필드 (required 목록에 없음)
  final String artist;
  final String role;
  final String resourceUrl;
  final int year;
  final String thumb;
  final Stats stats;
  final String? status;
  final String? format;
  final String? label;
  final String? trackinfo;

  Release({
    required this.id,
    required this.title,
    required this.type,
    this.mainRelease,
    required this.artist,
    required this.role,
    required this.resourceUrl,
    required this.year,
    required this.thumb,
    required this.stats,
    this.status,
    this.format,
    this.label,
    this.trackinfo,
  });

  factory Release.fromJson(Map<String, dynamic> json) {
    return Release(
      id: json['id'],
      title: json['title'],
      type: json['type'],
      mainRelease: json['main_release'],
      artist: json['artist'],
      role: json['role'],
      resourceUrl: json['resource_url'],
      year: json['year'],
      thumb: json['thumb'],
      stats: Stats.fromJson(json['stats']),
      status: json['status'],
      format: json['format'],
      label: json['label'],
      trackinfo: json['trackinfo'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'type': type,
      if (mainRelease != null) 'main_release': mainRelease,
      'artist': artist,
      'role': role,
      'resource_url': resourceUrl,
      'year': year,
      'thumb': thumb,
      'stats': stats.toJson(),
      if (status != null) 'status': status,
      if (format != null) 'format': format,
      if (label != null) 'label': label,
      if (trackinfo != null) 'trackinfo': trackinfo,
    };
  }
}

class Stats {
  final Community community;

  Stats({
    required this.community,
  });

  factory Stats.fromJson(Map<String, dynamic> json) {
    return Stats(
      community: Community.fromJson(json['community']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'community': community.toJson(),
    };
  }
}

class Community {
  final int inWantlist;
  final int inCollection;

  Community({
    required this.inWantlist,
    required this.inCollection,
  });

  factory Community.fromJson(Map<String, dynamic> json) {
    return Community(
      inWantlist: json['in_wantlist'],
      inCollection: json['in_collection'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'in_wantlist': inWantlist,
      'in_collection': inCollection,
    };
  }
}
