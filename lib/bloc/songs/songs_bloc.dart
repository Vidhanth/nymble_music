import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:nymble_music/data/repositories/songs_repository.dart';
import 'package:nymble_music/models/song.dart';
part 'songs_event.dart';
part 'songs_state.dart';

class SongsBloc extends Bloc<SongsEvent, SongsState> {
  final SongsRepository _songsRepository;

  SongsBloc(this._songsRepository) : super(SongsInitial()) {
    on<FetchSongsRequested>(_onFetchSongsRequested);
    on<SongsResetRequested>(_onSongsResetRequested);
    on<SearchSongsRequested>(_onSearchSongsRequested);
    on<SearchFilterChanged>(_onSearchFilterChanged);
    on<SongsFavoritesOnlySelected>(_onSongsFavoritesOnlySelected);
  }

  FutureOr<void> _onFetchSongsRequested(FetchSongsRequested event, Emitter<SongsState> emit) async {
    emit(SongsLoading());

    try {
      final songs = await _songsRepository.getAllSongs();
      emit(SongsLoaded(songs));
    } catch (e) {
      emit(SongsFailure("Could not load songs. Please try again."));
    }
  }

  FutureOr<void> _onSearchSongsRequested(SearchSongsRequested event, Emitter<SongsState> emit) {
    if (state is SongsLoaded) {
      emit((state as SongsLoaded).copyWith(searchQuery: event.searchQuery.trim()));
    }
  }

  FutureOr<void> _onSearchFilterChanged(SearchFilterChanged event, Emitter<SongsState> emit) {
    if (state is SongsLoaded) {
      emit((state as SongsLoaded).copyWith(filter: event.filter, userFavorites: null));
    }
  }

  FutureOr<void> _onSongsResetRequested(SongsResetRequested event, Emitter<SongsState> emit) {
    emit(SongsInitial());
  }

  FutureOr<void> _onSongsFavoritesOnlySelected(SongsFavoritesOnlySelected event, Emitter<SongsState> emit) {
    if (state is SongsLoaded) {
      emit((state as SongsLoaded).copyWith(filter: "", userFavorites: event.currentFavorites));
    }
  }
}
