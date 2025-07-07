import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../entities/account.dart';
import '../repositories/account_repository.dart';

class GetAccountByIdUseCase {
  final AccountRepository repository;
  
  GetAccountByIdUseCase(this.repository);
  
  Future<Either<Failure, Account>> call(String id) {
    return repository.getAccountById(id);
  }
} 