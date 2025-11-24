import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../repositories/auth_repository.dart';

class SaveUsernameUseCase {
  final AuthRepository repository;

  SaveUsernameUseCase(this.repository);

  Future<Either<Failure, bool>> call(String username) async {
    return await repository.saveUsername(username);
  }
}
