import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../data/models/client_search_model.dart';

abstract class ClientRepository {
  Future<Either<Failure, ClientSearchResponseModel>> searchClient(String cnic, int branchId);
}
