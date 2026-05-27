import 'package:dio/dio.dart';
import 'package:intl/intl.dart';
import 'package:logger/logger.dart';
import '../../domain/entities/transaction_summary.dart';

abstract class DashboardRemoteDataSource {
  Future<TransactionSummary> getSummary({
    String? accountId,
    DateTime? from,
    DateTime? to,
  });
}

class DashboardRemoteDataSourceImpl implements DashboardRemoteDataSource {
  final Dio dio;
  final Logger logger;

  DashboardRemoteDataSourceImpl({required this.dio, required this.logger});

  @override
  Future<TransactionSummary> getSummary({
    String? accountId,
    DateTime? from,
    DateTime? to,
  }) async {
    try {
      final dateFormat = DateFormat('yyyy-MM-dd');
      final queryParameters = <String, dynamic>{
        if (from != null) 'from': dateFormat.format(from),
        if (to != null) 'to': dateFormat.format(to),
        if (accountId != null && accountId.isNotEmpty) 'accountId': accountId,
      };
      final response = await dio.get(
        '/transaction-summary',
        queryParameters: queryParameters,
      );
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
