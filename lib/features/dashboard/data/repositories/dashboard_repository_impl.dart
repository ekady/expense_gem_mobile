import '../../domain/entities/transaction_summary.dart';
import '../../domain/repositories/dashboard_repository.dart';
import '../datasources/dashboard_remote_data_source.dart';

class DashboardRepositoryImpl implements DashboardRepository {
  final DashboardRemoteDataSource remoteDataSource;

  DashboardRepositoryImpl({required this.remoteDataSource});

  @override
  Future<TransactionSummary> getSummary({
    String? accountId,
    DateTime? from,
    DateTime? to,
  }) async {
    return await remoteDataSource.getSummary(
      accountId: accountId,
      from: from,
      to: to,
    );
  }
}
