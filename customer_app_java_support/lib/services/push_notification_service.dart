import 'package:bot_toast/bot_toast.dart';
import 'package:customer_app_java_support/locator.dart';
import 'package:customer_app_java_support/routing_constants.dart';
import 'package:customer_app_java_support/services/navigation_service.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class PushNotificationService {
  final FirebaseMessaging _fcm = FirebaseMessaging();
  final NavigationService _navigationService = locator<NavigationService>();
  final referenceDatabase = FirebaseDatabase.instance;
  final http.Client httpClient = http.Client();
  SharedPreferences prefs;

  Future init() async {
    prefs = await SharedPreferences.getInstance();
    int cusId = prefs.getInt('customerId');

    _fcm.getToken().then((token) {
      print(token);

      httpClient.post(
        "http://194.59.165.195:8080/pbs-webapi/api/users/$cusId/devicetoken",
        headers: {"Content-Type": "application/json; charset=UTF-8"},
        body: token,
      );
    });

    // _fcm.unsubscribeFromTopic("photographer-topic");
    // _fcm.subscribeToTopic("topic");
    final ref = referenceDatabase.reference();

    _fcm.configure(
      onMessage: (Map<String, dynamic> msg) async {
        print("onMessage ne");
        print('onMessage: $msg');
        ref
            .child('Notification_$cusId')
            .push()
            .child('NotificationContent')
            .set(msg)
            .asStream();

        BotToast.showSimpleNotification(
          title: msg["notification"]["body"],
          backgroundColor: Colors.grey[100],
          titleStyle: TextStyle(
              color: Colors.black, fontFamily: "Quicksand", fontSize: 16.0),
          duration: Duration(seconds: 10),
          hideCloseButton: false,
        );
      },
      onLaunch: (Map<String, dynamic> msg) async {
        print('onLaunch: $msg');
        _seralizeAndNavigate(msg);
        ref
            .child('Notification_$cusId')
            .push()
            .child('NotificationContent')
            .set(msg)
            .asStream();
      },
      onResume: (Map<String, dynamic> msg) async {
        print('onResume: $msg');
        _seralizeAndNavigate(msg);
        ref
            .child('Notification_$cusId')
            .push()
            .child('NotificationContent')
            .set(msg)
            .asStream();
      },
    );
  }

  void _seralizeAndNavigate(Map<String, dynamic> message) {
    var notificationData = message['data'];
    var view = notificationData['view'];
    var bookingId = notificationData['bookingId'];

    if (view != null) {
      if (view == 'booking_detail') {
        print("co zo serialize");
        _navigationService.navigateTo(BookingDetail, arguments: bookingId);
      }
      if (view == 'booking_history') {
        _navigationService.navigateTo(BookingHistory);
      }
    }
  }
}
