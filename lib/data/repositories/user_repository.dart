import 'package:nymble_music/data/data_provider/user_data_provider.dart';
import 'package:nymble_music/helpers/connectivity_helper.dart';
import 'package:nymble_music/helpers/prefs_helper.dart';
import 'package:nymble_music/models/pending_action.dart';
import 'package:nymble_music/models/user.dart';

class UserRepository {
  final UserDataProvider _userDataProvider;

  UserRepository(this._userDataProvider);

  Future<User> getUserData(String id) async {
    try {
      final response = await _userDataProvider.getUserData(id);
      return User.fromJson(response);
    } catch (e) {
      throw Exception("Something went wrong.");
    }
  }

  Future<List<int>?> checkAndExecutePendingActions(String id) async {
    try {
      final rawPendingAction = PrefsHelper.instance.getValue<Map<dynamic, dynamic>>("pendingAction");

      if (rawPendingAction == null) return null;

      final pendingAction = PendingAction.fromJson(rawPendingAction);

      final lastUpdated = await _userDataProvider.getLastFavoritesUpdated(id);

      if (lastUpdated.isAfter(pendingAction.timestamp)) {
        PrefsHelper.instance.remove("pendingAction");
        return null;
      } else {
        await _userDataProvider.updateFavorites(id, pendingAction.favorites);
        PrefsHelper.instance.remove("pendingAction");
        return pendingAction.favorites;
      }
    } catch (e) {
      return null;
    }
  }

  Future<void> updateFavorites(String userId, List<int> favorites) async {
    try {
      if (!ConnectivityHelper.instance.isConnected) {
        final pa = PendingAction(favorites: favorites, timestamp: DateTime.now());
        await PrefsHelper.instance.setValue("pendingAction", pa.toJson());
        return;
      }
      await _userDataProvider.updateFavorites(userId, favorites);
    } catch (e) {
      throw Exception("Something went wrong.");
    }
  }
}
