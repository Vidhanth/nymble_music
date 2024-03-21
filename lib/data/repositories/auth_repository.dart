import 'package:nymble_music/data/data_provider/auth_data_provider.dart';

class AuthRepository {
  final AuthDataProvider _authDataProvider;

  AuthRepository(this._authDataProvider);

  Future<String> signIn(String email, String password) async {
    try {
      final userId = await _authDataProvider.signIn(email, password);
      if (userId.isEmpty) {
        throw Exception("Auth failed.");
      }
      return userId;
    } catch (e) {
      throw Exception("Something went wrong.");
    }
  }

  Future<String> signUp(String email, String password) async {
    try {
      final userId = await _authDataProvider.signUp(email, password);
      if (userId.isEmpty) {
        throw Exception("Auth failed.");
      }
      return userId;
    } catch (e) {
      throw Exception("Something went wrong.");
    }
  }
}
