import 'package:bot_toast/bot_toast.dart';
import 'package:customer_app_java_support/blocs/authen_blocs/authentication_bloc.dart';
import 'package:customer_app_java_support/blocs/authen_blocs/authentication_event.dart';
import 'package:customer_app_java_support/blocs/authen_blocs/authentication_state.dart';
import 'package:customer_app_java_support/blocs/authen_blocs/home_page.dart';
import 'package:customer_app_java_support/blocs/authen_blocs/loading_indicator.dart';
import 'package:customer_app_java_support/blocs/authen_blocs/login_page.dart';
import 'package:customer_app_java_support/blocs/authen_blocs/splash.dart';
import 'package:customer_app_java_support/blocs/authen_blocs/user_repository.dart';
import 'package:customer_app_java_support/globals.dart' as globals;
import 'package:customer_app_java_support/locator.dart';
import 'package:customer_app_java_support/nav_screen.dart';
import 'package:customer_app_java_support/respositories/thread_api_client.dart';
import 'package:customer_app_java_support/routing_constants.dart';
import 'package:customer_app_java_support/screens/login_screen.dart';
import 'package:customer_app_java_support/services/navigation_service.dart';
import 'package:customer_app_java_support/services/push_notification_service.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:intl/date_symbol_data_local.dart';

import 'blocs/bloc_observer.dart';
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
    Firebase.initializeApp().whenComplete(() {
      print("completed");
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
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
            primaryColorDark: Color(0xff262833),
            primaryColorLight: Color(0xffFCF9F5),
            visualDensity: VisualDensity.adaptivePlatformDensity,
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
        // ignore: missing_required_param
        home: LoginScreen());
  }
}

// import 'package:expand_widget/expand_widget.dart';
// import 'package:flutter/material.dart';

// void main() => runApp(MyApp());

// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Expand Widget',
//       theme: ThemeData(
//         primarySwatch: Colors.blue,
//       ),
//       home: HomePage(),
//     );
//   }
// }

// class HomePage extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Expand Widget'),
//       ),
//       body: ListView(
//         padding: EdgeInsets.all(8),
//         children: <Widget>[
//           SizedBox(height: 4),
//           Container(
//             child: Padding(
//               padding: EdgeInsets.all(8),
//               child: Column(
//                 children: <Widget>[
//                   Text(
//                     'Expand Child',
//                     style: Theme.of(context).textTheme.headline6,
//                   ),
//                   SizedBox(height: 8),
//                   OutlineButton(
//                     child: Text('Button0'),
//                     onPressed: () => print('Pressed button0'),
//                   ),
//                   ExpandChild(
//                     child: Column(
//                       children: <Widget>[
//                         OutlineButton(
//                           child: Text('Button1'),
//                           onPressed: () => print('Pressed button1'),
//                         ),
//                         OutlineButton(
//                           child: Text('Button2'),
//                           onPressed: () => print('Pressed button2'),
//                         ),
//                         OutlineButton(
//                           child: Text('Button3'),
//                           onPressed: () => print('Pressed button3'),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
