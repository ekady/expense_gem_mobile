import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../../domain/entities/account.dart';

abstract class AccountLocalDataSource {
  Future<void> saveAccounts(List<Account> accounts);
  Future<List<Account>> getAccounts();
  Future<void> saveAccount(Account account);
  Future<Account?> getAccountById(String id);
  Future<void> deleteAccount(String id);
  Future<void> clearAccounts();
}

class AccountLocalDataSourceImpl implements AccountLocalDataSource {
  final SharedPreferences sharedPreferences;

  AccountLocalDataSourceImpl({required this.sharedPreferences});

  static const String _accountsKey = 'accounts';
  static const String _accountPrefix = 'account_';

  @override
  Future<void> saveAccounts(List<Account> accounts) async {
    final accountsJson =
        accounts.map((account) => _accountToJson(account)).toList();
    await sharedPreferences.setString(_accountsKey, jsonEncode(accountsJson));
  }

  @override
  Future<List<Account>> getAccounts() async {
    final accountsJson = sharedPreferences.getString(_accountsKey);
    if (accountsJson == null) {
      return [];
    }

    final List<dynamic> accountsList = jsonDecode(accountsJson);
    return accountsList.map((json) => _accountFromJson(json)).toList();
  }

  @override
  Future<void> saveAccount(Account account) async {
    final accounts = await getAccounts();
    final existingIndex = accounts.indexWhere((a) => a.id == account.id);

    if (existingIndex != -1) {
      accounts[existingIndex] = account;
    } else {
      accounts.add(account);
    }

    await saveAccounts(accounts);

    // Also save individual account for quick access
    await sharedPreferences.setString(
      '$_accountPrefix${account.id}',
      jsonEncode(_accountToJson(account)),
    );
  }

  @override
  Future<Account?> getAccountById(String id) async {
    final accountJson = sharedPreferences.getString('$_accountPrefix$id');
    if (accountJson == null) {
      return null;
    }

    return _accountFromJson(jsonDecode(accountJson));
  }

  @override
  Future<void> deleteAccount(String id) async {
    final accounts = await getAccounts();
    accounts.removeWhere((account) => account.id == id);
    await saveAccounts(accounts);

    // Remove individual account
    await sharedPreferences.remove('$_accountPrefix$id');
  }

  @override
  Future<void> clearAccounts() async {
    await sharedPreferences.remove(_accountsKey);

    // Remove all individual account keys
    final keys = sharedPreferences.getKeys();
    for (final key in keys) {
      if (key.startsWith(_accountPrefix)) {
        await sharedPreferences.remove(key);
      }
    }
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
}
