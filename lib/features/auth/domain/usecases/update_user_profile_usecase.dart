import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../entities/user.dart';
import '../repositories/auth_repository.dart';

class UpdateUserProfileUseCase {
  final AuthRepository repository;

  UpdateUserProfileUseCase(this.repository);

  Future<Either<Failure, User>> call({
    required String firstName,
    required String lastName,
    String? picturePath,
  }) {
    return repository.updateUserProfile(
      firstName: firstName,
      lastName: lastName,
      picturePath: picturePath,
    );
  }
}
