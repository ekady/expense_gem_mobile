import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/transaction_summary.dart';
import '../../domain/repositories/dashboard_repository.dart';
import '../../../../core/services/service_locator.dart';

final dashboardRepositoryProvider = Provider<DashboardRepository>((ref) {
  return getIt<DashboardRepository>();
});

final dashboardSummaryProvider = FutureProvider.autoDispose.family<TransactionSummary, DashboardSummaryFilterParams>((ref, params) async {
  final repo = ref.watch(dashboardRepositoryProvider);
  return await repo.getSummary(
    categoryId: params.categoryId,
    accountId: params.accountId,
    startDate: params.startDate,
    endDate: params.endDate,
    amountType: params.amountType,
  );
});

class DashboardSummaryFilterParams {
  final String? categoryId;
  final String? accountId;
  final DateTime? startDate;
  final DateTime? endDate;
  final int? amountType;

  const DashboardSummaryFilterParams({
    this.categoryId,
    this.accountId,
    this.startDate,
    this.endDate,
    this.amountType,
  });
} 