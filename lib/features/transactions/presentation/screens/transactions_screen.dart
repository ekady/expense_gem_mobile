import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../providers/transaction_providers.dart';
import '../widgets/transaction_list_item.dart';
import '../widgets/transaction_filter.dart';

class TransactionsScreen extends ConsumerStatefulWidget {
  const TransactionsScreen({super.key});

  @override
  ConsumerState<TransactionsScreen> createState() => _TransactionsScreenState();
}

class _TransactionsScreenState extends ConsumerState<TransactionsScreen>
    with WidgetsBindingObserver {
  final ScrollController _scrollController = ScrollController();
  bool _isLoadingMore = false;
  bool _hasInitialized = false;

  // Store filter parameters in state
  String? _selectedCategory;
  String? _selectedAccount;
  DateTimeRange? _selectedDateRange;
  int? _selectedAmountType; // 1 for income, -1 for expense, null for all

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
    if (!_hasInitialized) {
      _hasInitialized = true;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          _refreshProvider();
        }
      });
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.resumed && mounted && _hasInitialized) {
      Future.delayed(const Duration(milliseconds: 300), () {
        if (mounted) {
          setState(() {
            _isLoadingMore = false;
          });
          _refreshProvider();
        }
      });
    }
  }

  void _onScroll() {
    if (_isLoadingMore) return;
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 100) {
      final provider = _providerInstance();
      final transactionsState = ref.read(provider.notifier);
      if (transactionsState.hasMoreData) {
        setState(() {
          _isLoadingMore = true;
        });
        transactionsState
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

  // Helper to get the current provider instance with current filters
  TransactionsInfiniteScrollProvider _providerInstance() {
    return transactionsInfiniteScrollProvider(
      categoryId: _selectedCategory,
      accountId: _selectedAccount,
      startDate: _selectedDateRange?.start,
      endDate: _selectedDateRange?.end,
      amountType: _selectedAmountType,
    );
  }

  // Only call this when filters change or on refresh
  void _refreshProvider() {
    ref.read(_providerInstance().notifier).refresh();
    if (_scrollController.hasClients) {
      _scrollController.jumpTo(0);
    }
  }

  // Called when filters change
  void _onFilterChanged({
    String? category,
    String? account,
    DateTimeRange? dateRange,
    int? amountType,
  }) {
    setState(() {
      _selectedCategory = category;
      _selectedAccount = account;
      _selectedDateRange = dateRange;
      _selectedAmountType = amountType;
      _isLoadingMore = false;
    });
    _refreshProvider();
  }

  // Method to refresh transactions when returning from form screens
  void _refreshOnReturn() {
    if (mounted && _hasInitialized) {
      setState(() {
        _isLoadingMore = false;
      });
      _refreshProvider();
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = _providerInstance();
    final transactionsAsync = ref.watch(provider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Transactions'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () async {
              await context.push('/transactions/create');
              _refreshOnReturn();
            },
          ),
        ],
      ),
      body: Column(
        children: [
          TransactionFilter(
            selectedCategory: _selectedCategory,
            selectedAccount: _selectedAccount,
            selectedDateRange: _selectedDateRange,
            onCategoryChanged:
                (categoryId) => _onFilterChanged(
                  category: categoryId,
                  account: _selectedAccount,
                  dateRange: _selectedDateRange,
                  amountType: _selectedAmountType,
                ),
            onAccountChanged:
                (accountId) => _onFilterChanged(
                  category: _selectedCategory,
                  account: accountId,
                  dateRange: _selectedDateRange,
                  amountType: _selectedAmountType,
                ),
            onDateRangeChanged:
                (dateRange) => _onFilterChanged(
                  category: _selectedCategory,
                  account: _selectedAccount,
                  dateRange: dateRange,
                  amountType: _selectedAmountType,
                ),
            onResetFilters:
                () => _onFilterChanged(
                  category: null,
                  account: null,
                  dateRange: null,
                  amountType: null,
                ),
            onTypeChanged: (String? type) {
              // Convert type string to amountType: 'income' -> 1, 'expense' -> -1, null -> null
              int? amountType;
              if (type == 'income') {
                amountType = 1;
              } else if (type == 'expense') {
                amountType = -1;
              }
              _onFilterChanged(
                category: _selectedCategory,
                account: _selectedAccount,
                dateRange: _selectedDateRange,
                amountType: amountType,
              );
            },
          ),
          Expanded(
            child: RefreshIndicator(
              onRefresh: () async {
                _refreshProvider();
                return ref.read(provider.future);
              },
              child: transactionsAsync.when(
                data: (transactions) {
                  if (transactions.isEmpty) {
                    return _buildEmptyState();
                  }
                  return ListView.builder(
                    controller: _scrollController,
                    padding: const EdgeInsets.all(16),
                    itemCount: transactions.length + 1,
                    itemBuilder: (context, index) {
                      if (index == transactions.length) {
                        final transactionsState = ref.read(provider.notifier);
                        if (transactionsState.hasMoreData) {
                          return const Padding(
                            padding: EdgeInsets.all(16.0),
                            child: Center(child: CircularProgressIndicator()),
                          );
                        } else {
                          return const SizedBox.shrink();
                        }
                      }
                      final transaction = transactions[index];
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: TransactionListItem(
                          transaction: transaction,
                          onTap: () async {
                            await context.push(
                              '/transactions/edit/${transaction.id}',
                            );
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
                            'Error loading transactions',
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
                            onPressed: _refreshProvider,
                            child: const Text('Retry'),
                          ),
                        ],
                      ),
                    ),
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await context.push('/transactions/create');
          _refreshOnReturn();
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildEmptyState() {
    final bool hasFilters =
        _selectedCategory != null ||
        _selectedAccount != null ||
        _selectedDateRange != null ||
        _selectedAmountType != null;

    return SingleChildScrollView(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              hasFilters ? Icons.filter_list : Icons.receipt_long,
              size: 80,
              color: Theme.of(context).primaryColor.withValues(alpha: 0.5),
            ),
            const SizedBox(height: 16),
            Text(
              hasFilters ? 'No Matching Transactions' : 'No Transactions Yet',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            Text(
              hasFilters
                  ? 'Try adjusting your filters'
                  : 'Tap the + button to add your first transaction',
              style: Theme.of(context).textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            if (hasFilters)
              ElevatedButton.icon(
                onPressed:
                    () => _onFilterChanged(
                      category: null,
                      account: null,
                      dateRange: null,
                      amountType: null,
                    ),
                icon: const Icon(Icons.clear),
                label: const Text('Clear Filters'),
              )
            else
              ElevatedButton.icon(
                onPressed: () {
                  context.push('/transactions/create');
                },
                icon: const Icon(Icons.add),
                label: const Text('Add Transaction'),
              ),
          ],
        ),
      ),
    ).animate().fadeIn().scale(begin: const Offset(0.9, 0.9));
  }
}
