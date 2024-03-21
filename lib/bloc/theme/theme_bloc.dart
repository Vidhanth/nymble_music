import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nymble_music/helpers/prefs_helper.dart';
import 'package:nymble_music/presentation/constants/keys.dart';

part 'theme_event.dart';
part 'theme_state.dart';

class ThemeBloc extends Bloc<ThemeEvent, ThemeState> {
  ThemeBloc() : super(ThemeInitial()) {
    on<ThemeSetupRequested>(_onThemeSetupRequested);
    on<ThemeChanged>(_onThemeChanged);
  }

  FutureOr<void> _onThemeChanged(ThemeChanged event, Emitter<ThemeState> emit) {
    final currentState = state as ThemeSelected;

    emit(ThemeSelected(!currentState.darkMode));
  }

  FutureOr<void> _onThemeSetupRequested(ThemeSetupRequested event, Emitter<ThemeState> emit) {
    final darkMode = PrefsHelper.instance.getBool(darkModePrefsKey);
    emit(ThemeSelected(darkMode));
  }
}
