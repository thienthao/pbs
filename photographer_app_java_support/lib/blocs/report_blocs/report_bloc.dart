import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:photographer_app_java_support/models/report_bloc_model.dart';
import 'package:photographer_app_java_support/respositories/report_repository.dart';

import 'report_event.dart';
import 'report_state.dart';

class ReportBloc extends Bloc<ReportEvent, ReportState> {
  final ReportRepository reportRepository;
  ReportBloc({@required this.reportRepository})
      : assert(reportRepository != null),
        super(ReportStateLoading());

  @override
  Stream<ReportState> mapEventToState(ReportEvent reportEvent) async* {
    if (reportEvent is ReportEventInitial) {
      yield ReportStateLoading();
    } else if (reportEvent is ReportEventPost) {
      yield* _mapPostReportToState(reportEvent.report);
    }
  }

  Stream<ReportState> _mapPostReportToState(ReportBlocModel report) async* {
    try {
      final isPosted = await this.reportRepository.postReport(report);
      yield ReportStatePostedSuccess(isPosted: isPosted);
    } catch (_) {
      yield ReportStateFailure(error: _.toString());
    }
  }
}
