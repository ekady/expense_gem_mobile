import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../providers/account_providers.dart';
import '../widgets/account_item.dart';

class AccountsScreen extends ConsumerStatefulWidget {
  const AccountsScreen({super.key});

  @override
  ConsumerState<AccountsScreen> createState() => _AccountsScreenState();
}

class _AccountsScreenState extends ConsumerState<AccountsScreen>
    with WidgetsBindingObserver {
  final ScrollController _scrollController = ScrollController();
  bool _isLoadingMore = false;
  bool _hasInitialized = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Only refresh once when the screen is first loaded
    if (!_hasInitialized) {
      _hasInitialized = true;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          ref.read(accountsInfiniteScrollProvider.notifier).refresh();
        }
      });
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    // Only refresh when app becomes active and we have initialized
    if (state == AppLifecycleState.resumed && mounted && _hasInitialized) {
      // Add a small delay to avoid immediate refresh on app resume
      Future.delayed(const Duration(milliseconds: 300), () {
        if (mounted) {
          ref.read(accountsInfiniteScrollProvider.notifier).refresh();
        }
      });
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

        accountsState
            .loadNextPage()
            .then((_) {
              if (mounted) {
                setState(() {
                  _isLoadingMore = false;
                });
              }
            })
            .catchError((_) {
              if (mounted) {
                setState(() {
                  _isLoadingMore = false;
                });
              }
            });
      }
    }
  }

  // Method to refresh accounts when returning from form screens
  void _refreshOnReturn() {
    if (mounted && _hasInitialized) {
      ref.read(accountsInfiniteScrollProvider.notifier).refresh();
    }
  }

  @override
  Widget build(BuildContext context) {
    final accountsAsync = ref.watch(accountsInfiniteScrollProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Accounts'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () async {
              await context.push('/accounts/create');
              _refreshOnReturn();
            },
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh:
            () => ref.read(accountsInfiniteScrollProvider.notifier).refresh(),
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
                      color: Theme.of(
                        context,
                      ).primaryColor.withValues(alpha: 0.5),
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
                      onPressed: () async {
                        await context.push('/accounts/create');
                        _refreshOnReturn();
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
                  final accountsState = ref.read(
                    accountsInfiniteScrollProvider.notifier,
                  );
                  if (accountsState.hasMoreData) {
                    return const Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Center(child: CircularProgressIndicator()),
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
                    onTap: () async {
                      await context.push('/accounts/edit/${account.id}');
                      _refreshOnReturn();
                    },
                  ),
                );
              },
            );
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error:
              (error, stackTrace) => Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.error_outline,
                      size: 80,
                      color: Theme.of(
                        context,
                      ).colorScheme.error.withValues(alpha: 0.5),
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
                        ref
                            .read(accountsInfiniteScrollProvider.notifier)
                            .refresh();
                      },
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              ),
        ),
      ),
    );
  }
}

// Note: These classes are defined in your router.dart file
