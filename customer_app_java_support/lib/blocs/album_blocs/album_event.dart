import 'package:customer_app_java_support/models/album_bloc_model.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

abstract class AlbumEvent extends Equatable {
  const AlbumEvent();

  @override
  List<Object> get props => [];
}

class AlbumEventFetch extends AlbumEvent {
  final int categoryId;
  AlbumEventFetch({this.categoryId});
}

class AlbumRestartEvent extends AlbumEvent {}

class AlbumEventFetchInfinite extends AlbumEvent {}

class AlbumByPhotographerIdEventFetch extends AlbumEvent {
  final int id;
  AlbumByPhotographerIdEventFetch({@required this.id});
}

class AlbumEventIsLikedAlbumFetch extends AlbumEvent {
  final int albumId;
  AlbumEventIsLikedAlbumFetch({@required this.albumId});
}

class AlbumEventLikeAlbum extends AlbumEvent {
  final int albumId;
  AlbumEventLikeAlbum({@required this.albumId});
}

class AlbumEventUnlikeAlbum extends AlbumEvent {
  final int albumId;
  AlbumEventUnlikeAlbum({@required this.albumId});
}

class AlbumEventLoadSuccess extends AlbumEvent {
  AlbumEventLoadSuccess(List<AlbumBlocModel> list);
}

class AlbumEventRequested extends AlbumEvent {
  final AlbumBlocModel album;
  AlbumEventRequested({
    @required this.album,
  }) : assert(album != null);
  @override
  List<Object> get props => [album];
}

class AlbumEventRefresh extends AlbumEvent {
  final AlbumBlocModel album;
  AlbumEventRefresh({
    @required this.album,
  }) : assert(album != null);
  @override
  List<Object> get props => [album];
}
