abstract class ReportEvent {}

class LoadReport extends ReportEvent {
  DateTime dateTime;

  LoadReport(this.dateTime);
}
