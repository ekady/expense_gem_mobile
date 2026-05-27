import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../../core/utils/currency_formatter.dart';
import '../../domain/entities/transaction_summary.dart';

class DailyTrendChart extends StatelessWidget {
  final List<DaySummary> days;

  const DailyTrendChart({super.key, required this.days});

  @override
  Widget build(BuildContext context) {
    if (days.isEmpty) return _emptyState(context);

    final maxIncome = days.fold<double>(
      0,
      (m, d) => d.income > m ? d.income : m,
    );
    final maxExpense = days.fold<double>(
      0,
      (m, d) => d.expenses.abs() > m ? d.expenses.abs() : m,
    );
    final maxY = (maxIncome > maxExpense ? maxIncome : maxExpense) * 1.2;

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
          Row(
            children: [
              Text(
                'Daily Trend',
                style: Theme.of(
                  context,
                ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
              ),
              const Spacer(),
              _Dot(color: const Color(0xFF66BB6A), label: 'Income'),
              const SizedBox(width: 12),
              _Dot(color: const Color(0xFFEF5350), label: 'Expense'),
            ],
          ),
          const SizedBox(height: 20),
          SizedBox(
            height: 200,
            child: BarChart(
              BarChartData(
                alignment: BarChartAlignment.spaceAround,
                maxY: maxY > 0 ? maxY : 100,
                barTouchData: BarTouchData(
                  enabled: true,
                  touchTooltipData: BarTouchTooltipData(
                    tooltipMargin: 8,
                    getTooltipItem: (g, gi, rod, ri) {
                      final day = days[g.x.toInt()];
                      final ds = DateFormat('MMM d').format(day.date);
                      final v = ri == 0 ? day.income : day.expenses.abs();
                      final l = ri == 0 ? 'Income' : 'Expense';
                      return BarTooltipItem(
                        '$ds\n$l: ${CurrencyFormatter.format(v, symbol: "Rp", decimalDigits: 0)}',
                        Theme.of(context).textTheme.bodySmall!.copyWith(
                          color: Colors.white,
                          fontSize: 11,
                        ),
                      );
                    },
                  ),
                ),
                titlesData: FlTitlesData(
                  topTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  rightTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 50,
                      getTitlesWidget: (v, _) {
                        if (v == 0) return const SizedBox.shrink();
                        return Padding(
                          padding: const EdgeInsets.only(right: 4),
                          child: Text(
                            CurrencyFormatter.formatCompact(v, symbol: ''),
                            style: Theme.of(
                              context,
                            ).textTheme.labelSmall?.copyWith(
                              fontSize: 9,
                              color: Theme.of(
                                context,
                              ).colorScheme.onSurface.withValues(alpha: 0.5),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 28,
                      getTitlesWidget: (v, _) {
                        final idx = v.toInt();
                        if (idx % 5 != 0 || idx >= days.length) {
                          return const SizedBox.shrink();
                        }
                        return Padding(
                          padding: const EdgeInsets.only(top: 8),
                          child: Text(
                            DateFormat('d').format(days[idx].date),
                            style: Theme.of(
                              context,
                            ).textTheme.labelSmall?.copyWith(
                              fontSize: 10,
                              color: Theme.of(
                                context,
                              ).colorScheme.onSurface.withValues(alpha: 0.5),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: false,
                  horizontalInterval: maxY > 0 ? maxY / 4 : 25,
                  getDrawingHorizontalLine:
                      (v) => FlLine(
                        color: Theme.of(
                          context,
                        ).colorScheme.onSurface.withValues(alpha: 0.08),
                        strokeWidth: 1,
                      ),
                ),
                borderData: FlBorderData(show: false),
                barGroups: _bars(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<BarChartGroupData> _bars() => List.generate(days.length, (i) {
    final d = days[i];
    final w = days.length > 15 ? 3.0 : 6.0;
    const r = BorderRadius.only(
      topLeft: Radius.circular(3),
      topRight: Radius.circular(3),
    );
    return BarChartGroupData(
      x: i,
      barRods: [
        BarChartRodData(
          toY: d.income,
          color: const Color(0xFF66BB6A),
          width: w,
          borderRadius: r,
        ),
        BarChartRodData(
          toY: d.expenses.abs(),
          color: const Color(0xFFEF5350),
          width: w,
          borderRadius: r,
        ),
      ],
    );
  });

  Widget _emptyState(BuildContext context) => Container(
    padding: const EdgeInsets.all(20),
    decoration: BoxDecoration(
      color: Theme.of(context).cardColor,
      borderRadius: BorderRadius.circular(20),
    ),
    child: Column(
      children: [
        Text(
          'Daily Trend',
          style: Theme.of(
            context,
          ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 40),
        Icon(
          Icons.bar_chart_rounded,
          size: 48,
          color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.3),
        ),
        const SizedBox(height: 12),
        Text(
          'No daily data available',
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

class _Dot extends StatelessWidget {
  final Color color;
  final String label;
  const _Dot({required this.color, required this.label});

  @override
  Widget build(BuildContext context) => Row(
    mainAxisSize: MainAxisSize.min,
    children: [
      Container(
        width: 10,
        height: 10,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(3),
        ),
      ),
      const SizedBox(width: 4),
      Text(
        label,
        style: Theme.of(context).textTheme.labelSmall?.copyWith(
          color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
        ),
      ),
    ],
  );
}
