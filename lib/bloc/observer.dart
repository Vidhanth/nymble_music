import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nymble_music/bloc/auth/auth_bloc.dart';
import 'package:nymble_music/bloc/theme/theme_bloc.dart';
import 'package:nymble_music/helpers/prefs_helper.dart';
import 'package:nymble_music/presentation/constants/keys.dart';
import 'package:nymble_music/utils/extensions.dart';

class NMBlocObserver extends BlocObserver {
  @override
  void onCreate(BlocBase bloc) async {
    super.onCreate(bloc);

    if (bloc is AuthBloc) {
      await Future.delayed(1.seconds);
      final email = PrefsHelper.instance.getString(emailPrefsKey);
      final password = PrefsHelper.instance.getString(passwordPrefsKey);

      bloc.add(AuthLoginRequested(email, password, shouldShowError: false));
    }
  }

  @override
  void onChange(BlocBase bloc, Change change) {
    if (bloc is AuthBloc) {
      if (change.nextState is AuthInitial) {
        PrefsHelper.instance.remove(emailPrefsKey);
        PrefsHelper.instance.remove(passwordPrefsKey);
      }
    }
    if (bloc is ThemeBloc) {
      if (change.nextState is ThemeSelected) {
        PrefsHelper.instance.setBool(darkModePrefsKey, change.nextState.darkMode);
      }
    }
    super.onChange(bloc, change);
  }
}
