import 'package:capstone_mock_1/blocs/photographer_blocs/photographer_event.dart';
import 'package:capstone_mock_1/blocs/photographer_blocs/photographer_state.dart';
import 'package:capstone_mock_1/respositories/photographer_respository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PhotographerBloc extends Bloc<PhotographerEvent, PhotographerState> {
  final PhotographerRepository photographerRepository;
  PhotographerBloc({
    @required this.photographerRepository,
  })  : assert(PhotographerRepository != null),
        super(PhotographerStateLoading());

  @override
  Stream<PhotographerState> mapEventToState(
      PhotographerEvent photographerEvent) async* {
    if (photographerEvent is PhotographerEventFetch) {
      yield* _mapPhotographersLoadedToState();
    } else if (photographerEvent is PhotographerbyIdEventFetch) {
      yield* _mapPhotographerByIdLoadedToState(photographerEvent.id);
    } else if (photographerEvent is PhotographerEventRequested) {
      yield* _mapPhotographersLoadedToState();
    } else if (photographerEvent is PhotographerEventRefresh) {
      yield* _mapPhotographersLoadedToState();
    }
  }

  Stream<PhotographerState> _mapPhotographersLoadedToState() async* {
    try {
      final photographers =
          await this.photographerRepository.getListPhotographerByRating();
      yield PhotographerStateSuccess(photographers: photographers);
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
}
