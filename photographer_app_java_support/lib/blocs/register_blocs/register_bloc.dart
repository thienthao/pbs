import 'package:photographer_app_java_support/blocs/authen_blocs/user_repository.dart';
import 'package:photographer_app_java_support/blocs/register_blocs/register_event.dart';
import 'package:photographer_app_java_support/blocs/register_blocs/register_state.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RegisterBloc extends Bloc<RegisterEvent, RegisterState> {
  final UserRepository userRepository;

  RegisterBloc({@required this.userRepository}) : super(RegisterUninit());

  @override
  Stream<RegisterState> mapEventToState(
    RegisterEvent event,
  ) async* {
    print("zo bloc");
    if (event is SignUp) {
      try {
        print("zo signup");
        await userRepository.register(userRegister: event.userRegister);
        yield RegisterSuccess();
      } catch (e) {
        print(e.toString());
        yield RegisterFailure();
      }
    }
  }
}
