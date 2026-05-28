import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../repositories/account_repository.dart';

class GetAccountsUseCase {
  final AccountRepository repository;

  GetAccountsUseCase(this.repository);

  Future<Either<Failure, Map<String, dynamic>>> call({
    int page = 1,
    int limit = 10,
  }) {
    return repository.getAccounts(page: page, limit: limit);
  }
}
