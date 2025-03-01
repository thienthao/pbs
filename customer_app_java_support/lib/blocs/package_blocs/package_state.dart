import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

import 'package:customer_app_java_support/models/package_bloc_model.dart';

abstract class PackageState extends Equatable {
  const PackageState();

  @override
  List<Object> get props => [];
}

class PackageStateLoading extends PackageState {}

class PackageStateSuccess extends PackageState {
  final List<PackageBlocModel> packages;
  const PackageStateSuccess({@required this.packages})
      : assert(packages != null);
  @override
  List<Object> get props => [packages];

  @override
  String toString() => 'PackageStateSuccess { Package: $packages }';
}

class PackageStateFailure extends PackageState {
  final String error;
  PackageStateFailure({
    this.error,
  });
}
