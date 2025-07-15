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
  Future<String> validateOtp(String email, String otp);
  Future<void> resetPassword(String email, String token, String password);
  Future<User> getUserProfile();
  Future<Map<String, dynamic>> refreshToken(String refreshToken);
  Future<void> logout();
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

      final responseData = response.data['data'];

      return {
        'token': responseData['accessToken'],
        'refreshToken': responseData['refreshToken'],
        'user': User(
          id: responseData['user']['id'],
          firstName: responseData['user']['firstName'],
          lastName: responseData['user']['lastName'],
          email: responseData['user']['email'],
          picture: responseData['user']['picture'],
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
      await dio.post('/authentication/forgot-password', data: {'email': email});
    } on DioException catch (e) {
      logger.e('Forgot password error: ${e.message}');
      throw _handleDioError(e);
    } catch (e) {
      logger.e('Unexpected forgot password error: $e');
      throw Exception('An unexpected error occurred. Please try again.');
    }
  }

  @override
  Future<String> validateOtp(String email, String otp) async {
    try {
      final response = await dio.post(
        '/authentication/validate-otp',
        data: {'email': email, 'otp': otp},
      );
      return response.data['data']['resetToken'];
    } on DioException catch (e) {
      logger.e('OTP validation error: ${e.message}');
      throw _handleDioError(e);
    } catch (e) {
      logger.e('Unexpected OTP validation error: $e');
      throw Exception('An unexpected error occurred. Please try again.');
    }
  }

  @override
  Future<void> resetPassword(String email, String token, String password) async {
    try {
      await dio.post(
        '/authentication/reset-password',
        data: {
          'email': email,
          'resetToken': token,
          'newPassword': password,
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
      final response = await dio.get('/user/me');

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
        errorMessage = 'Invalid credentials. Please check your email and password.';
      } else if (statusCode == 422) {
        errorMessage = 'Validation error. Please check your inputs and try again.';
      } else if (statusCode == 404) {
        errorMessage = 'Resource not found.';
      } else if (statusCode == 500) {
        errorMessage = 'Server error. Please try again later.';
      }
      
      throw CustomException(errorMessage);
    } else {
      throw CustomException('An unexpected error occurred. Please try again.');
    }
  }

  @override
  Future<Map<String, dynamic>> refreshToken(String refreshToken) async {
    try {
      final response = await dio.post(
        '/authentication/refresh',
        options: Options(
          headers: {
            'Authorization': 'Bearer $refreshToken',
          },
        ),
      );
      final data = response.data['data'];
      return {
        'token': data['accessToken'],
        'refreshToken': data['refreshToken'],
      };
    } on DioException catch (e) {
      logger.e('Refresh token error: ${e.message}');
      throw _handleDioError(e);
    } catch (e) {
      logger.e('Unexpected refresh token error: $e');
      throw Exception('An unexpected error occurred. Please try again.');
    }
  }

  @override
  Future<void> logout() async {
    try {
      await dio.post(
        '/authentication/sign-out',
      );
    } on DioException catch (e) {
      logger.e('Logout error: ${e.message}');
      throw _handleDioError(e);
    } catch (e) {
      logger.e('Unexpected logout error: $e');
      throw Exception('An unexpected error occurred. Please try again.');
    }
  }
}
