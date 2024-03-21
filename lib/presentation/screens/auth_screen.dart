import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nymble_music/bloc/auth/auth_bloc.dart';
import 'package:nymble_music/helpers/navigation_helper.dart';
import 'package:nymble_music/helpers/prefs_helper.dart';
import 'package:nymble_music/presentation/components/button.dart';
import 'package:nymble_music/presentation/components/input_field.dart';
import 'package:nymble_music/presentation/components/logo/logo.dart';
import 'package:nymble_music/presentation/constants/keys.dart';
import 'package:nymble_music/presentation/constants/styles.dart';
import 'package:nymble_music/presentation/screens/home_screen.dart';
import 'package:nymble_music/utils/extensions.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  late final TextEditingController emailController, passwordController, confirmPasswordController;

  @override
  void initState() {
    emailController = TextEditingController();
    passwordController = TextEditingController();
    confirmPasswordController = TextEditingController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Center(
          child: BlocConsumer<AuthBloc, AuthState>(
            listener: (context, state) {
              if (state is AuthFailure) {
                context.showSnackbar(state.error, isError: true);
              }
              if (state is AuthSuccess) {
                PrefsHelper.instance.setString(emailPrefsKey, emailController.text.trim());
                PrefsHelper.instance.setString(passwordPrefsKey, passwordController.text.trim());
                NavigationHelper.replace(context, page: const HomeScreen());
              }
            },
            builder: (context, state) {
              if (state is AuthLoading || state is AuthSuccess) {
                return FadeInUp(
                  child: CircularProgressIndicator(
                    color: Theme.of(context).colorScheme.surfaceTint,
                  ),
                );
              }

              bool isSignInPage = true;
              if (state is AuthInitial) {
                isSignInPage = state.signInState;
              }
              if (state is AuthFailure) {
                isSignInPage = state.signInState;
              }

              return FadeIn(
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Logo(),
                      const SizedBox(
                        height: 20,
                      ),
                      FadeInUp(
                        duration: 500.milliseconds,
                        child: InputField(
                          controller: emailController,
                          inputType: TextInputType.emailAddress,
                          hint: "Email",
                        ),
                      ),
                      FadeInUp(
                        delay: 100.milliseconds,
                        duration: 500.milliseconds,
                        child: InputField(
                          controller: passwordController,
                          hint: "Password",
                          textInputAction: isSignInPage ? TextInputAction.done : TextInputAction.none,
                          inputType: TextInputType.visiblePassword,
                        ),
                      ),
                      AnimatedContainer(
                        duration: 500.milliseconds,
                        height: isSignInPage ? 0 : 70,
                        curve: Curves.fastOutSlowIn,
                        child: isSignInPage
                            ? const SizedBox()
                            : FadeIn(
                                delay: 500.milliseconds,
                                child: InputField(
                                  controller: confirmPasswordController,
                                  hint: "Confirm Password",
                                  inputType: TextInputType.visiblePassword,
                                ),
                              ),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      FadeInUp(
                        delay: 200.milliseconds,
                        child: Button(
                          label: isSignInPage ? "Sign In" : "Sign Up",
                          onTap: () {
                            if (isSignInPage) {
                              context.read<AuthBloc>().add(AuthLoginRequested(emailController.text.trim(), passwordController.text.trim()));
                              return;
                            }
                            context.read<AuthBloc>().add(AuthSignupRequested(
                                emailController.text.trim(), passwordController.text.trim(), confirmPasswordController.text.trim()));
                          },
                        ),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      FadeInUp(
                        delay: 300.milliseconds,
                        child: TextButton(
                          onPressed: () {
                            context.read<AuthBloc>().add(AuthFormChangeRequested());
                          },
                          child: Text(
                            isSignInPage ? "New here? Create an account." : "Already have an account? Sign in instead.",
                            style: montserratText,
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
