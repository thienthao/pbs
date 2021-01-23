import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:photographer_app_java_support/models/booking_bloc_model.dart';
import 'package:photographer_app_java_support/respositories/booking_repository.dart';

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
    } else if (bookingEvent is BookingEventFetchInfinite &&
        !hasReachedEndOfOnePage) {
      yield* _mapBookingsLoadedInfiniteToState(bookingEvent.status);
    } else if (bookingEvent is BookingRestartEvent) {
      bookingCurrentPage = 0;
      yield BookingStateLoading();
    } else if (bookingEvent is BookingEventFetchByDate) {
      yield* _mapBookingsLoadedByDateToState(bookingEvent.date);
    } else if (bookingEvent is BookingEventFetchByStatusPending) {
      yield* _mapPendingBookingsLoadedToState();
    } else if (bookingEvent is BookingEventDetailFetch) {
      yield* _mapBookingDetailLoadedToState(bookingEvent.id);
    } else if (bookingEvent is BookingEventCreate) {
      yield* _mapBookingCreatedtoState(bookingEvent.booking);
    } else if (bookingEvent is BookingEventAccept) {
      yield* _mapBookingAcceptedtoState(bookingEvent.booking);
    } else if (bookingEvent is BookingEventMoveToEdit) {
      yield* _mapBookingMovedToEditToState(bookingEvent.booking);
    } else if (bookingEvent is BookingEventMoveToDone) {
      yield* _mapBookingMovedToDoneToState(bookingEvent.booking);
    } else if (bookingEvent is BookingEventReject) {
      yield* _mapBookingRejectedtoState(bookingEvent.booking);
    } else if (bookingEvent is BookingEventCancel) {
      yield* _mapBookingCanceledtoState(bookingEvent.booking);
    } else if (bookingEvent is BookingEventLoadSuccess) {
    } else if (bookingEvent is BookingEventRequested) {
    } else if (bookingEvent is BookingEventRefresh) {
      yield* _mapBookingsLoadedToState();
    } else if (bookingEvent is BookingEventCheckIn) {
      yield* _mapBookingCheckIntoState(
          bookingEvent.bookingId, bookingEvent.timeLocationId);
    } else if (bookingEvent is BookingEventSendCheckInAllRequest) {
      yield* _mapBookingSendCheckInAllRequestToState(bookingEvent.bookingId);
    }
  }

  Stream<BookingState> _mapBookingsLoadedToState() async* {
    yield BookingStateLoading();
    try {
      final bookings =
          await this.bookingRepository.getListBookingByPhotographerId();
      yield BookingStateSuccess(bookings: bookings);
    } catch (e) {
      yield BookingStateFailure(error: e.toString());
    }
  }

  Stream<BookingState> _mapBookingsLoadedByDateToState(String date) async* {
    yield BookingStateFetchByDateInProgress();
    try {
      final bookings = await this.bookingRepository.getListBookingByDate(date);
      yield BookingStateFetchedByDateSuccess(bookings: bookings);
    } catch (e) {
      yield BookingStateFailure(error: e.toString());
    }
  }

  Stream<BookingState> _mapBookingsLoadedInfiniteToState(String status) async* {
    try {
      if (state is BookingStateLoading) {
        final bookings = await this
            .bookingRepository
            .getListInfiniteBookingByPhotographerId(
                0, NUMBER_OF_BOOKING_PER_PAGE, status);
        print('booking in bloc $bookings');
        yield BookingStateInfiniteFetchedSuccess(
            bookings: bookings, hasReachedEnd: false);
      } else {
        final bookings = await this
            .bookingRepository
            .getListInfiniteBookingByPhotographerId(
                ++bookingCurrentPage, NUMBER_OF_BOOKING_PER_PAGE, status);
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
    } catch (e) {
      yield BookingStateFailure(error: e.toString());
    }
  }

  Stream<BookingState> _mapPendingBookingsLoadedToState() async* {
    yield BookingStateLoading();
    try {
      final bookings =
          await this.bookingRepository.getListPendingBookingByPhotographerId();
      yield BookingStateSuccess(bookings: bookings);
    } catch (e) {
      yield BookingStateFailure(error: e.toString());
    }
  }

  Stream<BookingState> _mapBookingDetailLoadedToState(int id) async* {
    yield BookingStateLoading();
    try {
      final booking = await this.bookingRepository.getBookingDetailById(id);
      yield BookingDetailStateSuccess(booking: booking);
    } catch (e) {
      yield BookingStateFailure(error: e.toString());
    }
  }

  Stream<BookingState> _mapBookingCreatedtoState(
      BookingBlocModel booking) async* {
    yield BookingStateLoading();
    try {
      final isSuccess = await this.bookingRepository.createBooking(booking);
      yield BookingStateCreatedSuccess(isSuccess: isSuccess);
    } catch (e) {
      yield BookingStateFailure(error: e.toString());
    }
  }

  Stream<BookingState> _mapBookingAcceptedtoState(
      BookingBlocModel booking) async* {
    yield BookingStateLoading();
    try {
      final isSuccess = await this.bookingRepository.acceptBooking(booking);
      yield BookingStateAcceptedSuccess(isSuccess: isSuccess);
    } catch (e) {
      yield BookingStateFailure(error: e.toString());
    }
  }

  Stream<BookingState> _mapBookingMovedToEditToState(
      BookingBlocModel booking) async* {
    yield BookingStateLoading();
    try {
      final isSuccess = await this.bookingRepository.moveToEditBooking(booking);
      yield BookingStateMovedToEditSuccess(isSuccess: isSuccess);
    } catch (e) {
      yield BookingStateFailure(error: e.toString());
    }
  }

  Stream<BookingState> _mapBookingMovedToDoneToState(
      BookingBlocModel booking) async* {
    yield BookingStateLoading();
    try {
      final isSuccess = await this.bookingRepository.moveToDoneBooking(booking);
      yield BookingStateMovedToDoneSuccess(isSuccess: isSuccess);
    } catch (e) {
      yield BookingStateFailure(error: e.toString());
    }
  }

  Stream<BookingState> _mapBookingRejectedtoState(
      BookingBlocModel booking) async* {
    yield BookingStateLoading();
    try {
      final isSuccess = await this.bookingRepository.rejectBooking(booking);
      yield BookingStateRejectedSuccess(isSuccess: isSuccess);
    } catch (e) {
      yield BookingStateFailure(error: e.toString());
    }
  }

  Stream<BookingState> _mapBookingCanceledtoState(
      BookingBlocModel booking) async* {
    yield BookingStateLoading();
    try {
      final isSuccess = await this.bookingRepository.cancelBooking(booking);
      yield BookingStateCanceledSuccess(isSuccess: isSuccess);
    } catch (e) {
      yield BookingStateFailure(error: e.toString());
    }
  }

  Stream<BookingState> _mapBookingCheckIntoState(
      int bookingId, int timeLocationId) async* {
    try {
      final isSuccess =
          await this.bookingRepository.checkIn(bookingId, timeLocationId);
      yield BookingStateCheckInSuccess(isSuccess: isSuccess);
    } catch (e) {
      yield BookingStateFailure(error: e.toString());
    }
  }

  Stream<BookingState> _mapBookingSendCheckInAllRequestToState(
      int bookingId) async* {
    yield BookingStateCheckInAllRequestLoading();
    try {
      final isSuccess = await this.bookingRepository.checkInAll(bookingId);
      yield BookingStateCheckInAllRequestSuccess(isSuccess: isSuccess);
    } catch (e) {
      yield BookingStateCheckInAllRequestFailure(error: e.toString());
    }
  }
}
