import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:photographer_app_java_support/models/working_date_bloc_model.dart';
import 'package:photographer_app_java_support/respositories/calendar_repository.dart';

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
    } else if (workingDayEvent is WorkingDayEventUpdate) {
      yield* _mapUpdateWorkingDaysToState(
          workingDayEvent.ptgId, workingDayEvent.listWorkingDays);
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

  Stream<WorkingDayState> _mapUpdateWorkingDaysToState(
      int ptgId, List<WorkingDayBlocModel> listWorkingDays) async* {
    yield WorkingDayStateLoading();
    try {
      final isUpdatedSuccess = await this
          .calendarRepository
          .updateWorkingDay(ptgId, listWorkingDays);
      yield WorkingDayStateUpdateSuccess(isUpdateSuccess: isUpdatedSuccess);
    } catch (_) {
      yield WorkingDayStateFailure();
    }
  }
}
