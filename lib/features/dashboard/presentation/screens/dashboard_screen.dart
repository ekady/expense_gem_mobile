import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fl_chart/fl_chart.dart';

import '../widgets/account_balance_card.dart';
import '../widgets/expense_summary_card.dart';
import '../widgets/recent_transaction_card.dart';
import '../widgets/filter_chip_group.dart';
import '../widgets/dashboard_header.dart';
import '../providers/dashboard_providers.dart';

class DashboardScreen extends ConsumerStatefulWidget {
  const DashboardScreen({super.key});

  @override
  ConsumerState<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends ConsumerState<DashboardScreen> {
  String _selectedPeriod = 'This Month';
  String? _selectedAccount;
  String? _selectedCategory;
  DateTimeRange? _selectedDateRange;
  int? _selectedAmountType;

  final List<String> _periods = [
    'Today',
    'This Week',
    'This Month',
    'This Year',
  ];
  final List<String> _accounts = [
    'All Accounts',
    'Bank Account',
    'Cash',
    'Credit Card',
  ];
  final List<String> _categories = [
    'All Categories',
    'Food',
    'Transport',
    'Shopping',
    'Entertainment',
    'Bills',
    'Health',
  ];

  @override
  Widget build(BuildContext context) {
    final filterParams = DashboardSummaryFilterParams(
      categoryId: _selectedCategory,
      accountId: _selectedAccount,
      startDate: _selectedDateRange?.start,
      endDate: _selectedDateRange?.end,
      amountType: _selectedAmountType,
    );
    final summaryAsync = ref.watch(dashboardSummaryProvider(filterParams));
    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            // Dashboard Header
            SliverToBoxAdapter(
              child: DashboardHeader(
                userName: 'John',
                totalBalance: 12850.75,
              ).animate().fadeIn().slideY(begin: -0.1, end: 0),
            ),

            // Filters
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 8),
                    Text(
                      'Overview',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 8),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          FilterChipGroup(
                            items: _periods,
                            selectedItem: _selectedPeriod,
                            onSelected: (value) {
                              setState(() {
                                _selectedPeriod = value;
                              });
                            },
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 8),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          FilterChipGroup(
                            items: _accounts,
                            selectedItem: _selectedAccount ?? 'All Accounts',
                            onSelected: (value) {
                              setState(() {
                                _selectedAccount =
                                    value == 'All Accounts' ? null : value;
                              });
                            },
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 8),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          FilterChipGroup(
                            items: _categories,
                            selectedItem: _selectedCategory ?? 'All Categories',
                            onSelected: (value) {
                              setState(() {
                                _selectedCategory =
                                    value == 'All Categories' ? null : value;
                              });
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ).animate().fadeIn(delay: 100.ms).slideY(begin: 0.1, end: 0),
            ),

            // Account Balances
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Your Accounts',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      height: 120,
                      child: ListView(
                        scrollDirection: Axis.horizontal,
                        children: [
                          AccountBalanceCard(
                            accountName: 'Bank Account',
                            balance: 8450.50,
                            icon: Icons.account_balance,
                            color: Colors.blue,
                          ),
                          const SizedBox(width: 12),
                          AccountBalanceCard(
                            accountName: 'Cash',
                            balance: 1250.25,
                            icon: Icons.money,
                            color: Colors.green,
                          ),
                          const SizedBox(width: 12),
                          AccountBalanceCard(
                            accountName: 'Credit Card',
                            balance: 3150.00,
                            icon: Icons.credit_card,
                            color: Colors.purple,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ).animate().fadeIn(delay: 200.ms).slideY(begin: 0.1, end: 0),
            ),

            // Expense & Income Summary
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: summaryAsync.when(
                  data: (summary) => ExpenseSummaryCard(
                    income: summary.incomeAmount,
                    expense: summary.expensesAmount,
                    pieChartSections: [], // TODO: Map summary.categories to PieChartSectionData
                    categories: summary.categories.map((c) => {
                      'name': c.name,
                      'color': Colors.blue, // TODO: Assign color based on category or palette
                      'percentage': c.value, // TODO: Map value to percentage if needed
                    }).toList(),
                  ),
                  loading: () => const Center(child: CircularProgressIndicator()),
                  error: (e, _) => Center(child: Text('Error: $e')),
                ),
              ).animate().fadeIn(delay: 300.ms).slideY(begin: 0.1, end: 0),
            ),

            // Recent Transactions
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Recent Transactions',
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        TextButton(
                          onPressed: () {
                            // Navigate to transactions screen
                          },
                          child: const Text('See All'),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                  ],
                ),
              ),
            ),

            // List of Transactions
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  final transactions = [
                    {
                      'title': 'Grocery Shopping',
                      'category': 'Food',
                      'amount': -125.50,
                      'date': 'Today',
                      'icon': Icons.shopping_basket,
                      'color': Colors.red,
                    },
                    {
                      'title': 'Salary Deposit',
                      'category': 'Income',
                      'amount': 3500.00,
                      'date': 'Yesterday',
                      'icon': Icons.account_balance_wallet,
                      'color': Colors.green,
                    },
                    {
                      'title': 'Restaurant',
                      'category': 'Food',
                      'amount': -85.75,
                      'date': 'Yesterday',
                      'icon': Icons.restaurant,
                      'color': Colors.red,
                    },
                    {
                      'title': 'Uber Ride',
                      'category': 'Transport',
                      'amount': -24.99,
                      'date': '2 days ago',
                      'icon': Icons.directions_car,
                      'color': Colors.blue,
                    },
                    {
                      'title': 'Amazon Purchase',
                      'category': 'Shopping',
                      'amount': -149.99,
                      'date': '3 days ago',
                      'icon': Icons.shopping_cart,
                      'color': Colors.purple,
                    },
                  ];

                  if (index >= transactions.length) return null;

                  final transaction = transactions[index];

                  return Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16.0,
                          vertical: 8.0,
                        ),
                        child: RecentTransactionCard(
                          title: transaction['title'] as String,
                          category: transaction['category'] as String,
                          amount: transaction['amount'] as double,
                          date: transaction['date'] as String,
                          icon: transaction['icon'] as IconData,
                          color: transaction['color'] as Color,
                        ),
                      )
                      .animate()
                      .fadeIn(delay: Duration(milliseconds: 350 + (index * 50)))
                      .slideY(begin: 0.1, end: 0);
                },
                childCount: 5, // Number of transactions to show
              ),
            ),

            // Bottom padding for safe area
            const SliverToBoxAdapter(child: SizedBox(height: 16)),
          ],
        ),
      ),
    );
  }
}
