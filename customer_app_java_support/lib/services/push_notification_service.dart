import 'package:bot_toast/bot_toast.dart';
import 'package:customer_app_java_support/locator.dart';
import 'package:customer_app_java_support/respositories/customer_repository.dart';
import 'package:customer_app_java_support/respositories/photographer_respository.dart';
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

        var senderId = msg['data'] as Map;

        if (senderId['sender'] == null) {
          ref
              .child('Notification_$cusId')
              .push()
              .child('NotificationContent')
              .set(msg)
              .asStream();
        }

        BotToast.showSimpleNotification(
          title: msg["notification"]["body"],
          enableSlideOff: true,
          onTap: () {
            
            _seralizeAndNavigate(msg);
          },    
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

  getChatRoomId(String a, String b) {
    if (a.substring(0, 1).codeUnitAt(0) > b.substring(0, 1).codeUnitAt(0)) {
      return "$b\_$a";
    } else {
      return "$a\_$b";
    }
  }

  void _seralizeAndNavigate(Map<String, dynamic> message) async {
    var notificationData = message['data'];
    var view = notificationData['view'];
    var bookingId = notificationData['bookingId'];
    var senderId = notificationData['sender'];
    var receiverId = notificationData['receiver'];
    if (view != null) {
      if (view == 'booking_detail') {
        print("co zo serialize");
        _navigationService.navigateTo(BookingDetail, arguments: bookingId);
      }
      if (view == 'booking_history') {
        _navigationService.navigateTo(BookingHistory);
      }
    }
    if (senderId != null) {
      final CustomerRepository _customerRepository =
          CustomerRepository(httpClient: http.Client());
      final PhotographerRepository _photographerRepository =
          PhotographerRepository(httpClient: http.Client());
      final customer =
          await _customerRepository.getProfileById(int.parse(receiverId));
      final photographer = await _photographerRepository
          .getPhotographerbyId(int.parse(senderId));

      var chatInfo = {
        "photographer_id": photographer.id,
        "photographer_name": photographer.fullname,
        "photographer_avatar": photographer.avatar,
        "customer_id": customer.id,
        "customer_name": customer.fullname,
        "customer_avatar": customer.avatar,
      };

      _navigationService.navigateTo(Chat, arguments: chatInfo);
    }
  }
}
