import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/services/service_locator.dart';
import '../../domain/entities/user.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../domain/usecases/forgot_password_usecase.dart';
import '../../domain/usecases/get_current_user_usecase.dart';
import '../../domain/usecases/is_logged_in_usecase.dart';
import '../../domain/usecases/login_usecase.dart';
import '../../domain/usecases/logout_usecase.dart';
import '../../domain/usecases/register_usecase.dart';
import '../../domain/usecases/reset_password_usecase.dart';

part 'auth_providers.g.dart';

// Use Cases Providers
@riverpod
LoginUseCase loginUseCase(Ref ref) {
  return LoginUseCase(getIt<AuthRepository>());
}

@riverpod
RegisterUseCase registerUseCase(Ref ref) {
  return RegisterUseCase(getIt<AuthRepository>());
}

@riverpod
ForgotPasswordUseCase forgotPasswordUseCase(Ref ref) {
  return ForgotPasswordUseCase(getIt<AuthRepository>());
}

@riverpod
ResetPasswordUseCase resetPasswordUseCase(Ref ref) {
  return ResetPasswordUseCase(getIt<AuthRepository>());
}

@riverpod
GetCurrentUserUseCase getCurrentUserUseCase(Ref ref) {
  return GetCurrentUserUseCase(getIt<AuthRepository>());
}

@riverpod
LogoutUseCase logoutUseCase(Ref ref) {
  return LogoutUseCase(getIt<AuthRepository>()); 
}

@riverpod
IsLoggedInUseCase isLoggedInUseCase(Ref ref) {
  return IsLoggedInUseCase(getIt<AuthRepository>());
}

// Auth State Provider
@riverpod
class AuthState extends AutoDisposeAsyncNotifier<User?> {
  @override
  Future<User?> build() async {
    final isLoggedIn = await ref.read(isLoggedInUseCaseProvider).call();
    if (!isLoggedIn) {
      return null;
    }
    
    final result = await ref.read(getCurrentUserUseCaseProvider).call();
    return result.fold(
      (failure) => null,
      (user) => user,
    );
  }
  
  Future<void> login(String email, String password) async {
    state = const AsyncValue.loading();
    
    final result = await ref.read(loginUseCaseProvider).call(email, password);
    
    state = result.fold(
      (failure) => AsyncValue.error(failure.message, StackTrace.current),
      (user) => AsyncValue.data(user),
    );
  }
  
  Future<void> register(String name, String email, String password) async {
    state = const AsyncValue.loading();
    
    final result = await ref.read(registerUseCaseProvider).call(name, email, password);
    
    state = result.fold(
      (failure) => AsyncValue.error(failure.message, StackTrace.current),
      (user) => AsyncValue.data(user),
    );
  }
  
  Future<void> logout() async {
    state = const AsyncValue.loading();
    
    final result = await ref.read(logoutUseCaseProvider).call();
    
    result.fold(
      (failure) => state = AsyncValue.error(failure.message, StackTrace.current),
      (_) => state = const AsyncValue.data(null),
    );
  }
}

// Form State Providers
@riverpod
class LoginFormState extends AutoDisposeAsyncNotifier<void> {
  @override
  Future<void> build() async {
    return;
  }
  
  Future<void> login(String email, String password) async {
    state = const AsyncValue.loading();
    
    final result = await ref.read(loginUseCaseProvider).call(email, password);
    
    result.fold(
      (failure) {
        state = AsyncValue.error(failure.message, StackTrace.current);
      },
      (user) {
        ref.read(authStateProvider.notifier).state = AsyncValue.data(user);
        state = const AsyncValue.data(null);
      },
    );
  }
}

@riverpod
class RegisterFormState extends AutoDisposeAsyncNotifier<void> {
  @override
  Future<void> build() async {
    return;
  }
  
  Future<void> register(String name, String email, String password) async {
    state = const AsyncValue.loading();
    
    final result = await ref.read(registerUseCaseProvider).call(name, email, password);
    
    result.fold(
      (failure) {
        state = AsyncValue.error(failure.message, StackTrace.current);
      },
      (user) {
        ref.read(authStateProvider.notifier).state = AsyncValue.data(user);
        state = const AsyncValue.data(null);
      },
    );
  }
}

@riverpod
class ForgotPasswordFormState extends AutoDisposeAsyncNotifier<void> {
  @override
  Future<void> build() async {
    return;
  }
  
  Future<void> forgotPassword(String email) async {
    state = const AsyncValue.loading();
    
    final result = await ref.read(forgotPasswordUseCaseProvider).call(email);
    
    state = result.fold(
      (failure) => AsyncValue.error(failure.message, StackTrace.current),
      (_) => const AsyncValue.data(null),
    );
  }
}

@riverpod
class ResetPasswordFormState extends AutoDisposeAsyncNotifier<void> {
  @override
  Future<void> build() async {
    return;
  }
  
  Future<void> resetPassword(String token, String password) async {
    state = const AsyncValue.loading();
    
    final result = await ref.read(resetPasswordUseCaseProvider).call(token, password);
    
    state = result.fold(
      (failure) => AsyncValue.error(failure.message, StackTrace.current),
      (_) => const AsyncValue.data(null),
    );
  }
}