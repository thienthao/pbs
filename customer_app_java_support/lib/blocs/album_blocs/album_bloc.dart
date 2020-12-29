import 'package:customer_app_java_support/respositories/album_respository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'album_event.dart';
import 'album_state.dart';

class AlbumBloc extends Bloc<AlbumEvent, AlbumState> {
  static const NUMBER_OF_ALBUMS_PER_PAGE = 5;
  final AlbumRepository albumRepository;
  AlbumBloc({
    @required this.albumRepository,
  })  : assert(albumRepository != null),
        super(AlbumStateLoading());
  int albumCurrentPage = 0;
  @override
  Stream<AlbumState> mapEventToState(AlbumEvent albumEvent) async* {
    final hasReachedEndOfOnePage =
        (state is AlbumStateInifiniteFetchedSuccess &&
            (state as AlbumStateInifiniteFetchedSuccess).hasReachedEnd);

    if (albumEvent is AlbumEventFetch) {
      yield* _mapAlbumsLoadedToState(albumEvent.categoryId);
    } else if (albumEvent is AlbumEventFetchInfinite &&
        !hasReachedEndOfOnePage) {
      yield* _mapAlbumsLoadedInfiniteToState();
    } else if (albumEvent is AlbumByPhotographerIdEventFetch) {
      yield* _mapAlbumsByPhotographerIdLoadedToState(albumEvent.id);
    } else if (albumEvent is AlbumEventLoadSuccess) {
    } else if (albumEvent is AlbumEventRequested) {
    } else if (albumEvent is AlbumEventRefresh) {
    } else if (albumEvent is AlbumEventIsLikedAlbumFetch) {
      yield* _mapIsLikedAlbumFetchToState(albumEvent.albumId);
    } else if (albumEvent is AlbumEventLikeAlbum) {
      yield* _mapLikeAlbumToState(albumEvent.albumId);
    } else if (albumEvent is AlbumEventUnlikeAlbum) {
      yield* _mapUnlikeAlbumToState(albumEvent.albumId);
    }
  }

  Stream<AlbumState> _mapAlbumsLoadedToState(int categoryId) async* {
    yield AlbumStateLoading();
    try {
      final albums = await this.albumRepository.getListAlbum(categoryId);
      yield AlbumStateSuccess(albums: albums);
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

  Stream<AlbumState> _mapAlbumsLoadedInfiniteToState() async* {
    try {
      if (state is AlbumStateLoading) {
        final albums = await this
            .albumRepository
            .getInfiniteListAlbum(0, NUMBER_OF_ALBUMS_PER_PAGE);
        yield AlbumStateInifiniteFetchedSuccess(
            albums: albums, hasReachedEnd: false);
      } else {
        final albums = await this.albumRepository.getInfiniteListAlbum(
            ++albumCurrentPage, NUMBER_OF_ALBUMS_PER_PAGE);
        if (albums.isEmpty) {
          yield (state as AlbumStateInifiniteFetchedSuccess)
              .cloneWith(hasReachedEnd: true);
        } else {
          yield AlbumStateInifiniteFetchedSuccess(
              albums:
                  (state as AlbumStateInifiniteFetchedSuccess).albums + albums,
              hasReachedEnd: false);
        }
      }
    } catch (_) {
      yield AlbumStateFailure();
    }
  }

  Stream<AlbumState> _mapIsLikedAlbumFetchToState(int albumId) async* {
    try {
      final isLiked = await this.albumRepository.isLikedAlbum(albumId);
      yield AlbumStateIsLikedAlbumFetchSuccess(isLiked: isLiked);
    } catch (_) {
      yield AlbumStateFailure();
    }
  }

  Stream<AlbumState> _mapLikeAlbumToState(int albumId) async* {
    try {
      final isLiked = await this.albumRepository.likeAlbum(albumId);
      yield AlbumStateLikeAlbumSuccess(isLiked: isLiked);
    } catch (_) {
      yield AlbumStateFailure();
    }
  }

  Stream<AlbumState> _mapUnlikeAlbumToState(int albumId) async* {
    try {
      final isUnLiked = await this.albumRepository.unlikeAlbum(albumId);
      print(isUnLiked);
      yield AlbumStateUnlikeAlbumSuccess(isUnLiked: isUnLiked);
    } catch (_) {
      yield AlbumStateFailure();
    }
  }
}
