import 'package:photographer_app_java_support/models/package_bloc_model.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

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
  String toString() => 'PackagesLoadSuccess { Package: $packages }';
}

class PackageStateCreatedSuccess extends PackageState {
  final bool isSuccess;
  PackageStateCreatedSuccess({@required this.isSuccess});

  @override
  List<Object> get props => [isSuccess];

  @override
  String toString() =>
      'PackageStateCreatedSuccess { Package Created: $isSuccess }';
}

class PackageStateUpdatedSuccess extends PackageState {
  final bool isSuccess;
  PackageStateUpdatedSuccess({@required this.isSuccess});

  @override
  List<Object> get props => [isSuccess];

  @override
  String toString() =>
      'PackageStateUpdatedSuccess { Package Updated: $isSuccess }';
}

class PackageStateDeletedSuccess extends PackageState {
  final bool isSuccess;
  PackageStateDeletedSuccess({@required this.isSuccess});

  @override
  List<Object> get props => [isSuccess];

  @override
  String toString() =>
      'PackageStateDeletedSuccess { Package Delete: $isSuccess }';
}

class PackageStateFailure extends PackageState {
  final String error;

  const PackageStateFailure({this.error});

  @override
  List<Object> get props => [error];

  @override
  String toString() => 'Login failure {error: $error}';
}
