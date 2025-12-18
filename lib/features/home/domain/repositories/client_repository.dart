import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../data/models/client_search_model.dart';
import '../../data/models/nearby_client_model.dart';

abstract class ClientRepository {
  Future<Either<Failure, ClientSearchResponseModel>> searchClient(String cnic, int branchId);
  Future<Either<Failure, NearbyClientsResponseModel>> getNearbyClients({
    required int userId,
    required int branchId,
    required double latitude,
    required double longitude,
    required int page,
    required int rows,
  });
}
