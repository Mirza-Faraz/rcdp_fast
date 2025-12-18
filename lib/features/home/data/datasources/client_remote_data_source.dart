import 'package:dio/dio.dart';
import '../../../../core/constants/api_endpoints.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/network/api_client.dart';
import '../models/client_search_model.dart';
import '../models/nearby_client_model.dart';

abstract class ClientRemoteDataSource {
  Future<ClientSearchResponseModel> searchClient(String cnic, int branchId);
  Future<NearbyClientsResponseModel> getNearbyClients({
    required int userId,
    required int branchId,
    required double latitude,
    required double longitude,
    required int page,
    required int rows,
  });
}

class ClientRemoteDataSourceImpl implements ClientRemoteDataSource {
  final ApiClient apiClient;

  ClientRemoteDataSourceImpl({required this.apiClient});

  @override
  Future<ClientSearchResponseModel> searchClient(String cnic, int branchId) async {
    try {
      final response = await apiClient.get(
        ApiEndpoints.clientSearch,
        queryParameters: {
          'CNIC': cnic,
          'BranchId': branchId,
        },
      );

      if (response.statusCode == 200) {
        return ClientSearchResponseModel.fromJson(response.data);
      } else {
        throw ServerException('Failed to search client');
      }
    } catch (e) {
      if (e is ServerException || e is NetworkException) {
        rethrow;
      }
      throw ServerException('An error occurred while searching client: ${e.toString()}');
    }
  }

  @override
  Future<NearbyClientsResponseModel> getNearbyClients({
    required int userId,
    required int branchId,
    required double latitude,
    required double longitude,
    required int page,
    required int rows,
  }) async {
    try {
      final response = await apiClient.get(
        ApiEndpoints.nearbyClient,
        queryParameters: {
          'sidx': 'id',
          'sord': 'DESC',
          'page': page,
          'rows': rows,
          'Branch_id': branchId,
          'Member_ID': '',
          'Case_Date': '',
          'Case_DateTo': '',
          'UserID': userId,
          'Product_ID': '',
          'Center_No': '',
          'latitude': latitude,
          'longitude': longitude,
          'Distance': '', 
        },
      );

      if (response.statusCode == 200) {
        return NearbyClientsResponseModel.fromJson(response.data);
      } else {
        throw ServerException('Failed to fetch nearby clients');
      }
    } catch (e) {
      if (e is ServerException || e is NetworkException) {
        rethrow;
      }
      throw ServerException('An error occurred while fetching nearby clients: ${e.toString()}');
    }
  }
}
