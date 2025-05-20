import 'package:intl/intl.dart';

class CurrencyFormatter {
  static String format(
    double amount, {
    String locale = 'en_US',
    String symbol = '\$',
    int decimalDigits = 2,
  }) {
    final formatter = NumberFormat.currency(
      locale: locale,
      symbol: symbol,
      decimalDigits: decimalDigits,
    );
    
    return formatter.format(amount);
  }
  
  static String formatCompact(
    double amount, {
    String locale = 'en_US',
    String symbol = '\$',
  }) {
    final formatter = NumberFormat.compactCurrency(
      locale: locale,
      symbol: symbol,
    );
    
    return formatter.format(amount);
  }
}