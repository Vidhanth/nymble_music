part of 'theme_bloc.dart';

@immutable
sealed class ThemeState {}

final class ThemeInitial extends ThemeState {}

final class ThemeSelected extends ThemeState {
  final bool darkMode;
  ThemeSelected(this.darkMode);
}
