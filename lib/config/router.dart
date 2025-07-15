import 'package:expense_gem_mobile/features/accounts/presentation/screens/account_form_screen.dart';
import 'package:expense_gem_mobile/features/auth/presentation/screens/forgot_password_screen.dart';
import 'package:expense_gem_mobile/features/auth/presentation/screens/login_screen.dart';
import 'package:expense_gem_mobile/features/auth/presentation/screens/otp_validation_screen.dart';
import 'package:expense_gem_mobile/features/auth/presentation/screens/reset_password_screen.dart';
import 'package:expense_gem_mobile/features/auth/presentation/screens/reset_password_success_screen.dart';
import 'package:expense_gem_mobile/features/auth/presentation/screens/signup_screen.dart';
import 'package:expense_gem_mobile/features/categories/presentation/screens/category_form_screen.dart';
import 'package:expense_gem_mobile/features/dashboard/presentation/screens/dashboard_screen.dart';
import 'package:expense_gem_mobile/features/splash/presentation/screens/splash_screen.dart';
import 'package:expense_gem_mobile/features/accounts/presentation/screens/accounts_screen.dart';
import 'package:expense_gem_mobile/features/categories/presentation/screens/categories_screen.dart';
import 'package:expense_gem_mobile/features/transactions/presentation/screens/transaction_form_screen.dart';
import 'package:expense_gem_mobile/features/transactions/presentation/screens/transactions_screen.dart';
import 'package:expense_gem_mobile/features/profile/presentation/screens/profile_screen.dart';
import 'package:expense_gem_mobile/features/settings/presentation/screens/settings_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

final appRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: '/',
    debugLogDiagnostics: true,
    routes: [
      // Splash and Auth Routes
      GoRoute(
        path: '/',
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/signup',
        builder: (context, state) => const SignupScreen(),
      ),
      GoRoute(
        path: '/forgot-password',
        builder: (context, state) => const ForgotPasswordScreen(),
      ),
      GoRoute(
        path: '/otp-validation',
        builder: (context, state) {
          final extra = state.extra as Map<String, dynamic>;
          return OtpValidationScreen(email: extra['email']);
        },
      ),
      GoRoute(
        path: '/reset-password',
        builder: (context, state) {
          final extra = state.extra as Map<String, dynamic>;
          return ResetPasswordScreen(
            email: extra['email'],
            token: extra['token'],
          );
        },
      ),
      GoRoute(
        path: '/reset-password-success',
        builder: (context, state) => const ResetPasswordSuccessScreen(),
      ),
      
      // Main App Shell with Bottom Navigation
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return ScaffoldWithNavBar(navigationShell: navigationShell);
        },
        branches: [
          // Dashboard Branch
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/dashboard',
                builder: (context, state) => const DashboardScreen(),
              ),
            ],
          ),
          
          // Accounts Branch
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/accounts',
                builder: (context, state) => const AccountsScreen(),
                routes: [
                  GoRoute(
                    path: 'create',
                    builder: (context, state) => const AccountFormScreen(),
                  ),
                  GoRoute(
                    path: 'edit/:id',
                    builder: (context, state) => AccountFormScreen(
                      accountId: state.pathParameters['id'],
                    ),
                  ),
                ],
              ),
            ],
          ),
          
          // Categories Branch
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/categories',
                builder: (context, state) => const CategoriesScreen(),
                routes: [
                  GoRoute(
                    path: 'create',
                    builder: (context, state) => const CategoryFormScreen(),
                  ),
                  GoRoute(
                    path: 'edit/:id',
                    builder: (context, state) => CategoryFormScreen(
                      categoryId: state.pathParameters['id'],
                    ),
                  ),
                ],
              ),
            ],
          ),
          
          // Transactions Branch
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/transactions',
                builder: (context, state) => const TransactionsScreen(),
                routes: [
                  GoRoute(
                    path: 'create',
                    builder: (context, state) => const TransactionFormScreen(),
                  ),
                  GoRoute(
                    path: 'edit/:id',
                    builder: (context, state) => TransactionFormScreen(
                      transactionId: state.pathParameters['id'],
                    ),
                  ),
                ],
              ),
            ],
          ),
          
          // Profile Branch
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/profile',
                builder: (context, state) => const ProfileScreen(),
                routes: [
                  GoRoute(
                    path: 'settings',
                    builder: (context, state) => const SettingsScreen(),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    ],
  );
});

class ScaffoldWithNavBar extends StatelessWidget {
  const ScaffoldWithNavBar({
    required this.navigationShell,
    Key? key,
  }) : super(key: key ?? const ValueKey<String>('ScaffoldWithNavBar'));

  final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: navigationShell.currentIndex,
        onTap: (index) => _onTap(context, index),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard_outlined),
            activeIcon: Icon(Icons.dashboard),
            label: 'Dashboard',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_balance_outlined),
            activeIcon: Icon(Icons.account_balance),
            label: 'Accounts',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.category_outlined),
            activeIcon: Icon(Icons.category),
            label: 'Categories',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.receipt_outlined),
            activeIcon: Icon(Icons.receipt),
            label: 'Transactions',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            activeIcon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }

  void _onTap(BuildContext context, int index) {
    navigationShell.goBranch(
      index,
      initialLocation: index == navigationShell.currentIndex,
    );
  }
}