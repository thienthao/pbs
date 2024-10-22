import 'dart:io';
import 'package:photographer_app_java_support/models/album_bloc_model.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

abstract class AlbumEvent extends Equatable {
  const AlbumEvent();

  @override
  List<Object> get props => [];
}

class AlbumEventFetch extends AlbumEvent {}

class AlbumEventCreateAlbum extends AlbumEvent {
  final AlbumBlocModel album;
  final File thumbnail;
  final List<File> images;

  AlbumEventCreateAlbum({this.album, this.thumbnail, this.images});

  @override
  List<Object> get props => [];
}

class AlbumEventFetchByPhotographerId extends AlbumEvent {
  final int id;
  AlbumEventFetchByPhotographerId({@required this.id});
}

class AlbumEventUpdateInfo extends AlbumEvent {
  final AlbumBlocModel album;
  AlbumEventUpdateInfo({this.album});
}

class AlbumEventAddAnImageForAnAlbum extends AlbumEvent {
  final int albumId;
  final File image;
  AlbumEventAddAnImageForAnAlbum({this.albumId, this.image});
}

class AlbumEventDeleteAnImageOfAnAlbum extends AlbumEvent {
  final int albumId;
  final int imageId;
  AlbumEventDeleteAnImageOfAnAlbum({this.albumId, this.imageId});
}


class AlbumEventDeleteAlbum extends AlbumEvent {
  final int albumId;
  AlbumEventDeleteAlbum({this.albumId});
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
