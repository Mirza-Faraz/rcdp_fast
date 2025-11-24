import 'package:shared_preferences/shared_preferences.dart';
import '../../../../core/error/exceptions.dart';

abstract class AuthLocalDataSource {
  Future<bool> saveUsername(String username);
  Future<String?> getSavedUsername();
  Future<bool> saveLoginStatus(bool isLoggedIn);
  Future<bool> getLoginStatus();
  Future<void> clearAuthData();
}

class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  final SharedPreferences sharedPreferences;
  static const String usernameKey = 'SAVED_USERNAME';
  static const String loginStatusKey = 'IS_LOGGED_IN';

  AuthLocalDataSourceImpl({required this.sharedPreferences});

  @override
  Future<bool> saveUsername(String username) async {
    try {
      return await sharedPreferences.setString(usernameKey, username);
    } catch (e) {
      throw CacheException('Failed to save username');
    }
  }

  @override
  Future<String?> getSavedUsername() async {
    try {
      return sharedPreferences.getString(usernameKey);
    } catch (e) {
      throw CacheException('Failed to get username');
    }
  }

  @override
  Future<bool> saveLoginStatus(bool isLoggedIn) async {
    try {
      return await sharedPreferences.setBool(loginStatusKey, isLoggedIn);
    } catch (e) {
      throw CacheException('Failed to save login status');
    }
  }

  @override
  Future<bool> getLoginStatus() async {
    try {
      return sharedPreferences.getBool(loginStatusKey) ?? false;
    } catch (e) {
      throw CacheException('Failed to get login status');
    }
  }

  @override
  Future<void> clearAuthData() async {
    try {
      await sharedPreferences.remove(usernameKey);
      await sharedPreferences.remove(loginStatusKey);
    } catch (e) {
      throw CacheException('Failed to clear auth data');
    }
  }
}
