import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/services/service_locator.dart';
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
  VoidCallback? _onForceLogout;
  final Logger _logger = getIt<Logger>();

  AuthInterceptor(
    this.dio, 
    this.localDataSource, 
    this.remoteDataSource, {
    VoidCallback? onForceLogout,
  }) : _onForceLogout = onForceLogout;

  void setOnForceLogoutCallback(VoidCallback callback) {
    _onForceLogout = callback;
  }

  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final token = await localDataSource.getToken();
    if (token != null) {
      options.headers['Authorization'] = options.headers['Authorization'] ?? 'Bearer $token';
      _logger.d('Added Authorization header to request: ${options.path}');
    }
    handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    _logger.d('Interceptor received error:  [31m${err.response?.statusCode} [0m for ${err.requestOptions.path}');
    
    // Prevent infinite loop: if this is a refresh token request, do not try to refresh again
    if (err.requestOptions.headers['is-refresh-token'] == true) {
      _logger.w('401 received on refresh token request. Forcing logout, not retrying.');
      await _forceLogout();
      return handler.next(err);
    }
    if (err.response?.statusCode == 401) {
      _logger.d('Received 401 error for request: ${err.requestOptions.path}');
      
      try {
        final refreshToken = await localDataSource.getRefreshToken();
        _logger.d('Refresh token found: ${refreshToken != null}');
        
        if (refreshToken == null) {
          _logger.w('No refresh token found, forcing logout');
          await _forceLogout();
          return handler.next(err);
        }

         final result = await remoteDataSource.refreshToken(refreshToken);
        _logger.d('Refresh result: ${result.keys}');

        if (result.isEmpty || result['token'] == null) {
          _logger.e('Invalid refresh response received');
          await _forceLogout();
          return handler.next(err);
        }

        await localDataSource.saveToken(result['token']);
        await localDataSource.saveRefreshToken(result['refreshToken']);
        _logger.d('Successfully refreshed tokens');

        // Retry original request with new token
        final opts = err.requestOptions;
        opts.headers['Authorization'] = 'Bearer ${result['token']}';
        final cloneReq = await dio.fetch(opts);
        
        _logger.d('Successfully retried request with new token');
        return handler.resolve(cloneReq);
        
      } catch (e) {
        _logger.e('Token refresh failed: $e');
        await _forceLogout();
        return handler.next(err);
      }
    } else {
      _logger.d('Not a 401 error, passing through: ${err.response?.statusCode}');
    }
    
    handler.next(err);
  }

  Future<void> _forceLogout() async {
    try {
      _logger.w('Performing forced logout...');
      // Clear all auth data
      await localDataSource.deleteToken();
      await localDataSource.deleteRefreshToken();
      await localDataSource.deleteUser();
      
      // Notify about forced logout
      _logger.d('Calling force logout callback...');
      _onForceLogout?.call();
      _logger.d('Forced logout completed');
    } catch (e) {
      // Log error but don't throw
      _logger.e('Error during force logout: $e');
    }
  }

  // Test method to manually trigger a 401 error
  Future<void> test401Error() async {
    _logger.d('Testing 401 error handling...');
    try {
      // Make a request that will likely return 401
      await dio.get('/user/me');
    } catch (e) {
      _logger.d('Test 401 error caught: $e');
    }
  }
}
