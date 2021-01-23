import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

import 'package:customer_app_java_support/models/customer_bloc_model.dart';

abstract class CustomerEvent extends Equatable {
  const CustomerEvent();

  @override
  List<Object> get props => [];
}

class CustomerEventProfileFetch extends CustomerEvent {
  final int cusId;

  CustomerEventProfileFetch({this.cusId});
}

class CustomerEventUpdateAvatar extends CustomerEvent {
  final int cusId;
  final File image;
  CustomerEventUpdateAvatar({@required this.cusId, @required this.image});
}

class CustomerEventUpdateProfile extends CustomerEvent {
  final CustomerBlocModel customer;
  CustomerEventUpdateProfile({this.customer});
}

class CustomerEventChangePassword extends CustomerEvent {
  final String username;
  final String oldPassword;
  final String newPassword;

  CustomerEventChangePassword({
    this.username,
    this.oldPassword,
    this.newPassword,
  });
}


class CustomerEventRecoveryPassword extends CustomerEvent {
  final String email;
  CustomerEventRecoveryPassword({
    this.email,
  });
}
