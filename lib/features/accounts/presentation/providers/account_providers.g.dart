// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'account_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$getAccountsUseCaseHash() =>
    r'0b2a2dbbe45eaec940c057bbda72d2bdb7cf13ef';

/// See also [getAccountsUseCase].
@ProviderFor(getAccountsUseCase)
final getAccountsUseCaseProvider =
    AutoDisposeProvider<GetAccountsUseCase>.internal(
      getAccountsUseCase,
      name: r'getAccountsUseCaseProvider',
      debugGetCreateSourceHash:
          const bool.fromEnvironment('dart.vm.product')
              ? null
              : _$getAccountsUseCaseHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef GetAccountsUseCaseRef = AutoDisposeProviderRef<GetAccountsUseCase>;
String _$getAccountByIdUseCaseHash() =>
    r'39a1bd7e91cf6de99b0213b1099fb762fd5713f0';

/// See also [getAccountByIdUseCase].
@ProviderFor(getAccountByIdUseCase)
final getAccountByIdUseCaseProvider =
    AutoDisposeProvider<GetAccountByIdUseCase>.internal(
      getAccountByIdUseCase,
      name: r'getAccountByIdUseCaseProvider',
      debugGetCreateSourceHash:
          const bool.fromEnvironment('dart.vm.product')
              ? null
              : _$getAccountByIdUseCaseHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef GetAccountByIdUseCaseRef =
    AutoDisposeProviderRef<GetAccountByIdUseCase>;
String _$createAccountUseCaseHash() =>
    r'4ea70a0c746db23bde701c113d00f68f48bcfd88';

/// See also [createAccountUseCase].
@ProviderFor(createAccountUseCase)
final createAccountUseCaseProvider =
    AutoDisposeProvider<CreateAccountUseCase>.internal(
      createAccountUseCase,
      name: r'createAccountUseCaseProvider',
      debugGetCreateSourceHash:
          const bool.fromEnvironment('dart.vm.product')
              ? null
              : _$createAccountUseCaseHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef CreateAccountUseCaseRef = AutoDisposeProviderRef<CreateAccountUseCase>;
String _$updateAccountUseCaseHash() =>
    r'97a33276967828637f6b3468d1dadeb143aff360';

/// See also [updateAccountUseCase].
@ProviderFor(updateAccountUseCase)
final updateAccountUseCaseProvider =
    AutoDisposeProvider<UpdateAccountUseCase>.internal(
      updateAccountUseCase,
      name: r'updateAccountUseCaseProvider',
      debugGetCreateSourceHash:
          const bool.fromEnvironment('dart.vm.product')
              ? null
              : _$updateAccountUseCaseHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef UpdateAccountUseCaseRef = AutoDisposeProviderRef<UpdateAccountUseCase>;
String _$deleteAccountUseCaseHash() =>
    r'b45a5e5eeec13749a0d94dcfa2c23b4cd7eaefb1';

/// See also [deleteAccountUseCase].
@ProviderFor(deleteAccountUseCase)
final deleteAccountUseCaseProvider =
    AutoDisposeProvider<DeleteAccountUseCase>.internal(
      deleteAccountUseCase,
      name: r'deleteAccountUseCaseProvider',
      debugGetCreateSourceHash:
          const bool.fromEnvironment('dart.vm.product')
              ? null
              : _$deleteAccountUseCaseHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef DeleteAccountUseCaseRef = AutoDisposeProviderRef<DeleteAccountUseCase>;
String _$paginatedAccountsHash() => r'4d472867d01022a5efe02eba100894ab0775ae2b';

/// Copied from Dart SDK
class _SystemHash {
  _SystemHash._();

  static int combine(int hash, int value) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + value);
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x0007ffff & hash) << 10));
    return hash ^ (hash >> 6);
  }

  static int finish(int hash) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x03ffffff & hash) << 3));
    // ignore: parameter_assignments
    hash = hash ^ (hash >> 11);
    return 0x1fffffff & (hash + ((0x00003fff & hash) << 15));
  }
}

/// See also [paginatedAccounts].
@ProviderFor(paginatedAccounts)
const paginatedAccountsProvider = PaginatedAccountsFamily();

