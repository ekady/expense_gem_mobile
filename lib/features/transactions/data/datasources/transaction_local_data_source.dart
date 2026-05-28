import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../../../accounts/domain/entities/account.dart';
import '../../../categories/domain/entities/category.dart';
import '../../domain/entities/transaction.dart';

abstract class TransactionLocalDataSource {
  Future<void> saveTransactions(List<Transaction> transactions);
  Future<List<Transaction>> getTransactions();
  Future<void> saveTransaction(Transaction transaction);
  Future<Transaction?> getTransactionById(String id);
  Future<void> deleteTransaction(String id);
  Future<void> clearTransactions();
}

class TransactionLocalDataSourceImpl implements TransactionLocalDataSource {
  final SharedPreferences sharedPreferences;

  TransactionLocalDataSourceImpl({required this.sharedPreferences});

  static const String _transactionsKey = 'transactions';
  static const String _transactionPrefix = 'transaction_';

  @override
  Future<void> saveTransactions(List<Transaction> transactions) async {
    final transactionsJson =
        transactions
            .map((transaction) => _transactionToJson(transaction))
            .toList();
    await sharedPreferences.setString(
      _transactionsKey,
      jsonEncode(transactionsJson),
    );
  }

  @override
  Future<List<Transaction>> getTransactions() async {
    final transactionsJson = sharedPreferences.getString(_transactionsKey);
    if (transactionsJson == null) {
      return [];
    }

    final List<dynamic> transactionsList = jsonDecode(transactionsJson);
    return transactionsList.map((json) => _transactionFromJson(json)).toList();
  }

  @override
  Future<void> saveTransaction(Transaction transaction) async {
    final transactions = await getTransactions();
    final existingIndex = transactions.indexWhere(
      (t) => t.id == transaction.id,
    );

    if (existingIndex != -1) {
      transactions[existingIndex] = transaction;
    } else {
      transactions.add(transaction);
    }

    await saveTransactions(transactions);

    // Also save individual transaction for quick access
    await sharedPreferences.setString(
      '$_transactionPrefix${transaction.id}',
      jsonEncode(_transactionToJson(transaction)),
    );
  }

  @override
  Future<Transaction?> getTransactionById(String id) async {
    final transactionJson = sharedPreferences.getString(
      '$_transactionPrefix$id',
    );
    if (transactionJson == null) {
      return null;
    }

    return _transactionFromJson(jsonDecode(transactionJson));
  }

  @override
  Future<void> deleteTransaction(String id) async {
    final transactions = await getTransactions();
    transactions.removeWhere((transaction) => transaction.id == id);
    await saveTransactions(transactions);

    // Remove individual transaction
    await sharedPreferences.remove('$_transactionPrefix$id');
  }

  @override
  Future<void> clearTransactions() async {
    await sharedPreferences.remove(_transactionsKey);

    // Remove all individual transaction keys
    final keys = sharedPreferences.getKeys();
    for (final key in keys) {
      if (key.startsWith(_transactionPrefix)) {
        await sharedPreferences.remove(key);
      }
    }
  }

  Map<String, dynamic> _transactionToJson(Transaction transaction) {
    return {
      'id': transaction.id,
      'payee': transaction.payee,
      'notes': transaction.notes,
      'amount': transaction.amount,
      'date': transaction.date?.toIso8601String(),
      'type': transaction.type,
      'account': _accountToJson(
        transaction.account ??
            Account(id: '', name: '', description: '', icon: '', color: ''),
      ),
      'category': _categoryToJson(
        transaction.category ??
            Category(id: '', name: '', description: '', icon: '', color: ''),
      ),
      'createdAt': transaction.createdAt?.toIso8601String(),
      if (transaction.updatedAt != null)
        'updatedAt': transaction.updatedAt!.toIso8601String(),
    };
  }

  Transaction _transactionFromJson(Map<String, dynamic> json) {
    return Transaction(
      id: json['id'],
      payee: json['payee'],
      notes: json['notes'],
      amount: (json['amount'] as num).toDouble(),
      date: DateTime.parse(json['date']),
      type: json['type'],
      account: _accountFromJson(json['account']),
      category: _categoryFromJson(json['category']),
      createdAt:
          json['createdAt'] != null
              ? DateTime.parse(json['createdAt'])
              : DateTime.now(),
      updatedAt:
          json['updatedAt'] != null ? DateTime.parse(json['updatedAt']) : null,
    );
  }

  Map<String, dynamic> _accountToJson(Account account) {
    return {
      'id': account.id,
      'name': account.name,
      'description': account.description,
      'icon': account.icon,
      'color': account.color,
      if (account.createdAt != null)
        'createdAt': account.createdAt!.toIso8601String(),
      if (account.updatedAt != null)
        'updatedAt': account.updatedAt!.toIso8601String(),
    };
  }

  Account _accountFromJson(Map<String, dynamic> json) {
    return Account(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      icon: json['icon'],
      color: json['color'],
      createdAt:
          json['createdAt'] != null ? DateTime.parse(json['createdAt']) : null,
      updatedAt:
          json['updatedAt'] != null ? DateTime.parse(json['updatedAt']) : null,
    );
  }

  Map<String, dynamic> _categoryToJson(Category category) {
    return {
      'id': category.id,
      'name': category.name,
      'description': category.description,
      'icon': category.icon,
      'color': category.color,
      if (category.createdAt != null)
        'createdAt': category.createdAt!.toIso8601String(),
      if (category.updatedAt != null)
        'updatedAt': category.updatedAt!.toIso8601String(),
    };
  }

  Category _categoryFromJson(Map<String, dynamic> json) {
    return Category(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      icon: json['icon'],
      color: json['color'],
      createdAt:
          json['createdAt'] != null ? DateTime.parse(json['createdAt']) : null,
      updatedAt:
          json['updatedAt'] != null ? DateTime.parse(json['updatedAt']) : null,
    );
  }
}
