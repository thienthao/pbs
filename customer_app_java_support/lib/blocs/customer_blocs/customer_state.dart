import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

import 'package:customer_app_java_support/models/customer_bloc_model.dart';

abstract class CustomerState extends Equatable {
  const CustomerState();

  @override
  List<Object> get props => [];
}

class CustomerStateLoading extends CustomerState {}

class CustomerStateFetchedProfileSuccess extends CustomerState {
  final CustomerBlocModel customer;
  CustomerStateFetchedProfileSuccess({@required this.customer})
      : assert(customer != null);
  @override
  List<Object> get props => [customer];

  @override
  String toString() =>
      'CustomerStateSuccess { CustomerStateSuccess: $customer }';
}

class CustomerStateUpdatedAvatarSuccess extends CustomerState {
  final bool isSuccess;
  CustomerStateUpdatedAvatarSuccess({this.isSuccess});
}

class CustomerStateUpdatedProfileSuccess extends CustomerState {
  final bool isSuccess;
  CustomerStateUpdatedProfileSuccess({this.isSuccess});
}

class CustomerStateChangedPasswordSuccess extends CustomerState {
  final bool isSuccess;
  CustomerStateChangedPasswordSuccess({this.isSuccess});
}

class CustomerStateFailure extends CustomerState {
  final String error;
  CustomerStateFailure({
    this.error,
  });
}

class CustomerStateChangePasswordFailure extends CustomerState {
  final dynamic error;
  CustomerStateChangePasswordFailure({
    this.error,
  });
}
