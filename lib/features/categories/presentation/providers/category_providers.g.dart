// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'category_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$categoriesHash() => r'cf249e481f73e5e666ec32d47499489a1be74c3c';

/// See also [categories].
@ProviderFor(categories)
final categoriesProvider = AutoDisposeFutureProvider<List<Category>>.internal(
  categories,
  name: r'categoriesProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$categoriesHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef CategoriesRef = AutoDisposeFutureProviderRef<List<Category>>;
String _$categoriesByTypeHash() => r'45d82f163caafb9b697563ec4b9769d3cee558f1';

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

/// See also [categoriesByType].
@ProviderFor(categoriesByType)
const categoriesByTypeProvider = CategoriesByTypeFamily();

/// See also [categoriesByType].
class CategoriesByTypeFamily extends Family<AsyncValue<List<Category>>> {
  /// See also [categoriesByType].
  const CategoriesByTypeFamily();

  /// See also [categoriesByType].
  CategoriesByTypeProvider call(String type) {
    return CategoriesByTypeProvider(type);
  }

  @override
  CategoriesByTypeProvider getProviderOverride(
    covariant CategoriesByTypeProvider provider,
  ) {
    return call(provider.type);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'categoriesByTypeProvider';
}

/// See also [categoriesByType].
class CategoriesByTypeProvider
    extends AutoDisposeFutureProvider<List<Category>> {
  /// See also [categoriesByType].
  CategoriesByTypeProvider(String type)
    : this._internal(
        (ref) => categoriesByType(ref as CategoriesByTypeRef, type),
        from: categoriesByTypeProvider,
        name: r'categoriesByTypeProvider',
        debugGetCreateSourceHash:
            const bool.fromEnvironment('dart.vm.product')
                ? null
                : _$categoriesByTypeHash,
        dependencies: CategoriesByTypeFamily._dependencies,
        allTransitiveDependencies:
            CategoriesByTypeFamily._allTransitiveDependencies,
        type: type,
      );

  CategoriesByTypeProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.type,
  }) : super.internal();

  final String type;

  @override
  Override overrideWith(
    FutureOr<List<Category>> Function(CategoriesByTypeRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: CategoriesByTypeProvider._internal(
        (ref) => create(ref as CategoriesByTypeRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        type: type,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<List<Category>> createElement() {
    return _CategoriesByTypeProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is CategoriesByTypeProvider && other.type == type;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, type.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin CategoriesByTypeRef on AutoDisposeFutureProviderRef<List<Category>> {
  /// The parameter `type` of this provider.
  String get type;
}

class _CategoriesByTypeProviderElement
    extends AutoDisposeFutureProviderElement<List<Category>>
    with CategoriesByTypeRef {
  _CategoriesByTypeProviderElement(super.provider);

  @override
  String get type => (origin as CategoriesByTypeProvider).type;
}

String _$categoryHash() => r'10d6afd98656ccbba66c25c380c4a66cca3e81bf';

/// See also [category].
@ProviderFor(category)
const categoryProvider = CategoryFamily();

/// See also [category].
class CategoryFamily extends Family<AsyncValue<Category>> {
  /// See also [category].
  const CategoryFamily();

  /// See also [category].
  CategoryProvider call(String id) {
    return CategoryProvider(id);
  }

  @override
  CategoryProvider getProviderOverride(covariant CategoryProvider provider) {
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
  String? get name => r'categoryProvider';
}

/// See also [category].
class CategoryProvider extends AutoDisposeFutureProvider<Category> {
  /// See also [category].
  CategoryProvider(String id)
    : this._internal(
        (ref) => category(ref as CategoryRef, id),
        from: categoryProvider,
        name: r'categoryProvider',
        debugGetCreateSourceHash:
            const bool.fromEnvironment('dart.vm.product')
                ? null
                : _$categoryHash,
        dependencies: CategoryFamily._dependencies,
        allTransitiveDependencies: CategoryFamily._allTransitiveDependencies,
        id: id,
      );

  CategoryProvider._internal(
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
    FutureOr<Category> Function(CategoryRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: CategoryProvider._internal(
        (ref) => create(ref as CategoryRef),
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
  AutoDisposeFutureProviderElement<Category> createElement() {
    return _CategoryProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is CategoryProvider && other.id == id;
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
mixin CategoryRef on AutoDisposeFutureProviderRef<Category> {
  /// The parameter `id` of this provider.
  String get id;
}

class _CategoryProviderElement
    extends AutoDisposeFutureProviderElement<Category>
    with CategoryRef {
  _CategoryProviderElement(super.provider);

  @override
  String get id => (origin as CategoryProvider).id;
}

String _$categoryFormStateHash() => r'c0bce0d9ce84dec52d3c16987478ee2ce3819aeb';

abstract class _$CategoryFormState
    extends BuildlessAutoDisposeNotifier<AsyncValue<Category?>> {
  late final String? categoryId;

  AsyncValue<Category?> build([String? categoryId]);
}

/// See also [CategoryFormState].
@ProviderFor(CategoryFormState)
const categoryFormStateProvider = CategoryFormStateFamily();

/// See also [CategoryFormState].
class CategoryFormStateFamily extends Family<AsyncValue<Category?>> {
  /// See also [CategoryFormState].
  const CategoryFormStateFamily();

  /// See also [CategoryFormState].
  CategoryFormStateProvider call([String? categoryId]) {
    return CategoryFormStateProvider(categoryId);
  }

  @override
  CategoryFormStateProvider getProviderOverride(
    covariant CategoryFormStateProvider provider,
  ) {
    return call(provider.categoryId);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'categoryFormStateProvider';
}

/// See also [CategoryFormState].
class CategoryFormStateProvider
    extends
        AutoDisposeNotifierProviderImpl<
          CategoryFormState,
          AsyncValue<Category?>
        > {
  /// See also [CategoryFormState].
  CategoryFormStateProvider([String? categoryId])
    : this._internal(
        () => CategoryFormState()..categoryId = categoryId,
        from: categoryFormStateProvider,
        name: r'categoryFormStateProvider',
        debugGetCreateSourceHash:
            const bool.fromEnvironment('dart.vm.product')
                ? null
                : _$categoryFormStateHash,
        dependencies: CategoryFormStateFamily._dependencies,
        allTransitiveDependencies:
            CategoryFormStateFamily._allTransitiveDependencies,
        categoryId: categoryId,
      );

  CategoryFormStateProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.categoryId,
  }) : super.internal();

  final String? categoryId;

  @override
  AsyncValue<Category?> runNotifierBuild(covariant CategoryFormState notifier) {
    return notifier.build(categoryId);
  }

  @override
  Override overrideWith(CategoryFormState Function() create) {
    return ProviderOverride(
      origin: this,
      override: CategoryFormStateProvider._internal(
        () => create()..categoryId = categoryId,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        categoryId: categoryId,
      ),
    );
  }

  @override
  AutoDisposeNotifierProviderElement<CategoryFormState, AsyncValue<Category?>>
  createElement() {
    return _CategoryFormStateProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is CategoryFormStateProvider && other.categoryId == categoryId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, categoryId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin CategoryFormStateRef
    on AutoDisposeNotifierProviderRef<AsyncValue<Category?>> {
  /// The parameter `categoryId` of this provider.
  String? get categoryId;
}

class _CategoryFormStateProviderElement
    extends
        AutoDisposeNotifierProviderElement<
          CategoryFormState,
          AsyncValue<Category?>
        >
    with CategoryFormStateRef {
  _CategoryFormStateProviderElement(super.provider);

  @override
  String? get categoryId => (origin as CategoryFormStateProvider).categoryId;
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
