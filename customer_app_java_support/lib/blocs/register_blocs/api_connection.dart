import 'dart:convert';

import 'package:customer_app_java_support/blocs/register_blocs/user_register_model.dart';
import 'package:http/http.dart' as http;

final _base = "https://pbs-webapi.herokuapp.com";
final _register = "/api/auth/signup";
final _registerUrl = _base + _register;

Future<bool> registerApi(UserRegister userRegister) async {
  print(_registerUrl);
  final http.Response response = await http.post(
    _registerUrl,
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(userRegister.toDatabaseJson()),
  );
  if (response.statusCode == 200) {
    // success message
    // return Token.fromJson(json.decode(response.body));
    return true;
  } else {
    print(json.decode(response.body).toString());
    final data = jsonDecode(utf8.decode(response.bodyBytes)) as Map;
    throw Exception(data['message']);
  }
}