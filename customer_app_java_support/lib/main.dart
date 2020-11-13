import 'package:customer_app_java_support/blocs/authen_blocs/authentication_bloc.dart';
import 'package:customer_app_java_support/blocs/authen_blocs/authentication_event.dart';
import 'package:customer_app_java_support/blocs/authen_blocs/authentication_state.dart';
import 'package:customer_app_java_support/blocs/authen_blocs/home_page.dart';
import 'package:customer_app_java_support/blocs/authen_blocs/loading_indicator.dart';
import 'package:customer_app_java_support/blocs/authen_blocs/login_page.dart';
import 'package:customer_app_java_support/blocs/authen_blocs/splash.dart';
import 'package:customer_app_java_support/blocs/authen_blocs/user_repository.dart';
import 'package:customer_app_java_support/locator.dart';
import 'package:customer_app_java_support/nav_screen.dart';
import 'package:customer_app_java_support/respositories/thread_api_client.dart';
import 'package:customer_app_java_support/routing_constants.dart';
import 'package:customer_app_java_support/screens/login_screen.dart';
import 'package:customer_app_java_support/services/navigation_service.dart';
import 'package:customer_app_java_support/services/push_notification_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'blocs/bloc_observer.dart';
import 'package:customer_app_java_support/globals.dart' as globals;
import 'package:http/http.dart' as http;
import 'router.dart' as router;

void main() {
  initializeDateFormatting('vi_VN', null).then((_) {
    Bloc.observer = PBSBlocObserver();
    final userRepository = UserRepository();

    //thao
    setupLocator();
    ThreadApiClient threadApiClient =
        ThreadApiClient(httpClient: http.Client());
    threadApiClient.all();
    //end thao

    runApp(
      App(
        userRepository: userRepository,
      ),
    );
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
    globals.selectedTabGlobal = 0;
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (context) =>
            AuthenticationBloc(userRepository: widget.userRepository)
              ..add(AppStarted()),
        child: MaterialApp(
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

// ignore: must_be_immutable
class MyApp extends StatefulWidget {
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
    globals.selectedTabGlobal = 0;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        navigatorKey: locator<NavigationService>().navigatorKey,
        onGenerateRoute: router.generateRoute,
        initialRoute: Login,
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
