import 'package:photographer_app_1_11/models/photographer_bloc_model.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

abstract class PhotographerState extends Equatable {
  const PhotographerState();

  @override
  List<Object> get props => [];
}

class PhotographerStateLoading extends PhotographerState {}

class PhotographerStateSuccess extends PhotographerState {
  final List<Photographer> photographers;
  const PhotographerStateSuccess({@required this.photographers})
      : assert(photographers != null);
  @override
  List<Object> get props => [photographers];

  @override
  String toString() =>
      'PhotographersLoadSuccess { photographers: $photographers }';
}

class PhotographerIDStateSuccess extends PhotographerState {
  final Photographer photographer;
  const PhotographerIDStateSuccess({@required this.photographer})
      : assert(photographer != null);
  @override
  List<Object> get props => [photographer];

  @override
  String toString() =>
      'PhotographersLoadSuccess { photographers: $photographer }';
}

class PhotographerStateFailure extends PhotographerState {}
