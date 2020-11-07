import 'package:ptg_7_11_app/models/package_bloc_model.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

abstract class PackageEvent extends Equatable {
  const PackageEvent();

  @override
  List<Object> get props => [];
}

class PackageEventFetch extends PackageEvent {}

class PackageByPhotographerIdEventFetch extends PackageEvent {
  final int id;
  PackageByPhotographerIdEventFetch({@required this.id});
}

class PackageEventLoadSuccess extends PackageEvent {
  PackageEventLoadSuccess(List<PackageBlocModel> list);
}

class PackageEventCreate extends PackageEvent {
  final PackageBlocModel package;

  PackageEventCreate({@required this.package});
}

class PackageEventUpdate extends PackageEvent {
  final PackageBlocModel package;

  PackageEventUpdate({@required this.package});
}

class PackageEventDelete extends PackageEvent {
  final PackageBlocModel package;

  PackageEventDelete({@required this.package});
}

class PackageEventRequested extends PackageEvent {
  final PackageBlocModel package;
  PackageEventRequested({
    @required this.package,
  }) : assert(package != null);
  @override
  List<Object> get props => [package];
}

class PackageEventRefresh extends PackageEvent {
  final PackageBlocModel package;
  PackageEventRefresh({
    @required this.package,
  }) : assert(package != null);
  @override
  List<Object> get props => [package];
}
