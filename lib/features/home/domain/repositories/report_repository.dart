import 'package:dartz/dartz.dart';
import 'dart:typed_data';
import '../../../../core/error/failures.dart';

abstract class ReportRepository {
  Future<Either<Failure, Uint8List>> getClientLedgerReport({
    required int memberId,
    required int branchId,
  });

  Future<Either<Failure, Uint8List>> getSummaryReport({
    required int branchId,
    required int userId,
  });

  Future<Either<Failure, Uint8List>> getLdfReport({
    required int disbursId,
    required int branchId,
  });
}
