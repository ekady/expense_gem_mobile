import 'package:expense_gem_mobile/features/accounts/data/datasources/account_local_data_source.dart';
import 'package:expense_gem_mobile/features/accounts/data/datasources/account_remote_data_source.dart';
import 'package:expense_gem_mobile/features/accounts/data/repositories/account_repository_impl.dart';
import 'package:expense_gem_mobile/features/accounts/domain/repositories/account_repository.dart';
import 'package:expense_gem_mobile/features/auth/data/datasources/auth_local_data_source.dart';
import 'package:expense_gem_mobile/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:expense_gem_mobile/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:expense_gem_mobile/features/auth/domain/repositories/auth_repository.dart';
import 'package:expense_gem_mobile/features/categories/data/datasources/category_local_data_source.dart';
import 'package:expense_gem_mobile/features/categories/data/datasources/category_remote_data_source.dart';
import 'package:expense_gem_mobile/features/categories/data/repositories/category_repository_impl.dart';
import 'package:expense_gem_mobile/features/categories/domain/repositories/category_repository.dart';
import 'package:expense_gem_mobile/features/transactions/data/repositories/transaction_repository_impl.dart';
import 'package:expense_gem_mobile/features/transactions/domain/repositories/transaction_repository.dart';
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:expense_gem_mobile/config/env.dart';

final getIt = GetIt.instance;

Future<void> setupServiceLocator() async {
  // External services
  final sharedPreferences = await SharedPreferences.getInstance();
  getIt.registerSingleton<SharedPreferences>(sharedPreferences);
  
  getIt.registerSingleton<FlutterSecureStorage>(const FlutterSecureStorage());
  
  getIt.registerSingleton<Logger>(Logger(
    printer: PrettyPrinter(
      methodCount: 0,
      errorMethodCount: 5,
      lineLength: 50,
      colors: true,
      printEmojis: true,
      dateTimeFormat: DateTimeFormat.onlyTimeAndSinceStart,
    ),
  ));
  
  // Network
  getIt.registerSingleton<Dio>(Dio(BaseOptions(
    baseUrl: Env.backendUrl,
    connectTimeout: const Duration(seconds: 10),
    receiveTimeout: const Duration(seconds: 10),
    headers: {'Content-Type': 'application/json; charset=UTF-8'},
  )));
  
  // Auth Data sources
  getIt.registerSingleton<AuthLocalDataSource>(
    AuthLocalDataSourceImpl(
      secureStorage: getIt<FlutterSecureStorage>(),
      sharedPreferences: getIt<SharedPreferences>(),
    ),
  );
  
  getIt.registerSingleton<AuthRemoteDataSource>(
    AuthRemoteDataSourceImpl(
      dio: getIt<Dio>(),
      logger: getIt<Logger>(),
    ),
  );
  
  // Account Data sources
  getIt.registerSingleton<AccountLocalDataSource>(
    AccountLocalDataSourceImpl(
      sharedPreferences: getIt<SharedPreferences>(),
    ),
  );
  
  getIt.registerSingleton<AccountRemoteDataSource>(
    AccountRemoteDataSourceImpl(
      dio: getIt<Dio>(),
      logger: getIt<Logger>(),
    ),
  );
  
  // Category Data sources
  getIt.registerSingleton<CategoryLocalDataSource>(
    CategoryLocalDataSourceImpl(
      sharedPreferences: getIt<SharedPreferences>(),
    ),
  );
  
  getIt.registerSingleton<CategoryRemoteDataSource>(
    CategoryRemoteDataSourceImpl(
      dio: getIt<Dio>(),
      logger: getIt<Logger>(),
    ),
  );
  
  // Register AuthInterceptor for automatic token refresh and logout
  getIt<Dio>().interceptors.add(
    AuthInterceptor(
      getIt<Dio>(),
      getIt<AuthLocalDataSource>(),
      getIt<AuthRemoteDataSource>(),
    ),
  );
  
  // Repositories
  getIt.registerSingleton<AuthRepository>(
    AuthRepositoryImpl(
      remoteDataSource: getIt<AuthRemoteDataSource>(),
      localDataSource: getIt<AuthLocalDataSource>(),
    ),
  );
  
  getIt.registerSingleton<AccountRepository>(
    AccountRepositoryImpl(
      remoteDataSource: getIt<AccountRemoteDataSource>(),
      localDataSource: getIt<AccountLocalDataSource>(),
    ),
  );
  
  getIt.registerSingleton<CategoryRepository>(
    CategoryRepositoryImpl(
      remoteDataSource: getIt<CategoryRemoteDataSource>(),
      localDataSource: getIt<CategoryLocalDataSource>(),
    ),
  );
  
  getIt.registerSingleton<TransactionRepository>(
    TransactionRepositoryImpl(),
  );
}