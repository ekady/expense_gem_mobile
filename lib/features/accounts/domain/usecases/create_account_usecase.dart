import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../entities/account.dart';
import '../repositories/account_repository.dart';

class CreateAccountUseCase {
  final AccountRepository repository;
  
  CreateAccountUseCase(this.repository);
  
  Future<Either<Failure, Account>> call(Account account) {
    return repository.createAccount(account);
  }
} 