import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:http/http.dart' as http;
import 'package:intl/date_symbol_data_local.dart';
import 'package:ptg_7_11_app/blocs/booking_blocs/bookings.dart';
import 'package:ptg_7_11_app/blocs/package_blocs/packages.dart';
import 'package:ptg_7_11_app/respositories/package_repository.dart';
import 'package:ptg_7_11_app/respositories/photographer_respository.dart';
import 'package:ptg_7_11_app/screens/history_screens/history_screen.dart';
import 'package:ptg_7_11_app/screens/home_screen.dart';
import 'package:ptg_7_11_app/screens/login_screen.dart';
import 'package:ptg_7_11_app/screens/profile_screens/profile_screen.dart';
import 'package:ptg_7_11_app/screens/services_screens/service_list_screen.dart';
import 'blocs/bloc_observer.dart';
import 'blocs/photographer_blocs/photographers.dart';
import 'respositories/booking_repository.dart';

void main() {
  initializeDateFormatting('vi_VN', null).then((_) {
    Bloc.observer = PBSBlocObserver();

    runApp(MyApp());
  });
}

class MyApp extends StatefulWidget {
  // This widget is the root of your application.
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Photographer UI',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'Quicksand',
        primaryColor: Color(0xFFF88F8F),
        accentColor: Color(0xFFFFBDAC),
        scaffoldBackgroundColor: Color(0xFFF3F5F7),
      ),
      home: LoginScreen(),
    );
  }
}
