import 'package:capstone_mock_1/models/album_bloc_model.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

abstract class AlbumEvent extends Equatable {
  const AlbumEvent();

  @override
  List<Object> get props => [];
}

class AlbumEventFetch extends AlbumEvent {}

class AlbumByPhotographerIdEventFetch extends AlbumEvent {
  final int id;
  AlbumByPhotographerIdEventFetch({@required this.id});
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
