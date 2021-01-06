import 'package:customer_app_java_support/models/report_bloc_model.dart';
import 'package:equatable/equatable.dart';

abstract class ReportEvent extends Equatable {
  const ReportEvent();

  @override
  List<Object> get props => [];
}

class ReportEventInitial extends ReportEvent {}

class ReportEventPost extends ReportEvent {
  final ReportBlocModel report;
  ReportEventPost({this.report});
}
