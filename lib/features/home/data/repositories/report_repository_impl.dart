import 'dart:typed_data';
import 'package:dartz/dartz.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/network/network_info.dart';
import '../../domain/repositories/report_repository.dart';
import '../datasources/report_remote_data_source.dart';

class ReportRepositoryImpl implements ReportRepository {
  final ReportRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;

  ReportRepositoryImpl({
    required this.remoteDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, Uint8List>> getClientLedgerReport({
    required int memberId,
    required int branchId,
  }) async {
    if (await networkInfo.isConnected) {
      try {
        final pdfBytes = await remoteDataSource.getClientLedgerReport(
          memberId: memberId,
          branchId: branchId,
        );
        return Right(pdfBytes);
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
  Future<Either<Failure, Uint8List>> getSummaryReport({
    required int branchId,
    required int userId,
  }) async {
    if (await networkInfo.isConnected) {
      try {
        final pdfBytes = await remoteDataSource.getSummaryReport(
          branchId: branchId,
          userId: userId,
        );
        return Right(pdfBytes);
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
  Future<Either<Failure, Uint8List>> getLdfReport({
    required int disbursId,
    required int branchId,
  }) async {
    if (await networkInfo.isConnected) {
      try {
        final pdfBytes = await remoteDataSource.getLdfReport(
          disbursId: disbursId,
          branchId: branchId,
        );
        return Right(pdfBytes);
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
}
