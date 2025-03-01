import 'dart:async';

import 'package:bot_toast/bot_toast.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:photographer_app_java_support/globals.dart';
import 'package:photographer_app_java_support/locator.dart';
import 'package:photographer_app_java_support/respositories/photographer_respository.dart';
import 'package:photographer_app_java_support/routing_constants.dart';
import 'package:photographer_app_java_support/services/navigation_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PushNotificationService {
  final FirebaseMessaging _fcm = FirebaseMessaging();
  final NavigationService _navigationService = locator<NavigationService>();
  final referenceDatabase = FirebaseDatabase.instance;
  final http.Client httpClient = http.Client();
  SharedPreferences prefs;

  Future init() async {
    prefs = await SharedPreferences.getInstance();
    int ptgId = prefs.getInt('photographerId');

    if (ptgId != null) {
      _fcm.getToken().then((token) {
        print('$ptgId _ $token');
        httpClient.post(
          "http://194.59.165.195:8080/pbs-webapi/api/users/$ptgId/devicetoken",
          headers: {"Content-Type": "application/json; charset=UTF-8"},
          body: token,
        );
      });
    }

    final ref = referenceDatabase.reference();

    // _fcm.unsubscribeFromTopic("topic");
    // _fcm.subscribeToTopic("photographer-topic");

    print("configure");
    _fcm.configure(
      onMessage: (Map<String, dynamic> msg) async {
        print("onMessage ne");
        print('onMessage: $msg');
        var senderId = msg['data'] as Map;

        if (senderId['sender'] == null) {
          ref
              .child('Notification_$globalPtgId')
              .push()
              .child('NotificationContent')
              .set(msg)
              .asStream();
        }

        BotToast.showSimpleNotification(
          enableSlideOff: true,
          onTap: () {
            _seralizeAndNavigate(msg);
          },
          title: msg["notification"]["body"],
          backgroundColor: Colors.grey[100],
          titleStyle: TextStyle(
              color: Colors.black, fontFamily: "Quicksand", fontSize: 18.0),
          duration: Duration(seconds: 10),
          hideCloseButton: false,
        );

        // BotToast.showCustomNotification(toastBuilder: (widget) {
        //   return Container(
        //     alignment: Alignment.topCenter,
        //     height: 1.0,
        //     child: Text(msg["notification"]["body"]),
        //     color: Colors.red[200],
        //   );
        // });
        // Fluttertoast.showToast(
        //   msg: msg["notification"]["body"],
        //   toastLength: Toast.LENGTH_LONG,
        //   gravity: ToastGravity.TOP,
        //   backgroundColor: Color(0xFFF88F8F),
        //   textColor: Colors.white,
        //   fontSize: 16.0,
        // );
      },
      onLaunch: (Map<String, dynamic> msg) async {
        print('onLaunch: $msg');
        _seralizeAndNavigate(msg);
        ref
            .child('Notification_$globalPtgId')
            .push()
            .child('NotificationContent')
            .set(msg)
            .asStream();
      },
      onResume: (Map<String, dynamic> msg) async {
        print('onResume: $msg');

        _seralizeAndNavigate(msg);
        ref
            .child('Notification_$globalPtgId')
            .push()
            .child('NotificationContent')
            .set(msg)
            .asStream();
      },
    );
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
      final PhotographerRepository _photographerRepository =
          PhotographerRepository(httpClient: http.Client());
      final customer =
          await _photographerRepository.getProfileById(int.parse(senderId));
      final photographer = await _photographerRepository
          .getPhotographerbyId(int.parse(receiverId));
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

class CustomNotification extends StatefulWidget {
  @override
  _CustomNotificationState createState() => _CustomNotificationState();
}

class _CustomNotificationState extends State<CustomNotification> {
  bool enableSlideOff = true;
  bool onlyOne = true;
  bool crossPage = true;
  int seconds = 10;
  int animationMilliseconds = 200;
  int animationReverseMilliseconds = 200;
  BackButtonBehavior backButtonBehavior = BackButtonBehavior.none;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("CustomNotification"),
      ),
      body: Container(
        padding: EdgeInsets.only(top: 20),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              RaisedButton(
                onPressed: () {
                  BotToast.showCustomNotification(
                      animationDuration:
                          Duration(milliseconds: animationMilliseconds),
                      animationReverseDuration:
                          Duration(milliseconds: animationReverseMilliseconds),
                      duration: Duration(seconds: seconds),
                      backButtonBehavior: backButtonBehavior,
                      // ignore: missing_return
                      toastBuilder: (cancel) {},
                      enableSlideOff: enableSlideOff,
                      onlyOne: onlyOne,
                      crossPage: crossPage);
                },
                child: Text("CustomNotification"),
              ),
              SwitchListTile(
                value: enableSlideOff,
                onChanged: (value) {
                  setState(() {
                    enableSlideOff = value;
                  });
                },
                title: Text("enableSlideOff: "),
              ),
              SwitchListTile(
                value: onlyOne,
                onChanged: (value) {
                  setState(() {
                    onlyOne = value;
                  });
                },
                title: Text("onlyOne: "),
              ),
              SwitchListTile(
                value: crossPage,
                onChanged: (value) {
                  setState(() {
                    crossPage = value;
                  });
                },
                title: Text("crossPage: "),
              ),
              Center(
                child: Text('BackButtonBehavior'),
              ),
              Row(
                children: <Widget>[
                  Expanded(
                    child: RadioListTile(
                      value: BackButtonBehavior.none,
                      groupValue: backButtonBehavior,
                      onChanged: (value) {
                        setState(() {
                          backButtonBehavior = value;
                        });
                      },
                      title: Text('none'),
                    ),
                  ),
                  Expanded(
                    child: RadioListTile(
                      value: BackButtonBehavior.ignore,
                      groupValue: backButtonBehavior,
                      onChanged: (value) {
                        setState(() {
                          backButtonBehavior = value;
                        });
                      },
                      title: Text('ignore'),
                    ),
                  ),
                  Expanded(
                    child: RadioListTile(
                      value: BackButtonBehavior.close,
                      groupValue: backButtonBehavior,
                      onChanged: (value) {
                        setState(() {
                          backButtonBehavior = value;
                        });
                      },
                      title: Text('close'),
                    ),
                  )
                ],
              ),
              ListTile(
                title: Text("duration:   ${seconds}s"),
                trailing: CupertinoSlider(
                  min: 1,
                  max: 20,
                  value: seconds.toDouble(),
                  onChanged: (double value) {
                    setState(() {
                      seconds = value.toInt();
                    });
                  },
                ),
              ),
              ListTile(
                title: Text("animationDuration:   ${animationMilliseconds}ms"),
                trailing: CupertinoSlider(
                  min: 100,
                  max: 1000,
                  divisions: 18,
                  value: animationMilliseconds.toDouble(),
                  onChanged: (double value) {
                    setState(() {
                      animationMilliseconds = value.toInt();
                    });
                  },
                ),
              ),
              ListTile(
                title: Text(
                    "animationReverseDuration:   ${animationReverseMilliseconds}ms"),
                trailing: CupertinoSlider(
                  min: 100,
                  max: 1000,
                  divisions: 18,
                  value: animationReverseMilliseconds.toDouble(),
                  onChanged: (double value) {
                    setState(() {
                      animationReverseMilliseconds = value.toInt();
                    });
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
