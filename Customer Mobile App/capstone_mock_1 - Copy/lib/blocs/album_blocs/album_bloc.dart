
import 'package:capstone_mock_1/respositories/album_respository.dart';
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
      final albums = await albumRepository.getListAlbum();
      yield AlbumStateSuccess(albums: albums);
      yield* _mapAlbumsLoadedToState();
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
}
