part of 'songs_bloc.dart';

@immutable
sealed class SongsState {}

final class SongsInitial extends SongsState {}

final class SongsLoading extends SongsState {}

final class SongsFailure extends SongsState {
  final String error;

  SongsFailure(this.error);
}

final class SongsLoaded extends SongsState {
  final List<Song> songs;
  final String searchQuery;
  final String filter;
  final List<int>? userFavorites;

  List<String> get allFilters {
    Set<String> filters = {};
    for (Song song in songs) {
      filters.addAll(song.genres);
    }
    return filters.toList();
  }

  SongsLoaded copyWith({List<Song>? songs, String? searchQuery, String? filter, List<int>? userFavorites}) {
    return SongsLoaded(songs ?? this.songs,
        searchQuery: searchQuery ?? this.searchQuery, filter: filter ?? this.filter, userFavorites: userFavorites);
  }

  List<Song> get filteredSongs => songs
      .where(
        (song) =>
            (song.artist.toLowerCase().contains(searchQuery) || song.name.toLowerCase().contains(searchQuery)) &&
            (filter.isNotEmpty ? song.genres.contains(filter) : true) &&
            ((userFavorites == null)
                ? true
                : userFavorites!.contains(
                    song.id,
                  )),
      )
      .toList();

  SongsLoaded(this.songs, {this.searchQuery = "", this.filter = "", this.userFavorites});
}
