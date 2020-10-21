import 'package:capstone_mock_1/blocs/booking_blocs/bookings.dart';
import 'package:capstone_mock_1/respositories/booking_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'blocs/album_blocs/album.dart';
import 'blocs/bloc_observer.dart';
import 'blocs/category_blocs/categories.dart';
import 'blocs/photographer_blocs/photographers.dart';
import 'respositories/album_respository.dart';
import 'respositories/category_respository.dart';
import 'respositories/photographer_respository.dart';
import 'screens/history_screen.dart';
import 'screens/home_screen.dart';
import 'package:http/http.dart' as http;

void main() {
  initializeDateFormatting('vi_VN', null).then((_) {
    Bloc.observer = PBSBlocObserver();

    runApp(MyApp());
  });
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  int _selectedTab = 0;
  AlbumRepository _albumRepository = AlbumRepository(httpClient: http.Client());
  PhotographerRepository _photographerRepository =
      PhotographerRepository(httpClient: http.Client());
  CategoryRepository _categoryRepository =
      CategoryRepository(httpClient: http.Client());

  BookingRepository _bookingRepository =
      BookingRepository(httpClient: http.Client());
  List _pageOptions = [];

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
                photographerRepository: _photographerRepository)
              ..add(PhotographerEventFetch()),
          ),
          BlocProvider(
            create: (context) => AlbumBloc(albumRepository: _albumRepository),
          ),
          BlocProvider(
            create: (context) =>
                BookingBloc(bookingRepository: _bookingRepository),
          ),
        ],
        child: HomeScreen(),
      ),
      MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) =>
                BookingBloc(bookingRepository: _bookingRepository)
                  ..add(BookingEventFetch()),
          ),
        ],
        child: BookHistory(),
      ),
      BookHistory(),
      BookHistory(),
    ];
    return MaterialApp(
      title: 'Flutter User UI',
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
                      icon: Icons.favorite_border,
                      iconColor: Colors.grey[600],
                      text: 'Thích',
                    ),
                    GButton(
                      icon: Icons.library_books,
                      iconColor: Colors.grey[600],
                      text: 'Hoạt động',
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