/// See also [paginatedAccounts].
class PaginatedAccountsFamily extends Family<AsyncValue<Map<String, dynamic>>> {
  /// See also [paginatedAccounts].
  const PaginatedAccountsFamily();

  /// See also [paginatedAccounts].
  PaginatedAccountsProvider call({int page = 1, int limit = 10}) {
    return PaginatedAccountsProvider(page: page, limit: limit);
  }

  @override
  PaginatedAccountsProvider getProviderOverride(
    covariant PaginatedAccountsProvider provider,
  ) {
    return call(page: provider.page, limit: provider.limit);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'paginatedAccountsProvider';
}

/// See also [paginatedAccounts].
class PaginatedAccountsProvider
    extends AutoDisposeFutureProvider<Map<String, dynamic>> {
  /// See also [paginatedAccounts].
  PaginatedAccountsProvider({int page = 1, int limit = 10})
    : this._internal(
        (ref) => paginatedAccounts(
          ref as PaginatedAccountsRef,
          page: page,
          limit: limit,
        ),
        from: paginatedAccountsProvider,
        name: r'paginatedAccountsProvider',
        debugGetCreateSourceHash:
            const bool.fromEnvironment('dart.vm.product')
                ? null
                : _$paginatedAccountsHash,
        dependencies: PaginatedAccountsFamily._dependencies,
        allTransitiveDependencies:
            PaginatedAccountsFamily._allTransitiveDependencies,
        page: page,
        limit: limit,
      );

  PaginatedAccountsProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.page,
    required this.limit,
  }) : super.internal();

  final int page;
  final int limit;

  @override
  Override overrideWith(
    FutureOr<Map<String, dynamic>> Function(PaginatedAccountsRef provider)
    create,
  ) {
    return ProviderOverride(
      origin: this,
      override: PaginatedAccountsProvider._internal(
        (ref) => create(ref as PaginatedAccountsRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        page: page,
        limit: limit,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<Map<String, dynamic>> createElement() {
    return _PaginatedAccountsProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is PaginatedAccountsProvider &&
        other.page == page &&
        other.limit == limit;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, page.hashCode);
    hash = _SystemHash.combine(hash, limit.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin PaginatedAccountsRef
    on AutoDisposeFutureProviderRef<Map<String, dynamic>> {
  /// The parameter `page` of this provider.
  int get page;

  /// The parameter `limit` of this provider.
  int get limit;
}

class _PaginatedAccountsProviderElement
    extends AutoDisposeFutureProviderElement<Map<String, dynamic>>
    with PaginatedAccountsRef {
  _PaginatedAccountsProviderElement(super.provider);

  @override
  int get page => (origin as PaginatedAccountsProvider).page;
  @override
  int get limit => (origin as PaginatedAccountsProvider).limit;
}

String _$accountsHash() => r'9dc72687b8edcd7db415f0f17911e44fd18fe3c5';

/// See also [accounts].
@ProviderFor(accounts)
final accountsProvider = AutoDisposeFutureProvider<List<Account>>.internal(
  accounts,
  name: r'accountsProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$accountsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef AccountsRef = AutoDisposeFutureProviderRef<List<Account>>;
String _$accountHash() => r'4dacdee72ddbfc63aec167033e7174821009ed6c';

/// See also [account].
@ProviderFor(account)
const accountProvider = AccountFamily();

/// See also [account].
class AccountFamily extends Family<AsyncValue<Account>> {
  /// See also [account].
  const AccountFamily();

  /// See also [account].
  AccountProvider call(String id) {
    return AccountProvider(id);
  }

  @override
  AccountProvider getProviderOverride(covariant AccountProvider provider) {
    return call(provider.id);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'accountProvider';
}

/// See also [account].
class AccountProvider extends AutoDisposeFutureProvider<Account> {
  /// See also [account].
  AccountProvider(String id)
    : this._internal(
        (ref) => account(ref as AccountRef, id),
        from: accountProvider,
        name: r'accountProvider',
        debugGetCreateSourceHash:
            const bool.fromEnvironment('dart.vm.product')
                ? null
                : _$accountHash,
        dependencies: AccountFamily._dependencies,
        allTransitiveDependencies: AccountFamily._allTransitiveDependencies,
        id: id,
      );

  AccountProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.id,
  }) : super.internal();

  final String id;

  @override
  Override overrideWith(
    FutureOr<Account> Function(AccountRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: AccountProvider._internal(
        (ref) => create(ref as AccountRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        id: id,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<Account> createElement() {
    return _AccountProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is AccountProvider && other.id == id;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, id.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin AccountRef on AutoDisposeFutureProviderRef<Account> {
  /// The parameter `id` of this provider.
  String get id;
}

class _AccountProviderElement extends AutoDisposeFutureProviderElement<Account>
    with AccountRef {
  _AccountProviderElement(super.provider);

  @override
  String get id => (origin as AccountProvider).id;
}

String _$accountsInfiniteScrollHash() =>
    r'206de014e33bcbe6d59caff23aadd8b310f31500';

/// See also [AccountsInfiniteScroll].
@ProviderFor(AccountsInfiniteScroll)
final accountsInfiniteScrollProvider = AutoDisposeAsyncNotifierProvider<
  AccountsInfiniteScroll,
  List<Account>
>.internal(
  AccountsInfiniteScroll.new,
  name: r'accountsInfiniteScrollProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$accountsInfiniteScrollHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$AccountsInfiniteScroll = AutoDisposeAsyncNotifier<List<Account>>;
String _$accountFormStateHash() => r'6132a04494c3bc3a7257928a76d50c5b2c9c15f7';

abstract class _$AccountFormState
    extends BuildlessAutoDisposeNotifier<AsyncValue<Account?>> {
  late final String? accountId;

  AsyncValue<Account?> build([String? accountId]);
}

/// See also [AccountFormState].
@ProviderFor(AccountFormState)
const accountFormStateProvider = AccountFormStateFamily();

/// See also [AccountFormState].
class AccountFormStateFamily extends Family<AsyncValue<Account?>> {
  /// See also [AccountFormState].
  const AccountFormStateFamily();

  /// See also [AccountFormState].
  AccountFormStateProvider call([String? accountId]) {
    return AccountFormStateProvider(accountId);
  }

  @override
  AccountFormStateProvider getProviderOverride(
    covariant AccountFormStateProvider provider,
  ) {
    return call(provider.accountId);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'accountFormStateProvider';
}

/// See also [AccountFormState].
class AccountFormStateProvider
    extends
        AutoDisposeNotifierProviderImpl<
          AccountFormState,
          AsyncValue<Account?>
        > {
  /// See also [AccountFormState].
  AccountFormStateProvider([String? accountId])
    : this._internal(
        () => AccountFormState()..accountId = accountId,
        from: accountFormStateProvider,
        name: r'accountFormStateProvider',
        debugGetCreateSourceHash:
            const bool.fromEnvironment('dart.vm.product')
                ? null
                : _$accountFormStateHash,
        dependencies: AccountFormStateFamily._dependencies,
        allTransitiveDependencies:
            AccountFormStateFamily._allTransitiveDependencies,
        accountId: accountId,
      );

  AccountFormStateProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.accountId,
  }) : super.internal();

  final String? accountId;

  @override
  AsyncValue<Account?> runNotifierBuild(covariant AccountFormState notifier) {
    return notifier.build(accountId);
  }

  @override
  Override overrideWith(AccountFormState Function() create) {
    return ProviderOverride(
      origin: this,
      override: AccountFormStateProvider._internal(
        () => create()..accountId = accountId,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        accountId: accountId,
      ),
    );
  }

  @override
  AutoDisposeNotifierProviderElement<AccountFormState, AsyncValue<Account?>>
  createElement() {
    return _AccountFormStateProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is AccountFormStateProvider && other.accountId == accountId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, accountId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin AccountFormStateRef
    on AutoDisposeNotifierProviderRef<AsyncValue<Account?>> {
  /// The parameter `accountId` of this provider.
  String? get accountId;
}

class _AccountFormStateProviderElement
    extends
        AutoDisposeNotifierProviderElement<
          AccountFormState,
          AsyncValue<Account?>
        >
    with AccountFormStateRef {
  _AccountFormStateProviderElement(super.provider);

  @override
  String? get accountId => (origin as AccountFormStateProvider).accountId;
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
