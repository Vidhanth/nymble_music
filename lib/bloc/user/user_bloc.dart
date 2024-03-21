import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:nymble_music/data/repositories/user_repository.dart';
import 'package:nymble_music/models/user.dart';

part 'user_event.dart';
part 'user_state.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  final UserRepository _userRepository;

  UserBloc(this._userRepository) : super(UserInitial()) {
    on<UserLoggedIn>(_onUserLoggedIn);
    on<UserFavoritesUpdateRequested>(_onUserFavoritesUpdateRequested);
    on<UserPendingActionRequested>(_onUserPendingActionRequested);
    on<UserLoggedOut>(_onUserLoggedOut);
  }

  FutureOr<void> _onUserLoggedIn(UserLoggedIn event, Emitter<UserState> emit) async {
    emit(UserLoading());
    try {
      await _userRepository.checkAndExecutePendingActions(event.userId);
      final user = await _userRepository.getUserData(event.userId);
      emit(UserLoaded(user));
    } catch (e) {
      emit(UserFailure("Something went wrong. Please try again."));
    }
  }

  FutureOr<void> _onUserLoggedOut(UserLoggedOut event, Emitter<UserState> emit) {
    emit(UserInitial());
  }

  FutureOr<void> _onUserFavoritesUpdateRequested(UserFavoritesUpdateRequested event, Emitter<UserState> emit) async {
    try {
      final userLoadedState = state as UserLoaded;
      final songId = event.newFavorite;
      List<int> newFavorites;
      if (userLoadedState.user.favorites.contains(songId)) {
        newFavorites = userLoadedState.user.favorites.where((id) => id != songId).toList();
      } else {
        newFavorites = [...userLoadedState.user.favorites, songId];
      }
      await _userRepository.updateFavorites(userLoadedState.user.id, newFavorites);
      emit(UserLoaded(User(id: userLoadedState.user.id, favorites: newFavorites)));
    } catch (e) {
      // print(e);
    }
  }

  FutureOr<void> _onUserPendingActionRequested(UserPendingActionRequested event, Emitter<UserState> emit) async {
    try {
      if (state is! UserLoaded) return;
      final userLoadedState = state as UserLoaded;
      final user = await _userRepository.getUserData(userLoadedState.user.id);
      final newFavorites = await _userRepository.checkAndExecutePendingActions(userLoadedState.user.id);
      emit(UserLoaded(User(id: user.id, favorites: newFavorites ?? user.favorites)));
    } catch (e) {
      // print(e);
    }
  }
}
