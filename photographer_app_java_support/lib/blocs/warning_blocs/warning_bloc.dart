import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:photographer_app_java_support/models/booking_bloc_model.dart';
import 'package:photographer_app_java_support/respositories/warning_repository.dart';
import 'warnings.dart';

class WarningBloc extends Bloc<WarningEvent, WarningState> {
  final WarningRepository warningRepository;
  WarningBloc({
    @required this.warningRepository,
  })  : assert(WarningRepository != null),
        super(WarningStateLoading());

  @override
  Stream<WarningState> mapEventToState(WarningEvent timeWarningEvent) async* {
    if (timeWarningEvent is WarningEventGetTimeWarning) {
      yield* _mapTimeWarningFetchToState(
          timeWarningEvent.dateTime, timeWarningEvent.ptgId);
    }
    if (timeWarningEvent is WarningEventGetLocationWarning) {
      yield* _mapLocationWarningFetchToState(timeWarningEvent.booking);
    }
  }

  Stream<WarningState> _mapTimeWarningFetchToState(
      String dateTime, int ptgId) async* {
    yield WarningStateLoading();
    try {
      final notices =
          await this.warningRepository.getTimeWarning(dateTime, ptgId);
      yield WarningStateGetTimeWarningSuccess(notices: notices);
    } catch (_) {
      yield WarningStateFailure();
    }
  }

  Stream<WarningState> _mapLocationWarningFetchToState(
      BookingBlocModel booking) async* {
    yield WarningStateLoading();
    try {
      final notices = await this.warningRepository.getLocationWarning(booking);
      yield WarningStateGetLocationWarningSuccess(notices: notices);
    } catch (_) {
      yield WarningStateFailure();
    }
  }
}
