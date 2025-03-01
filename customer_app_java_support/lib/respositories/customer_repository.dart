import 'dart:convert';
import 'dart:io';

import 'package:customer_app_java_support/globals.dart';
import 'package:customer_app_java_support/models/customer_bloc_model.dart';
import 'package:customer_app_java_support/shared/base_api.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';

const baseUrl = 'https://pbs-webapi.herokuapp.com/api/';

class CustomerRepository {
  final http.Client httpClient;

  CustomerRepository({
    @required this.httpClient,
  }) : assert(httpClient != null);

  Future<CustomerBlocModel> getProfileById(int id) async {
    // final albumsTemp = getAlbumOfPhotographer(id) as List;
    final response = await this.httpClient.get(BaseApi.USER_URL + '/$id',
        headers: {HttpHeaders.authorizationHeader: 'Bearer $globalCusToken'});
    if (response.statusCode == 200) {
      final data = jsonDecode(utf8.decode(response.bodyBytes));
      final customer = CustomerBlocModel(
        id: data['id'],
        avatar: data['avatar'],
        email: data['email'],
        phone: data['phone'],
        username: data['username'],
        description: data['description'],
        fullname: data['fullname'],
      );
      return customer;
    } else if (response.statusCode == 401) {
      throw Exception('Unauthorized');
    } else {
      throw Exception('Error getting photographer');
    }
  }

  Future<bool> updateProfile(CustomerBlocModel customer) async {
    var resBody = {};

    resBody["id"] = customer.id;
    resBody["fullname"] = customer.fullname;
    resBody["email"] = customer.email;
    resBody["phone"] = customer.phone;
    String str = json.encode(resBody);
    print(str);
    final response = await httpClient.put(BaseApi.USER_URL,
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          HttpHeaders.authorizationHeader: 'Bearer ' + globalCusToken
        },
        body: str);

    bool result = false;
    if (response.statusCode == 200) {
      result = true;
    } else if (response.statusCode == 401) {
      throw Exception('Unauthorized');
    } else {
      throw Exception('Error at Update Photographer info');
    }

    return result;
  }

  Future<bool> updateAvatar(int cusId, File avatar) async {
    var request = http.MultipartRequest(
        "POST", Uri.parse(BaseApi.PHOTOGRAPHER_URL + '/$cusId/upload'));
    request.headers
        .addAll({HttpHeaders.authorizationHeader: 'Bearer ' + globalCusToken});
    request.files.add(http.MultipartFile(
        'file',
        File(avatar.path).readAsBytes().asStream(),
        File(avatar.path).lengthSync(),
        filename: avatar.path.split("/").last,
        contentType: new MediaType('image', 'jpeg')));

    final response = await request.send();

    bool result = false;
    if (response.statusCode == 200) {
      print("Avatar Uploaded!");
      result = true;
    } else if (response.statusCode == 401) {
      throw Exception('Unauthorized');
    } else {
      throw Exception('Error at update avatar!');
    }
    return result;
  }

  Future<bool> changePassword(
      String username, String oldPassword, String newPassword) async {
    var resBody = {};

    resBody["username"] = username;
    resBody["oldPassword"] = oldPassword;
    resBody["newPassword"] = newPassword;
    String str = json.encode(resBody);
    print(str);
    final response = await httpClient.put(BaseApi.AUTH_URL + '/changePassword',
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          HttpHeaders.authorizationHeader: 'Bearer ' + globalCusToken
        },
        body: str);

    bool result = false;
    if (response.statusCode == 200) {
      result = true;
    } else if (response.statusCode == 401) {
      throw Exception('Unauthorized');
    } else {
      final data = jsonDecode(utf8.decode(response.bodyBytes)) as Map;
      var message = {
        "newPassword": "",
        "oldPassword": "",
        "message": "",
      };
      message['newPassword'] = data['newPassword'] ?? '';
      message['oldPassword'] = data['oldPassword'] ?? '';
      message['message'] = data['message'] ?? '';
      throw Exception(message);
    }

    return result;
  }

  Future<bool> recoverPassword(String email) async {
    var resBody = {};

    resBody["email"] = email;

    String str = json.encode(resBody);
    print(str);
    final response =
        await httpClient.post(BaseApi.AUTH_URL + '/password/request',
            headers: {
              'Content-Type': 'application/json; charset=UTF-8',
              HttpHeaders.authorizationHeader: 'Bearer ' + globalCusToken
            },
            body: str);

    bool result = false;
    if (response.statusCode == 200) {
      result = true;
    } else if (response.statusCode == 401) {
      throw Exception('Unauthorized');
    } else {
      final data = jsonDecode(utf8.decode(response.bodyBytes)) as Map;
      throw Exception(data['message']);
    }

    return result;
  }
}
