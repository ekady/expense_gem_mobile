import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/services/service_locator.dart';
import '../../../../core/utils/date_utils.dart';
import '../../../accounts/domain/entities/account.dart';
import '../../../accounts/presentation/providers/account_providers.dart';
import '../../domain/entities/transaction_summary.dart';
import '../../domain/repositories/dashboard_repository.dart';

final dashboardRepositoryProvider = Provider<DashboardRepository>((ref) {
  return getIt<DashboardRepository>();
});

/// Filter params for the dashboard summary API
class DashboardFilter extends Equatable {
  final DateTime from;
  final DateTime to;
  final String? accountId;

  const DashboardFilter({required this.from, required this.to, this.accountId});

  /// Default filter: current month
  factory DashboardFilter.currentMonth() {
    final now = DateTime.now();
    return DashboardFilter(
      from: AppDateUtils.startOfMonth(now),
      to: AppDateUtils.endOfMonth(now),
    );
  }

  DashboardFilter copyWith({
    DateTime? from,
    DateTime? to,
    String? Function()? accountId,
  }) {
    return DashboardFilter(
      from: from ?? this.from,
      to: to ?? this.to,
      accountId: accountId != null ? accountId() : this.accountId,
    );
  }

  @override
  List<Object?> get props => [from, to, accountId];
}

/// Holds the current filter state
final dashboardFilterProvider = StateProvider<DashboardFilter>((ref) {
  return DashboardFilter.currentMonth();
});

/// Fetches dashboard summary based on current filter
final dashboardSummaryProvider = FutureProvider.autoDispose<TransactionSummary>(
  (ref) async {
    final filter = ref.watch(dashboardFilterProvider);
    final repo = ref.watch(dashboardRepositoryProvider);
    return await repo.getSummary(
      from: filter.from,
      to: filter.to,
      accountId: filter.accountId,
    );
  },
);

/// Fetches accounts for the filter dropdown
final dashboardAccountsProvider = FutureProvider.autoDispose<List<Account>>((
  ref,
) async {
  final data = await ref.watch(accountsProvider.future);
  return data;
});
