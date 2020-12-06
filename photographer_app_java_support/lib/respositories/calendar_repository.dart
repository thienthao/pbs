import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:photographer_app_java_support/models/busy_day_bloc_model.dart';
import 'package:photographer_app_java_support/models/calendar_model.dart';
import 'package:photographer_app_java_support/models/working_date_bloc_model.dart';

const baseUrl = 'https://pbs-webapi.herokuapp.com/api/';

class CalendarRepository {
  final http.Client httpClient;

  CalendarRepository({
    @required this.httpClient,
  }) : assert(httpClient != null);

  Future<CalendarModel> getBusyDaysOfPhotographer(int id) async {
    final response = await this
        .httpClient
        .get(baseUrl + 'photographers/$id/calendar/', headers: {
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

  Future<List<WorkingDayBlocModel>> getPhotographerWorkingDay(int id) async {
    final response = await this
        .httpClient
        .get(baseUrl + 'photographers/$id/working-days/', headers: {
      HttpHeaders.authorizationHeader: 'Bearer ' +
          'eyJhbGciOiJIUzUxMiJ9.eyJzdWIiOiJ0aG9jaHVwaGluaCIsImlhdCI6MTYwMjMwMzQ5NCwiZXhwIjoxNjE3ODU1NDk0fQ.25Oz4rCRj4pdX6GdpeWdwt1YT7fcY6YTKK8SywVyWheVPGpwB6641yHNz7U2JwlgNUtI3FE89Jf8qwWUXjfxRg'
    });
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

  Future<bool> updateWorkingDay(
      int ptgId, List<WorkingDayBlocModel> listWorkingDays) async {
    var resBody = [];

    var photographerResbody = {};

    for (var day in listWorkingDays) {
      var workingDay = {};
      workingDay["day"] = day.day;
      workingDay["startTime"] = day.startTime;
      workingDay["endTime"] = day.endTime;
      workingDay["workingDay"] = day.workingDay;
      photographerResbody["id"] = ptgId;
      workingDay["photographer"] = photographerResbody;
      resBody.add(workingDay);
    }

    String str = json.encode(resBody);

    final response =
        await httpClient.post(baseUrl + 'photographers/$ptgId/working-days',
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

  Future<List<BusyDayBlocModel>> getPhotographerBusyDaysSpecific(int id) async {
    final response = await this
        .httpClient
        .get(baseUrl + 'photographers/$id/busydays/', headers: {
      HttpHeaders.authorizationHeader: 'Bearer ' +
          'eyJhbGciOiJIUzUxMiJ9.eyJzdWIiOiJ0aG9jaHVwaGluaCIsImlhdCI6MTYwMjMwMzQ5NCwiZXhwIjoxNjE3ODU1NDk0fQ.25Oz4rCRj4pdX6GdpeWdwt1YT7fcY6YTKK8SywVyWheVPGpwB6641yHNz7U2JwlgNUtI3FE89Jf8qwWUXjfxRg'
    });
    if (response.statusCode == 200) {
      final data = jsonDecode(utf8.decode(response.bodyBytes)) as List;

      final listBusyDays = data.map((day) {
        return BusyDayBlocModel(
          id: day['id'],
          startDate: day['startDate'],
          endDate: day['endDate'],
          title: day['title'],
          description: day['description'],
        );
      }).toList();

      return listBusyDays;
    } else {
      throw Exception('Error getting Photographer Calendar');
    }
  }

  Future<bool> addBusyDay(int ptgId, BusyDayBlocModel busyDayBlocModel) async {
    var resBody = {};
    var photographerResbody = {};

    resBody["startDate"] = busyDayBlocModel.startDate;
    resBody["endDate"] = busyDayBlocModel.endDate;
    resBody["title"] = busyDayBlocModel.title;
    resBody["description"] = busyDayBlocModel.description;
    photographerResbody["id"] = ptgId;
    resBody["photographer"] = photographerResbody;

    String str = json.encode(resBody);
    print(str);
    final response =
        await httpClient.post(baseUrl + 'photographers/$ptgId/busydays',
            headers: {
              'Content-Type': 'application/json; charset=UTF-8',
            },
            body: str);

    bool result = false;
    if (response.statusCode == 200) {
      result = true;
    } else {
      throw Exception('Error at Add Photographer info');
    }

    return result;
  }

  Future<bool> updateBusyDay(
      int ptgId, BusyDayBlocModel busyDayBlocModel) async {
    var resBody = {};
    var photographerResbody = {};

    resBody["id"] = busyDayBlocModel.id;
    resBody["startDate"] = busyDayBlocModel.startDate;
    resBody["endDate"] = busyDayBlocModel.endDate;
    resBody["title"] = busyDayBlocModel.title;
    resBody["description"] = busyDayBlocModel.description;
    photographerResbody["id"] = ptgId;
    resBody["photographer"] = photographerResbody;

    String str = json.encode(resBody);
    print(str);
    final response =
        await httpClient.post(baseUrl + 'photographers/$ptgId/busydays',
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

  Future<bool> deleteBusyDay(int ptgId, int busyDayId) async {
    final response = await httpClient.delete(
      baseUrl + 'photographers/$ptgId/busydays/$busyDayId',
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );

    print(baseUrl + 'photographers/$ptgId/busydays/$busyDayId');

    bool result = false;
    if (response.statusCode == 200) {
      result = true;
    } else {
      throw Exception('Error at Delete Photographer info');
    }

    return result;
  }
}
