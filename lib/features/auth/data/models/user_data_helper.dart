/// Helper class to easily access saved user data throughout the app
/// This provides a convenient way to get user information without
/// dealing with repository/use case complexity
/// 
/// NOTE: This is a placeholder. In practice, use the repository directly
/// or create use cases for accessing user data.
import 'login_response_model.dart';

class UserDataHelper {
  /// Get the saved login response (contains all user data)
  /// 
  /// For actual usage, use repository directly:
  /// ```dart
  /// final repository = di.sl<AuthRepository>();
  /// final result = await repository.getLoginResponse();
  /// ```
  static Future<LoginResponseModel?> getSavedLoginResponse() async {
    // This is a placeholder - use repository directly in your code
    // See USER_DATA_USAGE_GUIDE.md for examples
    return null;
  }

  /// Get user description model
  static Future<UserDescriptionModel?> getUserDescription() async {
    final loginResponse = await getSavedLoginResponse();
    return loginResponse?.userDescription;
  }

  /// Get user ID
  static Future<int?> getUserId() async {
    final userDesc = await getUserDescription();
    return userDesc?.userId;
  }

  /// Get user name
  static Future<String?> getUserName() async {
    final userDesc = await getUserDescription();
    return userDesc?.userName;
  }

  /// Get user designation
  static Future<String?> getUserDesignation() async {
    final userDesc = await getUserDescription();
    return userDesc?.designation;
  }

  /// Get user branch
  static Future<String?> getUserBranch() async {
    final userDesc = await getUserDescription();
    return userDesc?.userBranch;
  }

  /// Get saved token
  static Future<String?> getToken() async {
    final loginResponse = await getSavedLoginResponse();
    return loginResponse?.token;
  }
}

/// Example usage in your app:
/// 
/// ```dart
/// // Get user name
/// final userName = await UserDataHelper.getUserName();
/// 
/// // Get user designation
/// final designation = await UserDataHelper.getUserDesignation();
/// 
/// // Get user ID
/// final userId = await UserDataHelper.getUserId();
/// 
/// // Get token for API calls
/// final token = await UserDataHelper.getToken();
/// ```

