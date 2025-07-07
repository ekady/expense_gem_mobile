import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../providers/account_providers.dart';
import '../widgets/account_item.dart';

class AccountsScreen extends ConsumerStatefulWidget {
  const AccountsScreen({super.key});

  @override
  ConsumerState<AccountsScreen> createState() => _AccountsScreenState();
}

class _AccountsScreenState extends ConsumerState<AccountsScreen> with WidgetsBindingObserver {
  final ScrollController _scrollController = ScrollController();
  final FocusNode _focusNode = FocusNode();
  bool _isLoadingMore = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    WidgetsBinding.instance.addObserver(this);
    
    // Add focus listener to refresh when screen gains focus
    _focusNode.addListener(() {
      if (_focusNode.hasFocus && mounted) {
        // Small delay to ensure navigation is complete
        Future.delayed(const Duration(milliseconds: 100), () {
          if (mounted) {
            ref.read(accountsInfiniteScrollProvider.notifier).refresh();
          }
        });
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _focusNode.dispose();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Refresh accounts when dependencies change (e.g., when returning to screen)
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        ref.read(accountsInfiniteScrollProvider.notifier).refresh();
      }
    });
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    // Refresh when app becomes active again
    if (state == AppLifecycleState.resumed && mounted) {
      ref.read(accountsInfiniteScrollProvider.notifier).refresh();
    }
  }

  void _onScroll() {
    if (_isLoadingMore) return; // Prevent multiple calls while loading
    
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 100) {
      final accountsState = ref.read(accountsInfiniteScrollProvider.notifier);
      if (accountsState.hasMoreData) {
        setState(() {
          _isLoadingMore = true;
        });
        
        accountsState.loadNextPage().then((_) {
          if (mounted) {
            setState(() {
              _isLoadingMore = false;
            });
          }
        }).catchError((_) {
          if (mounted) {
            setState(() {
              _isLoadingMore = false;
            });
          }
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final accountsAsync = ref.watch(accountsInfiniteScrollProvider);

    return Focus(
      focusNode: _focusNode,
      autofocus: true,
      child: Scaffold(
      appBar: AppBar(
        title: const Text('Your Accounts'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              context.push('/accounts/create');
            },
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () => ref.read(accountsInfiniteScrollProvider.notifier).refresh(),
        child: accountsAsync.when(
          data: (accounts) {
            if (accounts.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.account_balance_wallet_outlined,
                      size: 80,
                      color: Theme.of(context).primaryColor.withValues(alpha: 0.5),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'No Accounts Yet',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Tap the + button to add your first account',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton.icon(
                      onPressed: () {
                        context.push('/accounts/create');
                      },
                      icon: const Icon(Icons.add),
                      label: const Text('Add Account'),
                    ),
                  ],
                ),
              );
            }

            return ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.all(16),
              itemCount: accounts.length + 1, // +1 for loading indicator
              itemBuilder: (context, index) {
                if (index == accounts.length) {
                  // Show loading indicator at the bottom
                  final accountsState = ref.read(accountsInfiniteScrollProvider.notifier);
                  if (accountsState.hasMoreData) {
                    return const Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Center(
                        child: CircularProgressIndicator(),
                      ),
                    );
                  } else {
                    return const SizedBox.shrink();
                  }
                }

                final account = accounts[index];
                return Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: AccountItem(
                    account: account,
                    onTap: () {
                      context.push('/accounts/edit/${account.id}');
                    },
                  ),
                );
              },
            );
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, stackTrace) => Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.error_outline,
                  size: 80,
                  color: Theme.of(context).colorScheme.error.withValues(alpha: 0.5),
                ),
                const SizedBox(height: 16),
                Text(
                  'Error loading accounts',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 8),
                Text(
                  error.toString(),
                  style: Theme.of(context).textTheme.bodyMedium,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: () {
                    ref.read(accountsInfiniteScrollProvider.notifier).refresh();
                  },
                  child: const Text('Retry'),
                ),
              ],
            ),
          ),
        ),
      ),
    ));
  }
}

// Note: These classes are defined in your router.dart file
