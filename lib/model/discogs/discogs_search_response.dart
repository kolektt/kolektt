class DiscogsSearchResponse {
  final Pagination pagination;
  final List<DiscogsSearchItem> results;

  DiscogsSearchResponse({
    required this.pagination,
    required this.results,
  });

  factory DiscogsSearchResponse.fromJson(Map<String, dynamic> json) {
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
  // 주로 검색 결과에서 내려오는 필드들
  final String? country;
  final String? year; // 어떤 경우는 int로 내려오지만, 문자열일 수도 있음
  final List<String> format;
  final List<String> label;
  final String? type; // release, master, artist 등
  final List<String> genre;
  final List<String> style;
  final int? id; // 검색결과에는 int일 수도, string일 수도 있으니 주의
  final List<String> barcode;
  final int? masterId;
  final String? masterUrl;
  final String? uri;
  final String? catno;
  final String? title;
  final String? thumb; // 썸네일
  final String? coverImage; // 전체 표지
  final String? resourceUrl;

  // community, format_quantity, formats 등도 검색 시 종종 내려옴
  final DiscogsSearchCommunity? community;
  final int? formatQuantity;
  final List<DiscogsFormatShort> formats;

  DiscogsSearchItem({
    this.country,
    this.year,
    this.format = const [],
    this.label = const [],
    this.type,
    this.genre = const [],
    this.style = const [],
    this.id,
    this.barcode = const [],
    this.masterId,
    this.masterUrl,
    this.uri,
    this.catno,
    this.title,
    this.thumb,
    this.coverImage,
    this.resourceUrl,
    this.community,
    this.formatQuantity,
    this.formats = const [],
  });

  factory DiscogsSearchItem.fromJson(Map<String, dynamic> json) {
    return DiscogsSearchItem(
      country: json['country']?.toString(),
      year: json['year']?.toString(),
      format: (json['format'] as List<dynamic>?)
          ?.map((e) => e.toString())
          .toList() ??
          [],
      label: (json['label'] as List<dynamic>?)
          ?.map((e) => e.toString())
          .toList() ??
          [],
      type: json['type']?.toString(),
      genre: (json['genre'] as List<dynamic>?)
          ?.map((e) => e.toString())
          .toList() ??
          [],
      style: (json['style'] as List<dynamic>?)
          ?.map((e) => e.toString())
          .toList() ??
          [],
      id: json['id'] is int
          ? json['id']
          : int.tryParse(json['id']?.toString() ?? ''),
      barcode: (json['barcode'] as List<dynamic>?)
          ?.map((e) => e.toString())
          .toList() ??
          [],
      masterId: json['master_id'] is int
          ? json['master_id']
          : int.tryParse(json['master_id']?.toString() ?? ''),
      masterUrl: json['master_url']?.toString(),
      uri: json['uri']?.toString(),
      catno: json['catno']?.toString(),
      title: json['title']?.toString(),
      thumb: json['thumb']?.toString(),
      coverImage: json['cover_image']?.toString(),
      resourceUrl: json['resource_url']?.toString(),
      community: json['community'] != null
          ? DiscogsSearchCommunity.fromJson(json['community'])
          : null,
      formatQuantity: json['format_quantity'] is int
          ? json['format_quantity']
          : int.tryParse(json['format_quantity']?.toString() ?? ''),
      formats: (json['formats'] as List<dynamic>?)
          ?.map((e) => DiscogsFormatShort.fromJson(e))
          .toList() ??
          [],
    );
  }
}

class DiscogsSearchCommunity {
  final int want;
  final int have;

  DiscogsSearchCommunity({
    required this.want,
    required this.have,
  });

  factory DiscogsSearchCommunity.fromJson(Map<String, dynamic> json) {
    return DiscogsSearchCommunity(
      want: json['want'] ?? 0,
      have: json['have'] ?? 0,
    );
  }
}

class DiscogsFormatShort {
  final String name;
  final String qty;
  final List<String> descriptions;
  final String? text;

  DiscogsFormatShort({
    required this.name,
    required this.qty,
    required this.descriptions,
    this.text,
  });

  factory DiscogsFormatShort.fromJson(Map<String, dynamic> json) {
    return DiscogsFormatShort(
      name: json['name'] ?? '',
      qty: json['qty'] ?? '',
      descriptions: (json['descriptions'] as List<dynamic>?)
          ?.map((e) => e.toString())
          .toList() ??
          [],
      text: json['text'],
    );
  }
}