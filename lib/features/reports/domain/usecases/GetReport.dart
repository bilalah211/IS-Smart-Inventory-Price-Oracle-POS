import 'package:smartinevntary/features/reports/domain/entities/report_summary.dart';
import 'package:smartinevntary/features/reports/domain/repositories/report_repository.dart';

class GetReport {
  final ReportRepository reportRepository;

  GetReport(this.reportRepository);

  Future<ReportSummary> call(DateTime date) async {
    return reportRepository.getDailyReport(date);
  }
}
