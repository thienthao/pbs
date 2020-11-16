import 'package:customer_app_java_support/screens/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'blocs/bloc_observer.dart';
import 'package:customer_app_java_support/globals.dart' as globals;

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
