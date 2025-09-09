import '../../domain/entities/transaction_summary.dart';
import '../../domain/repositories/dashboard_repository.dart';
import '../datasources/dashboard_remote_data_source.dart';

class DashboardRepositoryImpl implements DashboardRepository {
  final DashboardRemoteDataSource remoteDataSource;

  DashboardRepositoryImpl({required this.remoteDataSource});

  @override
  Future<TransactionSummary> getSummary({
    String? categoryId,
    String? accountId,
    DateTime? startDate,
    DateTime? endDate,
    int? amountType,
  }) async {
    return await remoteDataSource.getSummary(
      categoryId: categoryId,
      accountId: accountId,
      startDate: startDate,
      endDate: endDate,
      amountType: amountType,
    );
  }
} 