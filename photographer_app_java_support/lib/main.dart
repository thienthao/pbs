import 'package:bot_toast/bot_toast.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:photographer_app_java_support/globals.dart';
import 'package:photographer_app_java_support/locator.dart';
import 'package:photographer_app_java_support/nav_screen.dart';
import 'package:photographer_app_java_support/screens/login_screen.dart';
import 'package:photographer_app_java_support/services/push_notification_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'blocs/authen_blocs/authen_export.dart';
import 'blocs/bloc_observer.dart';
import 'router.dart' as router;
import 'services/navigation_service.dart';

void main() {
  initializeDateFormatting('vi_VN', null).then((_) {
    final userRepository = UserRepository();
    Bloc.observer = PBSBlocObserver();
    setupLocator();
    runApp(App(
      userRepository: userRepository,
    ));
  });
}

class App extends StatefulWidget {
  final UserRepository userRepository;

  App({Key key, @required this.userRepository}) : super(key: key);

  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> {
  //thao
  final PushNotificationService _pushNotificationService =
      locator<PushNotificationService>();
  //end thao

  @override
  void initState() {
    _pushNotificationService.init();
    super.initState();

    Firebase.initializeApp().whenComplete(() {
      setState(() {});
    });
  }

  getPreference() async {
    prefs = await SharedPreferences.getInstance();
    globalPtgId = prefs.getInt('photographerId');
    globalPtgToken = prefs.getString('photographerToken');
  }


  @override

  Widget build(BuildContext context) {
    getPreference();
    SystemChrome.setEnabledSystemUIOverlays([]);
    return BlocProvider(
        create: (context) =>
            AuthenticationBloc(userRepository: widget.userRepository)
              ..add(AppStarted()),
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          builder: BotToastInit(),
          navigatorObservers: [BotToastNavigatorObserver()],
          navigatorKey: locator<NavigationService>().navigatorKey,
          onGenerateRoute: router.generateRoute,
          theme: ThemeData(
            fontFamily: 'Quicksand',
            primaryColor: Color(0xFFF88F8F),
            accentColor: Color(0xFFFFBDAC),
            scaffoldBackgroundColor: Color(0xFFF3F5F7),
          ),
          home: BlocBuilder<AuthenticationBloc, AuthenticationState>(
            builder: (context, state) {
              if (state is AuthenticationUnitialized) {
                return SplashPage();
              }
              if (state is AuthenticationAuthenticated) {
                return NavScreen();
              }
              if (state is AuthenticationUnauthenticated) {
                return LoginPage(
                  userRepository: widget.userRepository,
                );
              }
              if (state is AuthenticationLoading) {
                return LoadingIndicator();
              }
              return HomePage();
            },
          ),
        ));
  }
}

class MyApp extends StatefulWidget {
  // This widget is the root of your application.
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  //thao
  final PushNotificationService _pushNotificationService =
      locator<PushNotificationService>();
  //end thao

  @override
  void initState() {
    _pushNotificationService.init();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: locator<NavigationService>().navigatorKey,
      onGenerateRoute: router.generateRoute,
      title: 'Flutter Photographer UI',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'Quicksand',
        primaryColor: Color(0xFFF88F8F),
        accentColor: Color(0xFFFFBDAC),
        scaffoldBackgroundColor: Color(0xFFF3F5F7),
      ),
       // ignore: missing_required_param
      home: LoginScreen(),
    );
  }
}
