import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/models/client_dropdown_models.dart';
import '../../data/models/client_create_model.dart';
import '../../domain/repositories/client_repository.dart';

// States
abstract class ClientInfoState extends Equatable {
  const ClientInfoState();

  @override
  List<Object?> get props => [];
}

class ClientInfoInitial extends ClientInfoState {}

class ClientInfoDropdownsLoading extends ClientInfoState {}

class ClientInfoDropdownsLoaded extends ClientInfoState {
  final List<EducationModel> educationLevels;
  final List<VillageModel> villages;
  final List<RelationModel> relations;

  const ClientInfoDropdownsLoaded({
    required this.educationLevels,
    required this.villages,
    required this.relations,
  });

  @override
  List<Object?> get props => [educationLevels, villages, relations];
}

class ClientInfoSubmitting extends ClientInfoState {}

class ClientInfoSubmitSuccess extends ClientInfoState {
  final String message;
  const ClientInfoSubmitSuccess(this.message);

  @override
  List<Object?> get props => [message];
}

class ClientInfoError extends ClientInfoState {
  final String message;
  const ClientInfoError(this.message);

  @override
  List<Object?> get props => [message];
}

// Cubit
class ClientInfoCubit extends Cubit<ClientInfoState> {
  final ClientRepository _clientRepository;

  ClientInfoCubit({required ClientRepository clientRepository})
      : _clientRepository = clientRepository,
        super(ClientInfoInitial());

  List<EducationModel> _educationLevels = [];
  List<VillageModel> _villages = [];
  List<RelationModel> _relations = [];

  Future<void> loadDropdownData(int branchId) async {
    emit(ClientInfoDropdownsLoading());

    try {
      final educationResult = await _clientRepository.getEducationDropDown();
      final villageResult = await _clientRepository.getVillages(branchId);
      final relationResult = await _clientRepository.getAppRelations();

      educationResult.fold(
        (failure) => emit(ClientInfoError(failure.message)),
        (educationResponse) {
          _educationLevels = educationResponse.data;
          villageResult.fold(
            (failure) => emit(ClientInfoError(failure.message)),
            (villageResponse) {
              _villages = villageResponse.data;
              relationResult.fold(
                (failure) => emit(ClientInfoError(failure.message)),
                (relationResponse) {
                  _relations = relationResponse.data;
                  emit(ClientInfoDropdownsLoaded(
                    educationLevels: _educationLevels,
                    villages: _villages,
                    relations: _relations,
                  ));
                },
              );
            },
          );
        },
      );
    } catch (e) {
      emit(ClientInfoError('An unexpected error occurred: ${e.toString()}'));
    }
  }

  Future<void> submitClientInfo(ClientCreateRequest request) async {
    emit(ClientInfoSubmitting());

    final result = await _clientRepository.createClient(request);

    result.fold(
      (failure) => emit(ClientInfoError(failure.message)),
      (success) {
        if (success) {
          emit(const ClientInfoSubmitSuccess('Client Information saved successfully'));
        } else {
          emit(const ClientInfoError('Failed to save client information'));
        }
      },
    );
  }
  
  // Method to re-emit the loaded state if needed (e.g. after an error during submission)
  void restoreDropdowns() {
    if (_educationLevels.isNotEmpty && _villages.isNotEmpty && _relations.isNotEmpty) {
      emit(ClientInfoDropdownsLoaded(
        educationLevels: _educationLevels,
        villages: _villages,
        relations: _relations,
      ));
    }
  }
}
