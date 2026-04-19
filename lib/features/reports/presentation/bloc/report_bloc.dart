import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smartinevntary/features/reports/domain/usecases/GetReport.dart';
import 'package:smartinevntary/features/reports/presentation/bloc/report_event.dart';
import 'package:smartinevntary/features/reports/presentation/bloc/report_states.dart';

class ReportBloc extends Bloc<ReportEvent, ReportStates> {
  final GetReport getReport;
  ReportBloc(this.getReport) : super(ReportsLoading()) {
    on<LoadReport>((event, emit) async {
      emit(ReportsLoading());
      try {
        final summary = await getReport(event.dateTime);
        emit(ReportsLoaded(summary));
      } catch (e) {
        emit(ReportsError(e.toString()));
      }
    });
  }
}
