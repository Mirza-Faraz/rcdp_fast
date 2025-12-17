import 'package:dartz/dartz.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/network/network_info.dart';
import '../../domain/repositories/client_repository.dart';
import '../datasources/client_remote_data_source.dart';
import '../models/client_search_model.dart';

class ClientRepositoryImpl implements ClientRepository {
  final ClientRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;

  ClientRepositoryImpl({
    required this.remoteDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, ClientSearchResponseModel>> searchClient(String cnic, int branchId) async {
    if (await networkInfo.isConnected) {
      try {
        final response = await remoteDataSource.searchClient(cnic, branchId);
        return Right(response);
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
