import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';

import '../../../../core/entities/pagination.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/account.dart';
import '../../domain/repositories/account_repository.dart';
import '../datasources/account_local_data_source.dart';
import '../datasources/account_remote_data_source.dart';

class AccountRepositoryImpl implements AccountRepository {
  final AccountRemoteDataSource remoteDataSource;
  final AccountLocalDataSource localDataSource;

  AccountRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });
  
  @override
  Future<Either<Failure, Map<String, dynamic>>> getAccounts({int page = 1, int limit = 10}) async {
    try {
      // Always try remote first
      final result = await remoteDataSource.getAccounts(page: page, limit: limit);
      final accounts = result['accounts'] as List<Account>;
      final pagination = result['pagination'] as Pagination;
      
      // Save to local cache (only for first page or when refreshing)
      if (page == 1) {
        await localDataSource.saveAccounts(accounts);
      }
      
      return Right({
        'accounts': accounts,
        'pagination': pagination,
      });
    } on DioException catch (e) {
      // On network error, try local cache (only for first page)
      if (page == 1) {
        final cachedAccounts = await localDataSource.getAccounts();
        if (cachedAccounts.isNotEmpty) {
          return Right({
            'accounts': cachedAccounts,
            'pagination': Pagination(
              limit: limit,
              page: 1,
              total: cachedAccounts.length,
              totalPages: 1,
            ),
          });
        }
      }
      return Left(ServerFailure(message: e.message ?? 'An unexpected error occurred'));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }
  
  @override
  Future<Either<Failure, Account>> getAccountById(String id) async {
    try {
      // Always try remote first
      final remoteAccount = await remoteDataSource.getAccountById(id);
      await localDataSource.saveAccount(remoteAccount);
      return Right(remoteAccount);
    } on DioException catch (e) {
      // On network error, try local cache
      final cachedAccount = await localDataSource.getAccountById(id);
      if (cachedAccount != null) {
        return Right(cachedAccount);
      }
      return Left(ServerFailure(message: e.message ?? 'An unexpected error occurred'));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }
  
  @override
  Future<Either<Failure, Account>> createAccount(Account account) async {
    try {
      final createdAccount = await remoteDataSource.createAccount(account);
      await localDataSource.saveAccount(createdAccount);
      return Right(createdAccount);
    } on DioException catch (e) {
      return Left(ServerFailure(message: e.message ?? 'An unexpected error occurred'));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }
  
  @override
  Future<Either<Failure, Account>> updateAccount(Account account) async {
    try {
      final updatedAccount = await remoteDataSource.updateAccount(account);
      await localDataSource.saveAccount(updatedAccount);
      return Right(updatedAccount);
    } on DioException catch (e) {
      return Left(ServerFailure(message: e.message ?? 'An unexpected error occurred'));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }
  
  @override
  Future<Either<Failure, void>> deleteAccount(String id) async {
    try {
      await remoteDataSource.deleteAccount(id);
      await localDataSource.deleteAccount(id);
      return const Right(null);
    } on DioException catch (e) {
      return Left(ServerFailure(message: e.message ?? 'An unexpected error occurred'));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }
}