import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:nymble_music/data/repositories/auth_repository.dart';
import 'package:nymble_music/utils/extensions.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository _authRepository;

  AuthBloc(this._authRepository) : super(AuthInitial(true)) {
    on<AuthFormChangeRequested>(_onAuthFormChangeRequested);
    on<AuthLoginRequested>(_onAuthLoginRequested);
    on<AuthSignupRequested>(_onAuthSignupRequested);
    on<AuthLogoutRequested>(_onAuthLogoutRequested);
  }

  FutureOr<void> _onAuthLoginRequested(AuthLoginRequested event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    final email = event.email;
    final password = event.password;
    if (email.isEmpty || password.isEmpty) {
      if (event.shouldShowError) {
        emit(AuthFailure("Please fill up the form completely.", true));
        return;
      }
      emit(AuthInitial(true));
      return;
    }
    if (!email.isValidEmail) {
      emit(AuthFailure("Please enter a valid email address.", true));
      return;
    }
    try {
      final userId = await _authRepository.signIn(email, password);
      emit(AuthSuccess(userId));
    } catch (e) {
      emit(AuthFailure("Something went wrong. Please check your credentials and try again.", true));
    }
  }

  FutureOr<void> _onAuthSignupRequested(AuthSignupRequested event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    final email = event.email;
    final password = event.password;
    final passwordConfirmation = event.passwordConfirmation;
    if (email.isEmpty || password.isEmpty || passwordConfirmation.isEmpty) {
      emit(AuthFailure("Please fill up the form completely.", false));
      return;
    }
    if (!email.isValidEmail) {
      emit(AuthFailure("Please enter a valid email address.", false));
      return;
    }
    if (passwordConfirmation != password) {
      emit(AuthFailure("The passwords do not match.", false));
      return;
    }
    try {
      final userId = await _authRepository.signUp(email, password);
      emit(AuthSuccess(userId));
    } catch (e) {
      emit(AuthFailure("Something went wrong. Please try again later.", false));
    }
  }

  FutureOr<void> _onAuthLogoutRequested(AuthLogoutRequested event, Emitter<AuthState> emit) async {
    emit(AuthInitial(true));
  }

  FutureOr<void> _onAuthFormChangeRequested(event, Emitter<AuthState> emit) {
    bool isSignInState = true;
    if (state is AuthInitial) {
      isSignInState = (state as AuthInitial).signInState;
    }
    emit(AuthInitial(!isSignInState));
  }
}
