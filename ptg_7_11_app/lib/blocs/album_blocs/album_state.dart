import 'package:ptg_7_11_app/models/album_bloc_model.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

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

class AlbumStateSuccess extends AlbumState {
  final List<AlbumBlocModel> albums;
  const AlbumStateSuccess({@required this.albums}) : assert(albums != null);
  @override
  List<Object> get props => [albums];

  @override
  String toString() => 'AlbumsLoadSuccess { album: $albums }';
}

class AlbumStateFailure extends AlbumState {}
