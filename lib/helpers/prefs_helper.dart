import 'package:hive_flutter/hive_flutter.dart';

class PrefsHelper {
  static final instance = PrefsHelper();

  late final Box? _localDBBox;

  Future<void> initialize() async {
    _localDBBox = await Hive.openBox('localDB');
  }

  Future<void> setString(String key, String value) async {
    await _localDBBox?.put(key, value);
  }

  String getString(String key, {String defaultValue = ""}) {
    return (_localDBBox?.get(key) ?? defaultValue) as String;
  }

  Future<void> setBool(String key, bool value) async {
    await _localDBBox?.put(key, value);
  }

  Future<void> setValue<T>(String key, T value) async {
    await _localDBBox?.put(key, value);
  }

  T? getValue<T>(String key) {
    return _localDBBox?.get(key) as T?;
  }

  bool getBool(String key, {bool defaultValue = false}) {
    return (_localDBBox?.get(key) ?? defaultValue) as bool;
  }

  Future<void> remove(String key) async {
    await _localDBBox?.delete(key);
  }
}
