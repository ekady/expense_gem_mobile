import 'package:expense_gem_mobile/config/app_theme.dart';
import 'package:expense_gem_mobile/config/router.dart';
import 'package:expense_gem_mobile/config/env.dart';
import 'package:expense_gem_mobile/core/services/service_locator.dart';
import 'package:expense_gem_mobile/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:expense_gem_mobile/features/auth/domain/entities/user.dart';
import 'package:expense_gem_mobile/features/auth/presentation/providers/auth_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hive_flutter/hive_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize environment variables
  await Env.init();

  // Initialize Hive
  await Hive.initFlutter();

  // Initialize service locator
  await setupServiceLocator();

  runApp(const ProviderScope(child: ExpenseTrackerApp()));
}

class ExpenseTrackerApp extends ConsumerWidget {
  const ExpenseTrackerApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeModeProvider);
    final appRouter = ref.watch(appRouterProvider);

    // Set up auth interceptor callback for forced logout - only once
    WidgetsBinding.instance.addPostFrameCallback((_) {
      try {
        final authInterceptor = getIt<AuthInterceptor>();
        authInterceptor.setOnForceLogoutCallback(() {
          ref.read(authStateProvider.notifier).forceLogout();
        });
      } catch (e) {
        //
      }
    });

    ref.listen<AsyncValue<User?>>(authStateProvider, (_, next) {
      if (next.value == null) {
        context.go('/login');
      }
    });

    return MaterialApp.router(
      title: 'Expense Gem',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: themeMode,
      routerConfig: appRouter,
    );
  }
}
