import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../domain/entities/category.dart';
import '../providers/category_providers.dart';

class CategoryFormScreen extends ConsumerStatefulWidget {
  final String? categoryId;

  const CategoryFormScreen({super.key, this.categoryId});

  @override
  ConsumerState<CategoryFormScreen> createState() => _CategoryFormScreenState();
}

class _CategoryFormScreenState extends ConsumerState<CategoryFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();

  String? _selectedIcon;
  String? _selectedColorHex;

  bool _isLoading = false;

  // Predefined list of available icons
  final List<Map<String, dynamic>> _availableIcons = [
    {'name': 'restaurant', 'icon': Icons.restaurant, 'label': 'Food'},
    {
      'name': 'directions_car',
      'icon': Icons.directions_car,
      'label': 'Transport',
    },
    {'name': 'shopping_cart', 'icon': Icons.shopping_cart, 'label': 'Shopping'},
    {'name': 'movie', 'icon': Icons.movie, 'label': 'Entertainment'},
    {'name': 'receipt', 'icon': Icons.receipt, 'label': 'Bills'},
    {'name': 'local_hospital', 'icon': Icons.local_hospital, 'label': 'Health'},
    {
      'name': 'account_balance_wallet',
      'icon': Icons.account_balance_wallet,
      'label': 'Salary',
    },
    {'name': 'trending_up', 'icon': Icons.trending_up, 'label': 'Investment'},
    {'name': 'home', 'icon': Icons.home, 'label': 'Home'},
    {'name': 'school', 'icon': Icons.school, 'label': 'Education'},
    {'name': 'flight', 'icon': Icons.flight, 'label': 'Travel'},
    {'name': 'sports_esports', 'icon': Icons.sports_esports, 'label': 'Gaming'},
    {
      'name': 'fitness_center',
      'icon': Icons.fitness_center,
      'label': 'Fitness',
    },
    {
      'name': 'local_grocery_store',
      'icon': Icons.local_grocery_store,
      'label': 'Grocery',
    },
    {'name': 'local_cafe', 'icon': Icons.local_cafe, 'label': 'Coffee'},
    {'name': 'local_bar', 'icon': Icons.local_bar, 'label': 'Drinks'},
    {'name': 'local_movies', 'icon': Icons.local_movies, 'label': 'Movies'},
    {'name': 'local_mall', 'icon': Icons.local_mall, 'label': 'Shopping'},
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
    {'name': 'local_phone', 'icon': Icons.local_phone, 'label': 'Phone'},
    {
      'name': 'local_printshop',
      'icon': Icons.local_printshop,
      'label': 'Print Shop',
    },
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
    // Watch the category form state provider
    final categoryFormState = ref.watch(
      categoryFormStateProvider(widget.categoryId),
    );

    // Handle the category data when it loads
    categoryFormState.whenOrNull(
      data: (category) {
        if (category != null && widget.categoryId != null) {
          // Only set the values if they haven't been set yet (to avoid overwriting user input)
          if (_nameController.text.isEmpty) {
            _nameController.text = category.name;
            _descriptionController.text = category.description ?? '';
            _selectedIcon = category.icon;
            _selectedColorHex = category.color;
          }
        }
      },
    );

    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.categoryId == null ? 'Create Category' : 'Edit Category',
        ),
        actions: [
          if (widget.categoryId != null)
            IconButton(
              icon: const Icon(Icons.delete),
              onPressed: _deleteCategory,
            ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // Category Icon Header
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
                          : Icons.category,
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
                          widget.categoryId == null
                              ? 'Create Category'
                              : 'Edit Category',
                          style: Theme.of(
                            context,
                          ).textTheme.titleMedium?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Set up your category details',
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
                labelText: 'Category Name *',
                hintText: 'e.g., Food, Transport, Salary',
                prefixIcon: Icon(Icons.title),
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Category name is required';
                }
                if (value.trim().length < 2) {
                  return 'Category name must be at least 2 characters';
                }
                return null;
              },
            ),

            const SizedBox(height: 24),

            // Description Field
            TextFormField(
              controller: _descriptionController,
              maxLines: 3,
              decoration: const InputDecoration(
                labelText: 'Description (Optional)',
                hintText: 'Add any additional details about this category...',
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
                onPressed: _isLoading ? null : _saveCategory,
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
                          widget.categoryId == null
                              ? 'Create Category'
                              : 'Update Category',
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

  Future<void> _saveCategory() async {
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

    if (_selectedColorHex == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select a color'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final category = Category(
        id: widget.categoryId ?? '',
        name: _nameController.text.trim(),
        description:
            _descriptionController.text.trim().isEmpty
                ? null
                : _descriptionController.text.trim(),
        icon: _selectedIcon!,
        color: _selectedColorHex!,
      );

      await ref
          .read(categoryFormStateProvider(widget.categoryId).notifier)
          .saveCategory(category);

      if (mounted) {
        context.pop();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              widget.categoryId == null
                  ? 'Category created successfully!'
                  : 'Category updated successfully!',
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

  Future<void> _deleteCategory() async {
    if (widget.categoryId == null) return;

    final confirmed = await showDialog<bool>(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Delete Category'),
            content: const Text(
              'Are you sure you want to delete this category?',
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
            .read(categoryFormStateProvider(widget.categoryId).notifier)
            .deleteCategory(widget.categoryId!);

        if (mounted) {
          context.pop();
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Category deleted successfully!'),
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
      case 'restaurant':
        return Icons.restaurant;
      case 'directions_car':
        return Icons.directions_car;
      case 'shopping_cart':
        return Icons.shopping_cart;
      case 'movie':
        return Icons.movie;
      case 'receipt':
        return Icons.receipt;
      case 'local_hospital':
        return Icons.local_hospital;
      case 'account_balance_wallet':
        return Icons.account_balance_wallet;
      case 'trending_up':
        return Icons.trending_up;
      case 'home':
        return Icons.home;
      case 'school':
        return Icons.school;
      case 'flight':
        return Icons.flight;
      case 'sports_esports':
        return Icons.sports_esports;
      case 'fitness_center':
        return Icons.fitness_center;
      case 'local_grocery_store':
        return Icons.local_grocery_store;
      case 'local_cafe':
        return Icons.local_cafe;
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
      case 'local_phone':
        return Icons.local_phone;
      case 'local_printshop':
        return Icons.local_printshop;
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
        return Icons.category;
    }
  }
}
