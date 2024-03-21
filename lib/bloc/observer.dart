import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nymble_music/bloc/auth/auth_bloc.dart';
import 'package:nymble_music/bloc/theme/theme_bloc.dart';
import 'package:nymble_music/helpers/prefs_helper.dart';
import 'package:nymble_music/utils/extensions.dart';

class NMBlocObserver extends BlocObserver {
  @override
  void onCreate(BlocBase bloc) async {
    super.onCreate(bloc);

    if (bloc is AuthBloc) {
      await Future.delayed(1.seconds);
      final email = PrefsHelper.instance.getString('email');
      final password = PrefsHelper.instance.getString('password');

      bloc.add(AuthLoginRequested(email, password, shouldShowError: false));
    }
  }

  @override
  void onChange(BlocBase bloc, Change change) {
    if (bloc is AuthBloc) {
      if (change.nextState is AuthInitial) {
        PrefsHelper.instance.remove('email');
        PrefsHelper.instance.remove('password');
      }
    }
    if (bloc is ThemeBloc) {
      if (change.nextState is ThemeSelected) {
        PrefsHelper.instance.setBool("darkMode", change.nextState.darkMode);
      }
    }
    super.onChange(bloc, change);
  }
}
