class Profiles {
  final String user_id;
  final String? display_name;
  final String? profile_image;
  final String? genre;

  Profiles({
    required this.user_id,
    this.display_name,
    this.profile_image,
    this.genre,
  });
  factory Profiles.fromJson(Map<String, dynamic> json) {
    return Profiles(
      user_id: json['user_id'],
      display_name: json['display_name'],
      profile_image: json['profile_image'],
      genre: json['genre'],
    );
  }
}
