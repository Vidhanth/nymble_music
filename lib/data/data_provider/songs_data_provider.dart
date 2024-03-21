import 'package:nymble_music/helpers/supabase_helper.dart';

class SongsDataProvider {
  Future<List<Map<String, dynamic>>> getAllSongs() async {
    try {
      return await SupabaseHelper.instance.client.from("songs").select("*");
    } catch (e) {
      rethrow;
    }
  }
}
