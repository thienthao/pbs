import 'package:customer_app_java_support/models/working_date_bloc_model.dart';
import 'package:equatable/equatable.dart';

abstract class WorkingDayEvent extends Equatable {
  const WorkingDayEvent();

  @override
  List<Object> get props => [];
}

class WorkingDayEventFetch extends WorkingDayEvent {
  final int ptgId;

  WorkingDayEventFetch({this.ptgId});
}

class WorkingDayEventUpdate extends WorkingDayEvent {
  final int ptgId;
  final List<WorkingDayBlocModel> listWorkingDays;

  WorkingDayEventUpdate({this.ptgId, this.listWorkingDays});
}
