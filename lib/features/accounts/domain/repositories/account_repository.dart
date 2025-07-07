import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../entities/account.dart';

abstract class AccountRepository {
  Future<Either<Failure, Map<String, dynamic>>> getAccounts({int page = 1, int limit = 10});
  Future<Either<Failure, Account>> getAccountById(String id);
  Future<Either<Failure, Account>> createAccount(Account account);
  Future<Either<Failure, Account>> updateAccount(Account account);
  Future<Either<Failure, void>> deleteAccount(String id);
}