import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';

abstract class AuthRepository {
  Future<Either<Failure, bool>> login(String username, String password);
  Future<Either<Failure, bool>> saveUsername(String username);
  Future<Either<Failure, String?>> getSavedUsername();
  Future<Either<Failure, bool>> isLoggedIn();
  Future<Either<Failure, void>> logout();
}
