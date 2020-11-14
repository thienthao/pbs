import 'package:equatable/equatable.dart';

abstract class CalendarEvent extends Equatable {
  const CalendarEvent();

  @override
  List<Object> get props => [];
}

class CalendarEventPhotographerDaysFetch extends CalendarEvent {
  final int ptgId;

  CalendarEventPhotographerDaysFetch({this.ptgId});
}

