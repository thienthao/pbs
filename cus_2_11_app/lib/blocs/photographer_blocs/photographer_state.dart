import 'package:cus_2_11_app/models/photographer_bloc_model.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

abstract class PhotographerState extends Equatable {
  const PhotographerState();

  @override
  List<Object> get props => [];
}

class PhotographerStateLoading extends PhotographerState {}

class PhotographerStateInifiniteFetchedSuccess extends PhotographerState {
  final bool hasReachedEnd;
  final List<Photographer> photographers;
  const PhotographerStateInifiniteFetchedSuccess(
      {this.photographers, this.hasReachedEnd})
      : assert(photographers != null, hasReachedEnd != null);
  @override
  List<Object> get props => [photographers, hasReachedEnd];

  @override
  String toString() =>
      'PhotographerStateInifiniteFetchedSuccess { Photographer: $photographers , hasReachedEnd: $hasReachedEnd}';

  PhotographerStateInifiniteFetchedSuccess cloneWith(
      {bool hasReachedEnd, List<Photographer> photographers}) {
    return PhotographerStateInifiniteFetchedSuccess(
        photographers: photographers ?? this.photographers,
        hasReachedEnd: hasReachedEnd ?? this.hasReachedEnd);
  }
}

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

class PhotographerStateFetchByFactorAlgInProgress extends PhotographerState {}

class PhotographerStateFetchByFactorAlgSuccess extends PhotographerState {
  final List<Photographer> photographers;
  const PhotographerStateFetchByFactorAlgSuccess({@required this.photographers})
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
