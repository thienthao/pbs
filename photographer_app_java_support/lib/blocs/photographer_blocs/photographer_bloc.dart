import 'dart:io';

import 'package:photographer_app_java_support/blocs/photographer_blocs/photographer_event.dart';
import 'package:photographer_app_java_support/blocs/photographer_blocs/photographer_state.dart';
import 'package:photographer_app_java_support/models/location_bloc_model.dart';
import 'package:photographer_app_java_support/models/photographer_bloc_model.dart';
import 'package:photographer_app_java_support/respositories/photographer_respository.dart';
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
    } else if (photographerEvent is PhotographerEventUpdateProfile) {
      yield* _mapPhotographerUpdatedProfileToState(
          photographerEvent.photographer, photographerEvent.locations);
    } else if (photographerEvent is PhotographerEventRequested) {
      yield* _mapPhotographersLoadedToState();
    } else if (photographerEvent is PhotographerEventRefresh) {
      yield* _mapPhotographersLoadedToState();
    } else if (photographerEvent is PhotographerEventOnChangeAvatar) {
      yield* _mapPhotographerOnChangeAvatarToState(photographerEvent.image);
    } else if (photographerEvent is PhotographerEventOnChangeCover) {
      yield* _mapPhotographerOnChangeCoverToState(photographerEvent.image);
    } else if (photographerEvent is PhotographerEventGetLocations) {
      yield* _mapGetPhotographerLocationsToState(photographerEvent.ptgId);
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

  Stream<PhotographerState> _mapPhotographerOnChangeAvatarToState(
      File avatar) async* {
    try {
      await this.photographerRepository.updateAvatar(avatar);
      // yield PhotograherStateOnChangedAvatarSuccess(
      //     isSuccess: changeAvatarSuccess);
    } catch (_) {
      yield PhotographerStateFailure();
    }
  }

  Stream<PhotographerState> _mapPhotographerOnChangeCoverToState(
      File cover) async* {
    try {
      await this.photographerRepository.updateCover(cover);
      // yield PhotograherStateOnChangedCoverSuccess(isSuccess: changeAvatarCover);
    } catch (_) {
      yield PhotographerStateFailure();
    }
  }

  Stream<PhotographerState> _mapPhotographerUpdatedProfileToState(
      Photographer photographer, List<LocationBlocModel> locations) async* {
    yield PhotographerStateLoading();
    try {
      final updateProfileSuccess =
          await this.photographerRepository.updateProfile(photographer,locations);
      yield PhotographerStateUpdatedProfileSuccess(
          isSuccess: updateProfileSuccess);
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

  Stream<PhotographerState> _mapGetPhotographerLocationsToState(int id) async* {
    try {
      final locations =
          await this.photographerRepository.getPhotographerLocations(id);
      print('it goes here!');
      yield PhotographerStateGetLocationsSuccess(locations: locations);
    } catch (_) {
      yield PhotographerStateFailure();
    }
  }
}
