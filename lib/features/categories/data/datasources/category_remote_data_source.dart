import 'package:dio/dio.dart';
import 'package:logger/logger.dart';

import '../../../../core/entities/pagination.dart';
import '../../../../core/error/custom_exception.dart';
import '../../domain/entities/category.dart';

abstract class CategoryRemoteDataSource {
  Future<Map<String, dynamic>> getCategories({int page = 1, int limit = 10});
  Future<Category> getCategoryById(String id);
  Future<Category> createCategory(Category category);
  Future<Category> updateCategory(Category category);
  Future<void> deleteCategory(String id);
}

class CategoryRemoteDataSourceImpl implements CategoryRemoteDataSource {
  final Dio dio;
  final Logger logger;

  CategoryRemoteDataSourceImpl({required this.dio, required this.logger});

  @override
  Future<Map<String, dynamic>> getCategories({int page = 1, int limit = 10}) async {
    try {
      final response = await dio.get('/categories', queryParameters: {
        'page': page,
        'limit': limit,
        'sort': 'createdAt|desc',
      });
      
      final data = response.data['data'];
      final List<dynamic> categoriesData = data['data'];
      final paginationData = data['pagination'];
      
      final categories = categoriesData.map((json) => _categoryFromJson(json)).toList();
      final pagination = Pagination.fromJson(paginationData);
      
      return {
        'categories': categories,
        'pagination': pagination,
      };
    } on DioException catch (e) {
      logger.e('Get categories error: ${e.message}');
      throw _handleDioError(e);
    } catch (e) {
      logger.e('Unexpected get categories error: $e');
      throw Exception('An unexpected error occurred. Please try again.');
    }
  }

  @override
  Future<Category> getCategoryById(String id) async {
    try {
      final response = await dio.get('/categories/$id');
      return _categoryFromJson(response.data['data']);
    } on DioException catch (e) {
      logger.e('Get category by id error: ${e.message}');
      throw _handleDioError(e);
    } catch (e) {
      logger.e('Unexpected get category by id error: $e');
      throw Exception('An unexpected error occurred. Please try again.');
    }
  }

  @override
  Future<Category> createCategory(Category category) async {
    try {
      final response = await dio.post(
        '/categories',
        data: _categoryToJson(category),
      );
      return _categoryFromJson(response.data['data']);
    } on DioException catch (e) {
      logger.e('Create category error: ${e.message}');
      throw _handleDioError(e);
    } catch (e) {
      logger.e('Unexpected create category error: $e');
      throw Exception('An unexpected error occurred. Please try again.');
    }
  }

  @override
  Future<Category> updateCategory(Category category) async {
    try {
      final response = await dio.put(
        '/categories/${category.id}',
        data: _categoryToJson(category),
      );
      return _categoryFromJson(response.data['data']);
    } on DioException catch (e) {
      logger.e('Update category error: ${e.message}');
      throw _handleDioError(e);
    } catch (e) {
      logger.e('Unexpected update category error: $e');
      throw Exception('An unexpected error occurred. Please try again.');
    }
  }

  @override
  Future<void> deleteCategory(String id) async {
    try {
      await dio.delete('/categories/$id');
    } on DioException catch (e) {
      logger.e('Delete category error: ${e.message}');
      throw _handleDioError(e);
    } catch (e) {
      logger.e('Unexpected delete category error: $e');
      throw Exception('An unexpected error occurred. Please try again.');
    }
  }

  Category _categoryFromJson(Map<String, dynamic> json) {
    return Category(
      id: json['id'] ?? '',
      name: json['name'],
      description: json['description'],
      icon: json['icon'] ?? '',
      color: json['color'] ?? '#2196F3',
      createdAt: json['createdAt'] != null 
          ? DateTime.parse(json['createdAt']) 
          : null,
      updatedAt: json['updatedAt'] != null 
          ? DateTime.parse(json['updatedAt']) 
          : null,
    );
  }

  Map<String, dynamic> _categoryToJson(Category category) {
    return {
      'name': category.name,
      'description': category.description,
      'icon': category.icon,
      'color': category.color,
    };
  }

  Exception _handleDioError(DioException e) {
    if (e.type == DioExceptionType.connectionTimeout) {
      return CustomException(
        'Connection timeout. Please check your internet connection.',
      );
    } else if (e.type == DioExceptionType.receiveTimeout) {
      return CustomException(
        'Server is taking too long to respond. Please try again later.',
      );
    } else if (e.type == DioExceptionType.connectionError) {
      return CustomException(
        'No internet connection. Please check your network settings.',
      );
    } else if (e.response != null) {
      final statusCode = e.response!.statusCode;
      final responseData = e.response!.data?['errors']?[0] as Map<String, dynamic>?;

      if (responseData != null && responseData.containsKey('message')) {
        return CustomException(responseData['message']);
      } else if (statusCode == 401) {
        return CustomException(
          'Unauthorized. Please log in again.',
        );
      } else if (statusCode == 422) {
        return CustomException(
          'Validation error. Please check your inputs and try again.',
        );
      } else if (statusCode == 404) {
        return CustomException('Category not found.');
      } else if (statusCode == 500) {
        return CustomException('Server error. Please try again later.');
      } else {
        return CustomException('An error occurred. Please try again later.');
      }
    } else {
      return CustomException('An unexpected error occurred. Please try again.');
    }
  }
} 