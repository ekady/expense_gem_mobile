import 'package:flutter/material.dart';
import '../../domain/entities/category.dart';

class CategoryListItem extends StatelessWidget {
  final Category category;
  final VoidCallback onTap;

  const CategoryListItem({
    super.key,
    required this.category,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    // Convert hex to color
    Color categoryColor = Theme.of(context).primaryColor;
    try {
      if (category.color.isNotEmpty) {
        final hexCode = category.color.replaceFirst('#', '');
        categoryColor = Color(int.parse('FF$hexCode', radix: 16));
      }
    } catch (e) {
      //
    }

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: categoryColor.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  _getIconData(category.icon),
                  color: categoryColor,
                  size: 24,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      category.name,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    if (category.description != null &&
                        category.description!.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.only(top: 4.0),
                        child: Text(
                          category.description!,
                          style: Theme.of(
                            context,
                          ).textTheme.bodySmall?.copyWith(
                            color: Theme.of(
                              context,
                            ).colorScheme.onSurface.withValues(alpha: 0.7),
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                  ],
                ),
              ),
              Icon(
                Icons.chevron_right,
                color: Theme.of(
                  context,
                ).colorScheme.onSurface.withValues(alpha: 0.5),
              ),
            ],
          ),
        ),
      ),
    );
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
