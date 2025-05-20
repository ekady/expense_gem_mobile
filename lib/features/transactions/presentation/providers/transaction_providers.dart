import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/services/service_locator.dart';
import '../../domain/entities/transaction.dart';
import '../../domain/repositories/transaction_repository.dart';

part 'transaction_providers.g.dart';

// Repository provider
final transactionRepositoryProvider = Provider<TransactionRepository>((ref) {
  return getIt<TransactionRepository>();
});

// All transactions provider
@riverpod
Future<List<Transaction>> transactions(Ref ref) async {
  final repository = ref.watch(transactionRepositoryProvider);
  final result = await repository.getTransactions();

  return result.fold(
    (failure) => throw failure.message,
    (transactions) => transactions,
  );
}

// Filtered transactions provider
@riverpod
Future<List<Transaction>> filteredTransactions(
  Ref ref, {
  String? type,
  String? categoryId,
  String? accountId,
  DateTimeRange? dateRange,
}) async {
  final repository = ref.watch(transactionRepositoryProvider);

  // Get all transactions first as the base
  final allTransactionsResult = await repository.getTransactions();

  return allTransactionsResult.fold((failure) => throw failure.message, (
    transactions,
  ) {
    // Apply filters sequentially
    var filteredTransactions = List<Transaction>.from(transactions);

    // Filter by type
    if (type != null) {
      filteredTransactions =
          filteredTransactions
              .where((transaction) => transaction.type == type)
              .toList();
    }

    // Filter by category
    if (categoryId != null) {
      filteredTransactions =
          filteredTransactions
              .where((transaction) => transaction.categoryId == categoryId)
              .toList();
    }

    // Filter by account
    if (accountId != null) {
      filteredTransactions =
          filteredTransactions
              .where((transaction) => transaction.accountId == accountId)
              .toList();
    }

    // Filter by date range
    if (dateRange != null) {
      filteredTransactions =
          filteredTransactions
              .where(
                (transaction) =>
                    transaction.date.isAfter(
                      dateRange.start.subtract(const Duration(days: 1)),
                    ) &&
                    transaction.date.isBefore(
                      dateRange.end.add(const Duration(days: 1)),
                    ),
              )
              .toList();
    }

    // Sort by date, newest first
    filteredTransactions.sort((a, b) => b.date.compareTo(a.date));

    return filteredTransactions;
  });
}

// Single transaction provider
@riverpod
Future<Transaction> transaction(Ref ref, String id) async {
  final repository = ref.watch(transactionRepositoryProvider);
  final result = await repository.getTransactionById(id);

  return result.fold(
    (failure) => throw failure.message,
    (transaction) => transaction,
  );
}

// Transaction form provider
@riverpod
class TransactionFormState extends _$TransactionFormState {
  @override
  AsyncValue<Transaction?> build([String? transactionId]) {
    if (transactionId != null) {
      _loadTransaction(transactionId);
    }
    return const AsyncValue.data(null);
  }

  Future<void> _loadTransaction(String id) async {
    state = const AsyncValue.loading();

    final repository = ref.read(transactionRepositoryProvider);
    final result = await repository.getTransactionById(id);

    state = result.fold(
      (failure) => AsyncValue.error(failure.message, StackTrace.current),
      (transaction) => AsyncValue.data(transaction),
    );
  }

  Future<void> saveTransaction(Transaction transaction) async {
    state = const AsyncValue.loading();

    final repository = ref.read(transactionRepositoryProvider);
    final result =
        transaction.id.isEmpty
            ? await repository.createTransaction(transaction)
            : await repository.updateTransaction(transaction);

    state = result.fold(
      (failure) => AsyncValue.error(failure.message, StackTrace.current),
      (savedTransaction) {
        ref.invalidate(transactionsProvider);
        ref.invalidate(filteredTransactionsProvider);
        return AsyncValue.data(savedTransaction);
      },
    );
  }

  Future<void> deleteTransaction(String id) async {
    state = const AsyncValue.loading();

    final repository = ref.read(transactionRepositoryProvider);
    final result = await repository.deleteTransaction(id);

    result.fold(
      (failure) {
        state = AsyncValue.error(failure.message, StackTrace.current);
      },
      (_) {
        ref.invalidate(transactionsProvider);
        ref.invalidate(filteredTransactionsProvider);
        state = const AsyncValue.data(null);
      },
    );
  }
}
