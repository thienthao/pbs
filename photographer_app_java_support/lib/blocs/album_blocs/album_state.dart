import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

import 'package:photographer_app_java_support/models/album_bloc_model.dart';

abstract class AlbumState extends Equatable {
  const AlbumState();

  @override
  List<Object> get props => [];
}

class AlbumStateLoading extends AlbumState {}

class AlbumStateCreatedSuccess extends AlbumState {
  final bool isSuccess;
  AlbumStateCreatedSuccess({this.isSuccess});
  @override
  List<Object> get props => [isSuccess];

  @override
  String toString() => 'Albums Create State { album create: $isSuccess }';
}

class AlbumStateUpdatedSuccess extends AlbumState {
  final bool isSuccess;
  AlbumStateUpdatedSuccess({this.isSuccess});
  @override
  List<Object> get props => [isSuccess];

  @override
  String toString() => 'Albums Update State { album update: $isSuccess }';
}

class AlbumStateAddImageSuccess extends AlbumState {
  final bool isSuccess;
  AlbumStateAddImageSuccess({this.isSuccess});
  @override
  List<Object> get props => [isSuccess];

  @override
  String toString() => 'Image Add State { Image Add: $isSuccess }';
}

class AlbumStateRemoveImageSuccess extends AlbumState {
  final bool isSuccess;
  AlbumStateRemoveImageSuccess({this.isSuccess});
  @override
  List<Object> get props => [isSuccess];

  @override
  String toString() => 'Image Remove State {Image Remove: $isSuccess }';
}

class AlbumStateDeleteAlbumSuccess extends AlbumState {
  final bool isSuccess;
  AlbumStateDeleteAlbumSuccess({this.isSuccess});
  @override
  List<Object> get props => [isSuccess];

  @override
  String toString() => 'Album Remove State {Album Remove: $isSuccess }';
}



class AlbumStateSuccess extends AlbumState {
  final List<AlbumBlocModel> albums;
  const AlbumStateSuccess({@required this.albums}) : assert(albums != null);
  @override
  List<Object> get props => [albums];

  @override
  String toString() => 'AlbumsLoadSuccess { album: $albums }';
}

class AlbumStateFailure extends AlbumState {
  final String error;
  AlbumStateFailure({
    this.error,
  });
}
