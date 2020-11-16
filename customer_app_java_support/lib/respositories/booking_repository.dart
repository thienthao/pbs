import 'dart:convert';
import 'dart:io';

import 'package:customer_app_java_support/models/booking_bloc_model.dart';
import 'package:customer_app_java_support/models/package_bloc_model.dart';
import 'package:customer_app_java_support/models/photographer_bloc_model.dart';
import 'package:customer_app_java_support/models/time_and_location_bloc_model.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

const baseUrl = 'https://pbs-webapi.herokuapp.com/api/';

class BookingRepository {
  final http.Client httpClient;

  BookingRepository({
    @required this.httpClient,
  }) : assert(httpClient != null);

  Future<List<BookingBlocModel>> getListBookingByCustomerId() async {
    final response =
        await this.httpClient.get(baseUrl + 'bookings/customer/2/id', headers: {
      HttpHeaders.authorizationHeader: 'Bearer ' +
          'eyJhbGciOiJIUzUxMiJ9.eyJzdWIiOiJ0aG9jaHVwaGluaCIsImlhdCI6MTYwMjMwMzQ5NCwiZXhwIjoxNjE3ODU1NDk0fQ.25Oz4rCRj4pdX6GdpeWdwt1YT7fcY6YTKK8SywVyWheVPGpwB6641yHNz7U2JwlgNUtI3FE89Jf8qwWUXjfxRg'
    });
    if (response.statusCode == 200) {
      final data = jsonDecode(utf8.decode(response.bodyBytes)) as Map;
      final list = data['bookings'] as List;

      final List<BookingBlocModel> bookings = list.map((booking) {
        final tempPhotographer = booking['photographer'] as Map;
        final tempTimeAndLocations = booking['timeLocationDetails'] as List;
        bool isMultiDay = false;
        if (tempTimeAndLocations.length > 1) {
          isMultiDay = true;
        }
        Photographer photographer = Photographer(
            id: tempPhotographer['id'],
            fullname: tempPhotographer['fullname'],
            ratingCount: tempPhotographer['ratingCount'],
            avatar: tempPhotographer['avatar']);

        final List<TimeAndLocationBlocModel> listTimeAndLocations =
            tempTimeAndLocations.map((item) {
          return TimeAndLocationBlocModel(
              id: item['id'],
              start: item['start'],
              end: item['end'],
              formattedAddress: item['formattedAddress'],
              latitude: item['lat'],
              longitude: item['lon']);
        }).toList();

        return BookingBlocModel(
          id: booking['id'],
          status: booking['bookingStatus'],
          startDate: booking['startDate'] == null
              ? DateTime.now().toString()
              : booking['startDate'],
          endDate: booking['endDate'] ?? DateTime.now().toString(),
          serviceName: booking['serviceName'] ?? 'Không có dịch vụ nào',
          price: booking['price'] ?? 0,
          createdAt: booking['createdAt'] ?? '',
          updatedAt: booking['updatedAt'] ?? '',
          customerCanceledReason: booking['customerCanceledReason'] ?? '',
          photographerCanceledReason: booking['photographerCanceledReason'],
          rejectedReason: booking['rejectedReason'],
          rating: booking['rating'] ?? 0.0,
          comment: booking['comment'],
          address: booking['location'] ?? '',
          isMultiday: isMultiDay,
          commentDate: booking['commentDate'],
          listTimeAndLocations: listTimeAndLocations,
          photographer: photographer,
        );
      }).toList();
      return bookings;
    } else {
      throw Exception();
    }
  }

