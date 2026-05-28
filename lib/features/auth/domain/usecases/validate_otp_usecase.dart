import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../repositories/auth_repository.dart';

class ValidateOtpUseCase {
  final AuthRepository repository;

  ValidateOtpUseCase(this.repository);

  Future<Either<Failure, String>> call(String email, String otp) {
    return repository.validateOtp(email, otp);
  }
}
