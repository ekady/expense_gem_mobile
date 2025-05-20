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

class _TransactionsScreenState extends ConsumerState<TransactionsScreen> {
  String? _selectedType;
  String? _selectedCategory;
  String? _selectedAccount;
  DateTimeRange? _selectedDateRange;

  @override
  Widget build(BuildContext context) {
    final transactionsAsync = ref.watch(
      filteredTransactionsProvider(
        type: _selectedType,
        categoryId: _selectedCategory,
        accountId: _selectedAccount,
        dateRange: _selectedDateRange,
      ),
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Transactions'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              context.push('/transactions/create');
            },
          ),
        ],
      ),
      body: Column(
        children: [
          TransactionFilter(
            selectedType: _selectedType,
            selectedCategory: _selectedCategory,
            selectedAccount: _selectedAccount,
            selectedDateRange: _selectedDateRange,
            onTypeChanged: (type) {
              setState(() {
                _selectedType = type;
              });
            },
            onCategoryChanged: (categoryId) {
              setState(() {
                _selectedCategory = categoryId;
              });
            },
            onAccountChanged: (accountId) {
              setState(() {
                _selectedAccount = accountId;
              });
            },
            onDateRangeChanged: (dateRange) {
              setState(() {
                _selectedDateRange = dateRange;
              });
            },
            onResetFilters: () {
              setState(() {
                _selectedType = null;
                _selectedCategory = null;
                _selectedAccount = null;
                _selectedDateRange = null;
              });
            },
          ).animate().fadeIn().slideY(begin: -0.1, end: 0),
          Expanded(
            child: RefreshIndicator(
              onRefresh: () => ref.refresh(transactionsProvider.future),
              child: transactionsAsync.when(
                data: (transactions) {
                  if (transactions.isEmpty) {
                    return _buildEmptyState();
                  }

                  return ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: transactions.length,
                    itemBuilder: (context, index) {
                      final transaction = transactions[index];
                      return Padding(
                            padding: const EdgeInsets.only(bottom: 12),
                            child: TransactionListItem(
                              transaction: transaction,
                              onTap: () {
                                context.push(
                                  '/transactions/edit/${transaction.id}',
                                );
                              },
                            ),
                          )
                          .animate()
                          .fadeIn(delay: Duration(milliseconds: 50 * index))
                          .slideX(begin: 0.05, end: 0);
                    },
                  );
                },
                loading: () => const Center(child: CircularProgressIndicator()),
                error:
                    (error, stackTrace) => Center(child: Text('Error: $error')),
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          context.push('/transactions/create');
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildEmptyState() {
    final bool hasFilters =
        _selectedType != null ||
        _selectedCategory != null ||
        _selectedAccount != null ||
        _selectedDateRange != null;

    return Center(
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
              onPressed: () {
                setState(() {
                  _selectedType = null;
                  _selectedCategory = null;
                  _selectedAccount = null;
                  _selectedDateRange = null;
                });
              },
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
    ).animate().fadeIn().scale(begin: const Offset(0.9, 0.9));
  }
}
