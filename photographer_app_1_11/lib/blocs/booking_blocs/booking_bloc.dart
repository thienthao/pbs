import 'package:photographer_app_1_11/models/booking_bloc_model.dart';
import 'package:photographer_app_1_11/respositories/booking_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
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
    final hasReachedEndOfOnePage = (state is BookingStatePagingFetchedSuccess &&
        (state as BookingStatePagingFetchedSuccess).hasReachedEnd);

    if (bookingEvent is BookingEventFetch) {
      yield* _mapBookingsLoadedToState();
    } else if (bookingEvent is BookingEventFetchPaging &&
        !hasReachedEndOfOnePage) {
      yield* _mapBookingsLoadedPagingToState();
    } else if (bookingEvent is BookingRestartEvent) {
      bookingCurrentPage = 0;
      yield BookingStateLoading();
    } else if (bookingEvent is BookingEventFetchByPending) {
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
    }
  }

  Stream<BookingState> _mapBookingsLoadedToState() async* {
    yield BookingStateLoading();
    try {
      final bookings =
          await this.bookingRepository.getListBookingByPhotographerId();
      yield BookingStateSuccess(bookings: bookings);
    } catch (_) {
      yield BookingStateFailure();
    }
  }

  Stream<BookingState> _mapBookingsLoadedPagingToState() async* {
    try {
      if (state is BookingStateLoading) {
        final bookings = await this
            .bookingRepository
            .getListBookingByPhotographerIdPaging(
                0, NUMBER_OF_BOOKING_PER_PAGE);
        print('booking in bloc $bookings');
        yield BookingStatePagingFetchedSuccess(
            bookings: bookings, hasReachedEnd: false);
      } else {
        final bookings = await this
            .bookingRepository
            .getListBookingByPhotographerIdPaging(
                ++bookingCurrentPage, NUMBER_OF_BOOKING_PER_PAGE);
        if (bookings.isEmpty) {
          yield (state as BookingStatePagingFetchedSuccess)
              .cloneWith(hasReachedEnd: true);
        } else {
          yield BookingStatePagingFetchedSuccess(
              bookings: (state as BookingStatePagingFetchedSuccess).bookings +
                  bookings,
              hasReachedEnd: false);
        }
      }
    } catch (_) {
      yield BookingStateFailure();
    }
  }

  Stream<BookingState> _mapPendingBookingsLoadedToState() async* {
    yield BookingStateLoading();
    try {
      final bookings =
          await this.bookingRepository.getListPendingBookingByPhotographerId();
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

  Stream<BookingState> _mapBookingAcceptedtoState(
      BookingBlocModel booking) async* {
    yield BookingStateLoading();
    try {
      final isSuccess = await this.bookingRepository.acceptBooking(booking);
      yield BookingStateAcceptedSuccess(isSuccess: isSuccess);
    } catch (_) {
      yield BookingStateFailure();
    }
  }

  Stream<BookingState> _mapBookingMovedToEditToState(
      BookingBlocModel booking) async* {
    yield BookingStateLoading();
    try {
      final isSuccess = await this.bookingRepository.moveToEditBooking(booking);
      yield BookingStateMovedToEditSuccess(isSuccess: isSuccess);
    } catch (_) {
      yield BookingStateFailure();
    }
  }

  Stream<BookingState> _mapBookingMovedToDoneToState(
      BookingBlocModel booking) async* {
    yield BookingStateLoading();
    try {
      final isSuccess = await this.bookingRepository.moveToDoneBooking(booking);
      yield BookingStateMovedToDoneSuccess(isSuccess: isSuccess);
    } catch (_) {
      yield BookingStateFailure();
    }
  }

  Stream<BookingState> _mapBookingRejectedtoState(
      BookingBlocModel booking) async* {
    yield BookingStateLoading();
    try {
      final isSuccess = await this.bookingRepository.rejectBooking(booking);
      yield BookingStateRejectedSuccess(isSuccess: isSuccess);
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
