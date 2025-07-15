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
String _$paginatedTransactionsHash() =>
    r'67ff4178ca2a1627a8160858e9a0992ef5ded10f';

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

/// See also [paginatedTransactions].
@ProviderFor(paginatedTransactions)
const paginatedTransactionsProvider = PaginatedTransactionsFamily();

/// See also [paginatedTransactions].
class PaginatedTransactionsFamily
    extends Family<AsyncValue<Map<String, dynamic>>> {
  /// See also [paginatedTransactions].
  const PaginatedTransactionsFamily();

  /// See also [paginatedTransactions].
  PaginatedTransactionsProvider call({int page = 1, int limit = 10}) {
    return PaginatedTransactionsProvider(page: page, limit: limit);
  }

  @override
  PaginatedTransactionsProvider getProviderOverride(
    covariant PaginatedTransactionsProvider provider,
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
  String? get name => r'paginatedTransactionsProvider';
}

/// See also [paginatedTransactions].
class PaginatedTransactionsProvider
    extends AutoDisposeFutureProvider<Map<String, dynamic>> {
  /// See also [paginatedTransactions].
  PaginatedTransactionsProvider({int page = 1, int limit = 10})
    : this._internal(
        (ref) => paginatedTransactions(
          ref as PaginatedTransactionsRef,
          page: page,
          limit: limit,
        ),
        from: paginatedTransactionsProvider,
        name: r'paginatedTransactionsProvider',
        debugGetCreateSourceHash:
            const bool.fromEnvironment('dart.vm.product')
                ? null
                : _$paginatedTransactionsHash,
        dependencies: PaginatedTransactionsFamily._dependencies,
        allTransitiveDependencies:
            PaginatedTransactionsFamily._allTransitiveDependencies,
        page: page,
        limit: limit,
      );

  PaginatedTransactionsProvider._internal(
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
    FutureOr<Map<String, dynamic>> Function(PaginatedTransactionsRef provider)
    create,
  ) {
    return ProviderOverride(
      origin: this,
      override: PaginatedTransactionsProvider._internal(
        (ref) => create(ref as PaginatedTransactionsRef),
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
    return _PaginatedTransactionsProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is PaginatedTransactionsProvider &&
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
mixin PaginatedTransactionsRef
    on AutoDisposeFutureProviderRef<Map<String, dynamic>> {
  /// The parameter `page` of this provider.
  int get page;

  /// The parameter `limit` of this provider.
  int get limit;
}

class _PaginatedTransactionsProviderElement
    extends AutoDisposeFutureProviderElement<Map<String, dynamic>>
    with PaginatedTransactionsRef {
  _PaginatedTransactionsProviderElement(super.provider);

  @override
  int get page => (origin as PaginatedTransactionsProvider).page;
  @override
  int get limit => (origin as PaginatedTransactionsProvider).limit;
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

String _$transactionsInfiniteScrollHash() =>
    r'675c039496ba04d7eac6a036c840969b8678138c';

abstract class _$TransactionsInfiniteScroll
    extends BuildlessAutoDisposeAsyncNotifier<List<Transaction>> {
  late final String? categoryId;
  late final String? accountId;
  late final DateTime? startDate;
  late final DateTime? endDate;
  late final int? amountType;

  FutureOr<List<Transaction>> build({
    String? categoryId,
    String? accountId,
    DateTime? startDate,
    DateTime? endDate,
    int? amountType,
  });
}

/// See also [TransactionsInfiniteScroll].
@ProviderFor(TransactionsInfiniteScroll)
const transactionsInfiniteScrollProvider = TransactionsInfiniteScrollFamily();

/// See also [TransactionsInfiniteScroll].
class TransactionsInfiniteScrollFamily
    extends Family<AsyncValue<List<Transaction>>> {
  /// See also [TransactionsInfiniteScroll].
  const TransactionsInfiniteScrollFamily();

  /// See also [TransactionsInfiniteScroll].
  TransactionsInfiniteScrollProvider call({
    String? categoryId,
    String? accountId,
    DateTime? startDate,
    DateTime? endDate,
    int? amountType,
  }) {
    return TransactionsInfiniteScrollProvider(
      categoryId: categoryId,
      accountId: accountId,
      startDate: startDate,
      endDate: endDate,
      amountType: amountType,
    );
  }

  @override
  TransactionsInfiniteScrollProvider getProviderOverride(
    covariant TransactionsInfiniteScrollProvider provider,
  ) {
    return call(
      categoryId: provider.categoryId,
      accountId: provider.accountId,
      startDate: provider.startDate,
      endDate: provider.endDate,
      amountType: provider.amountType,
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
  String? get name => r'transactionsInfiniteScrollProvider';
}

/// See also [TransactionsInfiniteScroll].
class TransactionsInfiniteScrollProvider
    extends
        AutoDisposeAsyncNotifierProviderImpl<
          TransactionsInfiniteScroll,
          List<Transaction>
        > {
  /// See also [TransactionsInfiniteScroll].
  TransactionsInfiniteScrollProvider({
    String? categoryId,
    String? accountId,
    DateTime? startDate,
    DateTime? endDate,
    int? amountType,
  }) : this._internal(
         () =>
             TransactionsInfiniteScroll()
               ..categoryId = categoryId
               ..accountId = accountId
               ..startDate = startDate
               ..endDate = endDate
               ..amountType = amountType,
         from: transactionsInfiniteScrollProvider,
         name: r'transactionsInfiniteScrollProvider',
         debugGetCreateSourceHash:
             const bool.fromEnvironment('dart.vm.product')
                 ? null
                 : _$transactionsInfiniteScrollHash,
         dependencies: TransactionsInfiniteScrollFamily._dependencies,
         allTransitiveDependencies:
             TransactionsInfiniteScrollFamily._allTransitiveDependencies,
         categoryId: categoryId,
         accountId: accountId,
         startDate: startDate,
         endDate: endDate,
         amountType: amountType,
       );

  TransactionsInfiniteScrollProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.categoryId,
    required this.accountId,
    required this.startDate,
    required this.endDate,
    required this.amountType,
  }) : super.internal();

  final String? categoryId;
  final String? accountId;
  final DateTime? startDate;
  final DateTime? endDate;
  final int? amountType;

  @override
  FutureOr<List<Transaction>> runNotifierBuild(
    covariant TransactionsInfiniteScroll notifier,
  ) {
    return notifier.build(
      categoryId: categoryId,
      accountId: accountId,
      startDate: startDate,
      endDate: endDate,
      amountType: amountType,
    );
  }

  @override
  Override overrideWith(TransactionsInfiniteScroll Function() create) {
    return ProviderOverride(
      origin: this,
      override: TransactionsInfiniteScrollProvider._internal(
        () =>
            create()
              ..categoryId = categoryId
              ..accountId = accountId
              ..startDate = startDate
              ..endDate = endDate
              ..amountType = amountType,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        categoryId: categoryId,
        accountId: accountId,
        startDate: startDate,
        endDate: endDate,
        amountType: amountType,
      ),
    );
  }

  @override
  AutoDisposeAsyncNotifierProviderElement<
    TransactionsInfiniteScroll,
    List<Transaction>
  >
  createElement() {
    return _TransactionsInfiniteScrollProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is TransactionsInfiniteScrollProvider &&
        other.categoryId == categoryId &&
        other.accountId == accountId &&
        other.startDate == startDate &&
        other.endDate == endDate &&
        other.amountType == amountType;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, categoryId.hashCode);
    hash = _SystemHash.combine(hash, accountId.hashCode);
    hash = _SystemHash.combine(hash, startDate.hashCode);
    hash = _SystemHash.combine(hash, endDate.hashCode);
    hash = _SystemHash.combine(hash, amountType.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin TransactionsInfiniteScrollRef
    on AutoDisposeAsyncNotifierProviderRef<List<Transaction>> {
  /// The parameter `categoryId` of this provider.
  String? get categoryId;

  /// The parameter `accountId` of this provider.
  String? get accountId;

  /// The parameter `startDate` of this provider.
  DateTime? get startDate;

  /// The parameter `endDate` of this provider.
  DateTime? get endDate;

  /// The parameter `amountType` of this provider.
  int? get amountType;
}

class _TransactionsInfiniteScrollProviderElement
    extends
        AutoDisposeAsyncNotifierProviderElement<
          TransactionsInfiniteScroll,
          List<Transaction>
        >
    with TransactionsInfiniteScrollRef {
  _TransactionsInfiniteScrollProviderElement(super.provider);

  @override
  String? get categoryId =>
      (origin as TransactionsInfiniteScrollProvider).categoryId;
  @override
  String? get accountId =>
      (origin as TransactionsInfiniteScrollProvider).accountId;
  @override
  DateTime? get startDate =>
      (origin as TransactionsInfiniteScrollProvider).startDate;
  @override
  DateTime? get endDate =>
      (origin as TransactionsInfiniteScrollProvider).endDate;
  @override
  int? get amountType =>
      (origin as TransactionsInfiniteScrollProvider).amountType;
}

String _$transactionFormStateHash() =>
    r'a0197c16962c7400ebf2756c70f8687b8d431019';

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
