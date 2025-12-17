import 'package:dio/dio.dart';
import '../../../../core/constants/api_endpoints.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/network/api_client.dart';
import '../models/client_search_model.dart';

abstract class ClientRemoteDataSource {
  Future<ClientSearchResponseModel> searchClient(String cnic, int branchId);
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
}
