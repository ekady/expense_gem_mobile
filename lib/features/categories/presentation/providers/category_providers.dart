import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/services/service_locator.dart';
import '../../domain/entities/category.dart';
import '../../domain/repositories/category_repository.dart';

part 'category_providers.g.dart';

// Repository provider
final categoryRepositoryProvider = Provider<CategoryRepository>((ref) {
  return getIt<CategoryRepository>();
});

// All categories provider
@riverpod
Future<List<Category>> categories(Ref ref) async {
  final repository = ref.watch(categoryRepositoryProvider);
  final result = await repository.getCategories();

  return result.fold(
    (failure) => throw failure.message,
    (categories) => categories,
  );
}

// Categories by type provider
@riverpod
Future<List<Category>> categoriesByType(Ref ref, String type) async {
  final repository = ref.watch(categoryRepositoryProvider);
  final result = await repository.getCategoriesByType(type);

  return result.fold(
    (failure) => throw failure.message,
    (categories) => categories,
  );
}

// Single category provider
@riverpod
Future<Category> category(Ref ref, String id) async {
  final repository = ref.watch(categoryRepositoryProvider);
  final result = await repository.getCategoryById(id);

  return result.fold(
    (failure) => throw failure.message,
    (category) => category,
  );
}

// Category form provider
@riverpod
class CategoryFormState extends _$CategoryFormState {
  @override
  AsyncValue<Category?> build([String? categoryId]) {
    if (categoryId != null) {
      _loadCategory(categoryId);
    }
    return const AsyncValue.data(null);
  }

  Future<void> _loadCategory(String id) async {
    state = const AsyncValue.loading();

    final repository = ref.read(categoryRepositoryProvider);
    final result = await repository.getCategoryById(id);

    state = result.fold(
      (failure) => AsyncValue.error(failure.message, StackTrace.current),
      (category) => AsyncValue.data(category),
    );
  }

  Future<void> saveCategory(Category category) async {
    state = const AsyncValue.loading();

    final repository = ref.read(categoryRepositoryProvider);
    final result =
        category.id.isEmpty
            ? await repository.createCategory(category)
            : await repository.updateCategory(category);

    state = result.fold(
      (failure) => AsyncValue.error(failure.message, StackTrace.current),
      (savedCategory) {
        ref.invalidate(categoriesProvider);
        ref.invalidate(categoriesByTypeProvider(category.type));
        return AsyncValue.data(savedCategory);
      },
    );
  }

  Future<void> deleteCategory(String id) async {
    state = const AsyncValue.loading();

    // First get the category to know its type
    final categoryType = state.value?.type ?? 'expense';

    final repository = ref.read(categoryRepositoryProvider);
    final result = await repository.deleteCategory(id);

    result.fold(
      (failure) {
        state = AsyncValue.error(failure.message, StackTrace.current);
      },
      (_) {
        ref.invalidate(categoriesProvider);
        ref.invalidate(categoriesByTypeProvider(categoryType));
        state = const AsyncValue.data(null);
      },
    );
  }
}
