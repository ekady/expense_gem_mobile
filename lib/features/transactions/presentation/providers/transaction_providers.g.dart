// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'transaction_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$transactionsHash() => r'f0173603f85777ae4a47b381d4982023e053608c';

/// See also [transactions].
@ProviderFor(transactions)
final transactionsProvider =
    AutoDisposeFutureProvider<List<Transaction>>.internal(
      transactions,
      name: r'transactionsProvider',
      debugGetCreateSourceHash:
          const bool.fromEnvironment('dart.vm.product')
              ? null
              : _$transactionsHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef TransactionsRef = AutoDisposeFutureProviderRef<List<Transaction>>;
String _$filteredTransactionsHash() =>
    r'd87ddd57b6c82ac6bc276bcb6268784310d3f57d';

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

/// See also [filteredTransactions].
@ProviderFor(filteredTransactions)
const filteredTransactionsProvider = FilteredTransactionsFamily();

/// See also [filteredTransactions].
class FilteredTransactionsFamily extends Family<AsyncValue<List<Transaction>>> {
  /// See also [filteredTransactions].
  const FilteredTransactionsFamily();

  /// See also [filteredTransactions].
  FilteredTransactionsProvider call({
    String? type,
    String? categoryId,
    String? accountId,
    DateTimeRange? dateRange,
  }) {
    return FilteredTransactionsProvider(
      type: type,
      categoryId: categoryId,
      accountId: accountId,
      dateRange: dateRange,
    );
  }

  @override
  FilteredTransactionsProvider getProviderOverride(
    covariant FilteredTransactionsProvider provider,
  ) {
    return call(
      type: provider.type,
      categoryId: provider.categoryId,
      accountId: provider.accountId,
      dateRange: provider.dateRange,
    );
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'filteredTransactionsProvider';
}

/// See also [filteredTransactions].
class FilteredTransactionsProvider
    extends AutoDisposeFutureProvider<List<Transaction>> {
  /// See also [filteredTransactions].
  FilteredTransactionsProvider({
    String? type,
    String? categoryId,
    String? accountId,
    DateTimeRange? dateRange,
  }) : this._internal(
         (ref) => filteredTransactions(
           ref as FilteredTransactionsRef,
           type: type,
           categoryId: categoryId,
           accountId: accountId,
           dateRange: dateRange,
         ),
         from: filteredTransactionsProvider,
         name: r'filteredTransactionsProvider',
         debugGetCreateSourceHash:
             const bool.fromEnvironment('dart.vm.product')
                 ? null
                 : _$filteredTransactionsHash,
         dependencies: FilteredTransactionsFamily._dependencies,
         allTransitiveDependencies:
             FilteredTransactionsFamily._allTransitiveDependencies,
         type: type,
         categoryId: categoryId,
         accountId: accountId,
         dateRange: dateRange,
       );

  FilteredTransactionsProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.type,
    required this.categoryId,
    required this.accountId,
    required this.dateRange,
  }) : super.internal();

  final String? type;
  final String? categoryId;
  final String? accountId;
  final DateTimeRange? dateRange;

  @override
  Override overrideWith(
    FutureOr<List<Transaction>> Function(FilteredTransactionsRef provider)
    create,
  ) {
    return ProviderOverride(
      origin: this,
      override: FilteredTransactionsProvider._internal(
        (ref) => create(ref as FilteredTransactionsRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        type: type,
        categoryId: categoryId,
        accountId: accountId,
        dateRange: dateRange,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<List<Transaction>> createElement() {
    return _FilteredTransactionsProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is FilteredTransactionsProvider &&
        other.type == type &&
        other.categoryId == categoryId &&
        other.accountId == accountId &&
        other.dateRange == dateRange;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, type.hashCode);
    hash = _SystemHash.combine(hash, categoryId.hashCode);
    hash = _SystemHash.combine(hash, accountId.hashCode);
    hash = _SystemHash.combine(hash, dateRange.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin FilteredTransactionsRef
    on AutoDisposeFutureProviderRef<List<Transaction>> {
  /// The parameter `type` of this provider.
  String? get type;

  /// The parameter `categoryId` of this provider.
  String? get categoryId;

  /// The parameter `accountId` of this provider.
  String? get accountId;

  /// The parameter `dateRange` of this provider.
  DateTimeRange? get dateRange;
}

class _FilteredTransactionsProviderElement
    extends AutoDisposeFutureProviderElement<List<Transaction>>
    with FilteredTransactionsRef {
  _FilteredTransactionsProviderElement(super.provider);

  @override
  String? get type => (origin as FilteredTransactionsProvider).type;
  @override
  String? get categoryId => (origin as FilteredTransactionsProvider).categoryId;
  @override
  String? get accountId => (origin as FilteredTransactionsProvider).accountId;
  @override
  DateTimeRange? get dateRange =>
      (origin as FilteredTransactionsProvider).dateRange;
}

String _$transactionHash() => r'0a0fdb63054520197c441c2bde9b0d7385d40224';

/// See also [transaction].
@ProviderFor(transaction)
const transactionProvider = TransactionFamily();

/// See also [transaction].
class TransactionFamily extends Family<AsyncValue<Transaction>> {
  /// See also [transaction].
  const TransactionFamily();

  /// See also [transaction].
  TransactionProvider call(String id) {
    return TransactionProvider(id);
  }

  @override
  TransactionProvider getProviderOverride(
    covariant TransactionProvider provider,
  ) {
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
  String? get name => r'transactionProvider';
}

/// See also [transaction].
class TransactionProvider extends AutoDisposeFutureProvider<Transaction> {
  /// See also [transaction].
  TransactionProvider(String id)
    : this._internal(
        (ref) => transaction(ref as TransactionRef, id),
        from: transactionProvider,
        name: r'transactionProvider',
        debugGetCreateSourceHash:
            const bool.fromEnvironment('dart.vm.product')
                ? null
                : _$transactionHash,
        dependencies: TransactionFamily._dependencies,
        allTransitiveDependencies: TransactionFamily._allTransitiveDependencies,
        id: id,
      );

  TransactionProvider._internal(
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
    FutureOr<Transaction> Function(TransactionRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: TransactionProvider._internal(
        (ref) => create(ref as TransactionRef),
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
  AutoDisposeFutureProviderElement<Transaction> createElement() {
    return _TransactionProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is TransactionProvider && other.id == id;
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
mixin TransactionRef on AutoDisposeFutureProviderRef<Transaction> {
  /// The parameter `id` of this provider.
  String get id;
}

class _TransactionProviderElement
    extends AutoDisposeFutureProviderElement<Transaction>
    with TransactionRef {
  _TransactionProviderElement(super.provider);

  @override
  String get id => (origin as TransactionProvider).id;
}

String _$transactionFormStateHash() =>
    r'7064ac232aed4774263d49911939d70dcdc90c89';

abstract class _$TransactionFormState
    extends BuildlessAutoDisposeNotifier<AsyncValue<Transaction?>> {
  late final String? transactionId;

  AsyncValue<Transaction?> build([String? transactionId]);
}

/// See also [TransactionFormState].
@ProviderFor(TransactionFormState)
const transactionFormStateProvider = TransactionFormStateFamily();

/// See also [TransactionFormState].
class TransactionFormStateFamily extends Family<AsyncValue<Transaction?>> {
  /// See also [TransactionFormState].
  const TransactionFormStateFamily();

  /// See also [TransactionFormState].
  TransactionFormStateProvider call([String? transactionId]) {
    return TransactionFormStateProvider(transactionId);
  }

  @override
  TransactionFormStateProvider getProviderOverride(
    covariant TransactionFormStateProvider provider,
  ) {
    return call(provider.transactionId);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'transactionFormStateProvider';
}

/// See also [TransactionFormState].
class TransactionFormStateProvider
    extends
        AutoDisposeNotifierProviderImpl<
          TransactionFormState,
          AsyncValue<Transaction?>
        > {
  /// See also [TransactionFormState].
  TransactionFormStateProvider([String? transactionId])
    : this._internal(
        () => TransactionFormState()..transactionId = transactionId,
        from: transactionFormStateProvider,
        name: r'transactionFormStateProvider',
        debugGetCreateSourceHash:
            const bool.fromEnvironment('dart.vm.product')
                ? null
                : _$transactionFormStateHash,
        dependencies: TransactionFormStateFamily._dependencies,
        allTransitiveDependencies:
            TransactionFormStateFamily._allTransitiveDependencies,
        transactionId: transactionId,
      );

  TransactionFormStateProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.transactionId,
  }) : super.internal();

  final String? transactionId;

  @override
  AsyncValue<Transaction?> runNotifierBuild(
    covariant TransactionFormState notifier,
  ) {
    return notifier.build(transactionId);
  }

  @override
  Override overrideWith(TransactionFormState Function() create) {
    return ProviderOverride(
      origin: this,
      override: TransactionFormStateProvider._internal(
        () => create()..transactionId = transactionId,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        transactionId: transactionId,
      ),
    );
  }

  @override
  AutoDisposeNotifierProviderElement<
    TransactionFormState,
    AsyncValue<Transaction?>
  >
  createElement() {
    return _TransactionFormStateProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is TransactionFormStateProvider &&
        other.transactionId == transactionId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, transactionId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin TransactionFormStateRef
    on AutoDisposeNotifierProviderRef<AsyncValue<Transaction?>> {
  /// The parameter `transactionId` of this provider.
  String? get transactionId;
}

class _TransactionFormStateProviderElement
    extends
        AutoDisposeNotifierProviderElement<
          TransactionFormState,
          AsyncValue<Transaction?>
        >
    with TransactionFormStateRef {
  _TransactionFormStateProviderElement(super.provider);

  @override
  String? get transactionId =>
      (origin as TransactionFormStateProvider).transactionId;
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
