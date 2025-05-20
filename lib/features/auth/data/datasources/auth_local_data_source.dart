import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../domain/entities/user.dart';

abstract class AuthLocalDataSource {
  Future<void> saveToken(String token);
  Future<String?> getToken();
  Future<void> deleteToken();
  
  Future<void> saveUser(User user);
  Future<User?> getUser();
  Future<void> deleteUser();
  
  Future<void> saveOnboardingCompleted();
  Future<bool> isOnboardingCompleted();
}

class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  final FlutterSecureStorage secureStorage;
  final SharedPreferences sharedPreferences;
  
  AuthLocalDataSourceImpl({
    required this.secureStorage,
    required this.sharedPreferences,
  });
  
  @override
  Future<void> saveToken(String token) async {
    await secureStorage.write(key: 'auth_token', value: token);
  }
  
  @override
  Future<String?> getToken() async {
    return await secureStorage.read(key: 'auth_token');
  }
  
  @override
  Future<void> deleteToken() async {
    await secureStorage.delete(key: 'auth_token');
  }
  
  @override
  Future<void> saveUser(User user) async {
    final userJson = jsonEncode({
      'id': user.id,
      'name': user.name,
      'email': user.email,
      'avatar': user.avatar,
    });
    
    await sharedPreferences.setString('user_data', userJson);
  }
  
  @override
  Future<User?> getUser() async {
    final userJson = sharedPreferences.getString('user_data');
    
    if (userJson == null) {
      return null;
    }
    
    final userData = jsonDecode(userJson);
    
    return User(
      id: userData['id'],
      name: userData['name'],
      email: userData['email'],
      avatar: userData['avatar'],
    );
  }
  
  @override
  Future<void> deleteUser() async {
    await sharedPreferences.remove('user_data');
  }
  
  @override
  Future<void> saveOnboardingCompleted() async {
    await sharedPreferences.setBool('onboarding_completed', true);
  }
  
  @override
  Future<bool> isOnboardingCompleted() async {
    return sharedPreferences.getBool('onboarding_completed') ?? false;
  }
}