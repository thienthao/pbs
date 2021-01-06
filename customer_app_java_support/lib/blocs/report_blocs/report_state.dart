import 'package:equatable/equatable.dart';

abstract class ReportState extends Equatable {
  const ReportState();

  @override
  List<Object> get props => [];
}

class ReportStateLoading extends ReportState {}

class ReportStatePostedSuccess extends ReportState {
  final bool isPosted;

  ReportStatePostedSuccess({this.isPosted});
}

class ReportStateFailure extends ReportState {
  final String error;
  ReportStateFailure({
    this.error,
  });
}
