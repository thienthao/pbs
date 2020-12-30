import 'dart:convert';
import 'dart:io';

import 'package:customer_app_java_support/globals.dart';
import 'package:customer_app_java_support/models/booking_bloc_model.dart';
import 'package:customer_app_java_support/models/customer_bloc_model.dart';
import 'package:customer_app_java_support/models/package_bloc_model.dart';
import 'package:customer_app_java_support/models/photographer_bloc_model.dart';
import 'package:customer_app_java_support/models/time_and_location_bloc_model.dart';
import 'package:customer_app_java_support/shared/base_api.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

const baseUrl = 'https://pbs-webapi.herokuapp.com/api/';

class BookingRepository {
  final http.Client httpClient;

  BookingRepository({
    @required this.httpClient,
  }) : assert(httpClient != null);

  Future<List<BookingBlocModel>> getListBookingByCustomerId(int cusId) async {
    final response = await this.httpClient.get(
        BaseApi.BOOKING_URL + '/customer/$cusId/id',
        headers: {HttpHeaders.authorizationHeader: 'Bearer ' + globalCusToken});
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

  Future<List<BookingBlocModel>> getListInfiniteBookingByPhotographerId(
      int cusId, int page, int size, String status) async {
    String extendUrl;

    if (status == 'ALL') {
      extendUrl = '/customer/$cusId/id?page=$page&size=$size';
    } else {
      extendUrl =
          '/customer/$cusId/status?status=$status&page=$page&size=$size';
    }
    final response = await this.httpClient.get(BaseApi.BOOKING_URL + extendUrl,
        headers: {HttpHeaders.authorizationHeader: 'Bearer ' + globalCusToken});
    print(baseUrl + extendUrl);
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
          customerCanceledReason: booking['customerCanceledReason'] ?? '',
          photographerCanceledReason: booking['photographerCanceledReason'],
          rejectedReason: booking['rejectedReason'],
          rating: booking['rating'] ?? 0.0,
          address: booking['location'] ?? '',
          isMultiday: isMultiDay,
          photographer: photographer,
          listTimeAndLocations: listTimeAndLocations,
        );
      }).toList();
      return bookings;
    } else {
      throw Exception('Error getting list of bookings');
    }
  }

  Future<BookingBlocModel> getBookingDetailById(int id) async {
    final response = await this.httpClient.get(BaseApi.BOOKING_URL + '/$id',
        headers: {HttpHeaders.authorizationHeader: 'Bearer ' + globalCusToken});
    if (response.statusCode == 200) {
      final data = jsonDecode(utf8.decode(response.bodyBytes));

      final tempPhotographer = data['photographer'] as Map;
      Photographer photographer = Photographer(
          id: tempPhotographer['id'],
          phone: tempPhotographer['phone'],
          fullname: tempPhotographer['fullname'],
          ratingCount: tempPhotographer['ratingCount'],
          avatar: tempPhotographer['avatar']);

      final tempCustomer = data['customer'] as Map;
      CustomerBlocModel customer = CustomerBlocModel(
          id: tempCustomer['id'],
          phone: tempCustomer['phone'],
          fullname: tempCustomer['fullname'],
          avatar: tempCustomer['avatar']);
    

      final tempPackage = data['servicePackage'] as Map;
      PackageBlocModel package = PackageBlocModel(
        id: tempPackage['id'],
        name: tempPackage['name'],
        price: tempPackage['price'],
        supportMultiDays: tempPackage['supportMultiDays'],
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
          comment: data['comment'],
          address: data['location'] ?? '',
          commentDate: data['commentDate'],
          photographer: photographer,
          services: services ?? [],
          isMultiday: data['servicePackage']['supportMultiDays'],
          editDeadLine: data['editDeadline'],
          returningType: data['returningType']['id'],
          listTimeAndLocations: listTimeAndLocations,
          timeAnticipate: data['timeAnticipate'],
          packageDescription: data['servicePackage']['description'] ?? '',
          package: package ?? [],
          customer: customer,
          returningLink: data['returningLink']);

      return booking;
    } else {
      throw Exception('Error getting list of bookings');
    }
  }

  Future<int> createBooking(BookingBlocModel booking, int cusId) async {
    var resBody = {};
    var ptgResBody = {};
    var cusResBody = {};
    var packageResBody = {};
    var bookingDetailResBody = [];

    var returningTypeResBody = {};
    var timeLocationDetailsResbody = [];

    resBody["serviceName"] = booking.serviceName;

    resBody["price"] = booking.price;

    resBody["editDeadline"] = booking.editDeadLine;

    cusResBody["id"] = cusId;
    resBody["customer"] = cusResBody;

    ptgResBody["id"] = booking.photographer.id;
    resBody["photographer"] = ptgResBody;

    packageResBody["id"] = booking.package.id;
    resBody["servicePackage"] = packageResBody;

    returningTypeResBody["id"] = booking.returningType;
    resBody["returningType"] = returningTypeResBody;

    resBody["timeAnticipate"] = booking.package.timeAnticipate;

    for (var service in booking.package.serviceDtos) {
      var serviceResBody = {};
      serviceResBody["serviceName"] = service.name;
      bookingDetailResBody.add(serviceResBody);
    }
    resBody["bookingDetails"] = bookingDetailResBody;

    for (var item in booking.listTimeAndLocations) {
      var timeLocationDetailObject = {};
      timeLocationDetailObject["lat"] = item.latitude;
      timeLocationDetailObject["lon"] = item.longitude;
      timeLocationDetailObject["formattedAddress"] = item.formattedAddress;
      timeLocationDetailObject["start"] = item.start;
      timeLocationDetailObject["end"] = item.end;
      timeLocationDetailsResbody.add(timeLocationDetailObject);
    }
    resBody["timeLocationDetails"] = timeLocationDetailsResbody;
    String str = json.encode(resBody);
    print(str);
    final response = await httpClient.post(BaseApi.BOOKING_URL,
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          HttpHeaders.authorizationHeader: 'Bearer ' + globalCusToken
        },
        body: str);

    int result = 0;
    if (response.statusCode == 200) {
      final data = jsonDecode(utf8.decode(response.bodyBytes));
      result = data['id'];
    } else {
      throw Exception('Error Create a Booking');
    }

    return result;
  }

  Future<bool> editBooking(BookingBlocModel booking, int cusId) async {
    var resBody = {};
    var ptgResBody = {};
    var cusResBody = {};
    var packageResBody = {};
    var bookingDetailResBody = [];
    var returningTypeResBody = {};
    var timeLocationDetailsResbody = [];

    resBody["id"] = booking.id;
    print(booking.id);
    resBody["serviceName"] = booking.serviceName;

    resBody["price"] = booking.price;

    resBody["editDeadline"] = booking.editDeadLine;

    cusResBody["id"] = cusId;
    resBody["customer"] = cusResBody;

    ptgResBody["id"] = booking.photographer.id;
    resBody["photographer"] = ptgResBody;

    packageResBody["id"] = booking.package.id;
    resBody["servicePackage"] = packageResBody;

    returningTypeResBody["id"] = booking.returningType;
    resBody["returningType"] = returningTypeResBody;

    resBody["timeAnticipate"] = booking.package.timeAnticipate;

    // for (var service in booking.package.serviceDtos) {
    //   serviceResBody["serviceName"] = service.name;
    //   bookingDetailResBody.add(serviceResBody);
    // }
    resBody["bookingDetails"] = bookingDetailResBody;

    for (var item in booking.listTimeAndLocations) {
      var timeLocationDetailObject = {};
      timeLocationDetailObject["lat"] = item.latitude;
      timeLocationDetailObject["lon"] = item.longitude;
      timeLocationDetailObject["formattedAddress"] = item.formattedAddress;
      timeLocationDetailObject["start"] = item.start;
      timeLocationDetailObject["end"] = item.end;
      timeLocationDetailsResbody.add(timeLocationDetailObject);
    }
    resBody["timeLocationDetails"] = timeLocationDetailsResbody;
    String str = json.encode(resBody);

    print(str);
    final response = await httpClient.post(BaseApi.BOOKING_URL,
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          HttpHeaders.authorizationHeader: 'Bearer ' + globalCusToken
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

  Future<bool> cancelBooking(BookingBlocModel booking, int cusId) async {
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

    cusResBody["id"] = cusId;
    resBody["customer"] = cusResBody;

    String str = json.encode(resBody);

    final response =
        await httpClient.put(BaseApi.BOOKING_URL + '/cancel/customer',
            headers: {
              'Content-Type': 'application/json; charset=UTF-8',
              HttpHeaders.authorizationHeader: 'Bearer ' + globalCusToken
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
    final response = await this.httpClient.get(
        BaseApi.PHOTOGRAPHER_URL + '/$id/on-day/for-customer?date=$date',
        headers: {HttpHeaders.authorizationHeader: 'Bearer ' + globalCusToken});
    print(baseUrl + 'photographers/$id/on-day?date=$date');
    if (response.statusCode == 200) {
      final data = jsonDecode(utf8.decode(response.bodyBytes)) as Map;
      final bookingInfos = data['bookingInfos'] as List;
      List<BookingBlocModel> listBookings;
      if (bookingInfos != null) {
        listBookings = bookingInfos.map((booking) {
          return BookingBlocModel(
              id: booking['id'],
              status: booking['status'],
              latitude: booking['lat'],
              startDate: booking['start'],
              endDate: booking['end'],
              timeAnticipate: booking['timeAnticipate']);
        }).toList();
      } else {
        listBookings = [];
      }

      return listBookings;
    } else {
      throw Exception('Error getting Photographer Calendar');
    }
  }
}
