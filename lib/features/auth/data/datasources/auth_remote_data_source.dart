import 'package:dio/dio.dart';
import 'package:logger/logger.dart';

import '../../domain/entities/user.dart';

abstract class AuthRemoteDataSource {
  Future<Map<String, dynamic>> login(String email, String password);
  Future<Map<String, dynamic>> register(String name, String email, String password);
  Future<void> forgotPassword(String email);
  Future<void> resetPassword(String token, String password);
  Future<User> getUserProfile();
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final Dio dio;
  final Logger logger;
  
  AuthRemoteDataSourceImpl({
    required this.dio,
    required this.logger,
  });
  
  @override
  Future<Map<String, dynamic>> login(String email, String password) async {
    logger.i('Login request: $email, $password');
    logger.i('Dio: ${dio.options.baseUrl}'); 
    try {
      final response = await dio.post(
        '/authentication/sign-in',
        data: {
          'email': email,
          'password': password,
        },
      );
      
      return {
        'token': response.data['token'],
        'user': User(
          id: response.data['user']['id'],
          name: response.data['user']['name'],
          email: response.data['user']['email'],
          avatar: response.data['user']['avatar'],
        ),
      };
    } on DioException catch (e) {
      logger.e('Login error: ${e.message}');
      throw _handleDioError(e);
    } catch (e) {
      logger.e('Unexpected login error: $e');
      throw Exception('An unexpected error occurred. Please try again.');
    }
  }
  
  @override
  Future<Map<String, dynamic>> register(String name, String email, String password) async {
    try {
      final response = await dio.post(
        '/auth/register',
        data: {
          'name': name,
          'email': email,
          'password': password,
        },
      );
      
      return {
        'token': response.data['token'],
        'user': User(
          id: response.data['user']['id'],
          name: response.data['user']['name'],
          email: response.data['user']['email'],
          avatar: response.data['user']['avatar'],
        ),
      };
    } on DioException catch (e) {
      logger.e('Register error: ${e.message}');
      throw _handleDioError(e);
    } catch (e) {
      logger.e('Unexpected register error: $e');
      throw Exception('An unexpected error occurred. Please try again.');
    }
  }
  
  @override
  Future<void> forgotPassword(String email) async {
    try {
      await dio.post(
        '/auth/forgot-password',
        data: {
          'email': email,
        },
      );
    } on DioException catch (e) {
      logger.e('Forgot password error: ${e.message}');
      throw _handleDioError(e);
    } catch (e) {
      logger.e('Unexpected forgot password error: $e');
      throw Exception('An unexpected error occurred. Please try again.');
    }
  }
  
  @override
  Future<void> resetPassword(String token, String password) async {
    try {
      await dio.post(
        '/auth/reset-password',
        data: {
          'token': token,
          'password': password,
        },
      );
    } on DioException catch (e) {
      logger.e('Reset password error: ${e.message}');
      throw _handleDioError(e);
    } catch (e) {
      logger.e('Unexpected reset password error: $e');
      throw Exception('An unexpected error occurred. Please try again.');
    }
  }
  
  @override
  Future<User> getUserProfile() async {
    try {
      final response = await dio.get('/auth/profile');
      
      return User(
        id: response.data['id'],
        name: response.data['name'],
        email: response.data['email'],
        avatar: response.data['avatar'],
      );
    } on DioException catch (e) {
      logger.e('Get user profile error: ${e.message}');
      throw _handleDioError(e);
    } catch (e) {
      logger.e('Unexpected get user profile error: $e');
      throw Exception('An unexpected error occurred. Please try again.');
    }
  }
  
  Exception _handleDioError(DioException e) {
    if (e.type == DioExceptionType.connectionTimeout) {
      return Exception('Connection timeout. Please check your internet connection.');
    } else if (e.type == DioExceptionType.receiveTimeout) {
      return Exception('Server is taking too long to respond. Please try again later.');
    } else if (e.type == DioExceptionType.connectionError) {
      return Exception('No internet connection. Please check your network settings.');
    } else if (e.response != null) {
      final statusCode = e.response!.statusCode;
      final responseData = e.response!.data;
      
      if (statusCode == 401) {
        return Exception('Invalid credentials. Please check your email and password.');
      } else if (statusCode == 422) {
        if (responseData is Map && responseData.containsKey('message')) {
          return Exception(responseData['message']);
        }
        return Exception('Validation error. Please check your inputs and try again.');
      } else if (statusCode == 404) {
        return Exception('Resource not found.');
      } else if (statusCode == 500) {
        return Exception('Server error. Please try again later.');
      } else {
        return Exception('An error occurred. Please try again later.');
      }
    } else {
      return Exception('An unexpected error occurred. Please try again.');
    }
  }
}