class DiscogsSearchResponse {
  final Pagination pagination;
  final List<DiscogsSearchItem> results;

  DiscogsSearchResponse({
    required this.pagination,
    required this.results,
  });

  factory DiscogsSearchResponse.fromJson(Map<String, dynamic?> json) {
    return DiscogsSearchResponse(
      pagination: Pagination.fromJson(json['pagination'] ?? {}),
      results: (json['results'] as List<dynamic>? ?? [])
          .map((e) => DiscogsSearchItem.fromJson(e))
          .toList(),
    );
  }
}

class Pagination {
  final int page;
  final int pages;
  final int perPage;
  final int items;
  final PaginationUrls urls;

  Pagination({
    required this.page,
    required this.pages,
    required this.perPage,
    required this.items,
    required this.urls,
  });

  factory Pagination.fromJson(Map<String, dynamic> json) {
    return Pagination(
      page: json['page'] ?? 0,
      pages: json['pages'] ?? 0,
      perPage: json['per_page'] ?? 0,
      items: json['items'] ?? 0,
      urls: PaginationUrls.fromJson(json['urls'] ?? {}),
    );
  }
}

class PaginationUrls {
  final String? last;
  final String? next;

  PaginationUrls({
    this.last,
    this.next,
  });

  factory PaginationUrls.fromJson(Map<String, dynamic> json) {
    return PaginationUrls(
      last: json['last'],
      next: json['next'],
    );
  }
}

class DiscogsSearchItem {
  final String country;
  final String? year;
  final List<String> format;
  final List<String> label;
  final String type;
  final List<String> genre;
  final List<String> style;
  final int id;
  final List<String> barcode;
  final int masterId;
  final String? masterUrl;
  final String uri;
  final String catno;
  final String title;
  final String thumb;
  final String coverImage;
  final String resourceUrl;
  final Community community;
  final int formatQuantity;
  final List<DiscogsFormat> formats;

  DiscogsSearchItem({
    required this.country,
    this.year,
    required this.format,
    required this.label,
    required this.type,
    required this.genre,
    required this.style,
    required this.id,
    required this.barcode,
    required this.masterId,
    this.masterUrl,
    required this.uri,
    required this.catno,
    required this.title,
    required this.thumb,
    required this.coverImage,
    required this.resourceUrl,
    required this.community,
    required this.formatQuantity,
    required this.formats,
  });

  factory DiscogsSearchItem.fromJson(Map<String, dynamic> json) {
    return DiscogsSearchItem(
      country: json['country'],
      year: json['year'],
      format: List<String>.from(json['format']),
      label: List<String>.from(json['label']),
      type: json['type'],
      genre: List<String>.from(json['genre']),
      style: List<String>.from(json['style']),
      id: json['id'],
      barcode: List<String>.from(json['barcode']),
      masterId: json['master_id'],
      masterUrl: json['master_url'] ?? '',
      uri: json['uri'],
      catno: json['catno'],
      title: json['title'],
      thumb: json['thumb'],
      coverImage: json['cover_image'],
      resourceUrl: json['resource_url'],
      community: Community.fromJson(json['community']),
      formatQuantity: json['format_quantity'],
      formats: (json['formats'] as List)
          .map((item) => DiscogsFormat.fromJson(item))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'country': country,
      'year': year,
      'format': format,
      'label': label,
      'type': type,
      'genre': genre,
      'style': style,
      'id': id,
      'barcode': barcode,
      'master_id': masterId,
      'master_url': masterUrl,
      'uri': uri,
      'catno': catno,
      'title': title,
      'thumb': thumb,
      'cover_image': coverImage,
      'resource_url': resourceUrl,
      'community': community.toJson(),
      'format_quantity': formatQuantity,
      'formats': formats.map((f) => f.toJson()).toList(),
    };
  }
}

class Community {
  final int want;
  final int have;

  Community({
    required this.want,
    required this.have,
  });

  factory Community.fromJson(Map<String, dynamic> json) {
    return Community(
      want: json['want'],
      have: json['have'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'want': want,
      'have': have,
    };
  }
}

class DiscogsFormat {
  final String name;
  final String qty;
  final String? text;
  final List<String>? descriptions;

  DiscogsFormat({
    required this.name,
    required this.qty,
    this.text,
    required this.descriptions,
  });

  factory DiscogsFormat.fromJson(Map<String, dynamic> json) {
    return DiscogsFormat(
      name: json['name'],
      qty: json['qty'],
      text: json['text'] ?? "", // text might be null if not provided
      descriptions: List<String>.from(json['descriptions'] ?? []),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'qty': qty,
      'text': text,
      'descriptions': descriptions,
    };
  }
}
