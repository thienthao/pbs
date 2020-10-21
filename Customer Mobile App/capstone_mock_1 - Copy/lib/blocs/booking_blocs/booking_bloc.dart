import 'package:capstone_mock_1/models/booking_bloc_model.dart';
import 'package:capstone_mock_1/respositories/booking_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'booking_event.dart';
import 'booking_state.dart';

class BookingBloc extends Bloc<BookingEvent, BookingState> {
  final BookingRepository bookingRepository;
  BookingBloc({
    @required this.bookingRepository,
  })  : assert(bookingRepository != null),
        super(BookingStateLoading());

  @override
  Stream<BookingState> mapEventToState(BookingEvent bookingEvent) async* {
    if (bookingEvent is BookingEventFetch) {
      yield* _mapBookingsLoadedToState();
    } else if (bookingEvent is BookingEventDetailFetch) {
      yield* _mapBookingDetailLoadedToState(bookingEvent.id);
    } else if (bookingEvent is BookingEventCreate) {
      yield* _mapBookingCreatedtoState(bookingEvent.booking);
    } else if (bookingEvent is BookingEventCancel) {
      yield* _mapBookingCanceledtoState(bookingEvent.booking);
    } else if (bookingEvent is BookingEventLoadSuccess) {
    } else if (bookingEvent is BookingEventRequested) {
    } else if (bookingEvent is BookingEventRefresh) {
      yield* _mapBookingsLoadedToState();
    }
  }

  Stream<BookingState> _mapBookingsLoadedToState() async* {
    yield BookingStateLoading();
    try {
      final bookings =
          await this.bookingRepository.getListBookingByCustomerId();
      yield BookingStateSuccess(bookings: bookings);
    } catch (_) {
      yield BookingStateFailure();
    }
  }

  Stream<BookingState> _mapBookingDetailLoadedToState(int id) async* {
    yield BookingStateLoading();
    try {
      final booking = await this.bookingRepository.getBookingDetailById(id);
      yield BookingDetailStateSuccess(booking: booking);
    } catch (_) {
      yield BookingStateFailure();
    }
  }

  Stream<BookingState> _mapBookingCreatedtoState(
      BookingBlocModel booking) async* {
    yield BookingStateLoading();
    try {
      final isSuccess = await this.bookingRepository.createBooking(booking);
      yield BookingStateCreatedSuccess(isSuccess: isSuccess);
    } catch (_) {
      yield BookingStateFailure();
    }
  }

  Stream<BookingState> _mapBookingCanceledtoState(
      BookingBlocModel booking) async* {
    yield BookingStateLoading();
    try {
      final isSuccess = await this.bookingRepository.cancelBooking(booking);
      yield BookingStateCanceledSuccess(isSuccess: isSuccess);
    } catch (_) {
      yield BookingStateFailure();
    }
  }
}
