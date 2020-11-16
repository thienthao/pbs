import 'package:equatable/equatable.dart';
import 'package:photographer_app_java_support/models/busy_day_bloc_model.dart';

abstract class BusyDayEvent extends Equatable {
  const BusyDayEvent();

  @override
  List<Object> get props => [];
}

class BusyDayEventFetch extends BusyDayEvent {
  final int ptgId;

  BusyDayEventFetch({this.ptgId});
}

class BusyDayEventCreate extends BusyDayEvent {
  final int ptgId;
  final BusyDayBlocModel busyDayBlocModel;

  BusyDayEventCreate({this.ptgId, this.busyDayBlocModel});
}

class BusyDayEventUpdate extends BusyDayEvent {
  final int ptgId;
  final BusyDayBlocModel busyDayBlocModel;

  BusyDayEventUpdate({this.ptgId, this.busyDayBlocModel});
}

class BusyDayEventDelete extends BusyDayEvent {
  final int ptgId;
  final int busyDayId;

  BusyDayEventDelete({this.ptgId, this.busyDayId});
}
