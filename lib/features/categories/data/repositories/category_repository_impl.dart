import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';

import '../../../../core/error/failures.dart';
import '../../domain/entities/category.dart';
import '../../domain/repositories/category_repository.dart';
import '../datasources/category_local_data_source.dart';
import '../datasources/category_remote_data_source.dart';

class CategoryRepositoryImpl implements CategoryRepository {
  final CategoryRemoteDataSource remoteDataSource;
  final CategoryLocalDataSource localDataSource;

  CategoryRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  @override
  Future<Either<Failure, List<Category>>> getCategories({
    int page = 1,
    int limit = 20,
  }) async {
    try {
      // Always try remote first
      final result = await remoteDataSource.getCategories(
        page: page,
        limit: limit,
      );
      final categories = result['categories'] as List<Category>;
      // Save to local cache
      await localDataSource.saveCategories(categories);
      return Right(categories);
    } on DioException catch (e) {
      // On network error, try local cache
      final cachedCategories = await localDataSource.getCategories();
      if (cachedCategories.isNotEmpty) {
        return Right(cachedCategories);
      }
      return Left(
        ServerFailure(message: e.message ?? 'An unexpected error occurred'),
      );
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<Category>>> getCategoriesByType(
    String type,
  ) async {
    try {
      final categoriesResult = await getCategories();

      return categoriesResult.fold((failure) => Left(failure), (categories) {
        final filtered = categories.toList();
        return Right(filtered);
      });
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, Category>> getCategoryById(String id) async {
    try {
      // Always try remote first
      final remoteCategory = await remoteDataSource.getCategoryById(id);
      await localDataSource.saveCategory(remoteCategory);
      return Right(remoteCategory);
    } on DioException catch (e) {
      // On network error, try local cache
      final cachedCategory = await localDataSource.getCategoryById(id);
      if (cachedCategory != null) {
        return Right(cachedCategory);
      }
      return Left(
        ServerFailure(message: e.message ?? 'An unexpected error occurred'),
      );
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, Category>> createCategory(Category category) async {
    try {
      final createdCategory = await remoteDataSource.createCategory(category);
      await localDataSource.saveCategory(createdCategory);
      return Right(createdCategory);
    } on DioException catch (e) {
      return Left(
        ServerFailure(message: e.message ?? 'An unexpected error occurred'),
      );
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, Category>> updateCategory(Category category) async {
    try {
      final updatedCategory = await remoteDataSource.updateCategory(category);
      await localDataSource.saveCategory(updatedCategory);
      return Right(updatedCategory);
    } on DioException catch (e) {
      return Left(
        ServerFailure(message: e.message ?? 'An unexpected error occurred'),
      );
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> deleteCategory(String id) async {
    try {
      await remoteDataSource.deleteCategory(id);
      await localDataSource.deleteCategory(id);
      return const Right(null);
    } on DioException catch (e) {
      return Left(
        ServerFailure(message: e.message ?? 'An unexpected error occurred'),
      );
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }
}