  Future<BookingBlocModel> getBookingDetailById(int id) async {
    final response = await this
        .httpClient
        .get(baseUrl + 'bookings/' + id.toString(), headers: {
      HttpHeaders.authorizationHeader: 'Bearer ' +
          'eyJhbGciOiJIUzUxMiJ9.eyJzdWIiOiJ0aG9jaHVwaGluaCIsImlhdCI6MTYwMjMwMzQ5NCwiZXhwIjoxNjE3ODU1NDk0fQ.25Oz4rCRj4pdX6GdpeWdwt1YT7fcY6YTKK8SywVyWheVPGpwB6641yHNz7U2JwlgNUtI3FE89Jf8qwWUXjfxRg'
    });
    if (response.statusCode == 200) {
      final data = jsonDecode(utf8.decode(response.bodyBytes));

      final tempPhotographer = data['photographer'] as Map;
      Photographer photographer = Photographer(
          id: tempPhotographer['id'],
          fullname: tempPhotographer['fullname'],
          ratingCount: tempPhotographer['ratingCount'],
          avatar: tempPhotographer['avatar']);

      final tempPackage = data['servicePackage'] as Map;
      PackageBlocModel package = PackageBlocModel(
        id: tempPackage['id'],
        name: tempPackage['name'],
      );

      final tempServices = data['servicePackage']['services'] as List;

      final List<String> services = new List();
      for (final service in tempServices) {
        services.add(service['name']);
      }

      final tempTimeAndLocations = data['timeLocationDetails'] as List;

      final List<TimeAndLocationBlocModel> listTimeAndLocations =
          tempTimeAndLocations.map((item) {
        return TimeAndLocationBlocModel(
            id: item['id'],
            start: item['start'],
            end: item['end'],
            formattedAddress: item['formattedAddress'],
            latitude: item['lat'],
            longitude: item['lon']);
      }).toList();

      final booking = BookingBlocModel(
        id: data['id'],
        status: data['bookingStatus'],
        startDate: data['startDate'] ?? DateTime.now().toString(),
        endDate: data['endDate'] ?? DateTime.now().toString(),
        serviceName: data['serviceName'] ?? 'Không có dịch vụ nào',
        price: data['price'] ?? 0,
        createdAt: data['createdAt'] ?? DateTime.now().toString(),
        updatedAt: data['updatedAt'] ?? DateTime.now().toString(),
        customerCanceledReason: data['customerCanceledReason'] ?? '',
        photographerCanceledReason: data['photographerCanceledReason'] ?? '',
        rejectedReason: data['rejectedReason'] ?? '',
        rating: data['rating'] ?? 0.0,
        comment: data['comment'] ?? '',
        address: data['location'] ?? '',
        commentDate: data['commentDate'],
        photographer: photographer,
        services: services ?? [],
        isMultiday: data['servicePackage']['supportMultiDays'],
        editDeadLine: data['editDeadline'],
        returningType: data['returningType']['id'],
        listTimeAndLocations: listTimeAndLocations,
        packageDescription: data['servicePackage']['description'] ?? '',
        package: package ?? [],
      );

      return booking;
    } else {
      throw Exception('Error getting list of bookings');
    }
  }

  Future<bool> createBooking(BookingBlocModel booking) async {
    print(booking.listTimeAndLocations[0].formattedAddress);
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
    final response = await httpClient.post(baseUrl + 'bookings',
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: str);

    bool result = false;
    if (response.statusCode == 200) {
      result = true;
    } else {
      throw Exception('Error Create a Booking');
    }

    return result;
  }

  Future<bool> cancelBooking(BookingBlocModel booking) async {
    var resBody = {};
    var ptgResBody = {};
    var cusResBody = {};
    var packageResBody = {};

    resBody["id"] = booking.id;

    resBody["customerCanceledReason"] = booking.customerCanceledReason;

    ptgResBody["id"] = booking.photographer.id;
    resBody["photographer"] = ptgResBody;

    packageResBody["id"] = booking.package.id;
    resBody["servicePackage"] = packageResBody;

    cusResBody["id"] = "2";
    resBody["customer"] = cusResBody;

    String str = json.encode(resBody);

    final response = await httpClient.put(baseUrl + 'bookings/cancel',
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: str);

    bool result = false;
    if (response.statusCode == 200) {
      result = true;
    } else {
      throw Exception('Error at cancel a booking');
    }

    return result;
  }

  Future<List<BookingBlocModel>> getBookingsByDate(int id, String date) async {
    final response = await this
        .httpClient
        .get(baseUrl + 'photographers/$id/on-day?date=$date', headers: {
      HttpHeaders.authorizationHeader: 'Bearer ' +
          'eyJhbGciOiJIUzUxMiJ9.eyJzdWIiOiJ0aG9jaHVwaGluaCIsImlhdCI6MTYwMjMwMzQ5NCwiZXhwIjoxNjE3ODU1NDk0fQ.25Oz4rCRj4pdX6GdpeWdwt1YT7fcY6YTKK8SywVyWheVPGpwB6641yHNz7U2JwlgNUtI3FE89Jf8qwWUXjfxRg'
    });
    print(baseUrl + 'photographers/$id/on-day?date=$date');
    if (response.statusCode == 200) {
      final data = jsonDecode(utf8.decode(response.bodyBytes)) as Map;
      final bookingInfos = data['bookingInfos'] as List;
      print(bookingInfos.length);
      List<BookingBlocModel> listBookings = bookingInfos.map((booking) {
        return BookingBlocModel(
            id: booking['id'],
            latitude: booking['lat'],
            startDate: booking['start'],
            endDate: booking['end']);
      }).toList();

      return listBookings;
    } else {
      throw Exception('Error getting Photographer Calendar');
    }
  }
}
