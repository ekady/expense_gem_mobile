import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../../domain/entities/category.dart';
import '../../domain/repositories/category_repository.dart';

class CategoryRepositoryImpl implements CategoryRepository {
  // This would typically have data sources injected
  
  @override
  Future<Either<Failure, List<Category>>> getCategories() async {
    try {
      // Mock data for now
      return Right([
        Category(
          id: '1',
          name: 'Food',
          icon: 'restaurant',
          colorHex: '#F44336',
          type: 'expense',
          isDefault: true,
          createdAt: DateTime.now().subtract(const Duration(days: 30)),
        ),
        Category(
          id: '2',
          name: 'Transport',
          icon: 'directions_car',
          colorHex: '#2196F3',
          type: 'expense',
          isDefault: true,
          createdAt: DateTime.now().subtract(const Duration(days: 30)),
        ),
        Category(
          id: '3',
          name: 'Shopping',
          icon: 'shopping_cart',
          colorHex: '#4CAF50',
          type: 'expense',
          isDefault: true,
          createdAt: DateTime.now().subtract(const Duration(days: 30)),
        ),
        Category(
          id: '4',
          name: 'Entertainment',
          icon: 'movie',
          colorHex: '#FF9800',
          type: 'expense',
          isDefault: true,
          createdAt: DateTime.now().subtract(const Duration(days: 30)),
        ),
        Category(
          id: '5',
          name: 'Bills',
          icon: 'receipt',
          colorHex: '#9C27B0',
          type: 'expense',
          isDefault: true,
          createdAt: DateTime.now().subtract(const Duration(days: 30)),
        ),
        Category(
          id: '6',
          name: 'Health',
          icon: 'local_hospital',
          colorHex: '#009688',
          type: 'expense',
          isDefault: true,
          createdAt: DateTime.now().subtract(const Duration(days: 30)),
        ),
        Category(
          id: '7',
          name: 'Salary',
          icon: 'account_balance_wallet',
          colorHex: '#4CAF50',
          type: 'income',
          isDefault: true,
          createdAt: DateTime.now().subtract(const Duration(days: 30)),
        ),
        Category(
          id: '8',
          name: 'Investment',
          icon: 'trending_up',
          colorHex: '#2196F3',
          type: 'income',
          isDefault: true,
          createdAt: DateTime.now().subtract(const Duration(days: 30)),
        ),
      ]);
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }
  
  @override
  Future<Either<Failure, List<Category>>> getCategoriesByType(String type) async {
    try {
      final categoriesResult = await getCategories();
      
      return categoriesResult.fold(
        (failure) => Left(failure),
        (categories) {
          final filtered = categories.where((c) => c.type == type).toList();
          return Right(filtered);
        },
      );
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }
  
  @override
  Future<Either<Failure, Category>> getCategoryById(String id) async {
    try {
      final categoriesResult = await getCategories();
      
      return categoriesResult.fold(
        (failure) => Left(failure),
        (categories) {
          final category = categories.firstWhere(
            (c) => c.id == id,
            orElse: () => throw Exception('Category not found'),
          );
          return Right(category);
        },
      );
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }
  
  @override
  Future<Either<Failure, Category>> createCategory(Category category) async {
    try {
      // In a real app, this would add to storage
      return Right(
        category.copyWith(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          createdAt: DateTime.now(),
        ),
      );
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }
  
  @override
  Future<Either<Failure, Category>> updateCategory(Category category) async {
    try {
      // In a real app, this would update in storage
      return Right(
        category.copyWith(
          updatedAt: DateTime.now(),
        ),
      );
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }
  
  @override
  Future<Either<Failure, void>> deleteCategory(String id) async {
    try {
      // In a real app, this would delete from storage
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }
}