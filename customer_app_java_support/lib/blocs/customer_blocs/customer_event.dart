import 'dart:io';

import 'package:customer_app_java_support/models/customer_bloc_model.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

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
