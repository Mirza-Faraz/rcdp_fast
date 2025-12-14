import '../../../../core/constants/api_endpoints.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/network/api_client.dart';
import '../models/login_request_model.dart';
import '../models/login_response_model.dart';

abstract class AuthRemoteDataSource {
  Future<LoginResponseModel> login(LoginRequestModel request);
  Future<void> logout();
  Future<void> changePassword(String username, String oldPassword, String newPassword);
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final ApiClient apiClient;

  AuthRemoteDataSourceImpl({required this.apiClient});

  @override
  Future<LoginResponseModel> login(LoginRequestModel request) async {
    try {
      // Make POST request to login endpoint
      final response = await apiClient.post(
        ApiEndpoints.login,
        data: request.toJson(),
      );

      // Check if response is successful
      if (response.statusCode == 200 || response.statusCode == 201) {
        // Parse the response
        final loginResponse = LoginResponseModel.fromJson(response.data);
        
        // If login is successful, save the token
        if (loginResponse.success && loginResponse.token != null) {
          apiClient.setAuthToken(loginResponse.token!);
        }
        
        return loginResponse;
      } else {
        throw ServerException('Login failed: ${response.data['message'] ?? 'Unknown error'}');
      }
    } catch (e) {
      if (e is ServerException || e is NetworkException) {
        rethrow;
      }
      throw ServerException('An error occurred during login: ${e.toString()}');
    }
  }

  @override
  Future<void> logout() async {
    try {
      await apiClient.post(ApiEndpoints.logout);
      // Clear auth token after logout
      apiClient.clearAuthToken();
    } catch (e) {
      // Even if API call fails, clear local token
      apiClient.clearAuthToken();
      if (e is ServerException || e is NetworkException) {
        rethrow;
      }
      throw ServerException('An error occurred during logout: ${e.toString()}');
    }
  }

  @override
  Future<void> changePassword(
    String username,
    String oldPassword,
    String newPassword,
  ) async {
    try {
      final response = await apiClient.post(
        ApiEndpoints.changePassword,
        data: {
          'username': username,
          'oldPassword': oldPassword,
          'newPassword': newPassword,
        },
      );

      if (response.statusCode != 200 && response.statusCode != 201) {
        throw ServerException(
          response.data['message'] ?? 'Failed to change password',
        );
      }
    } catch (e) {
      if (e is ServerException || e is NetworkException) {
        rethrow;
      }
      throw ServerException('An error occurred while changing password: ${e.toString()}');
    }
  }
}


