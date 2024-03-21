part of 'user_bloc.dart';

@immutable
sealed class UserEvent {}

final class UserLoggedIn extends UserEvent {
  final String userId;
  UserLoggedIn(this.userId);
}

final class UserFavoritesUpdateRequested extends UserEvent {
  final int newFavorite;

  UserFavoritesUpdateRequested(this.newFavorite);
}

final class UserPendingActionRequested extends UserEvent {}

final class UserLoggedOut extends UserEvent {}
