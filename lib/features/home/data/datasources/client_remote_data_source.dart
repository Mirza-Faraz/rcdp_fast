import 'package:dio/dio.dart';
import '../../../../core/constants/api_endpoints.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/network/api_client.dart';
import '../models/client_search_model.dart';
import '../models/nearby_client_model.dart';
import '../models/already_saved_client_model.dart';
import '../models/loan_tracking_model.dart';
import '../models/client_dropdown_models.dart';
import '../models/client_create_model.dart';

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
    String? distance,
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
  Future<EducationResponseModel> getEducationDropDown();
  Future<VillageResponseModel> getVillages(int branchId);
  Future<RelationResponseModel> getAppRelations();
  Future<bool> createClient(ClientCreateRequest request);
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
    String? distance,
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
          'Distance': distance ?? '', 
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

  @override
  Future<EducationResponseModel> getEducationDropDown() async {
    try {
      final response = await apiClient.get(ApiEndpoints.getEducationDropDown);
      if (response.statusCode == 200) {
        return EducationResponseModel.fromJson(response.data);
      } else {
        throw ServerException('Failed to fetch education dropdown');
      }
    } catch (e) {
      throw ServerException('Failed to fetch education dropdown: ${e.toString()}');
    }
  }

  @override
  Future<VillageResponseModel> getVillages(int branchId) async {
    try {
      final response = await apiClient.get(
        ApiEndpoints.getVillageDropDown,
        queryParameters: {'BranchID': branchId},
      );
      if (response.statusCode == 200) {
        return VillageResponseModel.fromJson(response.data);
      } else {
        throw ServerException('Failed to fetch villages');
      }
    } catch (e) {
      throw ServerException('Failed to fetch villages: ${e.toString()}');
    }
  }

  @override
  Future<RelationResponseModel> getAppRelations() async {
    try {
      final response = await apiClient.get(ApiEndpoints.getAppRelationDropDown);
      if (response.statusCode == 200) {
        return RelationResponseModel.fromJson(response.data);
      } else {
        throw ServerException('Failed to fetch relations');
      }
    } catch (e) {
      throw ServerException('Failed to fetch relations: ${e.toString()}');
    }
  }

  @override
  Future<bool> createClient(ClientCreateRequest request) async {
    try {
      final response = await apiClient.post(
        ApiEndpoints.createClientInfo,
        data: request.toJson(),
      );
      if (response.statusCode == 200) {
        return true;
      } else {
        throw ServerException('Failed to create client info');
      }
    } catch (e) {
      throw ServerException('Failed to create client info: ${e.toString()}');
    }
  }
}
