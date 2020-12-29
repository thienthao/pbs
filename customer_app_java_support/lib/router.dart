import 'package:customer_app_java_support/blocs/booking_blocs/booking_bloc.dart';
import 'package:customer_app_java_support/blocs/booking_blocs/booking_event.dart';
import 'package:customer_app_java_support/main.dart';
import 'package:customer_app_java_support/respositories/booking_repository.dart';
import 'package:customer_app_java_support/routing_constants.dart';
import 'package:customer_app_java_support/screens/history_screens/history_screen.dart';
import 'package:customer_app_java_support/screens/login_screen.dart';
import 'package:customer_app_java_support/widgets/history_screen/booking_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

BookingRepository _bookingRepository =
    BookingRepository(httpClient: http.Client());
SharedPreferences prefs;
int cusId;
void getCusId() async {
  prefs = await SharedPreferences.getInstance();
  cusId = prefs.getInt('customerId');
}

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
                child: BookingWidget(),
                //child: BookingDetailScreen(bookingId: bookingId),
              ));
    case BookingHistory:
      return MaterialPageRoute(
          builder: (context) => BlocProvider(
                create: (context) =>
                    BookingBloc(bookingRepository: _bookingRepository)
                      ..add(BookingEventFetch(cusId: cusId)),
                child: BookHistory(),
              ));
    default:
      print("zo case default roi");
      // ignore: missing_required_param
      return MaterialPageRoute(builder: (context) => LoginScreen());
  }
}
