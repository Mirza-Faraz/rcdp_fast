import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../repositories/auth_repository.dart';

class GetSavedUsernameUseCase {
  final AuthRepository repository;

  GetSavedUsernameUseCase(this.repository);

  Future<Either<Failure, String?>> call() async {
    return await repository.getSavedUsername();
  }
}
