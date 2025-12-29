import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../data/models/client_search_model.dart';
import '../../data/models/nearby_client_model.dart';
import '../../data/models/already_saved_client_model.dart';
import '../../data/models/loan_tracking_model.dart';
import '../../data/models/client_dropdown_models.dart';
import '../../data/models/client_create_model.dart';

abstract class ClientRepository {
  Future<Either<Failure, ClientSearchResponseModel>> searchClient(String cnic, int branchId);
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
  });

  Future<Either<Failure, AlreadySavedClientsResponseModel>> getAlreadySavedClients({
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
  });
  Future<Either<Failure, EducationResponseModel>> getEducationDropDown();
  Future<Either<Failure, VillageResponseModel>> getVillages(int branchId);
  Future<Either<Failure, RelationResponseModel>> getAppRelations();
  Future<Either<Failure, bool>> createClient(ClientCreateRequest request);
}
