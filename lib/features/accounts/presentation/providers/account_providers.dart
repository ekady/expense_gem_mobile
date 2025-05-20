import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/services/service_locator.dart';
import '../../domain/entities/account.dart';
import '../../domain/repositories/account_repository.dart';

part 'account_providers.g.dart';

// Repository provider
final accountRepositoryProvider = Provider<AccountRepository>((ref) {
  return getIt<AccountRepository>();
});

// Accounts provider
@riverpod
Future<List<Account>> accounts(Ref ref) async {
  final repository = ref.watch(accountRepositoryProvider);
  final result = await repository.getAccounts();

  return result.fold(
    (failure) => throw failure.message,
    (accounts) => accounts,
  );
}

// Single account provider
@riverpod
Future<Account> account(Ref ref, String id) async {
  final repository = ref.watch(accountRepositoryProvider);
  final result = await repository.getAccountById(id);

  return result.fold((failure) => throw failure.message, (account) => account);
}

// Total balance provider
@riverpod
Future<double> totalBalance(Ref ref) async {
  final repository = ref.watch(accountRepositoryProvider);
  final result = await repository.getTotalBalance();

  return result.fold((failure) => throw failure.message, (total) => total);
}

// Account form provider
@riverpod
class AccountFormState extends _$AccountFormState {
  @override
  AsyncValue<Account?> build([String? accountId]) {
    if (accountId != null) {
      _loadAccount(accountId);
    }
    return const AsyncValue.data(null);
  }

  Future<void> _loadAccount(String id) async {
    state = const AsyncValue.loading();

    final repository = ref.read(accountRepositoryProvider);
    final result = await repository.getAccountById(id);

    state = result.fold(
      (failure) => AsyncValue.error(failure.message, StackTrace.current),
      (account) => AsyncValue.data(account),
    );
  }

  Future<void> saveAccount(Account account) async {
    state = const AsyncValue.loading();

    final repository = ref.read(accountRepositoryProvider);
    final result =
        account.id.isEmpty
            ? await repository.createAccount(account)
            : await repository.updateAccount(account);

    state = result.fold(
      (failure) => AsyncValue.error(failure.message, StackTrace.current),
      (savedAccount) {
        ref.invalidate(accountsProvider);
        ref.invalidate(totalBalanceProvider);
        return AsyncValue.data(savedAccount);
      },
    );
  }

  Future<void> deleteAccount(String id) async {
    state = const AsyncValue.loading();

    final repository = ref.read(accountRepositoryProvider);
    final result = await repository.deleteAccount(id);

    result.fold(
      (failure) {
        state = AsyncValue.error(failure.message, StackTrace.current);
      },
      (_) {
        ref.invalidate(accountsProvider);
        ref.invalidate(totalBalanceProvider);
        state = const AsyncValue.data(null);
      },
    );
  }
}
