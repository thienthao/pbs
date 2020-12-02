import 'dart:convert';
import 'dart:io';

import 'package:customer_app_java_support/models/customer_bloc_model.dart';
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
    final response = await this.httpClient.get(baseUrl + 'photographers/$id');
    if (response.statusCode == 200) {
      final data = jsonDecode(utf8.decode(response.bodyBytes));

      final customer = CustomerBlocModel(
        id: data['id'],
        avatar: data['avatar'],
        email: data['email'],
        phone: data['phone'],
        description: data['description'],
        fullname: data['fullname'],
      );
      return customer;
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
    final response = await httpClient.put(baseUrl + 'photographers/',
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: str);

    bool result = false;
    if (response.statusCode == 200) {
      result = true;
    } else {
      throw Exception('Error at Update Photographer info');
    }

    return result;
  }

  Future<bool> updateAvatar(int cusId, File avatar) async {
    var request =
        http.MultipartRequest("POST", Uri.parse(baseUrl + 'photographers/$cusId/upload'));

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
    } else {
      throw Exception('Error at update avatar!');
    }
    return result;
  }
}
