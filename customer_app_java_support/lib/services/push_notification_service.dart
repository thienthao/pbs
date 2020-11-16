import 'package:bot_toast/bot_toast.dart';
import 'package:customer_app_java_support/locator.dart';
import 'package:customer_app_java_support/routing_constants.dart';
import 'package:customer_app_java_support/services/navigation_service.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class PushNotificationService {
  final FirebaseMessaging _fcm = FirebaseMessaging();
  final NavigationService _navigationService = locator<NavigationService>();
  final http.Client httpClient = http.Client();

  Future init() async {
//    _fcm.getToken().then((token) {
//      print(token);
//      httpClient.post(
//        "https://pbs-webapi.herokuapp.com/api/users/168/devicetoken",
//        headers: {"Content-Type": "application/json; charset=UTF-8"},
//        body: token,
//      );
//    });

    _fcm.unsubscribeFromTopic("photographer-topic");
    _fcm.subscribeToTopic("topic");

    _fcm.configure(
      onMessage: (Map<String, dynamic> msg) async {
        print("onMessage ne");
        print('onMessage: $msg');
        BotToast.showSimpleNotification(
          title: msg["notification"]["body"],
          backgroundColor: Colors.red[200],
          titleStyle: TextStyle(
              color: Colors.white, fontFamily: "Quicksand", fontSize: 16.0),
          duration: Duration(seconds: 2),
          hideCloseButton: true,
        );
      },
      onLaunch: (Map<String, dynamic> msg) async {
        print('onLaunch: $msg');
        _seralizeAndNavigate(msg);
      },
      onResume: (Map<String, dynamic> msg) async {
        print('onResume: $msg');
        _seralizeAndNavigate(msg);
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
