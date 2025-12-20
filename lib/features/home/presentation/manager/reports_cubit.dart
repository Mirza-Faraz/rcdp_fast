import 'package:flutter/foundation.dart';
import 'dart:typed_data';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/repositories/report_repository.dart';

// States
abstract class ReportsState extends Equatable {
  const ReportsState();

  @override
  List<Object?> get props => [];
}

class ReportsInitial extends ReportsState {}

class ReportsLoading extends ReportsState {}

class ReportsLoaded extends ReportsState {
  final Uint8List pdfBytes;
  const ReportsLoaded(this.pdfBytes);

  @override
  List<Object?> get props => [pdfBytes];
}

class ReportsError extends ReportsState {
  final String message;
  const ReportsError(this.message);

  @override
  List<Object?> get props => [message];
}

// Cubit
class ReportsCubit extends Cubit<ReportsState> {
  final ReportRepository _reportRepository;

  ReportsCubit({required ReportRepository reportRepository})
      : _reportRepository = reportRepository,
        super(ReportsInitial());

  Future<void> fetchClientLedgerReport({
    required int memberId,
    required int branchId,
  }) async {
    debugPrint('ReportsCubit: fetchClientLedgerReport called');
    emit(ReportsLoading());

    final result = await _reportRepository.getClientLedgerReport(
      memberId: memberId,
      branchId: branchId,
    );

    result.fold(
      (failure) => emit(ReportsError(failure.message)),
      (pdfBytes) => emit(ReportsLoaded(pdfBytes)),
    );
  }

  Future<void> fetchSummaryReport({
    required int branchId,
    required int userId,
  }) async {
    debugPrint('ReportsCubit: fetchSummaryReport called');
    emit(ReportsLoading());

    final result = await _reportRepository.getSummaryReport(
      branchId: branchId,
      userId: userId,
    );

    result.fold(
      (failure) => emit(ReportsError(failure.message)),
      (pdfBytes) => emit(ReportsLoaded(pdfBytes)),
    );
  }

  Future<void> fetchLdfReport({
    required int disbursId,
    required int branchId,
  }) async {
    debugPrint('ReportsCubit: fetchLdfReport called');
    emit(ReportsLoading());

    final result = await _reportRepository.getLdfReport(
      disbursId: disbursId,
      branchId: branchId,
    );

    result.fold(
      (failure) => emit(ReportsError(failure.message)),
      (pdfBytes) => emit(ReportsLoaded(pdfBytes)),
    );
  }

  void reset() {
    emit(ReportsInitial());
  }
}
