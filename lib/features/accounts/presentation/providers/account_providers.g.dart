// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'account_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$accountsHash() => r'a3d2fa750bd9c818572b7efc1e2890d20cd95c08';

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
String _$accountHash() => r'd3e1589582ff3279a742e5ce3be8dbd8ef509a0f';

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

String _$totalBalanceHash() => r'31d8b5eb9e919d689efb710fe9f5c37e2b0f4bfd';

/// See also [totalBalance].
@ProviderFor(totalBalance)
final totalBalanceProvider = AutoDisposeFutureProvider<double>.internal(
  totalBalance,
  name: r'totalBalanceProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$totalBalanceHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef TotalBalanceRef = AutoDisposeFutureProviderRef<double>;
String _$accountFormStateHash() => r'4fe54cfe1fc77eea02c3a781e7f719211d53522d';

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
