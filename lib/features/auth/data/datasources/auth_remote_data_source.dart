import 'package:dio/dio.dart';
import 'package:expense_gem_mobile/core/error/custom_exception.dart';
import 'package:logger/logger.dart';

import '../../domain/entities/user.dart';

abstract class AuthRemoteDataSource {
  Future<Map<String, dynamic>> login(String email, String password);
  Future<Map<String, dynamic>> register(
    String firstName,
    String lastName,
    String email,
    String password,
    String confirmPassword,
  );
  Future<void> forgotPassword(String email);
  Future<void> resetPassword(String token, String password);
  Future<User> getUserProfile();
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final Dio dio;
  final Logger logger;

  AuthRemoteDataSourceImpl({required this.dio, required this.logger});

  @override
  Future<Map<String, dynamic>> login(String email, String password) async {
    try {
      final response = await dio.post(
        '/authentication/sign-in',
        data: {'email': email, 'password': password},
      );

      return {
        'token': response.data['token'],
        'user': User(
          id: response.data['user']['id'],
          firstName: response.data['user']['firstName'],
          lastName: response.data['user']['lastName'],
          email: response.data['user']['email'],
          picture: response.data['user']['picture'],
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
  Future<Map<String, dynamic>> register(
    String firstName,
    String lastName,
    String email,
    String password,
    String confirmPassword,
  ) async {
    try {
      final response = await dio.post(
        '/authentication/sign-up',
        data: {
          'firstName': firstName,
          'lastName': lastName,
          'email': email,
          'password': password,
          'passwordConfirm': confirmPassword,
        },
      );

      return {
        'user': User(
          id: response.data['data']['id'],
          firstName: response.data['data']['firstName'],
          lastName: response.data['data']['lastName'],
          email: response.data['data']['email'],
          picture: response.data['data']['picture'],
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
      await dio.post('/auth/forgot-password', data: {'email': email});
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
        data: {'token': token, 'password': password},
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
        firstName: response.data['firstName'],
        lastName: response.data['lastName'],
        email: response.data['email'],
        picture: response.data['picture'],
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
      final responseData =
          e.response!.data?['errors']?[0] as Map<String, dynamic>?;

      if (responseData != null && responseData.containsKey('message')) {
        return CustomException(responseData['message']);
      } else if (statusCode == 401) {
        return CustomException(
          'Invalid credentials. Please check your email and password.',
        );
      } else if (statusCode == 422) {
        return CustomException(
          'Validation error. Please check your inputs and try again.',
        );
      } else if (statusCode == 404) {
        return CustomException('Resource not found.');
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
