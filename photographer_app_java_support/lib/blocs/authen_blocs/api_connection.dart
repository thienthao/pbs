import 'dart:convert';

import 'package:photographer_app_java_support/blocs/authen_blocs/user_login_model.dart';
import 'package:http/http.dart' as http;
import 'package:photographer_app_java_support/blocs/register_blocs/user_register_model.dart';

final _base = "https://pbs-webapi.herokuapp.com";
final _login = "/api/auth/signin";
final _loginUrl = _base + _login;
final _signup = "/api/auth/signup";
final _signupUrl = _base + _signup;

Future<Token> getToken(UserLogin userLogin) async {
  print(_loginUrl);
  final http.Response response = await http.post(
    _loginUrl,
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(userLogin.toDatabaseJson()),
  );
  if (response.statusCode == 200) {
    return Token.fromJson(json.decode(response.body));
  } else {
    print(json.decode(response.body).toString());
    final data = jsonDecode(utf8.decode(response.bodyBytes)) as Map;
    throw Exception(data['message']);
  }
}

Future<bool> register(UserRegister userRegister) async {
  print(_signupUrl);
  final http.Response response = await http.post(
    _signupUrl,
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
