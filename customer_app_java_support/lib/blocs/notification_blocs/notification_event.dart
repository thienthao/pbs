import 'package:equatable/equatable.dart';

abstract class NotificationEvent extends Equatable {
  const NotificationEvent();

  @override
  List<Object> get props => [];
}

class NotificationEventInitial extends NotificationEvent {}

class NotificationEventFetch extends NotificationEvent {}

class NotificationEventDeleteANotification extends NotificationEvent {
  final int id;

  NotificationEventDeleteANotification({this.id});
}

class NotificationEventDeleteAllNotifications extends NotificationEvent {
  final List<int> listNotificationId;
  NotificationEventDeleteAllNotifications({this.listNotificationId});
}
