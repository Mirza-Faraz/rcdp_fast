import 'package:dartz/dartz.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/network/network_info.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_local_data_source.dart';
import '../datasources/auth_remote_data_source.dart';
import '../models/login_request_model.dart';
import '../models/login_response_model.dart';
import '../models/profile_response_model.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;
  final AuthLocalDataSource localDataSource;
  final NetworkInfo networkInfo;

  AuthRepositoryImpl({required this.remoteDataSource, required this.localDataSource, required this.networkInfo});

  @override
  Future<Either<Failure, bool>> login(String username, String password) async {
    // Check network connectivity first
    if (await networkInfo.isConnected) {
      try {
        // Call API for login
        final request = LoginRequestModel(username: username, password: password);
        final response = await remoteDataSource.login(request);

        // Guard: token and user id must be present
        final hasToken = response.token.isNotEmpty;
        final hasUserId = response.userDescription.userId != 0;

        if (response.success && hasToken && hasUserId) {
          // Save all login response data locally
          await localDataSource.saveUsername(response.userDescription.userName);
          await localDataSource.saveLoginStatus(true);
          await localDataSource.saveToken(response.token);
          await localDataSource.saveUserDescription(response.userDescription);

          // Save complete login response for easy retrieval
          // Save complete login response for easy retrieval
          await localDataSource.saveLoginResponse(response);

          // Fetch and save User Rights
          try {
            // Get group ID from user description (assuming mapping is correct)
            // UserDescriptionModel has 'groupId'.
            final groupId = response.userDescription.groupId;
            if (groupId != 0) {
              final userRightsResponse = await remoteDataSource.getUserRights(groupId);
              if (userRightsResponse.status == 'True' && userRightsResponse.data != null) {
                await localDataSource.saveUserRights(userRightsResponse.data!);
              }
            }
          } catch (e) {
            // Log error but don't fail login?
            // User asked to handle exceptions. 
            // If rights fetch fails, we proceed but maybe log it.
            // For now, I'll catch and ignore/print, as failing login might be too harsh 
            // if the main login succeeded. But if rights are critical, maybe we should warn.
            // Given the requirement "make sure that it will work properly", 
            // I'll proceed with login even if rights fail, but rights will be null.
            print('Failed to fetch user rights: $e');
          }

          // Fetch and save Branch Info
          try {
            // Get User ID from user description
            final userId = response.userDescription.userId;
            if (userId != 0) {
              final branchResponse = await remoteDataSource.getBranches(userId);
              if (branchResponse.status == 'True') {
                await localDataSource.saveBranches(branchResponse.data);

                  if (branchResponse.data.isNotEmpty) {
                    try {
                      // Using the first branch ID as per requirement "branch = 43" 
                      // assuming simple single-branch active context or first availability
                      final branchId = branchResponse.data.first.branchId;
                      if (branchId != 0) {
                        // Fetch Center Number
                        try {
                          final centerNumber = await remoteDataSource.getCenterNumber(branchId);
                          if (centerNumber.isNotEmpty) {
                            await localDataSource.saveCenterNumber(centerNumber);
                          }
                        } catch (e) {
                          print('Failed to fetch center number: $e');
                        }

                        // Fetch Products
                        try {
                          final productResponse = await remoteDataSource.getProducts(branchId);
                          if (productResponse.status == 'True') {
                            await localDataSource.saveProducts(productResponse.data);
                          }
                        } catch (e) {
                          print('Failed to fetch products: $e');
                        }
                      }
                    } catch (e) {
                      print('Failed to process branch dependent data: $e');
                    }
                  }
              }
            }
          } catch (e) {
            // Log error but don't fail login
            print('Failed to fetch branch info: $e');
          }

          return const Right(true);
        } else if (response.success && (!hasToken || !hasUserId)) {
          return const Left(ServerFailure('Invalid login response'));
        } else {
          return const Left(ServerFailure('Login failed'));
        }
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      } on NetworkException catch (e) {
        return Left(NetworkFailure(e.message));
      } catch (e) {
        return Left(ServerFailure('An unexpected error occurred: ${e.toString()}'));
      }
    } else {
      // No internet connection
      return const Left(NetworkFailure('No internet connection'));
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

  @override
  Future<Either<Failure, String?>> getToken() async {
    try {
      final token = await localDataSource.getToken();
      return Right(token);
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, UserDescriptionModel?>> getUserDescription() async {
    try {
      final userDescription = await localDataSource.getUserDescription();
      return Right(userDescription);
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, LoginResponseModel?>> getLoginResponse() async {
    try {
      final loginResponse = await localDataSource.getLoginResponse();
      return Right(loginResponse);
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, ProfileResponseModel>> getProfile(int userId) async {
    // Check network connectivity first
    if (await networkInfo.isConnected) {
      try {
        final token = await localDataSource.getToken();
        if (token == null || token.isEmpty) {
          return const Left(ServerFailure('Missing token. Please login again.'));
        }

        // Call API to get profile
        final response = await remoteDataSource.getProfile(userId, token: token);

        if (response.isSuccess && response.firstProfile != null) {
          // Save profile data locally
          await localDataSource.saveProfile(response.firstProfile!);
        }

        return Right(response);
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      } on NetworkException catch (e) {
        return Left(NetworkFailure(e.message));
      } catch (e) {
        return Left(ServerFailure('An unexpected error occurred: ${e.toString()}'));
      }
    } else {
      // Try to get cached profile if offline
      try {
        final cachedProfile = await localDataSource.getProfile();
        if (cachedProfile != null) {
          return Right(ProfileResponseModel(message: 'Cached data', data: [cachedProfile], status: 'True'));
        }
        return const Left(NetworkFailure('No internet connection and no cached data'));
      } catch (e) {
        return const Left(NetworkFailure('No internet connection'));
      }
    }
  }

  @override
  Future<Either<Failure, ProfileDataModel?>> getSavedProfile() async {
    try {
      final profile = await localDataSource.getProfile();
      return Right(profile);
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    }
  }
}
