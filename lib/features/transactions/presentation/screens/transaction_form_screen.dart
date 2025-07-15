import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/utils/date_utils.dart';
import '../../../accounts/domain/entities/account.dart';
import '../../../accounts/presentation/providers/account_providers.dart';
import '../../../categories/domain/entities/category.dart';
import '../../../categories/presentation/providers/category_providers.dart';
import '../../domain/entities/transaction.dart';
import '../providers/transaction_providers.dart';

class TransactionFormScreen extends ConsumerStatefulWidget {  
  final String? transactionId;

  const TransactionFormScreen({super.key, this.transactionId});

  @override
  ConsumerState<TransactionFormScreen> createState() => _TransactionFormScreenState();
}

class _TransactionFormScreenState extends ConsumerState<TransactionFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _payeeController = TextEditingController();
  final _amountController = TextEditingController();
  final _notesController = TextEditingController();
  
  String _selectedTransactionType = 'expense';
  String? _selectedAccountId;
  String? _selectedCategoryId;
  DateTime _selectedDate = DateTime.now();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadTransactionData();
  }

  @override
  void dispose() {
    _payeeController.dispose();
    _amountController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  void _loadTransactionData() {
    if (widget.transactionId != null) {
      final transactionAsync = ref.read(transactionProvider(widget.transactionId!));
      transactionAsync.whenData((transaction) {
        if (mounted) {
          _payeeController.text = transaction.payee ?? '';
          _amountController.text = transaction.amount?.abs().toString() ?? '';
          _notesController.text = transaction.notes ?? '';
          _selectedTransactionType = transaction.type ?? '';
          _selectedAccountId = transaction.account?.id;
          _selectedCategoryId = transaction.category?.id;
          _selectedDate = transaction.date ?? DateTime.now();
          setState(() {});
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final transactionFormState = ref.watch(
      transactionFormStateProvider(widget.transactionId),
    );

    // Handle form state changes
    transactionFormState.whenOrNull(
      data: (transaction) {
        // Load transaction data for editing
        if (transaction != null && widget.transactionId != null) {
          if (_payeeController.text.isEmpty) {
            _payeeController.text = transaction.payee ?? '';
            _amountController.text = transaction.amount?.abs().toString() ?? '';
            _notesController.text = transaction.notes ?? '';
            _selectedTransactionType = transaction.type ?? '';
            _selectedAccountId = transaction.account?.id;
            _selectedCategoryId = transaction.category?.id;
            _selectedDate = transaction.date ?? DateTime.now();
          }
        }
        
        // Handle successful operations only when loading
        if (_isLoading) {
          if (transaction != null) {
            // Handle successful save
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (mounted) {
                setState(() {
                  _isLoading = false;
                });
                context.pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      widget.transactionId == null
                          ? 'Transaction created successfully!'
                          : 'Transaction updated successfully!',
                    ),
                    backgroundColor: Colors.green,
                  ),
                );
              }
            });
          } else if (widget.transactionId != null) {
            // Handle successful delete (transaction becomes null after delete)
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (mounted) {
                setState(() {
                  _isLoading = false;
                });
                context.pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Transaction deleted successfully!'),
                    backgroundColor: Colors.green,
                  ),
                );
              }
            });
          }
        }
      },
      error: (error, stackTrace) {
        // Handle error state
        if (_isLoading) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (mounted) {
              setState(() {
                _isLoading = false;
              });
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Error: $error'),
                  backgroundColor: Colors.red,
                ),
              );
            }
          });
        }
      },
    );

    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.transactionId == null ? 'Create Transaction' : 'Edit Transaction',
        ),
        actions: [
          if (widget.transactionId != null)
            IconButton(
              icon: const Icon(Icons.delete),
              onPressed: _deleteTransaction,
            ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // Transaction Header
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Theme.of(context).primaryColor,
                    Theme.of(context).primaryColor.withValues(alpha: 0.8),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      _selectedTransactionType == 'income' 
                          ? Icons.trending_up 
                          : Icons.trending_down,
                      color: Colors.white,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Flexible(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.transactionId == null
                              ? 'Create Transaction'
                              : 'Edit Transaction',
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          _selectedTransactionType == 'income' 
                              ? 'Record your income'
                              : 'Record your expense',
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Colors.white.withValues(alpha: 0.9),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Transaction Type Radio Buttons
            _buildTransactionTypeSelector(),

            const SizedBox(height: 24),

            // Payee Field
            TextFormField(
              controller: _payeeController,
              decoration: const InputDecoration(
                labelText: 'Payee *',
                hintText: 'e.g., Grocery Store, Salary, Restaurant',
                prefixIcon: Icon(Icons.person),
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Payee is required';
                }
                if (value.trim().length < 2) {
                  return 'Payee must be at least 2 characters';
                }
                return null;
              },
            ),

            const SizedBox(height: 16),

            // Amount Field
            TextFormField(
              controller: _amountController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Amount *',
                hintText: '0.00',
                prefixIcon: Icon(Icons.attach_money),
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Amount is required';
                }
                final amount = double.tryParse(value);
                if (amount == null || amount <= 0) {
                  return 'Please enter a valid amount greater than 0';
                }
                return null;
              },
            ),

            const SizedBox(height: 16),

            // Date Field
            InkWell(
              onTap: () => _selectDate(context),
              child: InputDecorator(
                decoration: const InputDecoration(
                  labelText: 'Date *',
                  prefixIcon: Icon(Icons.calendar_today),
                  border: OutlineInputBorder(),
                ),
                child: Text(
                  AppDateUtils.formatDate(_selectedDate),
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Account Selection
            _buildAccountSelector(),

            const SizedBox(height: 16),

            // Category Selection
            _buildCategorySelector(),

            const SizedBox(height: 16),

            // Notes Field
            TextFormField(
              controller: _notesController,
              maxLines: 3,
              decoration: const InputDecoration(
                labelText: 'Notes (Optional)',
                hintText: 'Add any additional details about this transaction...',
                prefixIcon: Icon(Icons.note),
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 32),

            // Save Button
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _saveTransaction,
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: _isLoading
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : Text(
                        widget.transactionId == null
                            ? 'Create Transaction'
                            : 'Update Transaction',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTransactionTypeSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Transaction Type',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Flexible(
              child: RadioListTile<String>(
                title: Row(
                  children: [
                    Icon(
                      Icons.trending_down,
                      color: Colors.red,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    const Text('Expense'),
                  ],
                ),
                value: 'expense',
                groupValue: _selectedTransactionType,
                onChanged: (value) {
                  setState(() {
                    _selectedTransactionType = value!;
                  });
                },
                contentPadding: EdgeInsets.zero,
              ),
            ),
            Flexible(
              child: RadioListTile<String>(
                title: Row(
                  children: [
                    Icon(
                      Icons.trending_up,
                      color: Colors.green,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    const Text('Income'),
                  ],
                ),
                value: 'income',
                groupValue: _selectedTransactionType,
                onChanged: (value) {
                  setState(() {
                    _selectedTransactionType = value!;
                  });
                },
                contentPadding: EdgeInsets.zero,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildAccountSelector() {
    final accountsAsync = ref.watch(accountsProvider);
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Account *',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        accountsAsync.when(
          data: (accounts) {
            return DropdownButtonFormField<String>(
              value: _selectedAccountId,
              decoration: const InputDecoration(
                prefixIcon: Icon(Icons.account_balance_wallet),
                border: OutlineInputBorder(),
              ),
              hint: const Text('Select Account'),
              items: accounts.map((account) {
                return DropdownMenuItem<String>(
                  value: account.id,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        _getIconData(account.icon),
                        size: 20,
                        color: _getAccountColor(account.color),
                      ),
                      const SizedBox(width: 8),
                      Flexible(
                        child: Text(
                          account.name,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _selectedAccountId = value;
                });
              },
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please select an account';
                }
                return null;
              },
            );
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (_, __) => const Text('Failed to load accounts'),
        ),
      ],
    );
  }

  Widget _buildCategorySelector() {
    final categoriesAsync = ref.watch(categoriesProvider);
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Category *',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        categoriesAsync.when(
          data: (categories) {
            return DropdownButtonFormField<String>(
              value: _selectedCategoryId,
              decoration: const InputDecoration(
                prefixIcon: Icon(Icons.category),
                border: OutlineInputBorder(),
              ),
              hint: const Text('Select Category'),
              items: categories.map((category) {
                Color categoryColor = Theme.of(context).primaryColor;
                try {
                  final hexCode = category.color.replaceFirst('#', '');
                  categoryColor = Color(int.parse('FF$hexCode', radix: 16));
                } catch (e) {
                  // Use default if parsing fails
                }
                
                return DropdownMenuItem<String>(
                  value: category.id,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        _getIconData(category.icon),
                        size: 20,
                        color: categoryColor,
                      ),
                      const SizedBox(width: 8),
                      Flexible(
                        child: Text(
                          category.name,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _selectedCategoryId = value;
                });
              },
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please select a category';
                }
                return null;
              },
            );
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (_, __) => const Text('Failed to load categories'),
        ),
      ],
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  Future<void> _saveTransaction() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (_selectedAccountId == null || _selectedCategoryId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select both account and category'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    // Parse amount and apply sign based on transaction type
    final amount = double.parse(_amountController.text);
    final finalAmount = _selectedTransactionType == 'expense' ? -amount : amount;

    // For new transactions, we need to create a temporary transaction with the IDs
    // The API will handle the full object creation
    final transaction = Transaction(
      id: widget.transactionId ?? '',
      payee: _payeeController.text.trim(),
      notes: _notesController.text.trim().isEmpty 
          ? null 
          : _notesController.text.trim(),
      amount: finalAmount,
      date: _selectedDate,
      type: _selectedTransactionType,
      account: Account(
        id: _selectedAccountId!,
        name: '', // Will be filled by API
        description: null,
        icon: '',
        color: '',
      ),
      category: Category(
        id: _selectedCategoryId!,
        name: '', // Will be filled by API
        description: null,
        icon: '',
        color: '',
      ),
      createdAt: widget.transactionId != null 
          ? DateTime.now() 
          : DateTime.now(),
    );

    // Call the provider method - success/error will be handled in build method
    await ref
        .read(transactionFormStateProvider(widget.transactionId).notifier)
        .saveTransaction(transaction);
  }

  Future<void> _deleteTransaction() async {
    if (widget.transactionId == null) return;

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Transaction'),
        content: const Text(
          'Are you sure you want to delete this transaction?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      setState(() {
        _isLoading = true;
      });

      // Call the provider method - success/error will be handled in build method
      await ref
          .read(transactionFormStateProvider(widget.transactionId).notifier)
          .deleteTransaction(widget.transactionId!);
    }
  }

  Color _getAccountColor(String? colorHex) {
    if (colorHex != null && colorHex.isNotEmpty) {
      try {
        final hexCode = colorHex.replaceFirst('#', '');
        return Color(int.parse('FF$hexCode', radix: 16));
      } catch (e) {
        // Use default if parsing fails
      }
    }
    return Theme.of(context).primaryColor;
  }

  IconData _getIconData(String? iconName) {
    switch (iconName) {
      case 'account_balance':
        return Icons.account_balance;
      case 'money':
        return Icons.money;
      case 'credit_card':
        return Icons.credit_card;
      case 'savings':
        return Icons.savings;
      case 'wallet':
        return Icons.wallet;
      case 'payments':
        return Icons.payments;
      case 'account_circle':
        return Icons.account_circle;
      case 'business':
        return Icons.business;
      case 'home':
        return Icons.home;
      case 'school':
        return Icons.school;
      case 'store':
        return Icons.store;
      case 'shopping_cart':
        return Icons.shopping_cart;
      case 'restaurant':
        return Icons.restaurant;
      case 'hotel':
        return Icons.hotel;
      case 'flight':
        return Icons.flight;
      case 'directions_car':
        return Icons.directions_car;
      case 'directions_bus':
        return Icons.directions_bus;
      case 'directions_train':
        return Icons.directions_train;
      case 'directions_bike':
        return Icons.directions_bike;
      case 'directions_walk':
        return Icons.directions_walk;
      case 'local_grocery_store':
        return Icons.local_grocery_store;
      case 'local_pharmacy':
        return Icons.local_pharmacy;
      case 'local_hospital':
        return Icons.local_hospital;
      case 'local_gas_station':
        return Icons.local_gas_station;
      case 'local_cafe':
        return Icons.local_cafe;
      case 'local_restaurant':
        return Icons.local_restaurant;
      case 'local_bar':
        return Icons.local_bar;
      case 'local_movies':
        return Icons.local_movies;
      case 'local_mall':
        return Icons.local_mall;
      case 'local_offer':
        return Icons.local_offer;
      case 'local_shipping':
        return Icons.local_shipping;
      case 'local_taxi':
        return Icons.local_taxi;
      case 'local_airport':
        return Icons.local_airport;
      case 'local_hotel':
        return Icons.local_hotel;
      case 'local_laundry_service':
        return Icons.local_laundry_service;
      case 'local_parking':
        return Icons.local_parking;
      case 'local_atm':
        return Icons.local_atm;
      case 'local_post_office':
        return Icons.local_post_office;
      case 'local_library':
        return Icons.local_library;
      case 'local_fire_department':
        return Icons.local_fire_department;
      case 'local_police':
        return Icons.local_police;
      case 'local_phone':
        return Icons.local_phone;
      case 'local_printshop':
        return Icons.local_printshop;
      case 'local_see':
        return Icons.local_see;
      case 'local_florist':
        return Icons.local_florist;
      case 'local_pizza':
        return Icons.local_pizza;
      case 'local_dining':
        return Icons.local_dining;
      case 'local_drink':
        return Icons.local_drink;
      case 'local_convenience_store':
        return Icons.local_convenience_store;
      case 'local_car_wash':
        return Icons.local_car_wash;
      case 'local_activity':
        return Icons.local_activity;
      case 'local_play':
        return Icons.local_play;
      default:
        return Icons.account_balance_wallet;
    }
  }
}