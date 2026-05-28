import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';

import '../../../../core/error/failures.dart';
import '../../domain/entities/transaction.dart';
import '../../domain/repositories/transaction_repository.dart';
import '../datasources/transaction_local_data_source.dart';
import '../datasources/transaction_remote_data_source.dart';

class TransactionRepositoryImpl implements TransactionRepository {
  final TransactionRemoteDataSource remoteDataSource;
  final TransactionLocalDataSource localDataSource;

  TransactionRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  @override
  Future<Either<Failure, List<Transaction>>> getTransactions() async {
    try {
      // Always try remote first
      final result = await remoteDataSource.getTransactions();
      final transactions = result['transactions'] as List<Transaction>;

      // Save to local cache
      await localDataSource.saveTransactions(transactions);

      return Right(transactions);
    } on DioException catch (e) {
      // On network error, try local cache
      final cachedTransactions = await localDataSource.getTransactions();
      if (cachedTransactions.isNotEmpty) {
        return Right(cachedTransactions);
      }
      return Left(
        ServerFailure(message: e.message ?? 'An unexpected error occurred'),
      );
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, Map<String, dynamic>>> getPaginatedTransactions({
    int page = 1,
    int limit = 10,
    String? categoryId,
    String? accountId,
    DateTime? startDate,
    DateTime? endDate,
    int? amountType,
  }) async {
    try {
      // Always try remote first
      final result = await remoteDataSource.getTransactions(
        page: page,
        limit: limit,
        categoryId: categoryId,
        accountId: accountId,
        startDate: startDate,
        endDate: endDate,
        amountType: amountType,
      );

      // Save to local cache (for now, we'll save all transactions)
      final transactions = result['transactions'] as List<Transaction>;
      await localDataSource.saveTransactions(transactions);

      return Right(result);
    } on DioException catch (e) {
      // On network error, try local cache
      final cachedTransactions = await localDataSource.getTransactions();
      if (cachedTransactions.isNotEmpty) {
        // For local cache, we'll simulate pagination
        final startIndex = (page - 1) * limit;
        final endIndex = startIndex + limit;
        final paginatedTransactions =
            cachedTransactions.skip(startIndex).take(limit).toList();

        return Right({
          'transactions': paginatedTransactions,
          'total': cachedTransactions.length,
          'page': page,
          'limit': limit,
          'hasMore': endIndex < cachedTransactions.length,
        });
      }
      return Left(
        ServerFailure(message: e.message ?? 'An unexpected error occurred'),
      );
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<Transaction>>> getTransactionsByAccount(
    String accountId,
  ) async {
    try {
      final transactionsResult = await getTransactions();

      return transactionsResult.fold((failure) => Left(failure), (
        transactions,
      ) {
        final filtered =
            transactions
                .where((transaction) => transaction.account?.id == accountId)
                .toList();
        return Right(filtered);
      });
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<Transaction>>> getTransactionsByCategory(
    String categoryId,
  ) async {
    try {
      final transactionsResult = await getTransactions();

      return transactionsResult.fold((failure) => Left(failure), (
        transactions,
      ) {
        final filtered =
            transactions
                .where((transaction) => transaction.category?.id == categoryId)
                .toList();
        return Right(filtered);
      });
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<Transaction>>> getTransactionsByType(
    String type,
  ) async {
    try {
      final transactionsResult = await getTransactions();

      return transactionsResult.fold((failure) => Left(failure), (
        transactions,
      ) {
        final filtered =
            transactions
                .where((transaction) => transaction.type == type)
                .toList();
        return Right(filtered);
      });
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<Transaction>>> getTransactionsByDateRange(
    DateTime startDate,
    DateTime endDate,
  ) async {
    try {
      final transactionsResult = await getTransactions();

      return transactionsResult.fold((failure) => Left(failure), (
        transactions,
      ) {
        final filtered =
            transactions
                .where(
                  (transaction) =>
                      transaction.date!.isAfter(startDate) &&
                      transaction.date!.isBefore(
                        endDate.add(const Duration(days: 1)),
                      ),
                )
                .toList();
        return Right(filtered);
      });
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, Transaction>> getTransactionById(String id) async {
    try {
      // Always try remote first
      final remoteTransaction = await remoteDataSource.getTransactionById(id);
      await localDataSource.saveTransaction(remoteTransaction);
      return Right(remoteTransaction);
    } on DioException catch (e) {
      // On network error, try local cache
      final cachedTransaction = await localDataSource.getTransactionById(id);
      if (cachedTransaction != null) {
        return Right(cachedTransaction);
      }
      return Left(
        ServerFailure(message: e.message ?? 'An unexpected error occurred'),
      );
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, Transaction>> createTransaction(
    Transaction transaction,
  ) async {
    try {
      final createdTransaction = await remoteDataSource.createTransaction(
        transaction,
      );
      await localDataSource.saveTransaction(createdTransaction);
      return Right(createdTransaction);
    } on DioException catch (e) {
      return Left(
        ServerFailure(message: e.message ?? 'An unexpected error occurred'),
      );
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, Transaction>> updateTransaction(
    Transaction transaction,
  ) async {
    try {
      final updatedTransaction = await remoteDataSource.updateTransaction(
        transaction,
      );
      await localDataSource.saveTransaction(updatedTransaction);
      return Right(updatedTransaction);
    } on DioException catch (e) {
      return Left(
        ServerFailure(message: e.message ?? 'An unexpected error occurred'),
      );
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> deleteTransaction(String id) async {
    try {
      await remoteDataSource.deleteTransaction(id);
      await localDataSource.deleteTransaction(id);
      return const Right(null);
    } on DioException catch (e) {
      return Left(
        ServerFailure(message: e.message ?? 'An unexpected error occurred'),
      );
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, Map<String, double>>> getCategoryTotals(
    String type,
    DateTime startDate,
    DateTime endDate,
  ) async {
    try {
      final transactionsResult = await getTransactions();

      return transactionsResult.fold((failure) => Left(failure), (
        transactions,
      ) {
        final filtered =
            transactions
                .where(
                  (transaction) =>
                      transaction.type == type &&
                      transaction.date!.isAfter(startDate) &&
                      transaction.date!.isBefore(
                        endDate.add(const Duration(days: 1)),
                      ),
                )
                .toList();

        final categoryTotals = <String, double>{};

        for (final transaction in filtered) {
          final categoryId = transaction.category?.id;
          final amount = transaction.amount ?? 0;

          categoryTotals[categoryId ?? ''] =
              (categoryTotals[categoryId ?? ''] ?? 0) + amount;
        }

        return Right(categoryTotals);
      });
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, Map<String, double>>> getAccountTotals(
    DateTime startDate,
    DateTime endDate,
  ) async {
    try {
      final transactionsResult = await getTransactions();

      return transactionsResult.fold((failure) => Left(failure), (
        transactions,
      ) {
        final filtered =
            transactions
                .where(
                  (transaction) =>
                      transaction.date!.isAfter(startDate) &&
                      transaction.date!.isBefore(
                        endDate.add(const Duration(days: 1)),
                      ),
                )
                .toList();

        final accountTotals = <String, double>{};

        for (final transaction in filtered) {
          final accountId = transaction.account?.id;
          final amount =
              transaction.type == 'income'
                  ? transaction.amount ?? 0
                  : -(transaction.amount ?? 0);

          accountTotals[accountId ?? ''] =
              (accountTotals[accountId ?? ''] ?? 0) + amount;
        }

        return Right(accountTotals);
      });
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, Map<DateTime, double>>> getDailyTotals(
    String type,
    DateTime startDate,
    DateTime endDate,
  ) async {
    try {
      final transactionsResult = await getTransactions();

      return transactionsResult.fold((failure) => Left(failure), (
        transactions,
      ) {
        final filtered =
            transactions
                .where(
                  (transaction) =>
                      transaction.type == type &&
                      transaction.date!.isAfter(startDate) &&
                      transaction.date!.isBefore(
                        endDate.add(const Duration(days: 1)),
                      ),
                )
                .toList();

        final dailyTotals = <DateTime, double>{};

        for (final transaction in filtered) {
          // Normalize to start of day
          final day = DateTime(
            transaction.date!.year,
            transaction.date!.month,
            transaction.date!.day,
          );

          final amount = transaction.amount ?? 0;

          dailyTotals[day] = (dailyTotals[day] ?? 0) + amount;
        }

        return Right(dailyTotals);
      });
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }
}
