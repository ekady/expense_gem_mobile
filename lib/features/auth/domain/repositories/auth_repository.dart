import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../entities/user.dart';

abstract class AuthRepository {
  Future<Either<Failure, User>> login(String email, String password);
  Future<Either<Failure, User>> register(
    String firstName,
    String lastName,
    String email,
    String password,
    String confirmPassword,
  );
  Future<Either<Failure, bool>> forgotPassword(String email);
  Future<Either<Failure, String>> validateOtp(String email, String otp);
  Future<Either<Failure, bool>> resetPassword(
    String email,
    String token,
    String password,
  );
  Future<Either<Failure, User>> getCurrentUser();
  Future<Either<Failure, User>> updateUserProfile({
    required String firstName,
    required String lastName,
    String? picturePath,
  });
  Future<Either<Failure, bool>> updatePassword({
    required String currentPassword,
    required String password,
    required String passwordConfirm,
  });
  Future<Either<Failure, void>> logout();
  Future<Either<Failure, void>> refreshToken();
  Future<bool> isLoggedIn();
}
