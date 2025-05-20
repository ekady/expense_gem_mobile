import 'package:expense_gem_mobile/features/auth/domain/entities/user.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../auth/presentation/providers/auth_providers.dart';
import '../widgets/profile_menu_item.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userAsync = ref.watch(authStateProvider);

    return Scaffold(
      body: userAsync.when(
        data: (users) {
          User? user = User(
            id: '1',
            name: 'John Doe',
            email: 'john.doe@example.com',
          );

          return CustomScrollView(
            slivers: [
              SliverAppBar(
                expandedHeight: 200,
                pinned: true,
                flexibleSpace: FlexibleSpaceBar(
                  background: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Theme.of(context).primaryColor,
                          Theme.of(context).primaryColor.withValues(alpha: 0.8),
                        ],
                      ),
                    ),
                    child: SafeArea(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const SizedBox(height: 16),
                          user.avatar != null && user.avatar!.isNotEmpty
                              ? CircleAvatar(
                                radius: 40,
                                backgroundImage: NetworkImage(user.avatar!),
                              )
                              : CircleAvatar(
                                radius: 40,
                                backgroundColor: Colors.white,
                                child: Icon(
                                  Icons.person,
                                  size: 50,
                                  color: Theme.of(context).primaryColor,
                                ),
                              ),
                          const SizedBox(height: 12),
                          Text(
                            user.name,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            user.email,
                            style: TextStyle(
                              color: Colors.white.withValues(alpha: 0.8),
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Account',
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      Card(
                        child: Column(
                          children: [
                            ProfileMenuItem(
                                  icon: Icons.person_outline,
                                  title: 'Personal Information',
                                  onTap: () {
                                    // Navigate to edit profile
                                  },
                                )
                                .animate()
                                .fadeIn(delay: 100.ms)
                                .slideX(begin: 0.05, end: 0),
                            const Divider(height: 1),
                            ProfileMenuItem(
                                  icon: Icons.lock_outline,
                                  title: 'Change Password',
                                  onTap: () {
                                    // Navigate to change password
                                  },
                                )
                                .animate()
                                .fadeIn(delay: 150.ms)
                                .slideX(begin: 0.05, end: 0),
                            const Divider(height: 1),
                            ProfileMenuItem(
                                  icon: Icons.notifications_outlined,
                                  title: 'Notifications',
                                  onTap: () {
                                    // Navigate to notifications settings
                                  },
                                )
                                .animate()
                                .fadeIn(delay: 200.ms)
                                .slideX(begin: 0.05, end: 0),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),
                      Text(
                        'Preferences',
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      Card(
                        child: Column(
                          children: [
                            ProfileMenuItem(
                                  icon: Icons.settings_outlined,
                                  title: 'Settings',
                                  onTap: () {
                                    context.push('/profile/settings');
                                  },
                                )
                                .animate()
                                .fadeIn(delay: 250.ms)
                                .slideX(begin: 0.05, end: 0),
                            const Divider(height: 1),
                            ProfileMenuItem(
                                  icon: Icons.currency_exchange,
                                  title: 'Currency',
                                  subtitle: 'USD',
                                  onTap: () {
                                    // Navigate to currency settings
                                  },
                                )
                                .animate()
                                .fadeIn(delay: 300.ms)
                                .slideX(begin: 0.05, end: 0),
                            const Divider(height: 1),
                            ProfileMenuItem(
                                  icon: Icons.help_outline,
                                  title: 'Help & Support',
                                  onTap: () {
                                    // Navigate to help & support
                                  },
                                )
                                .animate()
                                .fadeIn(delay: 350.ms)
                                .slideX(begin: 0.05, end: 0),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),
                      Card(
                            child: ProfileMenuItem(
                              icon: Icons.logout,
                              title: 'Logout',
                              iconColor: Theme.of(context).colorScheme.error,
                              textColor: Theme.of(context).colorScheme.error,
                              onTap: () async {
                                await ref
                                    .read(authStateProvider.notifier)
                                    .logout();
                                if (context.mounted) {
                                  context.go('/login');
                                }
                              },
                            ),
                          )
                          .animate()
                          .fadeIn(delay: 400.ms)
                          .slideX(begin: 0.05, end: 0),
                      const SizedBox(height: 32),
                      Center(
                        child: Text(
                          'Expense Gem v1.0.0',
                          style: Theme.of(
                            context,
                          ).textTheme.bodySmall?.copyWith(
                            color: Theme.of(
                              context,
                            ).colorScheme.onSurface.withValues(alpha: 0.5),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stackTrace) => Center(child: Text('Error: $error')),
      ),
    );
  }
}
