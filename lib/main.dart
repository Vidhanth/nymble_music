import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:nymble_music/bloc/auth/auth_bloc.dart';
import 'package:nymble_music/bloc/observer.dart';
import 'package:nymble_music/bloc/songs/songs_bloc.dart';
import 'package:nymble_music/bloc/theme/theme_bloc.dart';
import 'package:nymble_music/bloc/user/user_bloc.dart';
import 'package:nymble_music/data/data_provider/auth_data_provider.dart';
import 'package:nymble_music/data/data_provider/songs_data_provider.dart';
import 'package:nymble_music/data/data_provider/user_data_provider.dart';
import 'package:nymble_music/data/repositories/auth_repository.dart';
import 'package:nymble_music/data/repositories/songs_repository.dart';
import 'package:nymble_music/data/repositories/user_repository.dart';
import 'package:nymble_music/helpers/audio_helper.dart';
import 'package:nymble_music/helpers/connectivity_helper.dart';
import 'package:nymble_music/helpers/prefs_helper.dart';
import 'package:nymble_music/helpers/supabase_helper.dart';
import 'package:nymble_music/presentation/constants/colors.dart';
import 'package:nymble_music/presentation/screens/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  ConnectivityHelper.instance.initialize();
  await SupabaseHelper.instance.initialize();
  await Hive.initFlutter();
  await PrefsHelper.instance.initialize();
  AudioHelper.instance.initialize();
  Bloc.observer = NMBlocObserver();
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<AuthRepository>(create: (_) => AuthRepository(AuthDataProvider())),
        RepositoryProvider<UserRepository>(create: (_) => UserRepository(UserDataProvider())),
        RepositoryProvider<SongsRepository>(create: (_) => SongsRepository(SongsDataProvider())),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(create: (context) => ThemeBloc()),
          BlocProvider(create: (context) => AuthBloc(context.read<AuthRepository>())),
          BlocProvider(create: (context) => SongsBloc(context.read<SongsRepository>())),
          BlocProvider(create: (context) => UserBloc(context.read<UserRepository>())),
        ],
        child: BlocBuilder<ThemeBloc, ThemeState>(
          builder: (context, state) {
            if (state is! ThemeSelected) {
              context.read<ThemeBloc>().add(ThemeSetupRequested());
              return const SizedBox();
            }
            return MaterialApp(
              theme: ThemeData.from(
                colorScheme: ColorScheme.fromSeed(
                  seedColor: primaryColor,
                  brightness: state.darkMode ? Brightness.dark : Brightness.light,
                ),
              ),
              home: const Scaffold(
                body: Center(
                  child: SplashScreen(),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
