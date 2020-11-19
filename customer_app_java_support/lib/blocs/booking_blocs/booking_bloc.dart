import 'package:customer_app_java_support/models/booking_bloc_model.dart';
import 'package:customer_app_java_support/respositories/booking_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'booking_event.dart';
import 'booking_state.dart';

class BookingBloc extends Bloc<BookingEvent, BookingState> {
  static const NUMBER_OF_BOOKING_PER_PAGE = 10;
  final BookingRepository bookingRepository;
  BookingBloc({
    @required this.bookingRepository,
  })  : assert(bookingRepository != null),
        super(BookingStateLoading());

  int bookingCurrentPage = 0;

  @override
  Stream<BookingState> mapEventToState(BookingEvent bookingEvent) async* {
    final hasReachedEndOfOnePage =
        (state is BookingStateInfiniteFetchedSuccess &&
            (state as BookingStateInfiniteFetchedSuccess).hasReachedEnd);

    if (bookingEvent is BookingEventFetch) {
      yield* _mapBookingsLoadedToState();
    } else if (bookingEvent is BookingEventDetailFetch) {
      yield* _mapBookingDetailLoadedToState(bookingEvent.id);
    } else if (bookingEvent is BookingEventCreate) {
      yield* _mapBookingCreatedtoState(bookingEvent.booking);
    } else if (bookingEvent is BookingEventCancel) {
      yield* _mapBookingCanceledtoState(bookingEvent.booking);
    } else if (bookingEvent is BookingEventGetBookingOnDate) {
      yield* _mapGetBookingByDayToState(bookingEvent.ptgId, bookingEvent.date);
    } else if (bookingEvent is BookingEventFetchInfinite &&
        !hasReachedEndOfOnePage) {
      yield* _mapBookingsLoadedInfiniteToState(
          bookingEvent.cusId, bookingEvent.status);
    } else if (bookingEvent is BookingRestartEvent) {
      bookingCurrentPage = 0;
      yield BookingStateLoading();
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
    yield BookingStateCancelInProgress();
    try {
      final isSuccess = await this.bookingRepository.cancelBooking(booking);
      yield BookingStateCanceledSuccess(isSuccess: isSuccess);
    } catch (_) {
      yield BookingStateFailure();
    }
  }

  Stream<BookingState> _mapGetBookingByDayToState(
      int ptgId, String date) async* {
    yield BookingStateLoading();
    try {
      final listBookings =
          await this.bookingRepository.getBookingsByDate(ptgId, date);
      yield BookingStateGetBookingByDateSuccess(listBookings: listBookings);
    } catch (_) {
      yield BookingStateFailure();
    }
  }

  Stream<BookingState> _mapBookingsLoadedInfiniteToState(
      int cusId, String status) async* {
    try {
      if (state is BookingStateLoading) {
        final bookings = await this
            .bookingRepository
            .getListInfiniteBookingByPhotographerId(
                cusId, 0, NUMBER_OF_BOOKING_PER_PAGE, status);
        print('booking in bloc $bookings');
        yield BookingStateInfiniteFetchedSuccess(
            bookings: bookings, hasReachedEnd: false);
      } else {
        final bookings = await this
            .bookingRepository
            .getListInfiniteBookingByPhotographerId(cusId, ++bookingCurrentPage,
                NUMBER_OF_BOOKING_PER_PAGE, status);
        if (bookings.isEmpty) {
          yield (state as BookingStateInfiniteFetchedSuccess)
              .cloneWith(hasReachedEnd: true);
        } else {
          yield BookingStateInfiniteFetchedSuccess(
              bookings: (state as BookingStateInfiniteFetchedSuccess).bookings +
                  bookings,
              hasReachedEnd: false);
        }
      }
    } catch (_) {
      yield BookingStateFailure();
    }
  }
}
