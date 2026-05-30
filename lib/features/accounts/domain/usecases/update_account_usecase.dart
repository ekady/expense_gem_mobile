import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../entities/account.dart';
import '../repositories/account_repository.dart';

class UpdateAccountUseCase {
  final AccountRepository repository;

  UpdateAccountUseCase(this.repository);

  Future<Either<Failure, Account>> call(Account account) {
    return repository.updateAccount(account);
  }
}
