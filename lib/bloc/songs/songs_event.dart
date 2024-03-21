part of 'songs_bloc.dart';

@immutable
sealed class SongsEvent {}

final class FetchSongsRequested extends SongsEvent {}

final class SongsResetRequested extends SongsEvent {}

final class SearchSongsRequested extends SongsEvent {
  final String searchQuery;

  SearchSongsRequested(this.searchQuery);
}

final class SearchFilterChanged extends SongsEvent {
  final String filter;
  SearchFilterChanged(this.filter);
}

final class SongsFavoritesOnlySelected extends SongsEvent {
  final List<int>? currentFavorites;
  SongsFavoritesOnlySelected(this.currentFavorites);
}
