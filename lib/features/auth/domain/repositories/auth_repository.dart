import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../data/models/login_response_model.dart';
import '../../data/models/profile_response_model.dart';

abstract class AuthRepository {
  Future<Either<Failure, bool>> login(String username, String password);
  Future<Either<Failure, bool>> saveUsername(String username);
  Future<Either<Failure, String?>> getSavedUsername();
  Future<Either<Failure, bool>> isLoggedIn();
  Future<Either<Failure, void>> logout();

  // New methods to retrieve saved user data
  Future<Either<Failure, String?>> getToken();
  Future<Either<Failure, UserDescriptionModel?>> getUserDescription();
  Future<Either<Failure, LoginResponseModel?>> getLoginResponse();

  // Profile methods
  Future<Either<Failure, ProfileResponseModel>> getProfile(int userId);
  Future<Either<Failure, ProfileDataModel?>> getSavedProfile();
}
