import 'package:equatable/equatable.dart';

import '../../../accounts/domain/entities/account.dart';
import '../../../categories/domain/entities/category.dart';

class Transaction extends Equatable {
  final String? id;
  final String? payee;
  final String? notes;
  final double? amount;
  final DateTime? date;
  final String? type; // 'income' or 'expense'
  final Account? account;
  final Category? category;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const Transaction({
    this.id,
    this.payee,
    this.notes,
    this.amount,
    this.date,
    this.type,
    this.account,
    this.category,
    this.createdAt,
    this.updatedAt,
  });

  Transaction copyWith({
    String? id,
    String? payee,
    String? notes,
    double? amount,
    DateTime? date,
    String? type,
    Account? account,
    Category? category,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Transaction(
      id: id ?? this.id,
      payee: payee ?? this.payee,
      notes: notes ?? this.notes,
      amount: amount ?? this.amount,
      date: date ?? this.date,
      type: type ?? this.type,
      account: account ?? this.account,
      category: category ?? this.category,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  List<Object?> get props => [
    id,
    payee,
    notes,
    amount,
    date,
    type,
    account,
    category,
    createdAt,
    updatedAt,
  ];
}
