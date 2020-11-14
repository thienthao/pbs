import 'dart:convert';
import 'package:photographer_app_java_support/models/package_bloc_model.dart';
import 'package:photographer_app_java_support/models/service_bloc_model.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

const baseUrl = 'https://pbs-webapi.herokuapp.com/api/';

class PackageRepository {
  final http.Client httpClient;

  PackageRepository({
    @required this.httpClient,
  }) : assert(httpClient != null);

  Future<List<PackageBlocModel>> getPackagesByPhotographerId(int id) async {
    print('packages of photographer');
    final response = await this.httpClient.get(
          baseUrl +
              'packages/photographer/' +
              id.toString() +
              '/split?page=0&size=10',
        );
    final temp = baseUrl +
        'packages/photographer/' +
        id.toString() +
        '/split?page=0&size=10';
    print('url $temp');

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
          serviceDtos: services,
        );
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

    resBody["name"] = package.name;
    resBody["price"] = package.price;
    resBody["description"] = package.description;
    resBody["supportMultiDays"] = package.supportMultiDays;

    ptgResBody["id"] = 168;
    resBody["photographer"] = ptgResBody;

    for (var service in package.serviceDtos) {
      serviceResBody = {};
      serviceResBody["name"] = service.name;
      serviceResBody["serviceDescription"] = service.description;
      servicesResBody.add(serviceResBody);
    }

    resBody["services"] = servicesResBody;

    String str = json.encode(resBody);
    print(str);

    final response = await httpClient.post(baseUrl + 'packages',
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
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

    resBody["id"] = package.id;
    resBody["name"] = package.name;
    resBody["price"] = package.price;
    resBody["description"] = package.description;

    ptgResBody["id"] = 168;
    resBody["photographer"] = ptgResBody;

    for (var service in package.serviceDtos) {
      serviceResBody = {};
      serviceResBody["id"] = service.id;
      serviceResBody["name"] = service.name;
      servicesResBody.add(serviceResBody);
    }

    // servicesResBody = package.serviceDtos.map((service) {
    //   serviceResBody = {};
    //   serviceResBody["id"] = service.id;
    //   serviceResBody["name"] = service.name;
    //   return serviceResBody;
    // }).toList();

    resBody["services"] = servicesResBody;

    String str = json.encode(resBody);
    print(str);

    final response = await httpClient.post(baseUrl + 'packages',
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
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

    ptgResBody["id"] = 168;
    resBody["photographer"] = ptgResBody;

    String str = json.encode(resBody);
    print(str);

    final response = await httpClient.delete(
      baseUrl + 'packages/168/${package.id}',
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );

    bool result = false;
    if (response.statusCode == 200) {
      print('create package success: $result');
      result = true;
    } else {
      throw Exception('Error Delete a Package');
    }

    return result;
  }
}
