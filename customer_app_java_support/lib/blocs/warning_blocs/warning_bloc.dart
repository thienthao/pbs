import 'package:customer_app_java_support/models/booking_bloc_model.dart';
import 'package:customer_app_java_support/respositories/warning_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'warnings.dart';

class WarningBloc extends Bloc<WarningEvent, WarningState> {
  final WarningRepository warningRepository;
  WarningBloc({
    @required this.warningRepository,
  })  : assert(WarningRepository != null),
        super(WarningStateLoading());

  @override
  Stream<WarningState> mapEventToState(WarningEvent warningEvent) async* {
    if (warningEvent is WarningEventGetTimeWarning) {
      yield* _mapTimeWarningFetchToState(
          warningEvent.dateTime, warningEvent.ptgId);
    } else if (warningEvent is WarningEventGetLocationWarning) {
      yield* _mapLocationWarningFetchToState(warningEvent.booking);
    } else if (warningEvent is WarningEventGetWeatherWarning) {
      yield* _mapWeatherWarningFetchToState(
          warningEvent.dateTime, warningEvent.latLng);
    } else if (warningEvent is WarningEventCheckOutOfWorkingTime) {
      yield* _mapCheckOutOfWorkingDayToState(warningEvent.time, warningEvent.ptgId);
    }
  }

  Stream<WarningState> _mapCheckOutOfWorkingDayToState(
      String time, int ptgId) async* {
    yield WarningStateLoading();
    try {
      final isOutOfWorkingTime = await this
          .warningRepository
          .checkValidWorkingTimeOfPhotographer(time, ptgId);
      yield WarningStateCheckOutOfWorkingTimeSuccess(
          isOutOfWorkingTime: isOutOfWorkingTime);
    } catch (error) {
      yield WarningStateFailure(error: error.toString());
    }
  }

  Stream<WarningState> _mapTimeWarningFetchToState(
      String dateTime, int ptgId) async* {
    yield WarningStateLoading();
    try {
      final notices =
          await this.warningRepository.getTimeWarning(dateTime, ptgId);
      yield WarningStateGetTimeWarningSuccess(notices: notices);
    } catch (error) {
      yield WarningStateFailure(error: error.toString());
    }
  }

  Stream<WarningState> _mapLocationWarningFetchToState(
      BookingBlocModel booking) async* {
    yield WarningStateLoading();
    try {
      final notices = await this.warningRepository.getLocationWarning(booking);
      yield WarningStateGetLocationWarningSuccess(notices: notices);
    } catch (error) {
      yield WarningStateFailure(error: error.toString());
    }
  }

  Stream<WarningState> _mapWeatherWarningFetchToState(
      String dateTime, LatLng latLng) async* {
    yield WarningStateLoading();
    try {
      final notice =
          await this.warningRepository.getWeatherWarning(dateTime, latLng);
      yield WarningStateGetWeatherWarningSuccess(notice: notice);
    } catch (error) {
      yield WarningStateFailure(error: error.toString());
    }
  }
}
