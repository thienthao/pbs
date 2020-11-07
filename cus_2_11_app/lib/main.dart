import 'package:cus_2_11_app/screens/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'blocs/bloc_observer.dart';
import 'package:cus_2_11_app/globals.dart' as globals;

void main() {
  initializeDateFormatting('vi_VN', null).then((_) {
    Bloc.observer = PBSBlocObserver();
    runApp(MyApp());
  });
}

// ignore: must_be_immutable
class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    globals.selectedTabGlobal = 0;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Photographer Booking System',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          fontFamily: 'Quicksand',
          primaryColor: Color(0xFFF88F8F),
          accentColor: Color(0xFFFFBDAC),
          scaffoldBackgroundColor: Color(0xFFF3F5F7),
        ),
        home: LoginScreen());
  }
}
