import 'package:equatable/equatable.dart';

class CategorySummary extends Equatable {
  final String name;
  final double value;

  const CategorySummary({
    required this.name,
    required this.value,
  });

  factory CategorySummary.fromJson(Map<String, dynamic> json) {
    return CategorySummary(
      name: json['name'] ?? '',
      value: double.tryParse(json['value'].toString()) ?? 0,
    );
  }

  @override
  List<Object?> get props => [name, value];
}

class TransactionSummary extends Equatable {
  final double remainingAmount;
  final double remainingChange;
  final double incomeAmount;
  final double incomeChange;
  final double expensesAmount;
  final double expensesChange;
  final List<CategorySummary> categories;

  const TransactionSummary({
    required this.remainingAmount,
    required this.remainingChange,
    required this.incomeAmount,
    required this.incomeChange,
    required this.expensesAmount,
    required this.expensesChange,
    required this.categories,
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
      categories: (data['categories'] as List<dynamic>? ?? [])
          .map((e) => CategorySummary.fromJson(e as Map<String, dynamic>))
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
  ];
} 