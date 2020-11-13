import 'package:customer_app_java_support/respositories/calendar_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'calendars.dart';

class CalendarBloc extends Bloc<CalendarEvent, CalendarState> {
  final CalendarRepository calendarRepository;
  CalendarBloc({
    @required this.calendarRepository,
  })  : assert(CalendarRepository != null),
        super(CalendarStateLoading());

  @override
  Stream<CalendarState> mapEventToState(CalendarEvent calendarEvent) async* {
    if (calendarEvent is CalendarEventPhotographerDaysFetch) {
      yield* _mapPhotographerDaysFetchToState(calendarEvent.ptgId);
    } 
  }

  Stream<CalendarState> _mapPhotographerDaysFetchToState(int ptgId) async* {
    yield CalendarStateLoading();
    try {
      final photographerDays =
          await this.calendarRepository.getBusyDaysOfPhotographer(ptgId);
      yield CalendarStatePhotographerDaysSuccess(
          photographerDays: photographerDays);
    } catch (_) {
      yield CalendarStateFailure();
    }
  }

  
}
