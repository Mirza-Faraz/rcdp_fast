import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../core/error/exceptions.dart';
import '../models/login_response_model.dart';
import '../models/profile_response_model.dart';

abstract class AuthLocalDataSource {
  Future<bool> saveUsername(String username);
  Future<String?> getSavedUsername();
  Future<bool> saveLoginStatus(bool isLoggedIn);
  Future<bool> getLoginStatus();
  Future<void> clearAuthData();

  // New methods for saving login response data
  Future<bool> saveToken(String token);
  Future<String?> getToken();
  Future<bool> saveUserDescription(UserDescriptionModel userDescription);
  Future<UserDescriptionModel?> getUserDescription();
  Future<bool> saveLoginResponse(LoginResponseModel loginResponse);
  Future<LoginResponseModel?> getLoginResponse();

  // Profile data methods
  Future<bool> saveProfile(ProfileDataModel profile);
  Future<ProfileDataModel?> getProfile();
}

class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  final SharedPreferences sharedPreferences;
  static const String usernameKey = 'SAVED_USERNAME';
  static const String loginStatusKey = 'IS_LOGGED_IN';
  static const String tokenKey = 'AUTH_TOKEN';
  static const String userDescriptionKey = 'USER_DESCRIPTION';
  static const String loginResponseKey = 'LOGIN_RESPONSE';
  static const String profileKey = 'USER_PROFILE';

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
  Future<bool> saveToken(String token) async {
    try {
      return await sharedPreferences.setString(tokenKey, token);
    } catch (e) {
      throw CacheException('Failed to save token');
    }
  }

  @override
  Future<String?> getToken() async {
    try {
      return sharedPreferences.getString(tokenKey);
    } catch (e) {
      throw CacheException('Failed to get token');
    }
  }

  @override
  Future<bool> saveUserDescription(UserDescriptionModel userDescription) async {
    try {
      return await sharedPreferences.setString(userDescriptionKey, userDescription.toJsonString());
    } catch (e) {
      throw CacheException('Failed to save user description');
    }
  }

  @override
  Future<UserDescriptionModel?> getUserDescription() async {
    try {
      final jsonString = sharedPreferences.getString(userDescriptionKey);
      if (jsonString != null && jsonString.isNotEmpty) {
        return UserDescriptionModel.fromJsonString(jsonString);
      }
      return null;
    } catch (e) {
      throw CacheException('Failed to get user description');
    }
  }

  @override
  Future<bool> saveLoginResponse(LoginResponseModel loginResponse) async {
    try {
      // Save complete login response
      final jsonString = jsonEncode(loginResponse.toJson());
      return await sharedPreferences.setString(loginResponseKey, jsonString);
    } catch (e) {
      throw CacheException('Failed to save login response');
    }
  }

  @override
  Future<LoginResponseModel?> getLoginResponse() async {
    try {
      final jsonString = sharedPreferences.getString(loginResponseKey);
      if (jsonString != null && jsonString.isNotEmpty) {
        final json = jsonDecode(jsonString) as Map<String, dynamic>;
        return LoginResponseModel.fromJson(json);
      }
      return null;
    } catch (e) {
      throw CacheException('Failed to get login response');
    }
  }

  @override
  Future<bool> saveProfile(ProfileDataModel profile) async {
    try {
      return await sharedPreferences.setString(profileKey, profile.toJsonString());
    } catch (e) {
      throw CacheException('Failed to save profile');
    }
  }

  @override
  Future<ProfileDataModel?> getProfile() async {
    try {
      final jsonString = sharedPreferences.getString(profileKey);
      if (jsonString != null && jsonString.isNotEmpty) {
        return ProfileDataModel.fromJsonString(jsonString);
      }
      return null;
    } catch (e) {
      throw CacheException('Failed to get profile');
    }
  }

  @override
  Future<void> clearAuthData() async {
    try {
      await sharedPreferences.remove(usernameKey);
      await sharedPreferences.remove(loginStatusKey);
      await sharedPreferences.remove(tokenKey);
      await sharedPreferences.remove(userDescriptionKey);
      await sharedPreferences.remove(loginResponseKey);
      await sharedPreferences.remove(profileKey);
    } catch (e) {
      throw CacheException('Failed to clear auth data');
    }
  }
}
