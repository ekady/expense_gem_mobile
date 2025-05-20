import 'package:equatable/equatable.dart';

class Transaction extends Equatable {
  final String id;
  final String title;
  final String? description;
  final double amount;
  final DateTime date;
  final String type; // 'income' or 'expense'
  final String categoryId;
  final String accountId;
  final DateTime createdAt;
  final DateTime? updatedAt;
  
  const Transaction({
    required this.id,
    required this.title,
    this.description,
    required this.amount,
    required this.date,
    required this.type,
    required this.categoryId,
    required this.accountId,
    required this.createdAt,
    this.updatedAt,
  });
  
  Transaction copyWith({
    String? id,
    String? title,
    String? description,
    double? amount,
    DateTime? date,
    String? type,
    String? categoryId,
    String? accountId,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Transaction(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      amount: amount ?? this.amount,
      date: date ?? this.date,
      type: type ?? this.type,
      categoryId: categoryId ?? this.categoryId,
      accountId: accountId ?? this.accountId,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
  
  @override
  List<Object?> get props => [
    id,
    title,
    description,
    amount,
    date,
    type,
    categoryId,
    accountId,
    createdAt,
    updatedAt,
  ];
}