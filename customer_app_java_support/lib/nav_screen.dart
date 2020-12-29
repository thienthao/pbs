import 'package:customer_app_java_support/blocs/booking_blocs/bookings.dart';
import 'package:customer_app_java_support/blocs/customer_blocs/customers.dart';
import 'package:customer_app_java_support/globals.dart' as globals;
import 'package:customer_app_java_support/globals.dart';
import 'package:customer_app_java_support/plane_indicator.dart';
import 'package:customer_app_java_support/respositories/booking_repository.dart';
import 'package:customer_app_java_support/respositories/customer_repository.dart';
import 'package:customer_app_java_support/screens/forum_screen/forum_screen.dart';
import 'package:customer_app_java_support/screens/profile_screens/profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'blocs/album_blocs/album.dart';
import 'blocs/category_blocs/categories.dart';
import 'blocs/photographer_alg_blocs/photographers_alg.dart';
import 'blocs/photographer_blocs/photographers.dart';
import 'respositories/album_respository.dart';
import 'respositories/category_respository.dart';
import 'respositories/photographer_respository.dart';
import 'screens/history_screens/history_screen.dart';
import 'screens/home_screens/home_screen.dart';

// ignore: must_be_immutable
class NavScreen extends StatefulWidget {
  @override
  _NavScreenState createState() => _NavScreenState();
}

class _NavScreenState extends State<NavScreen> {
  AlbumRepository _albumRepository = AlbumRepository(httpClient: http.Client());
  PhotographerRepository _photographerRepository =
      PhotographerRepository(httpClient: http.Client());
  CategoryRepository _categoryRepository =
      CategoryRepository(httpClient: http.Client());

  BookingRepository _bookingRepository =
      BookingRepository(httpClient: http.Client());
  CustomerRepository _customerRepository =
      CustomerRepository(httpClient: http.Client());
  List _pageOptions = [];
  SharedPreferences prefs;

  void getPreference() async {
    prefs = await SharedPreferences.getInstance();
    print('TOKEN: ${prefs.getString('customerToken')}');
    print('CUS ID: ${prefs.getInt('customerId')}');
    globalCusId = prefs.getInt('customerId');
    globalCusToken = prefs.getString('customerToken');
  }

  @override
  void initState() {
    super.initState();
    globals.selectedTabGlobal = 0;
    getPreference();
    SystemChrome.setEnabledSystemUIOverlays([]);
  }

  @override
  Widget build(BuildContext context) {
    _pageOptions = [
      MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) =>
                CategoryBloc(categoryRepository: _categoryRepository)
                  ..add(CategoryEventFetch()),
          ),
          BlocProvider(
            create: (context) => PhotographerBloc(
                photographerRepository: _photographerRepository),
          ),
          BlocProvider(
            create: (context) => PhotographerAlgBloc(
                photographerRepository: _photographerRepository),
          ),
          BlocProvider(
            create: (context) => AlbumBloc(albumRepository: _albumRepository),
          ),
          BlocProvider(
            create: (context) =>
                BookingBloc(bookingRepository: _bookingRepository),
          ),
        ],
        child: PlaneIndicator(child: HomeScreen()),
      ),
      ForumPage(),
      MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) =>
                BookingBloc(bookingRepository: _bookingRepository),
          ),
        ],
        child: BookHistory(),
      ),
      MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) =>
                CustomerBloc(customerRepository: _customerRepository),
          ),
        ],
        child: Profile(),
      )
    ];
    return MaterialApp(
      title: 'Photographer Booking System for Customer',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'Quicksand',
        primaryColor: Color(0xFFF88F8F),
        accentColor: Color(0xFFFFBDAC),
        scaffoldBackgroundColor: Color(0xFFF3F5F7),
      ),
      home: Scaffold(
        body: _pageOptions[globals.selectedTabGlobal],
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
                      icon: Icons.style,
                      iconColor: Colors.grey[600],
                      text: 'Diễn đàn',
                    ),
                    GButton(
                      icon: Icons.library_books,
                      iconColor: Colors.grey[600],
                      text: 'Lịch sử',
                      onPressed: () {
                        // Navigator.pop(context);
                      },
                    ),
                    GButton(
                      icon: Icons.account_circle_sharp,
                      iconColor: Colors.grey[600],
                      text: 'Profile',
                    ),
                  ],
                  selectedIndex: globals.selectedTabGlobal,
                  onTabChange: (index) {
                    setState(() {
                      globals.selectedTabGlobal = index;
                    });
                  }),
            ),
          ),
        ),
      ),
    );
  }
}
