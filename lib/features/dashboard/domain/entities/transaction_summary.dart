import 'package:equatable/equatable.dart';

class CategorySummary extends Equatable {
  final String name;
  final double value;

  const CategorySummary({required this.name, required this.value});

  factory CategorySummary.fromJson(Map<String, dynamic> json) {
    return CategorySummary(
      name: json['name'] ?? '',
      value: double.tryParse(json['value'].toString()) ?? 0,
    );
  }

  @override
  List<Object?> get props => [name, value];
}

class DaySummary extends Equatable {
  final DateTime date;
  final double income;
  final double expenses;

  const DaySummary({
    required this.date,
    required this.income,
    required this.expenses,
  });

  factory DaySummary.fromJson(Map<String, dynamic> json) {
    return DaySummary(
      date: DateTime.parse(json['date'] as String),
      income: double.tryParse(json['income'].toString()) ?? 0,
      expenses: double.tryParse(json['expenses'].toString()) ?? 0,
    );
  }

  @override
  List<Object?> get props => [date, income, expenses];
}

class TransactionSummary extends Equatable {
  final double remainingAmount;
  final double remainingChange;
  final double incomeAmount;
  final double incomeChange;
  final double expensesAmount;
  final double expensesChange;
  final List<CategorySummary> categories;
  final List<DaySummary> days;

  const TransactionSummary({
    required this.remainingAmount,
    required this.remainingChange,
    required this.incomeAmount,
    required this.incomeChange,
    required this.expensesAmount,
    required this.expensesChange,
    required this.categories,
    required this.days,
  });

  factory TransactionSummary.fromJson(Map<String, dynamic> json) {
    final data = json['data'] ?? json;
    return TransactionSummary(
      remainingAmount: (data['remainingAmount'] as num?)?.toDouble() ?? 0,
      remainingChange: (data['remainingChange'] as num?)?.toDouble() ?? 0,
      incomeAmount: (data['incomeAmount'] as num?)?.toDouble() ?? 0,
      incomeChange: (data['incomeChange'] as num?)?.toDouble() ?? 0,
      expensesAmount: (data['expensesAmount'] as num?)?.toDouble() ?? 0,
      expensesChange: (data['expensesChange'] as num?)?.toDouble() ?? 0,
      categories:
          (data['categories'] as List<dynamic>? ?? [])
              .map((e) => CategorySummary.fromJson(e as Map<String, dynamic>))
              .toList(),
      days:
          (data['days'] as List<dynamic>? ?? [])
              .map((e) => DaySummary.fromJson(e as Map<String, dynamic>))
              .toList(),
    );
  }

  @override
  List<Object?> get props => [
    remainingAmount,
    remainingChange,
    incomeAmount,
    incomeChange,
    expensesAmount,
    expensesChange,
    categories,
    days,
  ];
}
