// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$loginUseCaseHash() => r'7921c23418cc092d76ee0b26a10524c36916d47c';

/// See also [loginUseCase].
@ProviderFor(loginUseCase)
final loginUseCaseProvider = AutoDisposeProvider<LoginUseCase>.internal(
  loginUseCase,
  name: r'loginUseCaseProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$loginUseCaseHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef LoginUseCaseRef = AutoDisposeProviderRef<LoginUseCase>;
String _$registerUseCaseHash() => r'10cd9fcc98612663b71f580534fb0ca21aee53c9';

/// See also [registerUseCase].
@ProviderFor(registerUseCase)
final registerUseCaseProvider = AutoDisposeProvider<RegisterUseCase>.internal(
  registerUseCase,
  name: r'registerUseCaseProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$registerUseCaseHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef RegisterUseCaseRef = AutoDisposeProviderRef<RegisterUseCase>;
String _$forgotPasswordUseCaseHash() =>
    r'001f634f54a802772a4e4e81410d172478406f86';

/// See also [forgotPasswordUseCase].
@ProviderFor(forgotPasswordUseCase)
final forgotPasswordUseCaseProvider =
    AutoDisposeProvider<ForgotPasswordUseCase>.internal(
      forgotPasswordUseCase,
      name: r'forgotPasswordUseCaseProvider',
      debugGetCreateSourceHash:
          const bool.fromEnvironment('dart.vm.product')
              ? null
              : _$forgotPasswordUseCaseHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef ForgotPasswordUseCaseRef =
    AutoDisposeProviderRef<ForgotPasswordUseCase>;
String _$resetPasswordUseCaseHash() =>
    r'8c94c37d5bf63a04e8cbb684714c95a18b10fdb5';

/// See also [resetPasswordUseCase].
@ProviderFor(resetPasswordUseCase)
final resetPasswordUseCaseProvider =
    AutoDisposeProvider<ResetPasswordUseCase>.internal(
      resetPasswordUseCase,
      name: r'resetPasswordUseCaseProvider',
      debugGetCreateSourceHash:
          const bool.fromEnvironment('dart.vm.product')
              ? null
              : _$resetPasswordUseCaseHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef ResetPasswordUseCaseRef = AutoDisposeProviderRef<ResetPasswordUseCase>;
String _$getCurrentUserUseCaseHash() =>
    r'd1c5b6e15286a7c5b7bcacb8d21a25148d3b8168';

/// See also [getCurrentUserUseCase].
@ProviderFor(getCurrentUserUseCase)
final getCurrentUserUseCaseProvider =
    AutoDisposeProvider<GetCurrentUserUseCase>.internal(
      getCurrentUserUseCase,
      name: r'getCurrentUserUseCaseProvider',
      debugGetCreateSourceHash:
          const bool.fromEnvironment('dart.vm.product')
              ? null
              : _$getCurrentUserUseCaseHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef GetCurrentUserUseCaseRef =
    AutoDisposeProviderRef<GetCurrentUserUseCase>;
String _$logoutUseCaseHash() => r'dfc4d85ffd9f532bb8703616c5e9041ef1d1fe0a';

/// See also [logoutUseCase].
@ProviderFor(logoutUseCase)
final logoutUseCaseProvider = AutoDisposeProvider<LogoutUseCase>.internal(
  logoutUseCase,
  name: r'logoutUseCaseProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$logoutUseCaseHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef LogoutUseCaseRef = AutoDisposeProviderRef<LogoutUseCase>;
String _$isLoggedInUseCaseHash() => r'8255c9d918416f26296c02d068ecab2a4267a520';

/// See also [isLoggedInUseCase].
@ProviderFor(isLoggedInUseCase)
final isLoggedInUseCaseProvider =
    AutoDisposeProvider<IsLoggedInUseCase>.internal(
      isLoggedInUseCase,
      name: r'isLoggedInUseCaseProvider',
      debugGetCreateSourceHash:
          const bool.fromEnvironment('dart.vm.product')
              ? null
              : _$isLoggedInUseCaseHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef IsLoggedInUseCaseRef = AutoDisposeProviderRef<IsLoggedInUseCase>;
String _$authStateHash() => r'0b4e7b87fe5a6d3a9fd33de469d516ede5dce4e8';

/// See also [AuthState].
@ProviderFor(AuthState)
final authStateProvider =
    AutoDisposeAsyncNotifierProvider<AuthState, User?>.internal(
      AuthState.new,
      name: r'authStateProvider',
      debugGetCreateSourceHash:
          const bool.fromEnvironment('dart.vm.product')
              ? null
              : _$authStateHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$AuthState = AutoDisposeAsyncNotifier<User?>;
String _$loginFormStateHash() => r'50f65c9afe3f1edd60b44cec57eb0d6e427ff9b9';

/// See also [LoginFormState].
@ProviderFor(LoginFormState)
final loginFormStateProvider =
    AutoDisposeAsyncNotifierProvider<LoginFormState, void>.internal(
      LoginFormState.new,
      name: r'loginFormStateProvider',
      debugGetCreateSourceHash:
          const bool.fromEnvironment('dart.vm.product')
              ? null
              : _$loginFormStateHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$LoginFormState = AutoDisposeAsyncNotifier<void>;
String _$registerFormStateHash() => r'4b180854c3d8f68feafaa6521465f4ec3de1e102';

/// See also [RegisterFormState].
@ProviderFor(RegisterFormState)
final registerFormStateProvider =
    AutoDisposeAsyncNotifierProvider<RegisterFormState, User?>.internal(
      RegisterFormState.new,
      name: r'registerFormStateProvider',
      debugGetCreateSourceHash:
          const bool.fromEnvironment('dart.vm.product')
              ? null
              : _$registerFormStateHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$RegisterFormState = AutoDisposeAsyncNotifier<User?>;
String _$forgotPasswordFormStateHash() =>
    r'cf3e050aaa2a0eb7f3956cab03c072b644916d7e';

/// See also [ForgotPasswordFormState].
@ProviderFor(ForgotPasswordFormState)
final forgotPasswordFormStateProvider =
    AutoDisposeAsyncNotifierProvider<ForgotPasswordFormState, void>.internal(
      ForgotPasswordFormState.new,
      name: r'forgotPasswordFormStateProvider',
      debugGetCreateSourceHash:
          const bool.fromEnvironment('dart.vm.product')
              ? null
              : _$forgotPasswordFormStateHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$ForgotPasswordFormState = AutoDisposeAsyncNotifier<void>;
String _$resetPasswordFormStateHash() =>
    r'a2300460289c92801c937bbba018b127cd47edfc';

/// See also [ResetPasswordFormState].
@ProviderFor(ResetPasswordFormState)
final resetPasswordFormStateProvider =
    AutoDisposeAsyncNotifierProvider<ResetPasswordFormState, void>.internal(
      ResetPasswordFormState.new,
      name: r'resetPasswordFormStateProvider',
      debugGetCreateSourceHash:
          const bool.fromEnvironment('dart.vm.product')
              ? null
              : _$resetPasswordFormStateHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$ResetPasswordFormState = AutoDisposeAsyncNotifier<void>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
