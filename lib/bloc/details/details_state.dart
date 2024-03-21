part of 'details_bloc.dart';

@immutable
sealed class DetailsState {}

final class DetailsInitial extends DetailsState {}

final class DetailsLoaded extends DetailsState {
  final String streamURL;
  final double progress;
  final bool isPlaying;

  DetailsLoaded({
    required this.streamURL,
    required this.progress,
    required this.isPlaying,
  });
}
