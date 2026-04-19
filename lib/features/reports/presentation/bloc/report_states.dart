import 'package:smartinevntary/features/reports/domain/entities/report_summary.dart';

abstract class ReportStates {}

class ReportsLoading extends ReportStates {}

class ReportsLoaded extends ReportStates {
  final ReportSummary reportSummary;

  ReportsLoaded(this.reportSummary);
}

class ReportsError extends ReportStates {
  String message;

  ReportsError(this.message);
}
