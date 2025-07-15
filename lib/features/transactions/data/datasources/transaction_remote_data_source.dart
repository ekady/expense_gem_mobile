import 'package:dio/dio.dart';
import 'package:logger/logger.dart';

import '../../../../core/entities/pagination.dart';
import '../../../../core/error/custom_exception.dart';
import '../../../accounts/domain/entities/account.dart';
import '../../../categories/domain/entities/category.dart';
import '../../domain/entities/transaction.dart';

abstract class TransactionRemoteDataSource {
  Future<Map<String, dynamic>> getTransactions({
    int page = 1,
    int limit = 10,
    String? categoryId,
    String? accountId,
    DateTime? startDate,
    DateTime? endDate,
    int? amountType,
  });
  Future<Transaction> getTransactionById(String id);
  Future<Transaction> createTransaction(Transaction transaction);
  Future<Transaction> updateTransaction(Transaction transaction);
  Future<void> deleteTransaction(String id);
}

class TransactionRemoteDataSourceImpl implements TransactionRemoteDataSource {
  final Dio dio;
  final Logger logger;

  TransactionRemoteDataSourceImpl({required this.dio, required this.logger});

  @override
  Future<Map<String, dynamic>> getTransactions({
    int page = 1,
    int limit = 10,
    String? categoryId,
    String? accountId,
    DateTime? startDate,
    DateTime? endDate,
    int? amountType,
  }) async {
    try {
      final queryParameters = {
        'page': page,
        'limit': limit,
        'sort': 'createdAt|desc',
        if (categoryId != null) 'categoryId': categoryId,
        if (accountId != null) 'accountId': accountId,
        if (startDate != null) 'startDate': startDate.toIso8601String(),
        if (endDate != null) 'endDate': endDate.toIso8601String(),
        if (amountType != null) 'amountType': amountType,
      };
      final response = await dio.get('/transactions', queryParameters: queryParameters);
      
      final data = response.data['data'];
      final List<dynamic> transactionsData = data['data'];
      final paginationData = data['pagination'];
      
      final transactions = transactionsData.map((json) => _transactionFromJson(json)).toList();
      final pagination = Pagination.fromJson(paginationData);
      
      return {
        'transactions': transactions,
        'pagination': pagination,
      };
    } on DioException catch (e) {
      logger.e('Get transactions error: ${e.message}');
      throw _handleDioError(e);
    } catch (e) {
      logger.e('Unexpected get transactions error: $e');
      throw Exception('An unexpected error occurred. Please try again.');
    }
  }

  @override
  Future<Transaction> getTransactionById(String id) async {
    try {
      final response = await dio.get('/transactions/$id');
      return _transactionFromJson(response.data['data']);
    } on DioException catch (e) {
      logger.e('Get transaction by id error: ${e.message}');
      throw _handleDioError(e);
    } catch (e) {
      logger.e('Unexpected get transaction by id error: $e');
      throw Exception('An unexpected error occurred. Please try again.');
    }
  }

  @override
  Future<Transaction> createTransaction(Transaction transaction) async {
    try {
      final response = await dio.post(
        '/transactions',
        data: _transactionToJson(transaction),
      );
      return _transactionFromJson(response.data['data']);
    } on DioException catch (e) {
      logger.e('Create transaction error: ${e.message}');
      throw _handleDioError(e);
    } catch (e) {
      logger.e('Unexpected create transaction error: $e');
      throw Exception('An unexpected error occurred. Please try again.');
    }
  }

  @override
  Future<Transaction> updateTransaction(Transaction transaction) async {
    try {
      final response = await dio.put(
        '/transactions/${transaction.id}',
        data: _transactionToJson(transaction),
      );
      return _transactionFromJson(response.data['data']);
    } on DioException catch (e) {
      logger.e('Update transaction error: ${e.message}');
      throw _handleDioError(e);
    } catch (e) {
      logger.e('Unexpected update transaction error: $e');
      throw Exception('An unexpected error occurred. Please try again.');
    }
  }

