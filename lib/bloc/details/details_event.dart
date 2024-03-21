part of 'details_bloc.dart';

@immutable
sealed class DetailsEvent {}

final class PlayerSetupRequested extends DetailsEvent {
  final String streamURL;
  final Function(double) onProgressChanged;

  PlayerSetupRequested(this.streamURL, this.onProgressChanged);
}

final class SongPlayPauseRequested extends DetailsEvent {}

final class SongProgressUpdated extends DetailsEvent {
  final double progress;

  SongProgressUpdated(this.progress);
}
