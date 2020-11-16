import 'dart:convert';
import 'dart:io';

import 'package:customer_app_java_support/models/calendar_model.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

const baseUrl = 'https://pbs-webapi.herokuapp.com/api/';

class CalendarRepository {
  final http.Client httpClient;

  CalendarRepository({
    @required this.httpClient,
  }) : assert(httpClient != null);

  Future<CalendarModel> getBusyDaysOfPhotographer(int id) async {
    final response = await this
        .httpClient
        .get(baseUrl + 'photographers/$id/calendar/for-customer', headers: {
      HttpHeaders.authorizationHeader: 'Bearer ' +
          'eyJhbGciOiJIUzUxMiJ9.eyJzdWIiOiJ0aG9jaHVwaGluaCIsImlhdCI6MTYwMjMwMzQ5NCwiZXhwIjoxNjE3ODU1NDk0fQ.25Oz4rCRj4pdX6GdpeWdwt1YT7fcY6YTKK8SywVyWheVPGpwB6641yHNz7U2JwlgNUtI3FE89Jf8qwWUXjfxRg'
    });
    if (response.statusCode == 200) {
      final data = jsonDecode(utf8.decode(response.bodyBytes)) as Map;
      final listBusyDays = data['busyDays'] as List;
      final listBookedDays = data['bookingDates'] as List;

      List<String> busyDaysTemp = listBusyDays.map((e) {
        return e.toString();
      }).toList();

      List<String> bookedDaysTemp = listBookedDays.map((e) {
        return e.toString();
      }).toList();

      CalendarModel photographerCalendar =
          CalendarModel(busyDays: busyDaysTemp, bookedDays: bookedDaysTemp);
      return photographerCalendar;
    } else {
      throw Exception('Error getting Photographer Calendar');
    }
  }
}
