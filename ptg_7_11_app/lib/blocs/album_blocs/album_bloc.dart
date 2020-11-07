import 'dart:io';
import 'package:ptg_7_11_app/models/album_bloc_model.dart';
import 'package:ptg_7_11_app/respositories/album_respository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'album_event.dart';
import 'album_state.dart';

class AlbumBloc extends Bloc<AlbumEvent, AlbumState> {
  final AlbumRepository albumRepository;
  AlbumBloc({
    @required this.albumRepository,
  })  : assert(albumRepository != null),
        super(AlbumStateLoading());

  @override
  Stream<AlbumState> mapEventToState(AlbumEvent albumEvent) async* {
    if (albumEvent is AlbumEventFetch) {
      yield* _mapAlbumsLoadedToState();
    } else if (albumEvent is AlbumEventFetchByPhotographerId) {
      yield* _mapAlbumsByPhotographerIdLoadedToState(albumEvent.id);
    } else if (albumEvent is AlbumEventCreateAlbum) {
      yield* _mapAlbumsCreatedToState(
          albumEvent.album, albumEvent.thumbnail, albumEvent.images);
    } else if (albumEvent is AlbumEventLoadSuccess) {
      yield* _mapAlbumsLoadedToState();
    } else if (albumEvent is AlbumEventRequested) {
      yield* _mapAlbumsLoadedToState();
    } else if (albumEvent is AlbumEventRefresh) {
      yield* _mapAlbumsLoadedToState();
    }
  }

  Stream<AlbumState> _mapAlbumsLoadedToState() async* {
    try {
      final albums = await this.albumRepository.getListAlbum();
      yield AlbumStateSuccess(albums: albums);
    } catch (_) {
      yield AlbumStateFailure();
    }
  }

  Stream<AlbumState> _mapAlbumsCreatedToState(
      AlbumBlocModel album, File thumbnail, List<File> images) async* {
    yield AlbumStateLoading();
    try {
      final albumCreatedSuccess =
          await this.albumRepository.createAlbum(album, thumbnail, images);
      
      yield AlbumStateCreatedSuccess(isSuccess: albumCreatedSuccess);
    } catch (_) {
      yield AlbumStateFailure();
    }
  }

  Stream<AlbumState> _mapAlbumsByPhotographerIdLoadedToState(int id) async* {
    try {
      final albums = await this.albumRepository.getAlbumOfPhotographer(id);
      yield AlbumStateSuccess(albums: albums);
    } catch (_) {
      yield AlbumStateFailure();
    }
  }
}
