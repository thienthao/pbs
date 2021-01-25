import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:photographer_app_java_support/blocs/booking_blocs/booking_bloc.dart';
import 'package:photographer_app_java_support/blocs/booking_blocs/booking_event.dart';
import 'package:photographer_app_java_support/main.dart';
import 'package:photographer_app_java_support/respositories/booking_repository.dart';
import 'package:photographer_app_java_support/routing_constants.dart';
import 'package:photographer_app_java_support/screens/chat_screens/chat_screen.dart';
import 'package:photographer_app_java_support/screens/history_screens/booking_detail_screen.dart';
import 'package:photographer_app_java_support/screens/history_screens/history_screen.dart';
import 'package:photographer_app_java_support/screens/login_screen.dart';

BookingRepository _bookingRepository =
    BookingRepository(httpClient: http.Client());

Route<dynamic> generateRoute(RouteSettings settings) {
  print(settings.name);
  switch (settings.name) {
    case Home:
      print("zo case home roi");
      return MaterialPageRoute(builder: (context) => MyApp());
    case BookingDetail:
      var bookingId = int.parse(settings.arguments);
      print("co zo router");
      return MaterialPageRoute(
          builder: (context) => BlocProvider(
                create: (context) =>
                    BookingBloc(bookingRepository: _bookingRepository)
                      ..add(BookingEventDetailFetch(id: bookingId)),
                child: BookingDetailScreen(),
                //child: BookingDetailScreen(bookingId: bookingId),
              ));
    case BookingHistory:
      return MaterialPageRoute(
          builder: (context) => BlocProvider(
                create: (context) =>
                    BookingBloc(bookingRepository: _bookingRepository)
                      ..add(BookingEventFetch()),
                child: BookHistory(),
              ));
    case Chat:
      final info = settings.arguments as Map;
      print(info);

      // return MaterialPageRoute(
      //     builder: (context) => Text('${info['customer']['id']}'));
      return MaterialPageRoute(
          builder: (context) => ChatPage(
                senderId: info['photographer_id'],
                receiverId: info['customer_id'],
                avatar: info['customer_avatar'],
                chatRoomId:
                    '${info['photographer_name']}_${info['customer_name']}',
                myName: info['photographer_name'],
              ));
    default:
      print("zo case default roi");
      // ignore: missing_required_param
      return MaterialPageRoute(builder: (context) => LoginScreen());
  }
}
