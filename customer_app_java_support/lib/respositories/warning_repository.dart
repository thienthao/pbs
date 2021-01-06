import 'dart:convert';
import 'dart:io';

import 'package:customer_app_java_support/globals.dart';
import 'package:customer_app_java_support/models/booking_bloc_model.dart';
import 'package:customer_app_java_support/models/weather_bloc_model.dart';
import 'package:customer_app_java_support/shared/base_api.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;

const baseUrl = 'https://pbs-webapi.herokuapp.com/api/';

class WarningRepository {
  final http.Client httpClient;

  WarningRepository({
    @required this.httpClient,
  }) : assert(httpClient != null);

  Future<bool> checkValidWorkingTimeOfPhotographer(
      String time, int ptgId) async {
    final response = await this.httpClient.get(
        BaseApi.PHOTOGRAPHER_URL + '/$ptgId/working-days/check?time=$time',
        headers: {HttpHeaders.authorizationHeader: 'Bearer ' + globalCusToken});

    if (response.statusCode == 200) {
      final data = jsonDecode(utf8.decode(response.bodyBytes));
      return data;
    } else if (response.statusCode == 401) {
      throw Exception('Unauthorized');
    } else {
      throw Exception('Error getting Time Warning');
    }
  }

  Future<List<String>> getTimeWarning(String dateTime, int ptgId) async {
    final response = await this.httpClient.get(
        BaseApi.BOOKING_URL + '/time-warning/?datetime=$dateTime&ptgId=$ptgId',
        headers: {HttpHeaders.authorizationHeader: 'Bearer ' + globalCusToken});

    print(response.request.url);
    if (response.statusCode == 200) {
      final data = jsonDecode(utf8.decode(response.bodyBytes)) as List;

      List<String> noticeString = data.map((e) {
        return e.toString();
      }).toList();
      return noticeString;
    } else if (response.statusCode == 401) {
      throw Exception('Unauthorized');
    } else {
      throw Exception('Error getting Time Warning');
    }
  }

  Future<List<String>> getLocationWarning(BookingBlocModel booking) async {
    var resBody = {};
    var ptgResBody = {};
    var cusResBody = {};
    var packageResBody = {};
    var bookingDetailResBody = [];
    var serviceResBody = {};
    var returningTypeResBody = {};
    var timeLocationDetailsResbody = [];
    var timeLocationDetailObject = {};

    resBody["serviceName"] = booking.serviceName;

    resBody["price"] = booking.price;

    resBody["editDeadline"] = booking.editDeadLine;

    cusResBody["id"] = "2";
    resBody["customer"] = cusResBody;

    ptgResBody["id"] = booking.photographer.id;
    resBody["photographer"] = ptgResBody;

    packageResBody["id"] = booking.package.id;
    resBody["servicePackage"] = packageResBody;

    returningTypeResBody["id"] = booking.returningType;
    resBody["returningType"] = returningTypeResBody;

    for (var service in booking.package.serviceDtos) {
      serviceResBody["serviceName"] = service.name;
      bookingDetailResBody.add(serviceResBody);
    }
    resBody["bookingDetails"] = bookingDetailResBody;

    for (var item in booking.listTimeAndLocations) {
      timeLocationDetailObject["lat"] = item.latitude;
      timeLocationDetailObject["lon"] = item.longitude;
      timeLocationDetailObject["formattedAddress"] = item.formattedAddress;
      timeLocationDetailObject["start"] = item.start;
      timeLocationDetailObject["end"] = item.end;
      timeLocationDetailsResbody.add(timeLocationDetailObject);
    }
    resBody["timeLocationDetails"] = timeLocationDetailsResbody;
    String str = json.encode(resBody);

    final response =
        await httpClient.post(BaseApi.BOOKING_URL + '/distance-warning/',
            headers: {
              'Content-Type': 'application/json; charset=UTF-8',
              HttpHeaders.authorizationHeader: 'Bearer ' + globalCusToken
            },
            body: str);

    if (response.statusCode == 200) {
      final data = jsonDecode(utf8.decode(response.bodyBytes)) as List;
      final notices = data.map((notice) {
        return notice.toString();
      }).toList();
      return notices;
    } else if (response.statusCode == 401) {
      throw Exception('Unauthorized');
    } else {
      throw Exception('Error Create a Booking');
    }
  }

  Future<WeatherBlocModel> getWeatherWarning(
      String dateTime, LatLng latLng) async {
    final response = await this.httpClient.get(
        BaseApi.BOOKING_URL +
            '/weather-warning?datetime=$dateTime&lat=${latLng.latitude}&lon=${latLng.longitude}',
        headers: {HttpHeaders.authorizationHeader: 'Bearer ' + globalCusToken});

    if (response.statusCode == 200) {
      final data = jsonDecode(utf8.decode(response.bodyBytes));
      print(data['noti']);
      WeatherBlocModel weatherNotice = WeatherBlocModel(
          noti: data['noti'],
          humidity: data['humidity'],
          outlook: data['outlook'],
          temperature: data['temperature'],
          windSpeed: data['windSpeed']);
      print(weatherNotice.noti);
      return weatherNotice;
    } else if (response.statusCode == 401) {
      throw Exception('Unauthorized');
    } else {
      throw Exception();
    }
  }

  // Future<List<String>> getWeatherWarning(String dateTime, LatLng latLng) async {
  //   final response = await this.httpClient.get(
  //       BaseApi.BOOKING_URL +
  //           '/weather-warning?datetime=$dateTime&lat=${latLng.latitude}&lon=${latLng.longitude}',
  //       headers: {
  //         HttpHeaders.authorizationHeader : 'Bearer ' + globalCusToken});

  //   if (response.statusCode == 200) {
  //     final data = jsonDecode(utf8.decode(response.bodyBytes)) as List;
  //     final notices = data.map((notice) {
  //       return notice.toString();
  //     }).toList();
  //     return notices;
  //   } else {
  //     throw Exception();
  //   }
  // }
}
