import 'package:customer_app_java_support/blocs/photographer_blocs/photographer_event.dart';
import 'package:customer_app_java_support/blocs/photographer_blocs/photographer_state.dart';
import 'package:customer_app_java_support/respositories/photographer_respository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class PhotographerBloc extends Bloc<PhotographerEvent, PhotographerState> {
  static const NUMBER_OF_PHOTOGRAPHERS_PER_PAGE = 10;
  final PhotographerRepository photographerRepository;

  PhotographerBloc({
    @required this.photographerRepository,
  })  : assert(PhotographerRepository != null),
        super(PhotographerStateLoading());

  int photographerCurrentPage = 0;

  @override
  Stream<PhotographerState> mapEventToState(
      PhotographerEvent photographerEvent) async* {
    final hasReachedEndOfOnePage =
        (state is PhotographerStateInifiniteFetchedSuccess &&
            (state as PhotographerStateInifiniteFetchedSuccess).hasReachedEnd);
    if (photographerEvent is PhotographerEventFetch) {
      yield* _mapPhotographersLoadedToState(photographerEvent.categoryId,
          photographerEvent.latLng, photographerEvent.city);
    } else if (photographerEvent is PhotographerEventFetchInfinite &&
        !hasReachedEndOfOnePage) {
      yield* _mapPhotographersLoadedInfiniteToState();
    } else if (photographerEvent is PhotographerEventSearch) {
      yield* _mapFindPhotographerAndPackagesToState(photographerEvent.search);
    } else if (photographerEvent is PhotographerbyIdEventFetch) {
      yield* _mapPhotographerByIdLoadedToState(photographerEvent.id);
    } else if (photographerEvent is PhotographerEventRequested) {
    } else if (photographerEvent is PhotographerEventRefresh) {
      yield PhotographerStateLoading();
    } else if (photographerEvent is PhotographerRestartEvent) {
      photographerCurrentPage = 0;
      yield PhotographerStateLoading();
    }
  }

  Stream<PhotographerState> _mapPhotographersLoadedToState(
      int categoryId, LatLng latLng, String city) async* {
    yield PhotographerStateLoading();
    try {
      final photographers = await this
          .photographerRepository
          .getListPhotographerByRating(categoryId, latLng, city);
      yield PhotographerStateSuccess(photographers: photographers);
    } catch (_) {
      yield PhotographerStateFailure();
    }
  }

  Stream<PhotographerState> _mapPhotographerByIdLoadedToState(int id) async* {
    try {
      final photographer =
          await this.photographerRepository.getPhotographerbyId(id);
      yield PhotographerIDStateSuccess(photographer: photographer);
    } catch (_) {
      yield PhotographerStateFailure();
    }
  }

  Stream<PhotographerState> _mapPhotographersLoadedInfiniteToState() async* {
    try {
      if (state is PhotographerStateLoading) {
        final photographers = await this
            .photographerRepository
            .getInfiniteListPhotographer(0, NUMBER_OF_PHOTOGRAPHERS_PER_PAGE);
        yield PhotographerStateInifiniteFetchedSuccess(
            photographers: photographers, hasReachedEnd: false);
      } else {
        final photographers = await this
            .photographerRepository
            .getInfiniteListPhotographer(
                ++photographerCurrentPage, NUMBER_OF_PHOTOGRAPHERS_PER_PAGE);
        if (photographers.isEmpty) {
          yield (state as PhotographerStateInifiniteFetchedSuccess)
              .cloneWith(hasReachedEnd: true);
        } else {
          yield PhotographerStateInifiniteFetchedSuccess(
              photographers: (state as PhotographerStateInifiniteFetchedSuccess)
                      .photographers +
                  photographers,
              hasReachedEnd: false);
        }
      }
    } catch (_) {
      yield PhotographerStateFailure();
    }
  }

  Stream<PhotographerState> _mapFindPhotographerAndPackagesToState(
      String search) async* {
    yield PhotographerStateLoading();
    try {
      final searchModel = await this
          .photographerRepository
          .findPhotographerAndPackages(search, 0, 15);
      yield PhotographerStateSearchSuccess(
          searchModel: searchModel, hasReachedEnd: false);
    } catch (_) {
      yield PhotographerStateFailure();
    }
  }
}
