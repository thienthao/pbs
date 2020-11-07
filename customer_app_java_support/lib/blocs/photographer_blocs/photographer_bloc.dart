import 'package:customer_app_java_support/blocs/photographer_blocs/photographer_event.dart';
import 'package:customer_app_java_support/blocs/photographer_blocs/photographer_state.dart';
import 'package:customer_app_java_support/models/search_bloc_model.dart';
import 'package:customer_app_java_support/respositories/photographer_respository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
      yield* _mapPhotographersLoadedToState(photographerEvent.categoryId);
    } else if (photographerEvent is PhotographerEventFetchByFactorAlg) {
      yield* _mapPhotographersFetchByFactorAlgToState();
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
      int categoryId) async* {
    yield PhotographerStateLoading();
    try {
      final photographers = await this
          .photographerRepository
          .getListPhotographerByRating(categoryId);
      yield PhotographerStateSuccess(photographers: photographers);
    } catch (_) {
      yield PhotographerStateFailure();
    }
  }

  Stream<PhotographerState> _mapPhotographersFetchByFactorAlgToState() async* {
    yield PhotographerStateFetchByFactorAlgInProgress();
    try {
      final photographers =
          await this.photographerRepository.getListPhotographerByFactorAlg();
      yield PhotographerStateFetchByFactorAlgSuccess(
          photographers: photographers);
    } catch (_) {
      yield PhotographerStateFailure();
    }
  }

  Stream<PhotographerState> _mapPhotographerByIdLoadedToState(int id) async* {
    try {
      final photographer =
          await this.photographerRepository.getPhotographerbyId(id);
      print('it goes here!');
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
        print('photographer in bloc $photographers');
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
    try {
      if (state is PhotographerStateLoading) {
        final searchModel = await this
            .photographerRepository
            .findPhotographerAndPackages(
                search, 0, NUMBER_OF_PHOTOGRAPHERS_PER_PAGE);
        print('photographer in bloc $searchModel');
        yield PhotographerStateSearchSuccess(
            searchModel: searchModel, hasReachedEnd: false);
      }
    } catch (_) {
      yield PhotographerStateFailure();
    }
  }
}
