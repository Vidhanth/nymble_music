part of 'auth_bloc.dart';

@immutable
sealed class AuthState {}

final class AuthInitial extends AuthState {
  final bool signInState;

  AuthInitial(this.signInState);
}

final class AuthLoading extends AuthState {}

final class AuthFailure extends AuthState {
  final bool signInState;
  final String error;

  AuthFailure(this.error, this.signInState);
}

final class AuthSuccess extends AuthState {
  final String userId;
  AuthSuccess(this.userId);
}
