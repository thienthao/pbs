

import 'package:customer_app_java_support/blocs/authen_blocs/user_repository.dart';
import 'package:customer_app_java_support/blocs/register_blocs/register_event.dart';
import 'package:customer_app_java_support/blocs/register_blocs/register_state.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RegisterBloc extends Bloc<RegisterEvent, RegisterState> {
  final UserRepository userRepository;

  RegisterBloc({@required this.userRepository}) : super(RegisterUnInit());

  @override
  Stream<RegisterState> mapEventToState(RegisterEvent event) async* {
    if(event is RegisterPost) {
      bool success = await userRepository.register(username: event.userRegister.username, password: event.userRegister.password, email: event.userRegister.email);

      if(success) {
        yield RegisterSuccess();
      } else {
        yield RegisterFailure();
      }
    }
  }
}