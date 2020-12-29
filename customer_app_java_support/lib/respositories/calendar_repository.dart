import 'dart:convert';
import 'dart:io';

import 'package:customer_app_java_support/globals.dart';
import 'package:customer_app_java_support/models/calendar_model.dart';
import 'package:customer_app_java_support/models/working_date_bloc_model.dart';
import 'package:customer_app_java_support/shared/base_api.dart';
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
        .get(BaseApi.PHOTOGRAPHER_URL + '/$id/calendar/for-customer', headers: {
      HttpHeaders.authorizationHeader: 'Bearer ' +
          globalCusToken
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

  Future<List<WorkingDayBlocModel>> getPhotographerWorkingDay(int id) async {
    final response = await this.httpClient.get(
        BaseApi.PHOTOGRAPHER_URL + '/$id/working-days/',
        headers: {HttpHeaders.authorizationHeader: 'Bearer ' + globalCusToken});
    if (response.statusCode == 200) {
      final data = jsonDecode(utf8.decode(response.bodyBytes)) as List;

      final listWorkingDays = data.map((day) {
        return WorkingDayBlocModel(
          id: day['id'],
          day: day['day'],
          endTime: day['endTime'],
          startTime: day['startTime'],
          workingDay: day['workingDay'],
        );
      }).toList();

      return listWorkingDays;
    } else {
      throw Exception('Error getting Photographer Calendar');
    }
  }
}
