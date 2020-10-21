import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:photographer_app/blocs/booking_blocs/bookings.dart';
import 'package:photographer_app/screens/booking_detail_screen_done.dart';
import 'package:photographer_app/screens/history_screen.dart';
import 'package:photographer_app/screens/home_screen.dart';
import 'package:photographer_app/screens/service_list_screen.dart';

import 'package:http/http.dart' as http;

import 'blocs/bloc_observer.dart';
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
  int _selectedTab = 0;
  BookingRepository _bookingRepository =
      BookingRepository(httpClient: http.Client());

  List _pageOptions = [];

  @override
  Widget build(BuildContext context) {
    _pageOptions = [
      BlocProvider(
        create: (context) => BookingBloc(bookingRepository: _bookingRepository),
        child: HomeScreen(),
      ),
      ListService(),
      BookHistory(),
      BookingDetailScreenDone(),
    ];

    return MaterialApp(
      title: 'Flutter Photographer UI',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'Quicksand',
        primaryColor: Color(0xFFF88F8F),
        accentColor: Color(0xFFFFBDAC),
        scaffoldBackgroundColor: Color(0xFFF3F5F7),
      ),
      home: Scaffold(
        body: _pageOptions[_selectedTab],
        bottomNavigationBar: Container(
          decoration: BoxDecoration(color: Colors.white, boxShadow: [
            BoxShadow(
              blurRadius: 20,
              color: Colors.black.withOpacity(.1),
            ),
          ]),
          child: SafeArea(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 8),
              child: GNav(
                  gap: 2,
                  activeColor: Colors.white,
                  iconSize: 24,
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                  duration: Duration(seconds: 1),
                  tabBackgroundColor: Color(0xFFF88F8F),
                  tabs: [
                    GButton(
                      icon: Icons.home,
                      iconColor: Colors.grey[600],
                      text: 'Trang chủ',
                    ),
                    GButton(
                      icon: Icons.camera_alt_rounded,
                      iconColor: Colors.grey[600],
                      text: 'Dịch vụ',
                    ),
                    GButton(
                      icon: Icons.library_books,
                      iconColor: Colors.grey[600],
                      text: 'Công việc',
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                    GButton(
                      icon: Icons.account_circle_sharp,
                      iconColor: Colors.grey[600],
                      text: 'Profile',
                    ),
                  ],
                  selectedIndex: _selectedTab,
                  onTabChange: (index) {
                    setState(() {
                      _selectedTab = index;
                    });
                  }),
            ),
          ),
        ),
      ),
    );
  }
}
