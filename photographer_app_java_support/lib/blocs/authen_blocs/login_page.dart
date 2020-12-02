import 'package:photographer_app_java_support/blocs/authen_blocs/authentication_bloc.dart';
import 'package:photographer_app_java_support/blocs/authen_blocs/login_bloc.dart';
import 'package:photographer_app_java_support/blocs/authen_blocs/login_form.dart';
import 'package:photographer_app_java_support/blocs/authen_blocs/user_repository.dart';
import 'package:photographer_app_java_support/screens/login_screen.dart';
import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

class LoginPage extends StatelessWidget {
  final UserRepository userRepository;

  LoginPage({Key key, @required this.userRepository})
      : assert(userRepository != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocProvider(
        create: (context) {
          return LoginBloc(
            authenticationBloc: BlocProvider.of<AuthenticationBloc>(context),
            userRepository: userRepository,
          );
        },
        child: LoginScreen(userRepository: userRepository),
      ),
    );
  }
}
