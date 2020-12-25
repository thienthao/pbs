import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:photographer_app_java_support/models/busy_day_bloc_model.dart';
import 'package:photographer_app_java_support/respositories/calendar_repository.dart';

import 'busy_days.dart';

class BusyDayBloc extends Bloc<BusyDayEvent, BusyDayState> {
  final CalendarRepository calendarRepository;
  BusyDayBloc({
    @required this.calendarRepository,
  })  : assert(CalendarRepository != null),
        super(BusyDayStateLoading());

  @override
  Stream<BusyDayState> mapEventToState(BusyDayEvent busyDayEvent) async* {
    if (busyDayEvent is BusyDayEventFetch) {
      yield* _mapBusyDaysFetchToState(busyDayEvent.ptgId);
    } else if (busyDayEvent is BusyDayEventCreate) {
      yield* _mapCreateBusyDayToState(
          busyDayEvent.ptgId, busyDayEvent.busyDayBlocModel);
    } else if (busyDayEvent is BusyDayEventUpdate) {
      yield* _mapUpdateBusyDayToState(
          busyDayEvent.ptgId, busyDayEvent.busyDayBlocModel);
    } else if (busyDayEvent is BusyDayEventDelete) {
      yield* _mapDeleteBusyDayToState(
          busyDayEvent.ptgId, busyDayEvent.busyDayId);
    }
  }

  Stream<BusyDayState> _mapBusyDaysFetchToState(int ptgId) async* {
    yield BusyDayStateLoading();
    try {
      final listBusyDays =
          await this.calendarRepository.getPhotographerBusyDaysSpecific(ptgId);
      yield BusyDayStateFetchSuccess(listBusyDays: listBusyDays);
    } catch (_) {
      yield BusyDayStateFailure();
    }
  }

  Stream<BusyDayState> _mapCreateBusyDayToState(
      int ptgId, BusyDayBlocModel busyDayBlocModel) async* {
    yield BusyDayStateLoading();
    try {
      final isCreatedSuccess =
          await this.calendarRepository.addBusyDay(ptgId, busyDayBlocModel);
      yield BusyDayStateCreatedSuccess(isCreatedSuccess: isCreatedSuccess);
    } catch (_) {
      yield BusyDayStateFailure();
    }
  }

  Stream<BusyDayState> _mapUpdateBusyDayToState(
      int ptgId, BusyDayBlocModel busyDayBlocModel) async* {
    yield BusyDayStateLoading();
    try {
      final isUpdatedSuccess =
          await this.calendarRepository.updateBusyDay(ptgId, busyDayBlocModel);
      yield BusyDayStateUpdatedSuccess(isUpdateSuccess: isUpdatedSuccess);
    } catch (_) {
      yield BusyDayStateFailure();
    }
  }

  Stream<BusyDayState> _mapDeleteBusyDayToState(
      int ptgId, int busyDayId) async* {
    yield BusyDayStateLoading();
    try {
      final isDeletedSuccess =
          await this.calendarRepository.deleteBusyDay(ptgId, busyDayId);
      yield BusyDayStateDeletedSuccess(isDeletedSuccess: isDeletedSuccess);
    } catch (_) {
      yield BusyDayStateFailure();
    }
  }
}
