import 'dart:math' as math;
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import '../../domain/entities/transaction_summary.dart';

/// Curated palette for pie chart slices
const List<Color> _kCategoryColors = [
  Color(0xFF42A5F5), // Blue
  Color(0xFFEF5350), // Red
  Color(0xFF66BB6A), // Green
  Color(0xFFFF7043), // Deep Orange
  Color(0xFFAB47BC), // Purple
  Color(0xFFFFA726), // Orange
  Color(0xFF26C6DA), // Cyan
  Color(0xFFEC407A), // Pink
  Color(0xFF8D6E63), // Brown
  Color(0xFF78909C), // Blue-Grey
];

class CategoryBreakdownChart extends StatefulWidget {
  final List<CategorySummary> categories;

  const CategoryBreakdownChart({super.key, required this.categories});

  @override
  State<CategoryBreakdownChart> createState() => _CategoryBreakdownChartState();
}

class _CategoryBreakdownChartState extends State<CategoryBreakdownChart> {
  int _touchedIndex = -1;

  @override
  Widget build(BuildContext context) {
    final expenseCategories =
        widget.categories.where((c) => c.name != 'Main Income').toList();

    if (expenseCategories.isEmpty) {
      return _buildEmptyState(context);
    }

    final total = expenseCategories.fold<double>(
      0,
      (sum, c) => sum + c.value.abs(),
    );

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
            'Expense by Category',
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),
          SizedBox(
            height: 200,
            child: Row(
              children: [
                Expanded(
                  child: PieChart(
                    PieChartData(
                      pieTouchData: PieTouchData(
                        touchCallback: (event, response) {
                          setState(() {
                            if (!event.isInterestedForInteractions ||
                                response == null ||
                                response.touchedSection == null) {
                              _touchedIndex = -1;
                              return;
                            }
                            _touchedIndex =
                                response.touchedSection!.touchedSectionIndex;
                          });
                        },
                      ),
                      sections: _buildSections(expenseCategories, total),
                      centerSpaceRadius: 36,
                      sectionsSpace: 3,
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _CategoryLegend(
                    categories: expenseCategories,
                    total: total,
                    touchedIndex: _touchedIndex,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  List<PieChartSectionData> _buildSections(
    List<CategorySummary> categories,
    double total,
  ) {
    return List.generate(categories.length, (i) {
      final isTouched = i == _touchedIndex;
      final category = categories[i];
      final percentage = total > 0 ? (category.value.abs() / total) * 100 : 0;
      final color = _kCategoryColors[i % _kCategoryColors.length];

      return PieChartSectionData(
        value: category.value.abs(),
        title: isTouched ? '${percentage.toStringAsFixed(1)}%' : '',
        radius: isTouched ? 60 : 50,
        color: color,
        titleStyle: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
        titlePositionPercentageOffset: 0.6,
      );
    });
  }

  Widget _buildEmptyState(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          Text(
            'Expense by Category',
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 40),
          Icon(
            Icons.pie_chart_outline_rounded,
            size: 48,
            color: Theme.of(
              context,
            ).colorScheme.onSurface.withValues(alpha: 0.3),
          ),
          const SizedBox(height: 12),
          Text(
            'No expense data available',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Theme.of(
                context,
              ).colorScheme.onSurface.withValues(alpha: 0.5),
            ),
          ),
          const SizedBox(height: 40),
        ],
      ),
    );
  }
}

class _CategoryLegend extends StatelessWidget {
  final List<CategorySummary> categories;
  final double total;
  final int touchedIndex;

  const _CategoryLegend({
    required this.categories,
    required this.total,
    required this.touchedIndex,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: List.generate(math.min(categories.length, 5), (i) {
        final category = categories[i];
        final color = _kCategoryColors[i % _kCategoryColors.length];
        final percentage = total > 0 ? (category.value.abs() / total) * 100 : 0;
        final isTouched = i == touchedIndex;

        return AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          margin: const EdgeInsets.only(bottom: 8),
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
          decoration: BoxDecoration(
            color:
                isTouched ? color.withValues(alpha: 0.1) : Colors.transparent,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            children: [
              Container(
                width: 12,
                height: 12,
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(3),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  category.name,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    fontWeight: isTouched ? FontWeight.bold : FontWeight.normal,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Text(
                '${percentage.toStringAsFixed(0)}%',
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: color,
                ),
              ),
            ],
          ),
        );
      }),
    );
  }
}
