import 'package:nymble_music/data/data_provider/songs_data_provider.dart';
import 'package:nymble_music/models/song.dart';

class SongsRepository {
  final SongsDataProvider _songsDataProvider;

  SongsRepository(this._songsDataProvider);

  Future<List<Song>> getAllSongs() async {
    try {
      final response = await _songsDataProvider.getAllSongs();
      final List<Song> songs = List<Song>.from(response.map((x) => Song.fromJson(x)));
      return songs;
    } catch (e) {
      throw Exception("Something went wrong.");
    }
  }
}
