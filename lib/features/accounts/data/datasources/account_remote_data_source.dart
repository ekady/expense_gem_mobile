import 'package:dio/dio.dart';
import 'package:logger/logger.dart';

import '../../../../core/entities/pagination.dart';
import '../../../../core/error/custom_exception.dart';
import '../../domain/entities/account.dart';

abstract class AccountRemoteDataSource {
  Future<Map<String, dynamic>> getAccounts({int page = 1, int limit = 10});
  Future<Account> getAccountById(String id);
  Future<Account> createAccount(Account account);
  Future<Account> updateAccount(Account account);
  Future<void> deleteAccount(String id);
}

class AccountRemoteDataSourceImpl implements AccountRemoteDataSource {
  final Dio dio;
  final Logger logger;

  AccountRemoteDataSourceImpl({required this.dio, required this.logger});

  @override
  Future<Map<String, dynamic>> getAccounts({int page = 1, int limit = 10}) async {
    try {
      final response = await dio.get('/account', queryParameters: {
        'page': page,
        'limit': limit,
        'sort': 'createdAt|desc',
      });
      
      final data = response.data['data'];
      final List<dynamic> accountsData = data['data'];
      final paginationData = data['pagination'];
      
      final accounts = accountsData.map((json) => _accountFromJson(json)).toList();
      final pagination = Pagination.fromJson(paginationData);
      
      return {
        'accounts': accounts,
        'pagination': pagination,
      };
    } on DioException catch (e) {
      logger.e('Get accounts error: ${e.message}');
      throw _handleDioError(e);
    } catch (e) {
      logger.e('Unexpected get accounts error: $e');
      throw Exception('An unexpected error occurred. Please try again.');
    }
  }

  @override
  Future<Account> getAccountById(String id) async {
    try {
      final response = await dio.get('/account/$id');
      return _accountFromJson(response.data['data']);
    } on DioException catch (e) {
      logger.e('Get account by id error: ${e.message}');
      throw _handleDioError(e);
    } catch (e) {
      logger.e('Unexpected get account by id error: $e');
      throw Exception('An unexpected error occurred. Please try again.');
    }
  }

  @override
  Future<Account> createAccount(Account account) async {
    try {
      final response = await dio.post(
        '/account',
        data: _accountToJson(account),
      );
      return _accountFromJson(response.data['data']);
    } on DioException catch (e) {
      logger.e('Create account error: ${e.message}');
      throw _handleDioError(e);
    } catch (e) {
      logger.e('Unexpected create account error: $e');
      throw Exception('An unexpected error occurred. Please try again.');
    }
  }

  @override
  Future<Account> updateAccount(Account account) async {
    try {
      final response = await dio.put(
        '/account/${account.id}',
        data: _accountToJson(account),
      );
      return _accountFromJson(response.data['data']);
    } on DioException catch (e) {
      logger.e('Update account error: ${e.message}');
      throw _handleDioError(e);
    } catch (e) {
      logger.e('Unexpected update account error: $e');
      throw Exception('An unexpected error occurred. Please try again.');
    }
  }

  @override
  Future<void> deleteAccount(String id) async {
    try {
      await dio.delete('/account/$id');
    } on DioException catch (e) {
      logger.e('Delete account error: ${e.message}');
      throw _handleDioError(e);
    } catch (e) {
      logger.e('Unexpected delete account error: $e');
      throw Exception('An unexpected error occurred. Please try again.');
    }
  }

  Account _accountFromJson(Map<String, dynamic> json) {
    return Account(
      id: json['id'] ?? '',
      name: json['name'],
      description: json['description'] ?? '',
      icon: json['icon'] ?? '',
      color: json['color'] ?? '',
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: json['updatedAt'] != null 
          ? DateTime.parse(json['updatedAt']) 
          : null,
    );
  }

  Map<String, dynamic> _accountToJson(Account account) {
    return {
      'name': account.name,
      'description': account.description,
      'icon': account.icon,
      if (account.color != null) 'color': account.color,
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
        return CustomException('Account not found.');
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