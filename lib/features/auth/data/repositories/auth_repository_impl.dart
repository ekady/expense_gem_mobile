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
      await localDataSource.saveUser(result['user']);
      
      return Right(result['user']);
    } on DioException catch (e) {
      return Left(ServerFailure(message: e.message ?? 'An unexpected error occurred'));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }
  
  @override
  Future<Either<Failure, User>> register(String name, String email, String password) async {
    try {
      final result = await remoteDataSource.register(name, email, password);
      
      await localDataSource.saveToken(result['token']);
      await localDataSource.saveUser(result['user']);
      
      return Right(result['user']);
    } on DioException catch (e) {
      return Left(ServerFailure(message: e.message ?? 'An unexpected error occurred'));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }
  
  @override
  Future<Either<Failure, void>> forgotPassword(String email) async {
    try {
      await remoteDataSource.forgotPassword(email);
      return const Right(null);
    } on DioException catch (e) {
      return Left(ServerFailure(message: e.message ?? 'An unexpected error occurred'));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }
  
  @override
  Future<Either<Failure, void>> resetPassword(String token, String password) async {
    try {
      await remoteDataSource.resetPassword(token, password);
      return const Right(null);
    } on DioException catch (e) {
      return Left(ServerFailure(message: e.message ?? 'An unexpected error occurred'));
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
      await localDataSource.deleteToken();
      await localDataSource.deleteUser();
      return const Right(null);
    } catch (e) {
      return Left(CacheFailure(message: e.toString()));
    }
  }
  
  @override
  Future<bool> isLoggedIn() async {
    final token = await localDataSource.getToken();
    return token != null;
  }
}