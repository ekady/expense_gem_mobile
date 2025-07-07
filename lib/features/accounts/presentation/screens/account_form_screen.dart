import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../domain/entities/account.dart';
import '../providers/account_providers.dart';

class AccountFormScreen extends ConsumerStatefulWidget {
  final String? accountId;

  const AccountFormScreen({super.key, this.accountId});

  @override
  ConsumerState<AccountFormScreen> createState() => _AccountFormScreenState();
}

class _AccountFormScreenState extends ConsumerState<AccountFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();

  String? _selectedIcon;
  String? _selectedColorHex;

  bool _isLoading = false;

  // Predefined list of available icons
  final List<Map<String, dynamic>> _availableIcons = [
    {'name': 'account_balance', 'icon': Icons.account_balance, 'label': 'Bank'},
    {'name': 'money', 'icon': Icons.money, 'label': 'Money'},
    {'name': 'credit_card', 'icon': Icons.credit_card, 'label': 'Credit Card'},
    {'name': 'savings', 'icon': Icons.savings, 'label': 'Savings'},
    {'name': 'wallet', 'icon': Icons.wallet, 'label': 'Wallet'},
    {'name': 'payments', 'icon': Icons.payments, 'label': 'Payments'},
    {
      'name': 'account_circle',
      'icon': Icons.account_circle,
      'label': 'Account',
    },
    {'name': 'business', 'icon': Icons.business, 'label': 'Business'},
    {'name': 'home', 'icon': Icons.home, 'label': 'Home'},
    {'name': 'school', 'icon': Icons.school, 'label': 'School'},
    {'name': 'store', 'icon': Icons.store, 'label': 'Store'},
    {'name': 'shopping_cart', 'icon': Icons.shopping_cart, 'label': 'Shopping'},
    {'name': 'restaurant', 'icon': Icons.restaurant, 'label': 'Restaurant'},
    {'name': 'hotel', 'icon': Icons.hotel, 'label': 'Hotel'},
    {'name': 'flight', 'icon': Icons.flight, 'label': 'Flight'},
    {'name': 'directions_car', 'icon': Icons.directions_car, 'label': 'Car'},
    {'name': 'directions_bus', 'icon': Icons.directions_bus, 'label': 'Bus'},
    {
      'name': 'directions_train',
      'icon': Icons.directions_train,
      'label': 'Train',
    },
    {'name': 'directions_bike', 'icon': Icons.directions_bike, 'label': 'Bike'},
    {'name': 'directions_walk', 'icon': Icons.directions_walk, 'label': 'Walk'},
    {
      'name': 'local_grocery_store',
      'icon': Icons.local_grocery_store,
      'label': 'Grocery',
    },
    {
      'name': 'local_pharmacy',
      'icon': Icons.local_pharmacy,
      'label': 'Pharmacy',
    },
    {
      'name': 'local_hospital',
      'icon': Icons.local_hospital,
      'label': 'Hospital',
    },
    {
      'name': 'local_gas_station',
      'icon': Icons.local_gas_station,
      'label': 'Gas Station',
    },
    {'name': 'local_cafe', 'icon': Icons.local_cafe, 'label': 'Cafe'},
    {
      'name': 'local_restaurant',
      'icon': Icons.local_restaurant,
      'label': 'Restaurant',
    },
    {'name': 'local_bar', 'icon': Icons.local_bar, 'label': 'Bar'},
    {'name': 'local_movies', 'icon': Icons.local_movies, 'label': 'Movies'},
    {'name': 'local_mall', 'icon': Icons.local_mall, 'label': 'Mall'},
    {'name': 'local_offer', 'icon': Icons.local_offer, 'label': 'Offers'},
    {
      'name': 'local_shipping',
      'icon': Icons.local_shipping,
      'label': 'Shipping',
    },
    {'name': 'local_taxi', 'icon': Icons.local_taxi, 'label': 'Taxi'},
    {'name': 'local_airport', 'icon': Icons.local_airport, 'label': 'Airport'},
    {'name': 'local_hotel', 'icon': Icons.local_hotel, 'label': 'Hotel'},
    {
      'name': 'local_laundry_service',
      'icon': Icons.local_laundry_service,
      'label': 'Laundry',
    },
    {'name': 'local_parking', 'icon': Icons.local_parking, 'label': 'Parking'},
    {'name': 'local_atm', 'icon': Icons.local_atm, 'label': 'ATM'},
    {
      'name': 'local_post_office',
      'icon': Icons.local_post_office,
      'label': 'Post Office',
    },
    {'name': 'local_library', 'icon': Icons.local_library, 'label': 'Library'},
    {
      'name': 'local_fire_department',
      'icon': Icons.local_fire_department,
      'label': 'Fire Dept',
    },
    {'name': 'local_police', 'icon': Icons.local_police, 'label': 'Police'},
    {'name': 'local_phone', 'icon': Icons.local_phone, 'label': 'Phone'},
    {
      'name': 'local_printshop',
      'icon': Icons.local_printshop,
      'label': 'Print Shop',
    },
    {'name': 'local_see', 'icon': Icons.local_see, 'label': 'See'},
    {'name': 'local_florist', 'icon': Icons.local_florist, 'label': 'Florist'},
    {'name': 'local_pizza', 'icon': Icons.local_pizza, 'label': 'Pizza'},
    {'name': 'local_dining', 'icon': Icons.local_dining, 'label': 'Dining'},
    {'name': 'local_drink', 'icon': Icons.local_drink, 'label': 'Drink'},
    {
      'name': 'local_convenience_store',
      'icon': Icons.local_convenience_store,
      'label': 'Convenience',
    },
    {
      'name': 'local_car_wash',
      'icon': Icons.local_car_wash,
      'label': 'Car Wash',
    },
    {
      'name': 'local_activity',
      'icon': Icons.local_activity,
      'label': 'Activity',
    },
    {'name': 'local_play', 'icon': Icons.local_play, 'label': 'Play'},
  ];

  // Predefined list of colors
  final List<Map<String, dynamic>> _availableColors = [
    {'name': 'Blue', 'hex': '#2196F3'},
    {'name': 'Green', 'hex': '#4CAF50'},
    {'name': 'Purple', 'hex': '#9C27B0'},
    {'name': 'Orange', 'hex': '#FF9800'},
    {'name': 'Red', 'hex': '#F44336'},
    {'name': 'Teal', 'hex': '#009688'},
    {'name': 'Indigo', 'hex': '#3F51B5'},
    {'name': 'Pink', 'hex': '#E91E63'},
    {'name': 'Brown', 'hex': '#795548'},
    {'name': 'Grey', 'hex': '#9E9E9E'},
    {'name': 'Deep Purple', 'hex': '#673AB7'},
    {'name': 'Light Blue', 'hex': '#03A9F4'},
    {'name': 'Lime', 'hex': '#CDDC39'},
    {'name': 'Amber', 'hex': '#FFC107'},
    {'name': 'Deep Orange', 'hex': '#FF5722'},
    {'name': 'Cyan', 'hex': '#00BCD4'},
  ];

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Watch the account form state provider
    final accountFormState = ref.watch(
      accountFormStateProvider(widget.accountId),
    );

    // Handle the account data when it loads
    accountFormState.whenOrNull(
      data: (account) {
        if (account != null && widget.accountId != null) {
          // Only set the values if they haven't been set yet (to avoid overwriting user input)
          if (_nameController.text.isEmpty) {
            _nameController.text = account.name;
            _descriptionController.text = account.description ?? '';
            _selectedIcon = account.icon;
            _selectedColorHex = account.color;
          }
        }
      },
    );

    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.accountId == null ? 'Create Account' : 'Edit Account',
        ),
        actions: [
          if (widget.accountId != null)
            IconButton(
              icon: const Icon(Icons.delete),
              onPressed: _deleteAccount,
            ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // Account Icon Header
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
                      _selectedIcon != null
                          ? _getIconData(_selectedIcon!)
                          : Icons.account_balance_wallet,
                      color: Colors.white,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.accountId == null
                              ? 'Create Account'
                              : 'Edit Account',
                          style: Theme.of(
                            context,
                          ).textTheme.titleMedium?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Set up your account details',
                          style: Theme.of(
                            context,
                          ).textTheme.bodyMedium?.copyWith(
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

            // Name Field
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Account Name *',
                hintText: 'e.g., Main Bank Account, Cash Wallet',
                prefixIcon: Icon(Icons.title),
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Account name is required';
                }
                if (value.trim().length < 2) {
                  return 'Account name must be at least 2 characters';
                }
                return null;
              },
            ),

            const SizedBox(height: 16),

            // Description Field
            TextFormField(
              controller: _descriptionController,
              maxLines: 3,
              decoration: const InputDecoration(
                labelText: 'Description (Optional)',
                hintText: 'Add any additional details about this account...',
                prefixIcon: Icon(Icons.description),
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 24),

            // Icon Selection
            _buildIconSelector(),

            const SizedBox(height: 24),

            // Color Selection
            _buildColorSelector(),

            const SizedBox(height: 32),

            // Save Button
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _saveAccount,
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child:
                    _isLoading
                        ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                        : Text(
                          widget.accountId == null
                              ? 'Create Account'
                              : 'Update Account',
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

  Widget _buildIconSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Select Icon',
          style: Theme.of(
            context,
          ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 6,
            crossAxisSpacing: 8,
            mainAxisSpacing: 8,
            childAspectRatio: 1,
          ),
          itemCount: _availableIcons.length,
          itemBuilder: (context, index) {
            final iconData = _availableIcons[index];
            final isSelected = _selectedIcon == iconData['name'];

            return GestureDetector(
              onTap: () {
                setState(() {
                  _selectedIcon = iconData['name'];
                });
              },
              child: Container(
                decoration: BoxDecoration(
                  color:
                      isSelected
                          ? Theme.of(
                            context,
                          ).primaryColor.withValues(alpha: 0.2)
                          : Theme.of(context).cardColor,
                  borderRadius: BorderRadius.circular(12),
                  border:
                      isSelected
                          ? Border.all(
                            color: Theme.of(context).primaryColor,
                            width: 2,
                          )
                          : Border.all(
                            color: Theme.of(context).dividerColor,
                            width: 1,
                          ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      iconData['icon'],
                      color:
                          isSelected
                              ? Theme.of(context).primaryColor
                              : Theme.of(context).colorScheme.onSurface,
                      size: 24,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      iconData['label'],
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color:
                            isSelected
                                ? Theme.of(context).primaryColor
                                : Theme.of(context).colorScheme.onSurface,
                        fontWeight:
                            isSelected ? FontWeight.bold : FontWeight.normal,
                      ),
                      textAlign: TextAlign.center,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildColorSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Select Color',
          style: Theme.of(
            context,
          ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 8,
            crossAxisSpacing: 8,
            mainAxisSpacing: 8,
            childAspectRatio: 1,
          ),
          itemCount: _availableColors.length,
          itemBuilder: (context, index) {
            final colorData = _availableColors[index];
            final isSelected = _selectedColorHex == colorData['hex'];

            return GestureDetector(
              onTap: () {
                setState(() {
                  _selectedColorHex = colorData['hex'];
                });
              },
              child: Container(
                decoration: BoxDecoration(
                  color: Color(
                    int.parse(
                      'FF${colorData['hex'].replaceFirst('#', '')}',
                      radix: 16,
                    ),
                  ),
                  borderRadius: BorderRadius.circular(12),
                  border:
                      isSelected
                          ? Border.all(
                            color: Theme.of(context).primaryColor,
                            width: 3,
                          )
                          : Border.all(
                            color: Theme.of(context).dividerColor,
                            width: 1,
                          ),
                ),
                child:
                    isSelected
                        ? const Icon(Icons.check, color: Colors.white, size: 20)
                        : null,
              ),
            );
          },
        ),
      ],
    );
  }

  Future<void> _saveAccount() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (_selectedIcon == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select an icon'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final account = Account(
        id: widget.accountId ?? '',
        name: _nameController.text.trim(),
        description:
            _descriptionController.text.trim().isEmpty
                ? null
                : _descriptionController.text.trim(),
        icon: _selectedIcon!,
        color: _selectedColorHex,
        createdAt: DateTime.now(),
      );

      await ref
          .read(accountFormStateProvider(widget.accountId).notifier)
          .saveAccount(account);

      if (mounted) {
        context.pop();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              widget.accountId == null
                  ? 'Account created successfully!'
                  : 'Account updated successfully!',
            ),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e'), backgroundColor: Colors.red),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _deleteAccount() async {
    if (widget.accountId == null) return;

    final confirmed = await showDialog<bool>(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Delete Account'),
            content: const Text(
              'Are you sure you want to delete this account?',
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

      try {
        await ref
            .read(accountFormStateProvider(widget.accountId).notifier)
            .deleteAccount(widget.accountId!);

        if (mounted) {
          context.pop();
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Account deleted successfully!'),
              backgroundColor: Colors.green,
            ),
          );
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error: $e'), backgroundColor: Colors.red),
          );
        }
      } finally {
        if (mounted) {
          setState(() {
            _isLoading = false;
          });
        }
      }
    }
  }

  IconData _getIconData(String iconName) {
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
