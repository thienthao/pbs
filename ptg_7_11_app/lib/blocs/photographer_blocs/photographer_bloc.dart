import 'dart:io';

import 'package:ptg_7_11_app/blocs/photographer_blocs/photographer_event.dart';
import 'package:ptg_7_11_app/blocs/photographer_blocs/photographer_state.dart';
import 'package:ptg_7_11_app/models/photographer_bloc_model.dart';
import 'package:ptg_7_11_app/respositories/photographer_respository.dart';
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
          photographerEvent.photographer);
    } else if (photographerEvent is PhotographerEventRequested) {
      yield* _mapPhotographersLoadedToState();
    } else if (photographerEvent is PhotographerEventRefresh) {
      yield* _mapPhotographersLoadedToState();
    } else if (photographerEvent is PhotographerEventOnChangeAvatar) {
      yield* _mapPhotographerOnChangeAvatarToState(photographerEvent.image);
    } else if (photographerEvent is PhotographerEventOnChangeCover) {
      yield* _mapPhotographerOnChangeCoverToState(photographerEvent.image);
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
      Photographer photographer) async* {
    yield PhotographerStateLoading();
    try {
      final updateProfileSuccess =
          await this.photographerRepository.updateProfile(photographer);
      yield PhotograherStateUpdatedProfileSuccess(
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
}
