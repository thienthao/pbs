import 'package:customer_app_java_support/models/album_bloc_model.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

abstract class AlbumState extends Equatable {
  const AlbumState();

  @override
  List<Object> get props => [];
}

class AlbumStateLoading extends AlbumState {}

class AlbumStateInifiniteFetchedSuccess extends AlbumState {
  final bool hasReachedEnd;
  final List<AlbumBlocModel> albums;
  const AlbumStateInifiniteFetchedSuccess({this.albums, this.hasReachedEnd})
      : assert(albums != null, hasReachedEnd != null);
  @override
  List<Object> get props => [albums, hasReachedEnd];

  @override
  String toString() =>
      'AlbumStateInifiniteFetchedSuccess { Album: $albums , hasReachedEnd: $hasReachedEnd}';

  AlbumStateInifiniteFetchedSuccess cloneWith(
      {bool hasReachedEnd, List<AlbumBlocModel> albums}) {
    return AlbumStateInifiniteFetchedSuccess(
        albums: albums ?? this.albums,
        hasReachedEnd: hasReachedEnd ?? this.hasReachedEnd);
  }
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
