import 'package:flutter/foundation.dart';
import '../../../../core/constants/api_endpoints.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/network/api_client.dart';
import 'package:dio/dio.dart';
import 'dart:typed_data';

abstract class ReportRemoteDataSource {
  Future<Uint8List> getClientLedgerReport({
    required int memberId,
    required int branchId,
  });

  Future<Uint8List> getSummaryReport({
    required int branchId,
    required int userId,
  });

  Future<Uint8List> getLdfReport({
    required int disbursId,
    required int branchId,
  });
}

class ReportRemoteDataSourceImpl implements ReportRemoteDataSource {
  final ApiClient apiClient;

  ReportRemoteDataSourceImpl({required this.apiClient});

  @override
  Future<Uint8List> getClientLedgerReport({
    required int memberId,
    required int branchId,
  }) async {
    debugPrint('ReportRemoteDataSource: getClientLedgerReport called for $memberId, $branchId');
    try {
      final response = await apiClient.get(
        ApiEndpoints.clientLedgerReport,
        queryParameters: {
          'Member_Id': memberId,
          'Branch_ID': branchId,
        },
        options: Options(
          responseType: ResponseType.bytes,
        ),
      );

      if (response.statusCode == 200) {
        if (response.data is Uint8List) {
          return response.data;
        } else if (response.data is List<int>) {
          return Uint8List.fromList(response.data);
        } else {
          throw ServerException('Invalid response format for PDF');
        }
      } else {
        throw ServerException('Failed to fetch report');
      }
    } catch (e) {
      if (e is ServerException || e is NetworkException) {
        rethrow;
      }
      throw ServerException('An error occurred while fetching report: ${e.toString()}');
    }
  }

  @override
  Future<Uint8List> getSummaryReport({
    required int branchId,
    required int userId,
  }) async {
    debugPrint('ReportRemoteDataSource: getSummaryReport called for $branchId, $userId');
    try {
      final response = await apiClient.get(
        ApiEndpoints.summaryReport,
        queryParameters: {
          'Branch_ID': branchId,
          'UserId': userId,
        },
        options: Options(
          responseType: ResponseType.bytes,
        ),
      );

      if (response.statusCode == 200) {
        if (response.data is Uint8List) {
          return response.data;
        } else if (response.data is List<int>) {
          return Uint8List.fromList(response.data);
        } else {
          throw ServerException('Invalid response format for PDF');
        }
      } else {
        throw ServerException('Failed to fetch summary report');
      }
    } catch (e) {
      if (e is ServerException || e is NetworkException) {
        rethrow;
      }
      throw ServerException('An error occurred while fetching summary report: ${e.toString()}');
    }
  }
  @override
  Future<Uint8List> getLdfReport({
    required int disbursId,
    required int branchId,
  }) async {
    debugPrint('ReportRemoteDataSource: getLdfReport called for $disbursId, $branchId');
    try {
      final response = await apiClient.get(
        ApiEndpoints.ldfReport,
        queryParameters: {
          'DisbursID': disbursId,
          'Branch_ID': branchId,
        },
        options: Options(
          responseType: ResponseType.bytes,
        ),
      );

      if (response.statusCode == 200) {
        if (response.data is Uint8List) {
          return response.data;
        } else if (response.data is List<int>) {
          return Uint8List.fromList(response.data);
        } else {
          throw ServerException('Invalid response format for PDF');
        }
      } else {
        throw ServerException('Failed to fetch LDF report');
      }
    } catch (e) {
      if (e is ServerException || e is NetworkException) {
        rethrow;
      }
      throw ServerException('An error occurred while fetching LDF report: ${e.toString()}');
    }
  }
}
