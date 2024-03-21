import 'package:nymble_music/secrets.dart';

class Song {
  final int id;
  final DateTime createdAt;
  final String name;
  final String artist;
  final String pathName;
  final List<String> genres;

  Song({
    required this.id,
    required this.createdAt,
    required this.name,
    required this.artist,
    required this.pathName,
    required this.genres,
  });

  String get albumUrl => "$supabaseURL/storage/v1/object/public/songs/covers/$pathName.jpeg";
  String get streamUrl => "$supabaseURL/storage/v1/object/public/songs/mp3/$pathName.mp3";

  factory Song.fromJson(Map<String, dynamic> json) => Song(
        id: json["id"],
        createdAt: DateTime.parse(json["created_at"]),
        name: json["name"],
        artist: json["artist"],
        pathName: json["path_name"],
        genres: List<String>.from(json["genres"].map((x) => x)),
      );
}
