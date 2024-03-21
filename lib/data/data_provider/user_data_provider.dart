import 'package:nymble_music/helpers/supabase_helper.dart';

class UserDataProvider {
  Future<Map<String, dynamic>> getUserData(String id) async {
    try {
      return (await SupabaseHelper.instance.client.from("users").select('id, favorites').eq('id', id)).first;
    } catch (e) {
      rethrow;
    }
  }

  Future<DateTime> getLastFavoritesUpdated(String id) async {
    try {
      final response = (await SupabaseHelper.instance.client.from("users").select('updated_at').eq('id', id)).first;
      return DateTime.parse(response['updated_at']);
    } catch (e) {
      rethrow;
    }
  }

  Future updateFavorites(String userId, List<int> favorites) async {
    try {
      return await SupabaseHelper.instance.client.from("users").update({
        'favorites': favorites,
        'updated_at': DateTime.now().toUtc().toString(),
      }).eq('id', userId);
    } catch (e) {
      rethrow;
    }
  }
}
