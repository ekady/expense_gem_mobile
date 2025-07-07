import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/services/service_locator.dart';
import '../../domain/entities/account.dart';
import '../../domain/repositories/account_repository.dart';
import '../../domain/usecases/create_account_usecase.dart';
import '../../domain/usecases/delete_account_usecase.dart';
import '../../domain/usecases/get_account_by_id_usecase.dart';
import '../../domain/usecases/get_accounts_usecase.dart';
import '../../domain/usecases/update_account_usecase.dart';

part 'account_providers.g.dart';

// Use Cases Providers
@riverpod
GetAccountsUseCase getAccountsUseCase(Ref ref) {
  return GetAccountsUseCase(getIt<AccountRepository>());
}

@riverpod
GetAccountByIdUseCase getAccountByIdUseCase(Ref ref) {
  return GetAccountByIdUseCase(getIt<AccountRepository>());
}

@riverpod
CreateAccountUseCase createAccountUseCase(Ref ref) {
  return CreateAccountUseCase(getIt<AccountRepository>());
}

@riverpod
UpdateAccountUseCase updateAccountUseCase(Ref ref) {
  return UpdateAccountUseCase(getIt<AccountRepository>());
}

@riverpod
DeleteAccountUseCase deleteAccountUseCase(Ref ref) {
  return DeleteAccountUseCase(getIt<AccountRepository>());
}

// Paginated accounts provider
@riverpod
Future<Map<String, dynamic>> paginatedAccounts(Ref ref, {int page = 1, int limit = 10}) async {
  final useCase = ref.watch(getAccountsUseCaseProvider);
  final result = await useCase.call(page: page, limit: limit);

  return result.fold(
    (failure) => throw failure.message,
    (data) => data,
  );
}

// Accounts provider (for backward compatibility - gets first page)
@riverpod
Future<List<Account>> accounts(Ref ref) async {
  final useCase = ref.watch(getAccountsUseCaseProvider);
  final result = await useCase.call(page: 1, limit: 10);

  return result.fold(
    (failure) => throw failure.message,
    (data) => data['accounts'] as List<Account>,
  );
}

// Single account provider
@riverpod
Future<Account> account(Ref ref, String id) async {
  final useCase = ref.watch(getAccountByIdUseCaseProvider);
  final result = await useCase.call(id);

  return result.fold((failure) => throw failure.message, (account) => account);
}

// Infinite scroll accounts provider
@riverpod
class AccountsInfiniteScroll extends _$AccountsInfiniteScroll {
  bool _isLoadingMore = false;

  @override
  Future<List<Account>> build() async {
    return _loadFirstPage();
  }

  Future<List<Account>> _loadFirstPage() async {
    final useCase = ref.read(getAccountsUseCaseProvider);
    final result = await useCase.call(page: 1, limit: 10);

    return result.fold(
      (failure) => throw failure.message,
      (data) => data['accounts'] as List<Account>,
    );
  }

  Future<void> loadNextPage() async {
    if (_isLoadingMore) return; // Prevent duplicate calls
    
    _isLoadingMore = true;
    
    try {
      final currentAccounts = state.value ?? [];
      
      final useCase = ref.read(getAccountsUseCaseProvider);
      final result = await useCase.call(page: (currentAccounts.length / 10).ceil() + 1, limit: 10);

      result.fold(
        (failure) => state = AsyncValue.error(failure.message, StackTrace.current),
        (data) {
          final newAccounts = data['accounts'] as List<Account>;
          
          if (newAccounts.isNotEmpty) {
            final allAccounts = [...currentAccounts, ...newAccounts];
            state = AsyncValue.data(allAccounts);
          }
        },
      );
    } finally {
      _isLoadingMore = false;
    }
  }

  Future<void> refresh() async {
    _isLoadingMore = false;
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => _loadFirstPage());
  }

  bool get hasMoreData {
    if (_isLoadingMore) return false; // Don't load more if already loading
    
    final currentAccounts = state.value ?? [];
    // This is a simplified check - in a real app, you'd store pagination info
    return currentAccounts.length % 10 == 0 && currentAccounts.isNotEmpty;
  }
}

// Account form provider
@riverpod
class AccountFormState extends _$AccountFormState {
  @override
  AsyncValue<Account?> build([String? accountId]) {
    if (accountId != null) {
      _loadAccount(accountId);
      return const AsyncValue.loading();
    }
    return const AsyncValue.data(null);
  }

  Future<void> _loadAccount(String id) async {
    state = const AsyncValue.loading();

    final useCase = ref.read(getAccountByIdUseCaseProvider);
    final result = await useCase.call(id);

    state = result.fold(
      (failure) => AsyncValue.error(failure.message, StackTrace.current),
      (account) {
        return AsyncValue.data(account);
      },
    );
  }

  Future<void> saveAccount(Account account) async {
    state = const AsyncValue.loading();

    final result = account.id.isEmpty
        ? await ref.read(createAccountUseCaseProvider).call(account)
        : await ref.read(updateAccountUseCaseProvider).call(account);

    state = result.fold(
      (failure) => AsyncValue.error(failure.message, StackTrace.current),
      (savedAccount) {
        // Invalidate and refresh all account-related providers
        ref.invalidate(accountsProvider);
        ref.invalidate(paginatedAccountsProvider);
        
        // Refresh the infinite scroll provider to get fresh data
        ref.read(accountsInfiniteScrollProvider.notifier).refresh();
        
        return AsyncValue.data(savedAccount);
      },
    );
  }

  Future<void> deleteAccount(String id) async {
    state = const AsyncValue.loading();

    final useCase = ref.read(deleteAccountUseCaseProvider);
    final result = await useCase.call(id);

    result.fold(
      (failure) {
        state = AsyncValue.error(failure.message, StackTrace.current);
      },
      (_) {
        // Invalidate and refresh all account-related providers
        ref.invalidate(accountsProvider);
        ref.invalidate(paginatedAccountsProvider);
        
        // Refresh the infinite scroll provider to get fresh data
        ref.read(accountsInfiniteScrollProvider.notifier).refresh();
        
        state = const AsyncValue.data(null);
      },
    );
  }
}
