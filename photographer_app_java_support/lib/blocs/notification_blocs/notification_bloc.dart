import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:photographer_app_java_support/respositories/notification_repository.dart';

import 'notification_event.dart';
import 'notification_state.dart';

class NotificationBloc extends Bloc<NotificationEvent, NotificationState> {
  final NotificationRepository notificationRepository;
  NotificationBloc({@required this.notificationRepository})
      : assert(notificationRepository != null),
        super(NotificationStateLoading());

  @override
  Stream<NotificationState> mapEventToState(
      NotificationEvent notificationEvent) async* {
    if (notificationEvent is NotificationEventInitial) {
      yield NotificationStateLoading();
    } else if (notificationEvent is NotificationEventFetch) {
      yield* _mapNotificationsLoadedToState();
    } else if (notificationEvent is NotificationEventDeleteANotification) {
      yield* _mapDeleteANotificationToState(notificationEvent.id);
    } else if (notificationEvent is NotificationEventDeleteAllNotifications) {
      // yield* _mapCategoriesLoadedToState();
    }
  }

  Stream<NotificationState> _mapNotificationsLoadedToState() async* {
    try {
      final notifications =
          await this.notificationRepository.getNotificationsByUserId();
      yield NotificationStateFetchSuccess(notifications: notifications);
    } catch (e) {
      yield NotificationStateFailure(error: e.toString());
    }
  }

  Stream<NotificationState> _mapDeleteANotificationToState(int id) async* {
    try {
      final isDeleted =
          await this.notificationRepository.removeNotification(id);
      yield NotificationStateDeleteANotifcationSuccess(isDeleted: isDeleted);
    } catch (e) {
      yield NotificationStateFailure(error: e.toString());
    }
  }
}
