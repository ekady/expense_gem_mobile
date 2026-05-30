import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../repositories/auth_repository.dart';

class UpdatePasswordUseCase {
  final AuthRepository repository;

  UpdatePasswordUseCase(this.repository);

  Future<Either<Failure, bool>> call({
    required String currentPassword,
    required String password,
    required String passwordConfirm,
  }) {
    return repository.updatePassword(
      currentPassword: currentPassword,
      password: password,
      passwordConfirm: passwordConfirm,
    );
  }
}
