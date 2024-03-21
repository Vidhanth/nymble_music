import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nymble_music/helpers/audio_helper.dart';

part 'details_event.dart';
part 'details_state.dart';

class DetailsBloc extends Bloc<DetailsEvent, DetailsState> {
  DetailsBloc() : super(DetailsInitial()) {
    on<PlayerSetupRequested>(_onPlayerSetupRequested);
    on<SongPlayPauseRequested>(_onSongPlayPauseRequested);
    on<SongProgressUpdated>(_onSongProgressUpdated);
  }

  FutureOr<void> _onPlayerSetupRequested(PlayerSetupRequested event, Emitter<DetailsState> emit) {
    AudioHelper.instance.setSource(event.streamURL);
    AudioHelper.instance.setOnProgressListener(event.onProgressChanged);
    emit(DetailsLoaded(streamURL: event.streamURL, progress: 0, isPlaying: false));
  }

  FutureOr<void> _onSongPlayPauseRequested(SongPlayPauseRequested event, Emitter<DetailsState> emit) {
    final detailsState = state as DetailsLoaded;
    if (detailsState.isPlaying) {
      AudioHelper.instance.pause();
    } else {
      AudioHelper.instance.play();
    }
    emit(
      DetailsLoaded(
        streamURL: detailsState.streamURL,
        progress: detailsState.progress,
        isPlaying: !detailsState.isPlaying,
      ),
    );
  }

  FutureOr<void> _onSongProgressUpdated(SongProgressUpdated event, Emitter<DetailsState> emit) {
    final detailsState = state as DetailsLoaded;

    if (event.progress == detailsState.progress) {
      return null;
    }
    
    emit(
      DetailsLoaded(
        streamURL: detailsState.streamURL,
        progress: event.progress,
        isPlaying: event.progress == 1 ? false : detailsState.isPlaying,
      ),
    );
  }
}
