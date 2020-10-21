import 'package:photographer_app/models/photographer_bloc_model.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

abstract class PhotographerEvent extends Equatable {
  const PhotographerEvent();

  @override
  List<Object> get props => [];
}

class PhotographerEventFetch extends PhotographerEvent {}

class PhotographerbyIdEventFetch extends PhotographerEvent {
  final int id;
  PhotographerbyIdEventFetch({@required this.id});
}

class PhotographerbyIdEventLoadSuccess extends PhotographerEvent {
  PhotographerbyIdEventLoadSuccess(Photographer photographer);
}

class PhotographerEventLoadSuccess extends PhotographerEvent {
  PhotographerEventLoadSuccess(List<Photographer> list);
}

class PhotographerEventRequested extends PhotographerEvent {
  final Photographer photographer;
  PhotographerEventRequested({
    @required this.photographer,
  }) : assert(photographer != null);
  @override
  List<Object> get props => [photographer];
}

class PhotographerEventRefresh extends PhotographerEvent {
  final Photographer photographer;
  PhotographerEventRefresh({
    @required this.photographer,
  }) : assert(photographer != null);
  @override
  List<Object> get props => [photographer];
}
