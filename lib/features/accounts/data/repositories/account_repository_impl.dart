import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../../domain/entities/account.dart';
import '../../domain/repositories/account_repository.dart';

class AccountRepositoryImpl implements AccountRepository {
  // This would typically have data sources injected
  
  @override
  Future<Either<Failure, List<Account>>> getAccounts() async {
    try {
      // Mocked data for now
      return Right([
        Account(
          id: '1',
          name: 'Bank Account',
          balance: 8450.50,
          type: 'Bank',
          icon: 'account_balance',
          colorHex: '#1565C0',
          createdAt: DateTime.now().subtract(const Duration(days: 30)),
        ),
        Account(
          id: '2',
          name: 'Cash',
          balance: 1250.25,
          type: 'Cash',
          icon: 'money',
          colorHex: '#4CAF50',
          createdAt: DateTime.now().subtract(const Duration(days: 20)),
        ),
        Account(
          id: '3',
          name: 'Credit Card',
          balance: 3150.00,
          type: 'Credit Card',
          icon: 'credit_card',
          colorHex: '#9C27B0',
          createdAt: DateTime.now().subtract(const Duration(days: 10)),
        ),
      ]);
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }
  
  @override
  Future<Either<Failure, Account>> getAccountById(String id) async {
    try {
      // This would fetch from a local or remote data source
      return Right(
        Account(
          id: id,
          name: 'Bank Account',
          balance: 8450.50,
          type: 'Bank',
          icon: 'account_balance',
          colorHex: '#1565C0',
          createdAt: DateTime.now().subtract(const Duration(days: 30)),
        ),
      );
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }
  
  @override
  Future<Either<Failure, Account>> createAccount(Account account) async {
    try {
      // This would send to a local or remote data source
      return Right(
        account.copyWith(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          createdAt: DateTime.now(),
        ),
      );
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }
  
  @override
  Future<Either<Failure, Account>> updateAccount(Account account) async {
    try {
      // This would update in a local or remote data source
      return Right(
        account.copyWith(
          updatedAt: DateTime.now(),
        ),
      );
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }
  
  @override
  Future<Either<Failure, void>> deleteAccount(String id) async {
    try {
      // This would delete from a local or remote data source
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }
  
  @override
  Future<Either<Failure, double>> getTotalBalance() async {
    try {
      final accountsResult = await getAccounts();
      
      return accountsResult.fold(
        (failure) => Left(failure),
        (accounts) {
          final total = accounts.fold(
            0.0, 
            (previous, account) => previous + account.balance,
          );
          return Right(total);
        },
      );
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }
}