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

// Paginated transactions provider
@riverpod
Future<Map<String, dynamic>> paginatedTransactions(Ref ref, {int page = 1, int limit = 10}) async {
  final repository = ref.watch(transactionRepositoryProvider);
  final result = await repository.getPaginatedTransactions(page: page, limit: limit);

  return result.fold(
    (failure) => throw failure.message,
    (data) => data,
  );
}

// Infinite scroll transactions provider
@riverpod
class TransactionsInfiniteScroll extends _$TransactionsInfiniteScroll {
  bool _isLoadingMore = false;
  bool _hasReachedEnd = false;

  String? _categoryId;
  String? _accountId;
  DateTime? _startDate;
  DateTime? _endDate;
  int? _amountType;

  @override
  Future<List<Transaction>> build({
    String? categoryId,
    String? accountId,
    DateTime? startDate,
    DateTime? endDate,
    int? amountType,
  }) async {
    return _loadFirstPage(
      categoryId: categoryId,
      accountId: accountId,
      startDate: startDate,
      endDate: endDate,
      amountType: amountType,
    );
  }

  Future<List<Transaction>> _loadFirstPage({
    String? categoryId,
    String? accountId,
    DateTime? startDate,
    DateTime? endDate,
    int? amountType,
  }) async {
    _hasReachedEnd = false;
    _categoryId = categoryId;
    _accountId = accountId;
    _startDate = startDate;
    _endDate = endDate;
    _amountType = amountType;
    final repository = ref.read(transactionRepositoryProvider);
    final result = await repository.getPaginatedTransactions(
      page: 1,
      limit: 10,
      categoryId: categoryId,
      accountId: accountId,
      startDate: startDate,
      endDate: endDate,
      amountType: amountType,
    );
    return result.fold(
      (failure) => throw failure.message,
      (data) {
        final transactions = data['transactions'] as List<Transaction>;
        if (transactions.length < 10) {
          _hasReachedEnd = true;
        }
        return transactions;
      },
    );
  }

  Future<void> loadNextPage() async {
    if (_isLoadingMore || _hasReachedEnd) return;
    _isLoadingMore = true;
    try {
      final currentTransactions = state.value ?? [];
      final repository = ref.read(transactionRepositoryProvider);
      final result = await repository.getPaginatedTransactions(
        page: (currentTransactions.length / 10).ceil() + 1,
        limit: 10,
        categoryId: _categoryId,
        accountId: _accountId,
        startDate: _startDate,
        endDate: _endDate,
        amountType: _amountType,
      );
      result.fold(
        (failure) => state = AsyncValue.error(failure.message, StackTrace.current),
        (data) {
          final newTransactions = data['transactions'] as List<Transaction>;
          if (newTransactions.isNotEmpty) {
            final allTransactions = [...currentTransactions, ...newTransactions];
            state = AsyncValue.data(allTransactions);
            if (newTransactions.length < 10) {
              _hasReachedEnd = true;
            }
          } else {
            _hasReachedEnd = true;
          }
        },
      );
    } finally {
      _isLoadingMore = false;
    }
  }

  Future<void> refresh({
    String? categoryId,
    String? accountId,
    DateTime? startDate,
    DateTime? endDate,
    int? amountType,
  }) async {
    _isLoadingMore = false;
    _hasReachedEnd = false;
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => _loadFirstPage(
      categoryId: categoryId,
      accountId: accountId,
      startDate: startDate,
      endDate: endDate,
      amountType: amountType,
    ));
  }

  bool get hasMoreData {
    return !_isLoadingMore && !_hasReachedEnd;
  }
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
        (transaction.id?.isEmpty ?? true)
            ? await repository.createTransaction(transaction)
            : await repository.updateTransaction(transaction);

    state = result.fold(
      (failure) => AsyncValue.error(failure.message, StackTrace.current),
      (savedTransaction) {
        ref.invalidate(transactionsProvider);
        ref.invalidate(paginatedTransactionsProvider);
        ref.read(transactionsInfiniteScrollProvider(
          categoryId: null,
          accountId: null,
          startDate: null,
          endDate: null,
        ).notifier).refresh();
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
        ref.invalidate(paginatedTransactionsProvider);
        ref.read(transactionsInfiniteScrollProvider(
          categoryId: null,
          accountId: null,
          startDate: null,
          endDate: null,
        ).notifier).refresh();
        state = const AsyncValue.data(null);
      },
    );
  }
}
