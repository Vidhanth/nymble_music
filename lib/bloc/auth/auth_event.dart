part of 'auth_bloc.dart';

@immutable
sealed class AuthEvent {}

final class AuthFormChangeRequested extends AuthEvent {}

final class AuthLoginRequested extends AuthEvent {
  final String email;
  final String password;
  final bool shouldShowError;

  AuthLoginRequested(this.email, this.password, {this.shouldShowError = true});
}

final class AuthSignupRequested extends AuthEvent {
  final String email;
  final String password;
  final String passwordConfirmation;

  AuthSignupRequested(this.email, this.password, this.passwordConfirmation);
}

final class AuthLogoutRequested extends AuthEvent {}