  @override
  Future<void> deleteTransaction(String id) async {
    try {
      await dio.delete('/transactions/$id');
    } on DioException catch (e) {
      logger.e('Delete transaction error: ${e.message}');
      throw _handleDioError(e);
    } catch (e) {
      logger.e('Unexpected delete transaction error: $e');
      throw Exception('An unexpected error occurred. Please try again.');
    }
  }

  Transaction _transactionFromJson(Map<String, dynamic> json) {
    return Transaction(
      id: json['id'] ?? '',
      payee: json['payee'] ?? '',
      notes: json['notes'] ?? '',
      amount: (json['amount'] as num).toDouble(),
      date: json['date'] != null ? DateTime.parse(json['date']) : null,
      type: json['amount'] >= 0 ? 'income' : 'expense',
      account: json['account'] != null ? _accountFromJson(json['account']) : null,
      category: json['category'] != null ? _categoryFromJson(json['category']) : null,
      createdAt: json['createdAt'] != null 
          ? DateTime.parse(json['createdAt']) 
          : DateTime.now(),
      updatedAt: json['updatedAt'] != null 
          ? DateTime.parse(json['updatedAt']) 
          : null,
    );
  }

  Map<String, dynamic> _transactionToJson(Transaction transaction) {
    return {
      'amount': transaction.amount ?? 0,
      'payee': transaction.payee ?? '',
      'notes': transaction.notes ?? '',
      'date': transaction.date?.toIso8601String() ?? '',
      'accountId': transaction.account?.id ?? '',
      'categoryId': transaction.category?.id ?? '',
    };
  }

  Account _accountFromJson(Map<String, dynamic> json) {
    return Account(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      icon: json['icon'],
      color: json['color'],
      createdAt: json['createdAt'] != null 
          ? DateTime.parse(json['createdAt']) 
          : null,
      updatedAt: json['updatedAt'] != null 
          ? DateTime.parse(json['updatedAt']) 
          : null,
    );
  }

  Category _categoryFromJson(Map<String, dynamic> json) {
    return Category(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      icon: json['icon'],
      color: json['color'],
      createdAt: json['createdAt'] != null 
          ? DateTime.parse(json['createdAt']) 
          : null,
      updatedAt: json['updatedAt'] != null 
          ? DateTime.parse(json['updatedAt']) 
          : null,
    );
  }

  Exception _handleDioError(DioException e) {
    if (e.type == DioExceptionType.connectionTimeout) {
      throw CustomException(
        'Connection timeout. Please check your internet connection.',
      );
    } else if (e.type == DioExceptionType.receiveTimeout) {
      throw CustomException(
        'Server is taking too long to respond. Please try again later.',
      );
    } else if (e.type == DioExceptionType.connectionError) {
      throw CustomException(
        'No internet connection. Please check your network settings.',
      );
    } else if (e.response != null) {
      final statusCode = e.response!.statusCode;
      final responseData = e.response!.data;
      
      // Log the actual response structure for debugging
      logger.d('API Error Response: $responseData');
      
      String errorMessage = 'An error occurred. Please try again later.';
      
      // Try different response structures
      if (responseData is Map<String, dynamic>) {
        // Try errors array structure
        final errors = responseData['errors'] as List<dynamic>?;
        if (errors != null && errors.isNotEmpty) {
          final firstError = errors[0];
          if (firstError is Map<String, dynamic> && firstError.containsKey('message')) {
            errorMessage = firstError['message'];
          }
        }
        
        // Try message field directly
        if (responseData.containsKey('message')) {
          errorMessage = responseData['message'];
        }
        
        // Try error field
        if (responseData.containsKey('error')) {
          errorMessage = responseData['error'];
        }
      }
      
      // Override with specific status code messages
      if (statusCode == 401) {
        errorMessage = 'Unauthorized. Please log in again.';
      } else if (statusCode == 422) {
        errorMessage = 'Validation error. Please check your inputs and try again.';
      } else if (statusCode == 404) {
        errorMessage = 'Transaction not found.';
      } else if (statusCode == 500) {
        errorMessage = 'Server error. Please try again later.';
      }
      
      throw CustomException(errorMessage);
    } else {
      throw CustomException('An unexpected error occurred. Please try again.');
    }
  }
} 