import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/utils/currency_formatter.dart';
import '../../../../core/utils/date_utils.dart';
import '../../domain/entities/transaction.dart';

class TransactionListItem extends ConsumerWidget {
  final Transaction transaction;
  final VoidCallback onTap;
  
  const TransactionListItem({
    super.key,
    required this.transaction,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isIncome = transaction.type == 'income';
    
    return Card(
      elevation: 2,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              // Category Icon
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: _getCategoryColor(transaction.category?.color).withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  _getIconData(transaction.category?.icon),
                  color: _getCategoryColor(transaction.category?.color),
                  size: 24,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      transaction.payee ?? '',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Text(
                          transaction.account?.name ?? '',
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
                          ),
                        ),
                        const SizedBox(width: 8),
                        const Text('•'),
                        const SizedBox(width: 8),
                        Text(
                          AppDateUtils.formatDate(transaction.date ?? DateTime.now()),
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              Text(
                isIncome
                    ? '+ ${CurrencyFormatter.format(transaction.amount ?? 0)}'
                    : '- ${CurrencyFormatter.format((transaction.amount ?? 0) * -1)}',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: isIncome ? Colors.green : Colors.red,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  
  Color _getCategoryColor(String? colorHex) {
    if (colorHex != null && colorHex.isNotEmpty) {
      try {
        final hexCode = colorHex.replaceFirst('#', '');
        return Color(int.parse('FF$hexCode', radix: 16));
      } catch (e) {
        // Use default if parsing fails
      }
    }
    return Colors.grey;
  }
  
  IconData _getIconData(String? iconName) {
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
      case 'local_dining':
        return Icons.local_dining;
      case 'savings':
        return Icons.savings;
      case 'account_balance':
        return Icons.account_balance;
      case 'money':
        return Icons.money;
      case 'credit_card':
        return Icons.credit_card;
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
      case 'hotel':
        return Icons.hotel;
      case 'flight':
        return Icons.flight;
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