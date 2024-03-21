import 'package:nymble_music/secrets.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseHelper {
  static final instance = SupabaseHelper();

  late final SupabaseClient _client;

  SupabaseClient get client => _client;

  Future<void> initialize() async {
    final supabase = await Supabase.initialize(url: supabaseURL, anonKey: supabaseKey);
    _client = supabase.client;
  }
}
