import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../../domain/entities/transaction.dart';
import '../../domain/repositories/transaction_repository.dart';

class TransactionRepositoryImpl implements TransactionRepository {
  // This would typically have data sources injected
  
  @override
  Future<Either<Failure, List<Transaction>>> getTransactions() async {
    try {
      // Mock data for now
      return Right([
        Transaction(
          id: '1',
          title: 'Grocery Shopping',
          description: 'Weekly grocery shopping',
          amount: 125.50,
          date: DateTime.now().subtract(const Duration(hours: 5)),
          type: 'expense',
          categoryId: '1', // Food
          accountId: '1', // Bank Account
          createdAt: DateTime.now().subtract(const Duration(hours: 5)),
        ),
        Transaction(
          id: '2',
          title: 'Salary Deposit',
          amount: 3500.00,
          date: DateTime.now().subtract(const Duration(days: 1)),
          type: 'income',
          categoryId: '7', // Salary
          accountId: '1', // Bank Account
          createdAt: DateTime.now().subtract(const Duration(days: 1)),
        ),
        Transaction(
          id: '3',
          title: 'Restaurant',
          description: 'Dinner with friends',
          amount: 85.75,
          date: DateTime.now().subtract(const Duration(days: 1, hours: 10)),
          type: 'expense',
          categoryId: '1', // Food
          accountId: '3', // Credit Card
          createdAt: DateTime.now().subtract(const Duration(days: 1, hours: 10)),
        ),
        Transaction(
          id: '4',
          title: 'Uber Ride',
          amount: 24.99,
          date: DateTime.now().subtract(const Duration(days: 2)),
          type: 'expense',
          categoryId: '2', // Transport
          accountId: '3', // Credit Card
          createdAt: DateTime.now().subtract(const Duration(days: 2)),
        ),
        Transaction(
          id: '5',
          title: 'Amazon Purchase',
          description: 'New headphones',
          amount: 149.99,
          date: DateTime.now().subtract(const Duration(days: 3)),
          type: 'expense',
          categoryId: '3', // Shopping
          accountId: '3', // Credit Card
          createdAt: DateTime.now().subtract(const Duration(days: 3)),
        ),
        Transaction(
          id: '6',
          title: 'Movie Tickets',
          amount: 35.00,
          date: DateTime.now().subtract(const Duration(days: 5)),
          type: 'expense',
          categoryId: '4', // Entertainment
          accountId: '2', // Cash
          createdAt: DateTime.now().subtract(const Duration(days: 5)),
        ),
        Transaction(
          id: '7',
          title: 'Electricity Bill',
          amount: 120.00,
          date: DateTime.now().subtract(const Duration(days: 7)),
          type: 'expense',
          categoryId: '5', // Bills
          accountId: '1', // Bank Account
          createdAt: DateTime.now().subtract(const Duration(days: 7)),
        ),
        Transaction(
          id: '8',
          title: 'Doctor Appointment',
          amount: 75.00,
          date: DateTime.now().subtract(const Duration(days: 8)),
          type: 'expense',
          categoryId: '6', // Health
          accountId: '1', // Bank Account
          createdAt: DateTime.now().subtract(const Duration(days: 8)),
        ),
        Transaction(
          id: '9',
          title: 'Investment Return',
          amount: 250.00,
          date: DateTime.now().subtract(const Duration(days: 10)),
          type: 'income',
          categoryId: '8', // Investment
          accountId: '1', // Bank Account
          createdAt: DateTime.now().subtract(const Duration(days: 10)),
        ),
      ]);
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }
  
  @override
  Future<Either<Failure, List<Transaction>>> getTransactionsByAccount(String accountId) async {
    try {
      final transactionsResult = await getTransactions();
      
      return transactionsResult.fold(
        (failure) => Left(failure),
        (transactions) {
          final filtered = transactions
              .where((transaction) => transaction.accountId == accountId)
              .toList();
          return Right(filtered);
        },
      );
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }
  
  @override
  Future<Either<Failure, List<Transaction>>> getTransactionsByCategory(String categoryId) async {
    try {
      final transactionsResult = await getTransactions();
      
      return transactionsResult.fold(
        (failure) => Left(failure),
        (transactions) {
          final filtered = transactions
              .where((transaction) => transaction.categoryId == categoryId)
              .toList();
          return Right(filtered);
        },
      );
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }
  
  @override
  Future<Either<Failure, List<Transaction>>> getTransactionsByType(String type) async {
    try {
      final transactionsResult = await getTransactions();
      
      return transactionsResult.fold(
        (failure) => Left(failure),
        (transactions) {
          final filtered = transactions
              .where((transaction) => transaction.type == type)
              .toList();
          return Right(filtered);
        },
      );
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }
  
  @override
  Future<Either<Failure, List<Transaction>>> getTransactionsByDateRange(DateTime startDate, DateTime endDate) async {
    try {
      final transactionsResult = await getTransactions();
      
      return transactionsResult.fold(
        (failure) => Left(failure),
        (transactions) {
          final filtered = transactions
              .where((transaction) => 
                transaction.date.isAfter(startDate) && 
                transaction.date.isBefore(endDate.add(const Duration(days: 1))))
              .toList();
          return Right(filtered);
        },
      );
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }
  
  @override
  Future<Either<Failure, Transaction>> getTransactionById(String id) async {
    try {
      final transactionsResult = await getTransactions();
      
      return transactionsResult.fold(
        (failure) => Left(failure),
        (transactions) {
          final transaction = transactions.firstWhere(
            (transaction) => transaction.id == id,
            orElse: () => throw Exception('Transaction not found'),
          );
          return Right(transaction);
        },
      );
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }
  
  @override
  Future<Either<Failure, Transaction>> createTransaction(Transaction transaction) async {
    try {
      // This would save to a data source in a real app
      return Right(
        transaction.copyWith(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          createdAt: DateTime.now(),
        ),
      );
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }
  
  @override
  Future<Either<Failure, Transaction>> updateTransaction(Transaction transaction) async {
    try {
      // This would update in a data source in a real app
      return Right(
        transaction.copyWith(
          updatedAt: DateTime.now(),
        ),
      );
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }
  
  @override
  Future<Either<Failure, void>> deleteTransaction(String id) async {
    try {
      // This would delete from a data source in a real app
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }
  
  @override
  Future<Either<Failure, Map<String, double>>> getCategoryTotals(String type, DateTime startDate, DateTime endDate) async {
    try {
      final transactionsResult = await getTransactions();
      
      return transactionsResult.fold(
        (failure) => Left(failure),
        (transactions) {
          final filtered = transactions
              .where((transaction) => 
                transaction.type == type &&
                transaction.date.isAfter(startDate) && 
                transaction.date.isBefore(endDate.add(const Duration(days: 1))))
              .toList();
          
          final categoryTotals = <String, double>{};
          
          for (final transaction in filtered) {
            final categoryId = transaction.categoryId;
            final amount = transaction.amount;
            
            categoryTotals[categoryId] = (categoryTotals[categoryId] ?? 0) + amount;
          }
          
          return Right(categoryTotals);
        },
      );
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }
  
  @override
  Future<Either<Failure, Map<String, double>>> getAccountTotals(DateTime startDate, DateTime endDate) async {
    try {
      final transactionsResult = await getTransactions();
      
      return transactionsResult.fold(
        (failure) => Left(failure),
        (transactions) {
          final filtered = transactions
              .where((transaction) => 
                transaction.date.isAfter(startDate) && 
                transaction.date.isBefore(endDate.add(const Duration(days: 1))))
              .toList();
          
          final accountTotals = <String, double>{};
          
          for (final transaction in filtered) {
            final accountId = transaction.accountId;
            final amount = transaction.type == 'income' 
                ? transaction.amount 
                : -transaction.amount;
            
            accountTotals[accountId] = (accountTotals[accountId] ?? 0) + amount;
          }
          
          return Right(accountTotals);
        },
      );
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }
  
  @override
  Future<Either<Failure, Map<DateTime, double>>> getDailyTotals(String type, DateTime startDate, DateTime endDate) async {
    try {
      final transactionsResult = await getTransactions();
      
      return transactionsResult.fold(
        (failure) => Left(failure),
        (transactions) {
          final filtered = transactions
              .where((transaction) => 
                transaction.type == type &&
                transaction.date.isAfter(startDate) && 
                transaction.date.isBefore(endDate.add(const Duration(days: 1))))
              .toList();
          
          final dailyTotals = <DateTime, double>{};
          
          for (final transaction in filtered) {
            // Normalize to start of day
            final day = DateTime(
              transaction.date.year, 
              transaction.date.month, 
              transaction.date.day,
            );
            
            final amount = transaction.amount;
            
            dailyTotals[day] = (dailyTotals[day] ?? 0) + amount;
          }
          
          return Right(dailyTotals);
        },
      );
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }
}