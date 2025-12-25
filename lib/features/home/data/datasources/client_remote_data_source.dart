import 'package:dio/dio.dart';
import '../../../../core/constants/api_endpoints.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/network/api_client.dart';
import '../models/client_search_model.dart';
import '../models/nearby_client_model.dart';
import '../models/already_saved_client_model.dart';
import '../models/loan_tracking_model.dart';

abstract class ClientRemoteDataSource {
  Future<ClientSearchResponseModel> searchClient(String cnic, int branchId);
  Future<NearbyClientsResponseModel> getNearbyClients({
    required int userId,
    required int branchId,
    required double latitude,
    required double longitude,
    required int page,
    required int rows,
    String? memberId,
    String? cnic,
    String? productId,
    String? centerNo,
    String? caseDate,
    String? caseDateTo,
  });
  Future<AlreadySavedClientsResponseModel> getAlreadySavedClients({
    required int userId,
    required int branchId,
    required int page,
    required int rows,
    String? sidx,
    String? sord,
    String? memberId,
    String? cnic,
    String? productId,
    String? centerNo,
    String? caseDate,
    String? caseDateTo,
  });
  Future<LoanTrackingResponseModel> getLoanTrackingList({
    required int userId,
    required int branchId,
    required int page,
    required int rows,
    String? sidx,
    String? sord,
    String? memberId,
    String? cnic,
    String? productId,
    String? centerNo,
    String? caseDate,
    String? caseDateTo,
    String? approvel,
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
    String? memberId,
    String? cnic,
    String? productId,
    String? centerNo,
    String? caseDate,
    String? caseDateTo,
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
          'Member_ID': memberId ?? '',
          'Case_Date': caseDate ?? '',
          'Case_DateTo': caseDateTo ?? '',
          'UserID': userId,
          'Product_ID': productId ?? '',
          'Center_No': centerNo ?? '',
          'CNIC': cnic ?? '', // Added CNIC if supported by API, though user mentioned it as field
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

  @override
  Future<AlreadySavedClientsResponseModel> getAlreadySavedClients({
    required int userId,
    required int branchId,
    required int page,
    required int rows,
    String? sidx,
    String? sord,
    String? memberId,
    String? cnic,
    String? productId,
    String? centerNo,
    String? caseDate,
    String? caseDateTo,
  }) async {
    try {
      final response = await apiClient.get(
        ApiEndpoints.alreadySavedClients,
        queryParameters: {
          'sidx': sidx ?? 'member_id',
          'sord': sord ?? 'DESC',
          'page': page,
          'rows': rows,
          'Branch_id': branchId,
          'Member_ID': memberId ?? '',
          'Case_Date': caseDate ?? '',
          'Case_DateTo': caseDateTo ?? '',
          'UserID': userId,
          'Product_ID': productId ?? '',
          'Center_No': centerNo ?? '',
          'CNIC': cnic ?? '',
        },
      );

      if (response.statusCode == 200) {
        return AlreadySavedClientsResponseModel.fromJson(response.data);
      } else {
        throw ServerException('Failed to fetch already saved clients');
      }
    } catch (e) {
      if (e is ServerException || e is NetworkException) {
        rethrow;
      }
      throw ServerException(
          'An error occurred while fetching already saved clients: ${e.toString()}');
    }
  }

  @override
  Future<LoanTrackingResponseModel> getLoanTrackingList({
    required int userId,
    required int branchId,
    required int page,
    required int rows,
    String? sidx,
    String? sord,
    String? memberId,
    String? cnic,
    String? productId,
    String? centerNo,
    String? caseDate,
    String? caseDateTo,
    String? approvel,
  }) async {
    try {
      final response = await apiClient.get(
        ApiEndpoints.loanTrackingList,
        queryParameters: {
          'sidx': sidx ?? 'member_id',
          'sord': sord ?? 'DESC',
          'page': page,
          'rows': rows,
          'Branch_id': branchId,
          'MemberID': memberId ?? '',
          'Case_Date': caseDate ?? '',
          'Case_DateTo': caseDateTo ?? '',
          'UserID': userId,
          'Product_ID': productId ?? '',
          'Center_No': centerNo ?? '',
          'CNIC': cnic ?? '',
          'Approvel': approvel ?? '',
        },
      );

      if (response.statusCode == 200) {
        return LoanTrackingResponseModel.fromJson(response.data);
      } else {
        throw ServerException('Failed to fetch loan tracking list');
      }
    } catch (e) {
      if (e is ServerException || e is NetworkException) {
        rethrow;
      }
      throw ServerException(
          'An error occurred while fetching loan tracking list: ${e.toString()}');
    }
  }
}
