import '../entities/transaction_summary.dart';

abstract class DashboardRepository {
  Future<TransactionSummary> getSummary({
    String? accountId,
    DateTime? from,
    DateTime? to,
  });
}
