import 'dart:convert';
import 'dart:io';
import 'package:photographer_app_java_support/globals.dart';
import 'package:photographer_app_java_support/models/package_bloc_model.dart';
import 'package:photographer_app_java_support/models/service_bloc_model.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:photographer_app_java_support/widgets/shared/base_api.dart';

const baseUrl = 'https://pbs-webapi.herokuapp.com/api/';

class PackageRepository {
  final http.Client httpClient;

  PackageRepository({
    @required this.httpClient,
  }) : assert(httpClient != null);

  Future<List<PackageBlocModel>> getPackagesByPhotographerId(int id) async {
    print('packages of photographer');
    final response = await this.httpClient.get(
          BaseApi.PACKAGE_URL +
              '/photographer/$globalPtgId/split?page=0&size=10' ,
              headers: {
                HttpHeaders.authorizationHeader: 'Bearer ' + globalPtgToken
              }
        );
  
    if (response.statusCode == 200) {
      final data = jsonDecode(utf8.decode(response.bodyBytes)) as Map;
      final list = data['package'] as List;

      final List<PackageBlocModel> packages = list.map((package) {
        final listServices = package['serviceDtos'] as List;

        final services = listServices.map((service) {
          return ServiceBlocModel(id: service['id'], name: service['name']);
        }).toList();

        return PackageBlocModel(
            id: package['id'],
            name: package['name'].toString(),
            price: package['price'],
            description: package['description'].toString(),
            timeAnticipate: package['timeAnticipate'],
            serviceDtos: services,
            supportMultiDays: package['supportMultiDays']);
      }).toList();

      return packages;
    } else {
      throw Exception('Error getting list of photographers');
    }
  }

  Future<bool> createPackage(PackageBlocModel package) async {
    var resBody = {};
    var ptgResBody = {};

    var servicesResBody = [];
    var serviceResBody = {};

    var categoryResBody = {};

    resBody["name"] = package.name;
    resBody["price"] = package.price;
    resBody["description"] = package.description;
    resBody["supportMultiDays"] = package.supportMultiDays;
    resBody["timeAnticipate"] = package.timeAnticipate;

    ptgResBody["id"] = globalPtgId;
    resBody["photographer"] = ptgResBody;

    for (var service in package.serviceDtos) {
      serviceResBody = {};
      serviceResBody["name"] = service.name;
      serviceResBody["serviceDescription"] = service.description;
      servicesResBody.add(serviceResBody);
    }

    resBody["services"] = servicesResBody;

    categoryResBody["id"] = package.category.id;
    resBody["category"] = categoryResBody;

    String str = json.encode(resBody);
    print(str);

    final response = await httpClient.post(BaseApi.PACKAGE_URL,
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          HttpHeaders.authorizationHeader: 'Bearer ' + globalPtgToken
        },
        body: str);

    bool result = false;
    if (response.statusCode == 200) {
      print('create package success: $result');
      result = true;
    } else {
      throw Exception('Error Create a Package');
    }

    return result;
  }

  Future<bool> updatePackage(PackageBlocModel package) async {
    var resBody = {};
    var ptgResBody = {};

    var servicesResBody = [];
    var serviceResBody = {};

    var categoryResBody = {};

    categoryResBody["id"] = package.category.id;
    resBody["category"] = categoryResBody;

    resBody["id"] = package.id;
    resBody["name"] = package.name;
    resBody["price"] = package.price;
    resBody["description"] = package.description;
    resBody["supportMultiDays"] = package.supportMultiDays;
    resBody["timeAnticipate"] = package.timeAnticipate;

    ptgResBody["id"] = globalPtgId;
    resBody["photographer"] = ptgResBody;

    for (var service in package.serviceDtos) {
      serviceResBody = {};
      serviceResBody["id"] = service.id;
      serviceResBody["name"] = service.name;
      servicesResBody.add(serviceResBody);
    }

    resBody["services"] = servicesResBody;

    String str = json.encode(resBody);
    print(str);

    final response = await httpClient.post(BaseApi.PACKAGE_URL,
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          HttpHeaders.authorizationHeader: 'Bearer ' + globalPtgToken
        },
        body: str);

    bool result = false;
    if (response.statusCode == 200) {
      print('create package success: $result');
      result = true;
    } else {
      throw Exception('Error Update a Package');
    }

    return result;
  }

  Future<bool> deletePackage(PackageBlocModel package) async {
    var resBody = {};
    var ptgResBody = {};

    resBody["id"] = package.id;

    ptgResBody["id"] = globalPtgId;
    resBody["photographer"] = ptgResBody;

    String str = json.encode(resBody);
    print(str);

    final response = await httpClient.delete(
      BaseApi.PACKAGE_URL + '/$globalPtgId/${package.id}',
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        HttpHeaders.authorizationHeader: 'Bearer ' + globalPtgToken
      },
    );
    bool result = false;
    if (response.statusCode == 200) {
      result = true;
    } else {
      print(json.decode(response.body).toString());
      final data = jsonDecode(utf8.decode(response.bodyBytes)) as Map;
      throw Exception(data['message']);
    }

    return result;
  }
}
