part of 'user_bloc.dart';

@immutable
sealed class UserState {}

final class UserInitial extends UserState {}

final class UserLoading extends UserState {}

final class UserFailure extends UserState {
  final String error;

  UserFailure(this.error);
}

final class UserLoaded extends UserState {
  final User user;

  UserLoaded(this.user);
}
