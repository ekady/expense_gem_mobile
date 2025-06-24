import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../entities/user.dart';
import '../repositories/auth_repository.dart';

class RegisterUseCase {
  final AuthRepository repository;

  RegisterUseCase(this.repository);

  Future<Either<Failure, User>> call(
    String firstName,
    String lastName,
    String email,
    String password,
    String confirmPassword,
  ) {
    return repository.register(
      firstName,
      lastName,
      email,
      password,
      confirmPassword,
    );
  }
}
