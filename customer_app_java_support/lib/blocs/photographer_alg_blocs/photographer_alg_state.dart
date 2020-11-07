import 'package:customer_app_java_support/models/photographer_bloc_model.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

abstract class PhotographerAlgState extends Equatable {
  const PhotographerAlgState();

  @override
  List<Object> get props => [];
}

class PhotographerAlgStateLoading extends PhotographerAlgState {}

class PhotographerAlgStateSuccess extends PhotographerAlgState {
  final List<Photographer> photographers;
  const PhotographerAlgStateSuccess({@required this.photographers})
      : assert(photographers != null);
  @override
  List<Object> get props => [photographers];

  @override
  String toString() =>
      'PhotographersLoadSuccess { photographers: $photographers }';
}

class PhotographerAlgStateFailure extends PhotographerAlgState {}
