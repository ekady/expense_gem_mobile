import 'package:dio/dio.dart';
import 'package:logger/logger.dart';
import '../../domain/entities/transaction_summary.dart';

abstract class DashboardRemoteDataSource {
  Future<TransactionSummary> getSummary({
    String? categoryId,
    String? accountId,
    DateTime? startDate,
    DateTime? endDate,
    int? amountType,
  });
}

class DashboardRemoteDataSourceImpl implements DashboardRemoteDataSource {
  final Dio dio;
  final Logger logger;

  DashboardRemoteDataSourceImpl({required this.dio, required this.logger});

  @override
  Future<TransactionSummary> getSummary({
    String? categoryId,
    String? accountId,
    DateTime? startDate,
    DateTime? endDate,
    int? amountType,
  }) async {
    try {
      final queryParameters = {
        if (categoryId != null) 'categoryId': categoryId,
        if (accountId != null) 'accountId': accountId,
        if (startDate != null) 'startDate': startDate.toIso8601String(),
        if (endDate != null) 'endDate': endDate.toIso8601String(),
        if (amountType != null) 'amountType': amountType,
      };
      final response = await dio.get('/transaction-summary', queryParameters: queryParameters);
      return TransactionSummary.fromJson(response.data);
    } on DioException catch (e) {
      logger.e('Get dashboard summary error: ${e.message}');
      rethrow;
    } catch (e) {
      logger.e('Unexpected dashboard summary error: $e');
      rethrow;
    }
  }
} 