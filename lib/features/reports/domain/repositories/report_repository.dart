import 'package:smartinevntary/features/reports/domain/entities/report_summary.dart';

abstract class ReportRepository {
  Future<ReportSummary> getDailyReport(DateTime date);
}
