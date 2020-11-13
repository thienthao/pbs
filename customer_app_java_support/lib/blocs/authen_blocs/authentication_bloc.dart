import 'package:customer_app_java_support/blocs/authen_blocs/authentication_event.dart';
import 'package:customer_app_java_support/blocs/authen_blocs/authentication_state.dart';
import 'package:customer_app_java_support/blocs/authen_blocs/user_repository.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AuthenticationBloc
    extends Bloc<AuthenticationEvent, AuthenticationState> {
  final UserRepository userRepository;

  AuthenticationBloc({@required this.userRepository})
      : super(AuthenticationUnitialized());

  @override
  Stream<AuthenticationState> mapEventToState(
    AuthenticationEvent event,
  ) async* {
    if (event is AppStarted) {
      final bool hasToken = await userRepository.hasToken();

      if (hasToken) {
        yield AuthenticationAuthenticated();
      } else {
        yield AuthenticationUnauthenticated();
      }
    }

    if (event is LoggedIn) {
      yield AuthenticationLoading();

      try {
        await userRepository.persistToken(user: event.user);
      } catch (e) {
        print(e.toString());
      }
      yield AuthenticationAuthenticated();
    }

    if (event is LoggedOut) {
      yield AuthenticationLoading();

      await userRepository.deleteToken(id: 0);

      yield AuthenticationUnauthenticated();
    }
  }
}
