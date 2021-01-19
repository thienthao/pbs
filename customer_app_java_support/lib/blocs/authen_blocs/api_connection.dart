import 'dart:convert';

import 'package:customer_app_java_support/blocs/authen_blocs/user_login_model.dart';
import 'package:customer_app_java_support/blocs/register_blocs/user_register_model.dart';
import 'package:customer_app_java_support/globals.dart';
import 'package:customer_app_java_support/shared/base_api.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

// final _base = "https://pbs-webapi.herokuapp.com";
// final _login = "/api/auth/signin";
// final _loginUrl = _base + _login;
// final _signup = "/api/auth/signup";
// final _signupUrl = _base + _signup;
SharedPreferences prefs;
Future<Token> getToken(UserLogin userLogin) async {
  prefs = await SharedPreferences.getInstance();
  final http.Response response = await http.post(
    BaseApi.LOGIN_URL,
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(userLogin.toDatabaseJson()),
  );
  if (response.statusCode == 200) {
    final data = json.decode(response.body);

    if (data['role'].toString().toUpperCase() == 'ROLE_CUSTOMER') {
      prefs.setInt('customerId', data['id']);
      globalCusId = data['id'];
      prefs.setString('customerToken', data['accessToken']);
      globalCusToken = data['accessToken'];
      return Token.fromJson(json.decode(response.body));
    } else {
      throw Exception('Tài khoản này không hợp lệ');
    }
  } else if (response.statusCode == 401) {
    throw Exception('Tài khoản của bạn đã bị khóa');
  } else {
    print(json.decode(response.body).toString());
    final data = jsonDecode(utf8.decode(response.bodyBytes)) as Map;
    throw Exception(data['message']);
  }
}

Future<bool> register(UserRegister userRegister) async {
  final http.Response response = await http.post(
    BaseApi.SIGNUP_URL,
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(userRegister.toDatabaseJson()),
  );
  if (response.statusCode == 200) {
    return true;
  } else {
    print(json.decode(response.body).toString());
    final data = jsonDecode(utf8.decode(response.bodyBytes)) as Map;
    
    throw Exception(data['message']);
  }
}
