import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:photographer_app_java_support/models/notification_bloc_model.dart';

abstract class NotificationState extends Equatable {
  const NotificationState();

  @override
  List<Object> get props => [];
}

class NotificationStateLoading extends NotificationState {}

class NotificationStateFetchSuccess extends NotificationState {
  final List<NotificationBlocModel> notifications;
  const NotificationStateFetchSuccess({@required this.notifications})
      : assert(notifications != null);
  @override
  List<Object> get props => [notifications];

  @override
  String toString() =>
      'Notification Fetch Success { notifications: $notifications }';
}

class NotificationStateDeleteANotifcationSuccess extends NotificationState {
  final bool isDeleted;

  NotificationStateDeleteANotifcationSuccess({this.isDeleted});
}

class NotificationStateDeleteAllNotifcationSuccess extends NotificationState {
  final bool isDeleted;

  NotificationStateDeleteAllNotifcationSuccess({this.isDeleted});
}

class NotificationStateFailure extends NotificationState {
  final String error;
  NotificationStateFailure({
    this.error,
  });
}
