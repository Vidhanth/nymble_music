import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nymble_music/bloc/auth/auth_bloc.dart';
import 'package:nymble_music/helpers/navigation_helper.dart';
import 'package:nymble_music/presentation/components/logo/logo.dart';
import 'package:nymble_music/presentation/screens/auth_screen.dart';
import 'package:nymble_music/presentation/screens/home_screen.dart';
import 'package:nymble_music/utils/extensions.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (BuildContext context, state) {
        if (state is AuthInitial) {
          NavigationHelper.replace(context, page: const AuthScreen());
        }
        if (state is AuthSuccess) {
          NavigationHelper.replace(context, page: const HomeScreen());
        }
      },
      child: Scaffold(
        body: Center(
          child: ZoomIn(
            duration: 1500.milliseconds,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Logo(),
                const SizedBox(
                  height: 13,
                ),
                SizedBox(
                  height: 16,
                  width: 16,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: Theme.of(context).colorScheme.surfaceTint,
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
