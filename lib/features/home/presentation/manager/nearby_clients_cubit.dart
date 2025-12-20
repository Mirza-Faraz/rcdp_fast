import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import '../../../../core/error/failures.dart';
import '../../data/models/nearby_client_model.dart';
import '../../domain/repositories/client_repository.dart';

// States
abstract class NearbyClientsState extends Equatable {
  const NearbyClientsState();

  @override
  List<Object?> get props => [];
}

class NearbyClientsInitial extends NearbyClientsState {}

class NearbyClientsLoading extends NearbyClientsState {}

class NearbyClientsLoaded extends NearbyClientsState {
  final List<NearbyClientModel> clients;
  final bool hasReachedMax;

  const NearbyClientsLoaded({
    required this.clients,
    required this.hasReachedMax,
  });

  @override
  List<Object?> get props => [clients, hasReachedMax];
}

class NearbyClientsError extends NearbyClientsState {
  final String message;

  const NearbyClientsError(this.message);

  @override
  List<Object?> get props => [message];
}

class LocationPermissionRequired extends NearbyClientsState {}

class LocationServiceDisabled extends NearbyClientsState {}


// Cubit
class NearbyClientsCubit extends Cubit<NearbyClientsState> {
  final ClientRepository _clientRepository;
  int _page = 1;
  final int _rows = 20;
  bool _isFetching = false;
  List<NearbyClientModel> _allClients = [];
  
  // Keep track of parameters for pagination
  int? _userId;
  int? _branchId;
  double? _latitude;
  double? _longitude;
  
  // Optional filters
  String? _memberId;
  String? _cnic;
  String? _productId;
  String? _centerNo;
  String? _caseDate;
  String? _caseDateTo;

  NearbyClientsCubit({required ClientRepository clientRepository})
      : _clientRepository = clientRepository,
        super(NearbyClientsInitial());

  Future<void> fetchNearbyClients({
    required int userId,
    required int branchId,
    bool isRefresh = false,
    String? memberId,
    String? cnic,
    String? productId,
    String? centerNo,
    String? caseDate,
    String? caseDateTo,
  }) async {
    if (_isFetching) return;

    if (isRefresh) {
      _page = 1;
      _allClients.clear();
      _userId = userId;
      _branchId = branchId;
      _memberId = memberId;
      _cnic = cnic;
      _productId = productId;
      _centerNo = centerNo;
      _caseDate = caseDate;
      _caseDateTo = caseDateTo;
      emit(NearbyClientsLoading());
    } else {
        if (state is NearbyClientsLoaded && (state as NearbyClientsLoaded).hasReachedMax) return;
    }

    _isFetching = true;

    try {
      // 1. Check Location Permissions and Service
      bool serviceEnabled;
      LocationPermission permission;

      serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        _isFetching = false;
        emit(LocationServiceDisabled());
        return;
      }

      permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          _isFetching = false;
          emit(LocationPermissionRequired());
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        _isFetching = false;
        emit(LocationPermissionRequired()); // Or a specific state for denied forever
        return;
      }

      // 2. Get Current Position
      // If refresh, get new location. If pagination, maybe reuse? 
      // User request says "Get these locations from device". 
      // Usually pagination uses same location.
      if (isRefresh || _latitude == null || _longitude == null) {
          Position position = await Geolocator.getCurrentPosition();
          _latitude = position.latitude;
          _longitude = position.longitude;
      }

      // 3. Call Repository
      final result = await _clientRepository.getNearbyClients(
        userId: userId,
        branchId: branchId,
        latitude: _latitude!,
        longitude: _longitude!,
        page: _page,
        rows: _rows,
        memberId: _memberId,
        cnic: _cnic,
        productId: _productId,
        centerNo: _centerNo,
        caseDate: _caseDate,
        caseDateTo: _caseDateTo,
      );

      result.fold(
        (failure) {
          if (isRefresh) {
             emit(NearbyClientsError(_mapFailureToMessage(failure)));
          } else {
             // For pagination error, maybe show snackbar or keep existing state?
             // For simplicity, emit error if it makes sense, or handle gracefully.
             // If we emit error here, we lose the list content. 
             // Better to perhaps have a separate error stream or just stop paginating.
             // But existing patterns might differ. stick to simple emit error for now 
             // but if we have clients, we might want to keep showing them.
             // Let's just emit error, user can retry.
             emit(NearbyClientsError(_mapFailureToMessage(failure)));
          }
        },
        (response) {
          final newClients = response.data;
          _allClients.addAll(newClients);
          _page++;
          
          emit(NearbyClientsLoaded(
            clients: List.of(_allClients),
            hasReachedMax: newClients.length < _rows,
          ));
        },
      );
    } catch (e) {
      emit(NearbyClientsError(e.toString()));
    } finally {
      _isFetching = false;
    }
  }

  String _mapFailureToMessage(Failure failure) {
    if (failure is ServerFailure) {
      return failure.message;
    } else if (failure is NetworkFailure) {
      return failure.message;
    } else {
      return 'Unexpected error';
    }
  }
}
