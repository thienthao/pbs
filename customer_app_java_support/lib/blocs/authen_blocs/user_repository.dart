import 'package:customer_app_java_support/blocs/authen_blocs/user_dao.dart';
import 'package:customer_app_java_support/blocs/authen_blocs/user_login_model.dart';
import 'package:customer_app_java_support/blocs/authen_blocs/user_model.dart';
import 'package:customer_app_java_support/blocs/authen_blocs/api_connection.dart'
    as api;
import 'package:customer_app_java_support/blocs/register_blocs/user_register_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserRepository {
  final userDao = UserDao();
  SharedPreferences prefs;
  Future<User> authenticate({
    @required String username,
    @required String password,
  }) async {
    prefs = await SharedPreferences.getInstance();
    UserLogin userLogin = UserLogin(username: username, password: password);
    Token token = await api.getToken(userLogin);
    prefs.setString('customerToken', token.token);
    User user = User(
      id: 0,
      username: username,
      accessToken: token.token,
    );
    return user;
  }

  Future<bool> register({@required UserRegister userRegister}) async {
    return Future.value(await api.register(userRegister));
  }

  Future<void> persistToken({@required User user}) async {
    // write token with the user to the database
    await userDao.createUser(user);
  }

  Future<void> deleteToken({@required int id}) async {
    await userDao.deleteUser(id);
  }

  Future<bool> hasToken() async {
    bool result = await userDao.checkUser(0);
    return result;
  }
}
