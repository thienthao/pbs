

import 'dart:convert';

import 'package:customer_app_java_support/blocs/authen_blocs/user_login_model.dart';
import 'package:http/http.dart' as http;

final _base = "https://pbs-webapi.herokuapp.com";
final _login = "/api/auth/signin";
final _loginUrl = _base + _login;

Future<Token> getToken(UserLogin userLogin) async {
  print(_loginUrl);
  final http.Response response = await http.post(
    _loginUrl,
    headers: <String, String> {
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(userLogin.toDatabaseJson()),
  );
  if(response.statusCode == 200) {
    return Token.fromJson(json.decode(response.body));
  } else {
    print(json.decode(response.body).toString());
    throw Exception(json.decode(response.body));
  }
}