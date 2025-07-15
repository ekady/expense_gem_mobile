import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../entities/transaction.dart';

abstract class TransactionRepository {
  Future<Either<Failure, List<Transaction>>> getTransactions();
  Future<Either<Failure, Map<String, dynamic>>> getPaginatedTransactions({
    int page = 1,
    int limit = 10,
    String? categoryId,
    String? accountId,
    DateTime? startDate,
    DateTime? endDate,
    int? amountType,
  });
  Future<Either<Failure, List<Transaction>>> getTransactionsByAccount(String accountId);
  Future<Either<Failure, List<Transaction>>> getTransactionsByCategory(String categoryId);
  Future<Either<Failure, List<Transaction>>> getTransactionsByType(String type);
  Future<Either<Failure, List<Transaction>>> getTransactionsByDateRange(DateTime startDate, DateTime endDate);
  Future<Either<Failure, Transaction>> getTransactionById(String id);
  Future<Either<Failure, Transaction>> createTransaction(Transaction transaction);
  Future<Either<Failure, Transaction>> updateTransaction(Transaction transaction);
  Future<Either<Failure, void>> deleteTransaction(String id);
  Future<Either<Failure, Map<String, double>>> getCategoryTotals(String type, DateTime startDate, DateTime endDate);
  Future<Either<Failure, Map<String, double>>> getAccountTotals(DateTime startDate, DateTime endDate);
  Future<Either<Failure, Map<DateTime, double>>> getDailyTotals(String type, DateTime startDate, DateTime endDate);
}