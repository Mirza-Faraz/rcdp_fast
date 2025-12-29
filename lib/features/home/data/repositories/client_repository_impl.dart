import 'package:dartz/dartz.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/network/network_info.dart';
import '../../domain/repositories/client_repository.dart';
import '../datasources/client_remote_data_source.dart';
import '../models/client_search_model.dart';
import '../models/nearby_client_model.dart';
import '../models/already_saved_client_model.dart';
import '../models/loan_tracking_model.dart';

class ClientRepositoryImpl implements ClientRepository {
  final ClientRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;

  ClientRepositoryImpl({
    required this.remoteDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, ClientSearchResponseModel>> searchClient(String cnic, int branchId) async {
    if (await networkInfo.isConnected) {
      try {
        final response = await remoteDataSource.searchClient(cnic, branchId);
        return Right(response);
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      } on NetworkException catch (e) {
        return Left(NetworkFailure(e.message));
      } catch (e) {
        return Left(ServerFailure('An unexpected error occurred: ${e.toString()}'));
      }
    } else {
      return const Left(NetworkFailure('No internet connection'));
    }
  }
  @override
  Future<Either<Failure, NearbyClientsResponseModel>> getNearbyClients({
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
    if (await networkInfo.isConnected) {
      try {
        final result = await remoteDataSource.getNearbyClients(
          userId: userId,
          branchId: branchId,
          latitude: latitude,
          longitude: longitude,
          page: page,
          rows: rows,
          memberId: memberId,
          cnic: cnic,
          productId: productId,
          centerNo: centerNo,
          caseDate: caseDate,
          caseDateTo: caseDateTo,
          distance: distance,
        );
        return Right(result);
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      } catch (e) {
        return Left(ServerFailure(e.toString()));
      }
    } else {
      return const Left(NetworkFailure('No internet connection'));
    }
  }

  @override
  Future<Either<Failure, AlreadySavedClientsResponseModel>>
      getAlreadySavedClients({
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
    if (await networkInfo.isConnected) {
      try {
        final result = await remoteDataSource.getAlreadySavedClients(
          userId: userId,
          branchId: branchId,
          page: page,
          rows: rows,
          sidx: sidx,
          sord: sord,
          memberId: memberId,
          cnic: cnic,
          productId: productId,
          centerNo: centerNo,
          caseDate: caseDate,
          caseDateTo: caseDateTo,
        );
        return Right(result);
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      } catch (e) {
        return Left(ServerFailure(e.toString()));
      }
    } else {
      return const Left(NetworkFailure('No internet connection'));
    }
  }

  @override
  Future<Either<Failure, LoanTrackingResponseModel>> getLoanTrackingList({
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
    if (await networkInfo.isConnected) {
      try {
        final result = await remoteDataSource.getLoanTrackingList(
          userId: userId,
          branchId: branchId,
          page: page,
          rows: rows,
          sidx: sidx,
          sord: sord,
          memberId: memberId,
          cnic: cnic,
          productId: productId,
          centerNo: centerNo,
          caseDate: caseDate,
          caseDateTo: caseDateTo,
          approvel: approvel,
        );
        return Right(result);
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      } catch (e) {
        return Left(ServerFailure(e.toString()));
      }
    } else {
      return const Left(NetworkFailure('No internet connection'));
    }
  }
}
