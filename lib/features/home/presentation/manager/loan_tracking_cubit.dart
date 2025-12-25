import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../data/models/loan_tracking_model.dart';
import '../../domain/repositories/client_repository.dart';

abstract class LoanTrackingState extends Equatable {
  const LoanTrackingState();

  @override
  List<Object?> get props => [];
}

class LoanTrackingInitial extends LoanTrackingState {}

class LoanTrackingLoading extends LoanTrackingState {}

class LoanTrackingLoaded extends LoanTrackingState {
  final List<LoanTrackingModel> loans;
  const LoanTrackingLoaded({required this.loans});

  @override
  List<Object?> get props => [loans];
}

class LoanTrackingError extends LoanTrackingState {
  final String message;
  const LoanTrackingError({required this.message});

  @override
  List<Object?> get props => [message];
}

class LoanTrackingCubit extends Cubit<LoanTrackingState> {
  final ClientRepository clientRepository;

  LoanTrackingCubit({required this.clientRepository}) : super(LoanTrackingInitial());

  Future<void> fetchLoanTrackingList({
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
    emit(LoanTrackingLoading());

    final result = await clientRepository.getLoanTrackingList(
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

    result.fold(
      (failure) => emit(LoanTrackingError(message: failure.message)),
      (response) => emit(LoanTrackingLoaded(loans: response.data)),
    );
  }
}
