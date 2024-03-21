import 'package:nymble_music/helpers/supabase_helper.dart';

class AuthDataProvider {
  Future<String> signUp(String email, String password) async {
    try {
      return (await SupabaseHelper.instance.client.auth.signUp(password: password, email: email)).user?.id ?? "";
    } catch (e) {
      rethrow;
    }
  }

  Future<String> signIn(String email, String password) async {
    try {
      return (await SupabaseHelper.instance.client.auth.signInWithPassword(password: password, email: email)).user?.id ?? "";
    } catch (e) {
      rethrow;
    }
  }
}
