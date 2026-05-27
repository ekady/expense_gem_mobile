import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/utils/currency_formatter.dart';
import '../providers/dashboard_providers.dart';
import '../widgets/category_breakdown_chart.dart';
import '../widgets/daily_trend_chart.dart';
import '../widgets/dashboard_filter_bar.dart';
import '../widgets/summary_card.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final summaryAsync = ref.watch(dashboardSummaryProvider);

    return Scaffold(
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async {
            ref.invalidate(dashboardSummaryProvider);
          },
          child: CustomScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            slivers: [
              // App Bar
              SliverToBoxAdapter(child: _DashboardAppBar()),

              // Filter Bar
              SliverToBoxAdapter(
                child: const DashboardFilterBar()
                    .animate()
                    .fadeIn(delay: 100.ms)
                    .slideY(begin: 0.1, end: 0),
              ),

              // Content
              summaryAsync.when(
                data:
                    (summary) => SliverList(
                      delegate: SliverChildListDelegate([
                        // Summary Cards Row
                        Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                              ),
                              child: _SummaryCardsSection(
                                remainingAmount: summary.remainingAmount,
                                remainingChange: summary.remainingChange,
                                incomeAmount: summary.incomeAmount,
                                incomeChange: summary.incomeChange,
                                expensesAmount: summary.expensesAmount,
                                expensesChange: summary.expensesChange,
                              ),
                            )
                            .animate()
                            .fadeIn(delay: 200.ms)
                            .slideY(begin: 0.1, end: 0),

                        const SizedBox(height: 16),

                        // Income vs Expense Overview
                        Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                              ),
                              child: _IncomeExpenseOverview(
                                income: summary.incomeAmount,
                                expense: summary.expensesAmount.abs(),
                              ),
                            )
                            .animate()
                            .fadeIn(delay: 300.ms)
                            .slideY(begin: 0.1, end: 0),

                        const SizedBox(height: 16),

                        // Daily Trend Chart
                        Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                              ),
                              child: DailyTrendChart(days: summary.days),
                            )
                            .animate()
                            .fadeIn(delay: 400.ms)
                            .slideY(begin: 0.1, end: 0),

                        const SizedBox(height: 16),

                        // Category Breakdown
                        Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                              ),
                              child: CategoryBreakdownChart(
                                categories: summary.categories,
                              ),
                            )
                            .animate()
                            .fadeIn(delay: 500.ms)
                            .slideY(begin: 0.1, end: 0),

                        const SizedBox(height: 24),
                      ]),
                    ),
                loading:
                    () => const SliverFillRemaining(
                      child: Center(child: CircularProgressIndicator()),
                    ),
                error:
                    (error, _) => SliverFillRemaining(
                      child: _ErrorState(
                        message: error.toString(),
                        onRetry: () {
                          ref.invalidate(dashboardSummaryProvider);
                        },
                      ),
                    ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DashboardAppBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Dashboard',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                'Your financial overview',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Theme.of(
                    context,
                  ).colorScheme.onSurface.withValues(alpha: 0.6),
                ),
              ),
            ],
          ),
          const Spacer(),
        ],
      ),
    ).animate().fadeIn().slideY(begin: -0.1, end: 0);
  }
}

class _SummaryCardsSection extends StatelessWidget {
  final double remainingAmount;
  final double remainingChange;
  final double incomeAmount;
  final double incomeChange;
  final double expensesAmount;
  final double expensesChange;

  const _SummaryCardsSection({
    required this.remainingAmount,
    required this.remainingChange,
    required this.incomeAmount,
    required this.incomeChange,
    required this.expensesAmount,
    required this.expensesChange,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Balance Card (full width)
        SummaryCard(
          title: 'Remaining Balance',
          amount: remainingAmount,
          changePercent: remainingChange,
          icon: Icons.account_balance_wallet_rounded,
          color: const Color(0xFF1565C0),
        ),
        const SizedBox(height: 12),
        // Income & Expense Row
        Row(
          children: [
            Expanded(
              child: SummaryCard(
                title: 'Income',
                amount: incomeAmount,
                changePercent: incomeChange,
                icon: Icons.arrow_downward_rounded,
                color: const Color(0xFF4CAF50),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: SummaryCard(
                title: 'Expenses',
                amount: expensesAmount,
                changePercent: expensesChange,
                icon: Icons.arrow_upward_rounded,
                color: const Color(0xFFE53935),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _IncomeExpenseOverview extends StatelessWidget {
  final double income;
  final double expense;

  const _IncomeExpenseOverview({required this.income, required this.expense});

  @override
  Widget build(BuildContext context) {
    final total = income + expense;
    final incomePct = total > 0 ? (income / total) : 0.5;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Income vs Expense',
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          // Progress bar
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: SizedBox(
              height: 12,
              child: Row(
                children: [
                  Expanded(
                    flex: (incomePct * 100).toInt(),
                    child: Container(
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          colors: [Color(0xFF66BB6A), Color(0xFF4CAF50)],
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: ((1 - incomePct) * 100).toInt(),
                    child: Container(
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          colors: [Color(0xFFEF5350), Color(0xFFE53935)],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              _OverviewItem(
                label: 'Income',
                amount: income,
                color: const Color(0xFF4CAF50),
                icon: Icons.arrow_downward_rounded,
              ),
              const SizedBox(width: 16),
              _OverviewItem(
                label: 'Expense',
                amount: expense,
                color: const Color(0xFFE53935),
                icon: Icons.arrow_upward_rounded,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _OverviewItem extends StatelessWidget {
  final String label;
  final double amount;
  final Color color;
  final IconData icon;

  const _OverviewItem({
    required this.label,
    required this.amount,
    required this.color,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: color, size: 16),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(
                      context,
                    ).colorScheme.onSurface.withValues(alpha: 0.6),
                  ),
                ),
                const SizedBox(height: 2),
                FittedBox(
                  fit: BoxFit.scaleDown,
                  alignment: Alignment.centerLeft,
                  child: Text(
                    CurrencyFormatter.format(
                      amount,
                      symbol: 'Rp',
                      decimalDigits: 0,
                    ),
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ErrorState extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const _ErrorState({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline_rounded,
              size: 64,
              color: Theme.of(context).colorScheme.error.withValues(alpha: 0.7),
            ),
            const SizedBox(height: 16),
            SelectableText.rich(
              TextSpan(
                text: message,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).colorScheme.error,
                ),
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh_rounded),
              label: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }
}
