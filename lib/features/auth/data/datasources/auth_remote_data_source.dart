import 'package:dio/dio.dart';
import '../../../../core/constants/api_endpoints.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/network/api_client.dart';
import '../models/login_request_model.dart';
import '../models/login_response_model.dart';
import '../models/profile_response_model.dart';
import '../models/profile_response_model.dart';
import '../models/user_rights_model.dart';
import '../models/branch_model.dart';
import '../models/product_model.dart';
import '../models/credit_officer_model.dart';

abstract class AuthRemoteDataSource {
  Future<LoginResponseModel> login(LoginRequestModel request);
  Future<void> logout();
  Future<void> changePassword(String username, String oldPassword, String newPassword);
  Future<ProfileResponseModel> getProfile(int userId, {required String token});
  Future<UserRightsResponseModel> getUserRights(int groupId);
  Future<BranchResponseModel> getBranches(int userId);
  Future<String> getCenterNumber(int branchId);
  Future<ProductResponseModel> getProducts(int branchId);
  Future<CreditOfficerResponseModel> getCreditOfficers(int branchId);
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final ApiClient apiClient;

  AuthRemoteDataSourceImpl({required this.apiClient});

  @override
  Future<LoginResponseModel> login(LoginRequestModel request) async {
    try {
      // Make POST request to login endpoint
      final response = await apiClient.post(ApiEndpoints.login, data: request.toJson());

      // Check if response is successful
      if (response.statusCode == 200 || response.statusCode == 201) {
        // Parse the response
        final loginResponse = LoginResponseModel.fromJson(response.data);

        // If login is successful, save the token
        if (loginResponse.success && loginResponse.token.isNotEmpty) {
          apiClient.setAuthToken(loginResponse.token);
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
  Future<void> changePassword(String username, String oldPassword, String newPassword) async {
    try {
      final response = await apiClient.post(ApiEndpoints.changePassword, data: {'username': username, 'oldPassword': oldPassword, 'newPassword': newPassword});

      if (response.statusCode != 200 && response.statusCode != 201) {
        throw ServerException(response.data['message'] ?? 'Failed to change password');
      }
    } catch (e) {
      if (e is ServerException || e is NetworkException) {
        rethrow;
      }
      throw ServerException('An error occurred while changing password: ${e.toString()}');
    }
  }

  @override
  Future<ProfileResponseModel> getProfile(int userId, {required String token}) async {
    try {
      // Make GET request to profile endpoint with User_ID parameter
      final response = await apiClient.get(
        ApiEndpoints.getUserProfile,
        queryParameters: {'User_ID': userId},
        options: Options(headers: {'Authorization': token}),
      );

      // Check if response is successful
      if (response.statusCode == 200 || response.statusCode == 201) {
        // Parse the response
        final profileResponse = ProfileResponseModel.fromJson(response.data);
        return profileResponse;
      } else {
        final errorMessage = response.data != null && response.data is Map
            ? (response.data as Map)['message'] ?? 'Unknown error'
            : 'Failed to get profile. Status code: ${response.statusCode}';
        throw ServerException('Failed to get profile: $errorMessage');
      }
    } catch (e) {
      if (e is ServerException || e is NetworkException) {
        rethrow;
      }
      throw ServerException('An error occurred while getting profile: ${e.toString()}');
    }
  }

  @override
  Future<UserRightsResponseModel> getUserRights(int groupId) async {
    try {
      final response = await apiClient.get(
        ApiEndpoints.getUserRights,
        queryParameters: {'group': groupId},
      );

      if (response.statusCode == 200) {
        return UserRightsResponseModel.fromJson(response.data);
      } else {
        throw ServerException('Failed to fetch user rights');
      }
    } catch (e) {
      if (e is ServerException || e is NetworkException) {
        rethrow;
      }
      throw ServerException('An error occurred while fetching user rights: ${e.toString()}');
    }
  }

  @override
  Future<BranchResponseModel> getBranches(int userId) async {
    try {
      final response = await apiClient.get(
        ApiEndpoints.getBranchesByUserId,
        queryParameters: {'UserId': userId},
      );

      if (response.statusCode == 200) {
        return BranchResponseModel.fromJson(response.data);
      } else {
        throw ServerException('Failed to fetch branches');
      }
    } catch (e) {
      if (e is ServerException || e is NetworkException) {
        rethrow;
      }
      throw ServerException('An error occurred while fetching branches: ${e.toString()}');
    }
  }

  @override
  Future<String> getCenterNumber(int branchId) async {
    try {
      final response = await apiClient.get(
        ApiEndpoints.getCenterNumber,
        queryParameters: {'BranchId': branchId},
      );

      if (response.statusCode == 200) {
        final data = response.data;
        if (data is Map<String, dynamic> && data['status'] == 'True') {
          return data['data']?.toString() ?? '';
        }
        throw ServerException('Failed to fetch center number: Invalid response format');
      } else {
        throw ServerException('Failed to fetch center number');
      }
    } catch (e) {
      if (e is ServerException || e is NetworkException) {
        rethrow;
      }
      throw ServerException('An error occurred while fetching center number: ${e.toString()}');
    }
  }

  @override
  Future<ProductResponseModel> getProducts(int branchId) async {
    try {
      final response = await apiClient.get(
        ApiEndpoints.getProductByBranch,
        queryParameters: {'BranchID': branchId},
      );

      if (response.statusCode == 200) {
        return ProductResponseModel.fromJson(response.data);
      } else {
        throw ServerException('Failed to fetch products');
      }
    } catch (e) {
      if (e is ServerException || e is NetworkException) {
        rethrow;
      }
      throw ServerException('An error occurred while fetching products: ${e.toString()}');
    }
  }

  @override
  Future<CreditOfficerResponseModel> getCreditOfficers(int branchId) async {
    try {
      final response = await apiClient.get(
        ApiEndpoints.getCoByBranch,
        queryParameters: {'BranchId': branchId},
      );

      if (response.statusCode == 200) {
        return CreditOfficerResponseModel.fromJson(response.data);
      } else {
        throw ServerException('Failed to fetch credit officers');
      }
    } catch (e) {
      if (e is ServerException || e is NetworkException) {
        rethrow;
      }
      throw ServerException('An error occurred while fetching credit officers: ${e.toString()}');
    }
  }
}
