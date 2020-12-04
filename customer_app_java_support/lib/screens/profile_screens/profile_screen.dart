import 'package:customer_app_java_support/blocs/authen_blocs/authentication_bloc.dart';
import 'package:customer_app_java_support/blocs/authen_blocs/login_bloc.dart';
import 'package:customer_app_java_support/blocs/authen_blocs/user_repository.dart';
import 'package:customer_app_java_support/blocs/customer_blocs/customers.dart';
import 'package:customer_app_java_support/respositories/customer_repository.dart';
import 'package:customer_app_java_support/widgets/profile_screen/profile_body.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;

class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  final userRepository = UserRepository();
  CustomerRepository _customerRepository =
      CustomerRepository(httpClient: http.Client());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) {
            return LoginBloc(
              authenticationBloc: BlocProvider.of<AuthenticationBloc>(context),
              userRepository: userRepository,
            );
          },
        ),
        BlocProvider(
          create: (context) =>
              CustomerBloc(customerRepository: _customerRepository),
        )
      ],
      child: Body(),
    ));
  }
}
