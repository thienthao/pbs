import 'package:customer_app_java_support/respositories/calendar_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'working_days.dart';

class WorkingDayBloc extends Bloc<WorkingDayEvent, WorkingDayState> {
  final CalendarRepository calendarRepository;
  WorkingDayBloc({
    @required this.calendarRepository,
  })  : assert(CalendarRepository != null),
        super(WorkingDayStateLoading());

  @override
  Stream<WorkingDayState> mapEventToState(
      WorkingDayEvent workingDayEvent) async* {
    if (workingDayEvent is WorkingDayEventFetch) {
      yield* _mapWorkingDaysFetchToState(workingDayEvent.ptgId);
    } 
  }

  Stream<WorkingDayState> _mapWorkingDaysFetchToState(int ptgId) async* {
    yield WorkingDayStateLoading();
    try {
      final listWorkingDays =
          await this.calendarRepository.getPhotographerWorkingDay(ptgId);
      yield WorkingDayStateFetchSuccess(listWorkingDays: listWorkingDays);
    } catch (_) {
      yield WorkingDayStateFailure();
    }
  }

}
