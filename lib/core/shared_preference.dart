import 'package:shared_preferences/shared_preferences.dart';

class SharedPreference {
  SharedPreference(this._sharedPreferences);
  static const String _userId = 'USER_ID';
  static const String _password = 'PASSWORD';

  final SharedPreferences _sharedPreferences;

  Future<String> getUserId() async {
    return _sharedPreferences.getString(_userId) ?? '';
  }

  Future<bool> setUserId(String id) async {
    return _sharedPreferences.setString(_userId, id);
  }

  Future<String> getPassword() async {
    return _sharedPreferences.getString(_password) ?? '';
  }

  Future<bool> setPassword(String password) async {
    return _sharedPreferences.setString(_password, password);
  }

  Future<bool> logout() async {
    await _sharedPreferences.setString(_userId, '');
    await _sharedPreferences.setString(_password, '');

    return true;
  }
}
