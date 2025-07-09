import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/services/service_locator.dart';
import '../../domain/entities/category.dart';
import '../../domain/repositories/category_repository.dart';
import '../../domain/usecases/create_category_usecase.dart';
import '../../domain/usecases/delete_category_usecase.dart';
import '../../domain/usecases/get_category_by_id_usecase.dart';
import '../../domain/usecases/get_categories_usecase.dart';
import '../../domain/usecases/update_category_usecase.dart';

part 'category_providers.g.dart';

// Use Cases Providers
@riverpod
GetCategoriesUseCase getCategoriesUseCase(Ref ref) {
  return GetCategoriesUseCase(getIt<CategoryRepository>());
}

@riverpod
GetCategoryByIdUseCase getCategoryByIdUseCase(Ref ref) {
  return GetCategoryByIdUseCase(getIt<CategoryRepository>());
}

@riverpod
CreateCategoryUseCase createCategoryUseCase(Ref ref) {
  return CreateCategoryUseCase(getIt<CategoryRepository>());
}

@riverpod
UpdateCategoryUseCase updateCategoryUseCase(Ref ref) {
  return UpdateCategoryUseCase(getIt<CategoryRepository>());
}

@riverpod
DeleteCategoryUseCase deleteCategoryUseCase(Ref ref) {
  return DeleteCategoryUseCase(getIt<CategoryRepository>());
}

// All categories provider
@riverpod
Future<List<Category>> categories(Ref ref) async {
  final useCase = ref.watch(getCategoriesUseCaseProvider);
  final result = await useCase.call();

  return result.fold(
    (failure) => throw failure.message,
    (categories) => categories,
  );
}

// Categories by type provider (deprecated - type field removed)
@riverpod
Future<List<Category>> categoriesByType(Ref ref, String type) async {
  final useCase = ref.watch(getCategoriesUseCaseProvider);
  final result = await useCase.call();

  return result.fold(
    (failure) => throw failure.message,
    (categories) => categories, // Return all categories since type is no longer a field
  );
}

// Single category provider
@riverpod
Future<Category> category(Ref ref, String id) async {
  final useCase = ref.watch(getCategoryByIdUseCaseProvider);
  final result = await useCase.call(id);

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
      return const AsyncValue.loading();
    }
    return const AsyncValue.data(null);
  }

  Future<void> _loadCategory(String id) async {
    state = const AsyncValue.loading();

    final useCase = ref.read(getCategoryByIdUseCaseProvider);
    final result = await useCase.call(id);

    state = result.fold(
      (failure) => AsyncValue.error(failure.message, StackTrace.current),
      (category) => AsyncValue.data(category),
    );
  }

  Future<void> saveCategory(Category category) async {
    state = const AsyncValue.loading();

    final result = category.id.isEmpty
        ? await ref.read(createCategoryUseCaseProvider).call(category)
        : await ref.read(updateCategoryUseCaseProvider).call(category);

    state = result.fold(
      (failure) => AsyncValue.error(failure.message, StackTrace.current),
      (savedCategory) {
        // Invalidate and refresh all category-related providers
        ref.invalidate(categoriesProvider);
        
        return AsyncValue.data(savedCategory);
      },
    );
  }

  Future<void> deleteCategory(String id) async {
    state = const AsyncValue.loading();

    final useCase = ref.read(deleteCategoryUseCaseProvider);
    final result = await useCase.call(id);

    result.fold(
      (failure) {
        state = AsyncValue.error(failure.message, StackTrace.current);
      },
      (_) {
        // Invalidate and refresh all category-related providers
        ref.invalidate(categoriesProvider);
        
        state = const AsyncValue.data(null);
      },
    );
  }
}
