import 'package:dartz/dartz.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/example_entity.dart';
import '../../domain/repositories/example_repository.dart';
import '../datasources/example_local_data_source.dart';
import '../datasources/example_remote_data_source.dart';

class ExampleRepositoryImpl implements ExampleRepository {
  final ExampleRemoteDataSource remoteDataSource;
  final ExampleLocalDataSource localDataSource;

  ExampleRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  @override
  Future<Either<Failure, List<ExampleEntity>>> getExamples() async {
    try {
      final remoteExamples = await remoteDataSource.getExamples();
      await localDataSource.cacheExamples(remoteExamples);
      return Right(remoteExamples);
    } on ServerException catch (e) {
      try {
        final cachedExamples = await localDataSource.getCachedExamples();
        return Right(cachedExamples);
      } on CacheException {
        return Left(ServerFailure(e.message));
      }
    }
  }

  @override
  Future<Either<Failure, ExampleEntity>> getExampleById(int id) async {
    try {
      final example = await remoteDataSource.getExampleById(id);
      return Right(example);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    }
  }
}
