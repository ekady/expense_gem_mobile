import '../entities/transaction_summary.dart';

abstract class DashboardRepository {
  Future<TransactionSummary> getSummary({
    String? categoryId,
    String? accountId,
    DateTime? startDate,
    DateTime? endDate,
    int? amountType,
  });
} 