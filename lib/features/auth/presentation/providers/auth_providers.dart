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
import '../../domain/usecases/update_password_usecase.dart';
import '../../domain/usecases/update_user_profile_usecase.dart';
import '../../domain/usecases/validate_otp_usecase.dart';

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

@riverpod
ValidateOtpUseCase validateOtpUseCase(Ref ref) {
  return ValidateOtpUseCase(getIt<AuthRepository>());
}

@riverpod
UpdateUserProfileUseCase updateUserProfileUseCase(Ref ref) {
  return UpdateUserProfileUseCase(getIt<AuthRepository>());
}

@riverpod
UpdatePasswordUseCase updatePasswordUseCase(Ref ref) {
  return UpdatePasswordUseCase(getIt<AuthRepository>());
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
    return result.fold((failure) => null, (user) => user);
  }

  Future<void> login(String email, String password) async {
    state = const AsyncValue.loading();

    final result = await ref.read(loginUseCaseProvider).call(email, password);

    state = result.fold(
      (failure) => AsyncValue.error(failure.message, StackTrace.current),
      (user) => AsyncValue.data(user),
    );
  }

  Future<void> logout() async {
    state = const AsyncValue.loading();

    final result = await ref.read(logoutUseCaseProvider).call();

    result.fold(
      (failure) =>
          state = AsyncValue.error(failure.message, StackTrace.current),
      (_) => state = const AsyncValue.data(null),
    );
  }

  void forceLogout() {
    state = const AsyncValue.data(null);
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
class RegisterFormState extends AutoDisposeAsyncNotifier<User?> {
  @override
  Future<User?> build() async {
    return null;
  }

  Future<void> register(
    String firstName,
    String lastName,
    String email,
    String password,
    String confirmPassword,
  ) async {
    state = const AsyncValue.loading();

    final result = await ref
        .read(registerUseCaseProvider)
        .call(firstName, lastName, email, password, confirmPassword);

    result.fold(
      (failure) {
        state = AsyncValue.error(failure.message, StackTrace.current);
      },
      (user) {
        state = AsyncValue.data(user);
      },
    );
  }
}

@riverpod
class ForgotPasswordFormState extends AutoDisposeAsyncNotifier<void> {
  String? _email;

  @override
  Future<void> build() async {
    return;
  }

  Future<bool> forgotPassword(String email) async {
    _email = email;
    state = const AsyncLoading();
    final forgotPasswordUsecase = ref.read(forgotPasswordUseCaseProvider);
    final result = await forgotPasswordUsecase.call(email);
    return result.fold(
      (failure) {
        state = AsyncError(failure.message, StackTrace.current);
        return false;
      },
      (response) {
        state = const AsyncData(null);
        return true;
      },
    );
  }

  String? get email => _email;
}

@riverpod
class ValidateOtpFormState extends AutoDisposeAsyncNotifier<String?> {
  @override
  Future<String?> build() async {
    return null;
  }

  Future<void> validateOtp(String email, String otp) async {
    state = const AsyncValue.loading();

    final result = await ref.read(validateOtpUseCaseProvider).call(email, otp);

    state = result.fold(
      (failure) => AsyncValue.error(failure.message, StackTrace.current),
      (token) => AsyncValue.data(token),
    );
  }
}

@riverpod
class ResetPasswordFormState extends AutoDisposeAsyncNotifier<void> {
  @override
  Future<void> build() async {
    return;
  }

  Future<bool> resetPassword(
    String email,
    String token,
    String password,
  ) async {
    state = const AsyncValue.loading();

    final result = await ref
        .read(resetPasswordUseCaseProvider)
        .call(email, token, password);

    return result.fold(
      (failure) {
        state = AsyncValue.error(failure.message, StackTrace.current);
        return false;
      },
      (_) {
        state = const AsyncValue.data(null);
        return true;
      },
    );
  }
}

@riverpod
class ProfileFormState extends AutoDisposeAsyncNotifier<User?> {
  @override
  Future<User?> build() async {
    return null;
  }

  Future<bool> updateProfile({
    required String firstName,
    required String lastName,
    String? picturePath,
  }) async {
    state = const AsyncValue.loading();

    final result = await ref
        .read(updateUserProfileUseCaseProvider)
        .call(
          firstName: firstName,
          lastName: lastName,
          picturePath: picturePath,
        );

    return result.fold(
      (failure) {
        state = AsyncValue.error(failure.message, StackTrace.current);
        return false;
      },
      (user) {
        ref.read(authStateProvider.notifier).state = AsyncValue.data(user);
        state = AsyncValue.data(user);
        return true;
      },
    );
  }
}

@riverpod
class ChangePasswordFormState extends AutoDisposeAsyncNotifier<void> {
  @override
  Future<void> build() async {
    return;
  }

  Future<bool> updatePassword({
    required String currentPassword,
    required String password,
    required String passwordConfirm,
  }) async {
    state = const AsyncValue.loading();

    final result = await ref
        .read(updatePasswordUseCaseProvider)
        .call(
          currentPassword: currentPassword,
          password: password,
          passwordConfirm: passwordConfirm,
        );

    return result.fold(
      (failure) {
        state = AsyncValue.error(failure.message, StackTrace.current);
        return false;
      },
      (_) {
        state = const AsyncValue.data(null);
        return true;
      },
    );
  }
}
