import 'dart:io';

import 'package:photographer_app_java_support/models/location_bloc_model.dart';
import 'package:photographer_app_java_support/models/photographer_bloc_model.dart';
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

class PhotographerEventOnChangeAvatar extends PhotographerEvent {
  final File image;
  PhotographerEventOnChangeAvatar({this.image});
}

class PhotographerEventOnChangeCover extends PhotographerEvent {
  final File image;
  PhotographerEventOnChangeCover({this.image});
}

class PhotographerbyIdEventLoadSuccess extends PhotographerEvent {
  PhotographerbyIdEventLoadSuccess(Photographer photographer);
}

class PhotographerEventUpdateProfile extends PhotographerEvent {
  final Photographer photographer;
  final List<LocationBlocModel> locations;

  PhotographerEventUpdateProfile({this.photographer, this.locations});
}

class PhotographerEventLoadSuccess extends PhotographerEvent {
  PhotographerEventLoadSuccess(List<Photographer> list);
}

class PhotographerEventGetLocations extends PhotographerEvent {
  final int ptgId;
  PhotographerEventGetLocations({this.ptgId});
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
