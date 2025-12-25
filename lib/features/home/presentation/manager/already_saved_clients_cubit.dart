import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/models/already_saved_client_model.dart';
import '../../domain/repositories/client_repository.dart';

// States
abstract class AlreadySavedClientsState extends Equatable {
  const AlreadySavedClientsState();

  @override
  List<Object?> get props => [];
}

class AlreadySavedClientsInitial extends AlreadySavedClientsState {}

class AlreadySavedClientsLoading extends AlreadySavedClientsState {}

class AlreadySavedClientsLoaded extends AlreadySavedClientsState {
  final List<AlreadySavedClientModel> clients;
  const AlreadySavedClientsLoaded(this.clients);

  @override
  List<Object?> get props => [clients];
}

class AlreadySavedClientsError extends AlreadySavedClientsState {
  final String message;
  const AlreadySavedClientsError(this.message);

  @override
  List<Object?> get props => [message];
}

// Cubit
class AlreadySavedClientsCubit extends Cubit<AlreadySavedClientsState> {
  final ClientRepository _clientRepository;

  AlreadySavedClientsCubit({required ClientRepository clientRepository})
      : _clientRepository = clientRepository,
        super(AlreadySavedClientsInitial());

  Future<void> fetchAlreadySavedClients({
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
    emit(AlreadySavedClientsLoading());

    final result = await _clientRepository.getAlreadySavedClients(
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

    result.fold(
      (failure) => emit(AlreadySavedClientsError(failure.message)),
      (response) => emit(AlreadySavedClientsLoaded(response.data)),
    );
  }
}
