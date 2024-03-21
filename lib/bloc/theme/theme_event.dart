part of 'theme_bloc.dart';

@immutable
sealed class ThemeEvent {}

final class ThemeSetupRequested extends ThemeEvent {}

final class ThemeChanged extends ThemeEvent {}
