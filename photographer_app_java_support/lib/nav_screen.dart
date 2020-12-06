import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:http/http.dart' as http;
import 'package:photographer_app_java_support/blocs/booking_blocs/bookings.dart';
import 'package:photographer_app_java_support/blocs/package_blocs/packages.dart';
import 'package:photographer_app_java_support/respositories/calendar_repository.dart';
import 'package:photographer_app_java_support/respositories/package_repository.dart';
import 'package:photographer_app_java_support/respositories/photographer_respository.dart';
import 'package:photographer_app_java_support/screens/history_screens/history_screen.dart';
import 'package:photographer_app_java_support/screens/home_screen.dart';
import 'package:photographer_app_java_support/screens/profile_screens/profile_screen.dart';
import 'package:photographer_app_java_support/screens/services_screens/service_list_screen.dart';
import 'package:photographer_app_java_support/widgets/shared/pop_up.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'blocs/calendar_blocs/calendars.dart';
import 'blocs/photographer_blocs/photographers.dart';
import 'respositories/booking_repository.dart';

class NavScreen extends StatefulWidget {
  @override
  _NavScreenState createState() => _NavScreenState();
}

class _NavScreenState extends State<NavScreen> {
  int _selectedTab = 0;
  BookingRepository _bookingRepository =
      BookingRepository(httpClient: http.Client());
  PackageRepository _packageRepository =
      PackageRepository(httpClient: http.Client());
  PhotographerRepository _photographerRepository =
      PhotographerRepository(httpClient: http.Client());
  CalendarRepository _calendarRepository =
      CalendarRepository(httpClient: http.Client());
  List _pageOptions = [];

  int unreadNoti = 0;
  SharedPreferences prefs;
  _getPreference() async {
    prefs = await SharedPreferences.getInstance();
    if(prefs.getInt('unreadNoti') != null) {
      unreadNoti = prefs.getInt('unreadNoti');
    }
    setState(() {});
  }

  _setPreference() async {
    prefs = await SharedPreferences.getInstance();
    prefs.setInt('unreadNoti', 0);
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    _getPreference();
    print(unreadNoti);
  }

  @override
  Widget build(BuildContext context) {
    _pageOptions = [
      MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) =>
                BookingBloc(bookingRepository: _bookingRepository)
                  ..add(BookingRestartEvent()),
          ),
          BlocProvider(
            create: (context) =>
                CalendarBloc(calendarRepository: _calendarRepository),
          ),
        ],
        child: HomeScreen(),
      ),
      BlocProvider(
        create: (context) => PackageBloc(packageRepository: _packageRepository),
        child: ListService(),
      ),
      BlocProvider(
        create: (context) => BookingBloc(bookingRepository: _bookingRepository)
          ..add(BookingRestartEvent()),
        child: BookHistory(),
      ),
      BlocProvider(
        create: (context) =>
            PhotographerBloc(photographerRepository: _photographerRepository)
              ..add(PhotographerbyIdEventFetch(id: 168)),
        child: Profile(),
      ),
    ];

    return Scaffold(
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
            child: Listener(
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
                      text: 'Lịch sử',
                      onPressed: () {
                        unreadNoti = 0;
                        setState(() {});
                      },
                      leading: _selectedTab == 2
                          ? null
                          : unreadNoti != 0
                              ? Badge(
                                  badgeContent: Text(
                                    unreadNoti.toString(),
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  child: Icon(
                                    Icons.library_books,
                                    color: Colors.grey[600],
                                  ))
                              : Icon(Icons.library_books,
                                  color: Colors.grey[600]),
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
