import 'package:flutter/material.dart';
import '../../domain/entities/account.dart';

class AccountItem extends StatelessWidget {
  final Account account;
  final VoidCallback onTap;

  const AccountItem({super.key, required this.account, required this.onTap});

  @override
  Widget build(BuildContext context) {
    // Determine the color from hex or use a default
    Color accountColor = Theme.of(context).colorScheme.primary;
    if (account.color != null && account.color!.isNotEmpty) {
      try {
        final hexCode = account.color!.replaceFirst('#', '');
        accountColor = Color(int.parse('FF$hexCode', radix: 16));
      } catch (e) {
        // Use default color if parsing fails
      }
    }

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: accountColor.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                _getIconData(account.icon),
                color: accountColor.withValues(alpha: 0.8),
                size: 24,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                account.name,
                style: Theme.of(
                  context,
                ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
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
    );
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
      default:
        return Icons.account_balance_wallet;
    }
  }
}
