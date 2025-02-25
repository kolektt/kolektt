class DiscogsRecord {
  final int id;
  final String title;
  final String? artist;
  final int? year;
  final String thumb;
  final double? lowestPrice;
  final String? format;
  final List<String>? genre;
  final List<String>? style;
  final Community? community;

  DiscogsRecord({
    required this.id,
    required this.title,
    this.artist,
    this.year,
    this.thumb = '',
    this.lowestPrice,
    this.format,
    this.genre,
    this.style,
    this.community,
  });

  factory DiscogsRecord.fromJson(Map<String, dynamic> json) {
    return DiscogsRecord(
      id: json['id'] as int,
      title: json['title'] as String,
      artist: json['artist'] as String?,
      year: json['year'] != null ? int.tryParse(json['year'].toString()) : null,
      thumb: json['thumb'] as String? ?? '',
      lowestPrice: json['lowest_price'] != null ? double.tryParse(json['lowest_price'].toString()) : null,
      format: json['format'] != null ? json['format'][0] as String? : null,
      genre: json['genre'] != null ? List<String>.from(json['genre']) : null,
      style: json['style'] != null ? List<String>.from(json['style']) : null,
      community: json['community'] != null ? Community.fromJson(json['community']) : null,
    );
  }
}

class Community {
  final int? want;
  final int? have;

  Community({
    this.want,
    this.have,
  });

  factory Community.fromJson(Map<String, dynamic> json) {
    return Community(
      want: json['want'] as int?,
      have: json['have'] as int?,
    );
  }
}