import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';

import '../../../../core/error/failures.dart';
import '../../domain/entities/user.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_local_data_source.dart';
import '../datasources/auth_remote_data_source.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;
  final AuthLocalDataSource localDataSource;

  AuthRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  @override
  Future<Either<Failure, User>> login(String email, String password) async {
    try {
      final result = await remoteDataSource.login(email, password);

      await localDataSource.saveToken(result['token']);
      await localDataSource.saveRefreshToken(result['refreshToken']);
      await localDataSource.saveUser(result['user']);

      return Right(result['user']);
    } on DioException catch (e) {
      return Left(
        ServerFailure(message: e.message ?? 'An unexpected error occurred'),
      );
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, User>> register(
    String firstName,
    String lastName,
    String email,
    String password,
    String confirmPassword,
  ) async {
    try {
      final result = await remoteDataSource.register(
        firstName,
        lastName,
        email,
        password,
        confirmPassword,
      );

      return Right(result['user']);
    } on DioException catch (e) {
      return Left(
        ServerFailure(message: e.message ?? 'An unexpected error occurred'),
      );
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> forgotPassword(String email) async {
    try {
      await remoteDataSource.forgotPassword(email);
      return const Right(true);
    } on DioException catch (e) {
      return Left(
        ServerFailure(message: e.message ?? 'An unexpected error occurred'),
      );
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, String>> validateOtp(String email, String otp) async {
    try {
      final token = await remoteDataSource.validateOtp(email, otp);
      return Right(token);
    } on DioException catch (e) {
      return Left(
        ServerFailure(message: e.message ?? 'An unexpected error occurred'),
      );
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> resetPassword(
    String email,
    String token,
    String password,
  ) async {
    try {
      await remoteDataSource.resetPassword(email, token, password);
      return const Right(true);
    } on DioException catch (e) {
      return Left(
        ServerFailure(message: e.message ?? 'An unexpected error occurred'),
      );
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, User>> getCurrentUser() async {
    try {
      final user = await localDataSource.getUser();

      if (user != null) {
        return Right(user);
      } else {
        final token = await localDataSource.getToken();

        if (token != null) {
          final user = await remoteDataSource.getUserProfile();
          await localDataSource.saveUser(user);
          return Right(user);
        }

        return Left(AuthFailure(message: 'User not authenticated'));
      }
    } catch (e) {
      return Left(CacheFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> logout() async {
    try {
      final refreshToken = await localDataSource.getRefreshToken();
      if (refreshToken != null) {
        await remoteDataSource.logout();
      }
      await localDataSource.deleteToken();
      await localDataSource.deleteRefreshToken();
      await localDataSource.deleteUser();
      return const Right(null);
    } catch (e) {
      return Left(CacheFailure(message: e.toString()));
    }
  }

  @override
  Future<bool> isLoggedIn() async {
    final token = await localDataSource.getToken();
    if (token == null) return false;
    try {
      // Try to fetch the user from backend to validate token
      await getCurrentUser();
      return true;
    } catch (_) {
      return false;
    }
  }

  @override
  Future<Either<Failure, void>> refreshToken() async {
    try {
      final refreshToken = await localDataSource.getRefreshToken();
      if (refreshToken == null) {
        return Left(AuthFailure(message: 'No refresh token found'));
      }
      final result = await remoteDataSource.refreshToken(refreshToken);
      await localDataSource.saveToken(result['token']);
      await localDataSource.saveRefreshToken(result['refreshToken']);
      return const Right(null);
    } on DioException catch (e) {
      return Left(
        ServerFailure(message: e.message ?? 'An unexpected error occurred'),
      );
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }
}

class AuthInterceptor extends Interceptor {
  final Dio dio;
  final AuthLocalDataSource localDataSource;
  final AuthRemoteDataSource remoteDataSource;

  AuthInterceptor(this.dio, this.localDataSource, this.remoteDataSource);

  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final token = await localDataSource.getToken();
    if (token != null) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    try {
      final refreshToken = await localDataSource.getRefreshToken();

      if (err.response?.statusCode == 401 && refreshToken != null) {
        await localDataSource.deleteToken();
      
        final result = await remoteDataSource.refreshToken(refreshToken);
        await localDataSource.saveToken(result['token']);
        await localDataSource.saveRefreshToken(result['refreshToken']);
        // Retry original request
        final opts = err.requestOptions;
        final cloneReq = await dio.fetch(opts);
        return handler.resolve(cloneReq);
      }
    } catch (e) {
      // When refresh fails, delete both tokens to force re-login
      await localDataSource.deleteToken();
      await localDataSource.deleteRefreshToken();
      await localDataSource.deleteUser();
    }
    handler.next(err);
  }
}
