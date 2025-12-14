import 'package:dartz/dartz.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/network/network_info.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_local_data_source.dart';
import '../datasources/auth_remote_data_source.dart';
import '../models/login_request_model.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;
  final AuthLocalDataSource localDataSource;
  final NetworkInfo networkInfo;

  AuthRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, bool>> login(String username, String password) async {
    // Check network connectivity first
    if (await networkInfo.isConnected) {
      try {
        // Call API for login
        final request = LoginRequestModel(username: username, password: password);
        final response = await remoteDataSource.login(request);
        
        if (response.success) {
          // Save username and login status locally
          await localDataSource.saveUsername(username);
          await localDataSource.saveLoginStatus(true);
          
          // Save token if available (you might want to add this to local data source)
          // await localDataSource.saveToken(response.token);
          
          return const Right(true);
        } else {
          return Left(ServerFailure(response.message));
        }
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      } on NetworkException catch (e) {
        return Left(NetworkFailure(e.message));
      } catch (e) {
        return Left(ServerFailure('An unexpected error occurred: ${e.toString()}'));
      }
    } else {
      // No internet connection - you can either:
      // 1. Return error (current implementation)
      return const Left(NetworkFailure('No internet connection'));
      
      // 2. Or check if user was previously logged in and allow offline login
      // final isLoggedIn = await localDataSource.getLoginStatus();
      // if (isLoggedIn) {
      //   return const Right(true);
      // } else {
      //   return const Left(NetworkFailure('No internet connection'));
      // }
    }
  }

  @override
  Future<Either<Failure, bool>> saveUsername(String username) async {
    try {
      final result = await localDataSource.saveUsername(username);
      return Right(result);
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, String?>> getSavedUsername() async {
    try {
      final username = await localDataSource.getSavedUsername();
      return Right(username);
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, bool>> isLoggedIn() async {
    try {
      final isLoggedIn = await localDataSource.getLoginStatus();
      return Right(isLoggedIn);
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, void>> logout() async {
    try {
      await localDataSource.clearAuthData();
      return const Right(null);
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    }


  }


}
