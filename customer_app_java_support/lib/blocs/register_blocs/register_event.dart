
import 'package:customer_app_java_support/blocs/register_blocs/user_register_model.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

abstract class RegisterEvent extends Equatable {
  const RegisterEvent();

  @override
  List<Object> get props => [];
}

class RegisterPost extends RegisterEvent {
  final UserRegister userRegister;

  const RegisterPost({@required this.userRegister});

  @override
  List<Object> get props => [userRegister];

  @override
  String toString() => '${userRegister.toString()}';
}