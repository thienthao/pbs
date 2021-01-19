import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:photographer_app_java_support/globals.dart';
import 'package:photographer_app_java_support/models/booking_bloc_model.dart';
import 'package:photographer_app_java_support/models/customer_bloc_model.dart';
import 'package:photographer_app_java_support/models/package_bloc_model.dart';
import 'package:photographer_app_java_support/models/photographer_bloc_model.dart';
import 'package:photographer_app_java_support/models/time_and_location_bloc_model.dart';
import 'package:photographer_app_java_support/models/weather_bloc_model.dart';
import 'package:photographer_app_java_support/widgets/shared/base_api.dart';

const baseUrl = 'https://pbs-webapi.herokuapp.com/api/';

class BookingRepository {
  final http.Client httpClient;

  BookingRepository({
    @required this.httpClient,
  }) : assert(httpClient != null);

  Future<List<BookingBlocModel>> getListBookingByPhotographerId() async {
    final response = await this.httpClient.get(
        BaseApi.BOOKING_URL + '/photographer/$globalPtgId/id?page=0&size=15',
        headers: {HttpHeaders.authorizationHeader: 'Bearer ' + globalPtgToken});
    if (response.statusCode == 200) {
      final data = jsonDecode(utf8.decode(response.bodyBytes)) as Map;
      final list = data['bookings'] as List;

      print('get list booking $list');
      final List<BookingBlocModel> bookings = list.map((booking) {
        final tempCustomer = booking['customer'] as Map;
        CustomerBlocModel customer = CustomerBlocModel(
            id: tempCustomer['id'],
            fullname: tempCustomer['fullname'],
            avatar: tempCustomer['avatar'] ??
                'https://upload.wikimedia.org/wikipedia/commons/7/7c/Profile_avatar_placeholder_large.png');
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
          location: booking['location'] ?? '',
          customer: customer,
        );
      }).toList();
      print('Tất cả các bookings $bookings');
      return bookings;
    } else if (response.statusCode == 401) {
      throw Exception('Unauthorized');
    } else {
      throw Exception('Error getting list of bookings');
    }
  }

  Future<List<BookingBlocModel>> getListInfiniteBookingByPhotographerId(
      int page, int size, String status) async {
    String extendUrl;

    if (status == 'ALL') {
      extendUrl = '/photographer/$globalPtgId/id?page=$page&size=$size';
    } else {
      extendUrl =
          '/photographer/$globalPtgId/status?status=$status&page=$page&size=$size';
    }
    final response = await this.httpClient.get(BaseApi.BOOKING_URL + extendUrl,
        headers: {HttpHeaders.authorizationHeader: 'Bearer ' + globalPtgToken});
    print(baseUrl + extendUrl);
    if (response.statusCode == 200) {
      final data = jsonDecode(utf8.decode(response.bodyBytes)) as Map;
      final list = data['bookings'] as List;

      final List<BookingBlocModel> bookings = list.map((booking) {
        final tempCustomer = booking['customer'] as Map;
        CustomerBlocModel customer = CustomerBlocModel(
            id: tempCustomer['id'],
            fullname: tempCustomer['fullname'],
            phone: tempCustomer['phone'],
            avatar: tempCustomer['avatar'] ??
                'https://upload.wikimedia.org/wikipedia/commons/7/7c/Profile_avatar_placeholder_large.png');

        final tempTimeAndLocations = booking['timeLocationDetails'] as List;
        bool isMultiDay = false;
        if (tempTimeAndLocations.length > 1) {
          isMultiDay = true;
        }
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
            location: booking['location'] ?? '',
            customer: customer,
            listTimeAndLocations: listTimeAndLocations,
            isMultiday: isMultiDay);
      }).toList();
      return bookings;
    } else if (response.statusCode == 401) {
      throw Exception('Unauthorized');
    } else {
      throw Exception('Error getting list of bookings');
    }
  }

  Future<List<BookingBlocModel>> getListBookingByDate(String date) async {
    final response = await this.httpClient.get(
        BaseApi.PHOTOGRAPHER_URL + '/$globalPtgId/on-day?date=$date',
        headers: {HttpHeaders.authorizationHeader: 'Bearer ' + globalPtgToken});
    if (response.statusCode == 200) {
      final data = jsonDecode(utf8.decode(response.bodyBytes)) as Map;

      final list = data['bookingInfos'] as List;
      List<BookingBlocModel> bookings;
      if (list != null) {
        bookings = list.map((booking) {
          CustomerBlocModel customer = CustomerBlocModel(
            id: booking['customerId'],
            fullname: booking['customerName'],
          );
          return BookingBlocModel(
            id: booking['id'],
            status: booking['status'],
            startDate: booking['start'] == null
                ? DateTime.now().toString()
                : booking['start'],
            endDate: booking['end'] ?? DateTime.now().toString(),
            serviceName: booking['packageName'] ?? 'Không có dịch vụ nào',
            location: booking['address'],
            latitude: booking['lat'],
            longitude: booking['long'],
            editDeadLine: booking['editDeadline'],
            price: booking['packagePrice'] ?? 0,
            customer: customer,
          );
        }).toList();
      } else {
        bookings = [];
      }

      return bookings;
    } else if (response.statusCode == 401) {
      throw Exception('Unauthorized');
    } else {
      throw Exception('Error getting list of bookings');
    }
  }

  // Future<List<BookingBlocModel>> getListPendingBookingByPhotographerId() async {
  //   final response = await this.httpClient.get(
  //       BaseApi.BOOKING_URL + '/photographer/globalPtgId/status?status=pending',
  //       headers: {
  //         HttpHeaders.authorizationHeader: 'Bearer ' +
  //             'eyJhbGciOiJIUzUxMiJ9.eyJzdWIiOiJ0aG9jaHVwaGluaCIsImlhdCI6MTYwMjMwMzQ5NCwiZXhwIjoxNjE3ODU1NDk0fQ.25Oz4rCRj4pdX6GdpeWdwt1YT7fcY6YTKK8SywVyWheVPGpwB6641yHNz7U2JwlgNUtI3FE89Jf8qwWUXjfxRg'
  //       });
  //   if (response.statusCode == 200) {
  //     final data = jsonDecode(utf8.decode(response.bodyBytes)) as Map;
  //     final list = data['bookings'] as List;

  //     final List<BookingBlocModel> bookings = list.map((booking) {
  //       final tempCustomer = booking['customer'] as Map;
  //       CustomerBlocModel customer = CustomerBlocModel(
  //           id: tempCustomer['id'],
  //           fullname: tempCustomer['fullname'],
  //           phone: tempCustomer['phone'],
  //           avatar: tempCustomer['avatar']);

  //       final tempTimeAndLocations = booking['timeLocationDetails'] as List;

  //       final List<TimeAndLocationBlocModel> listTimeAndLocations =
  //           tempTimeAndLocations.map((item) {
  //         return TimeAndLocationBlocModel(
  //             id: item['id'],
  //             start: item['start'],
  //             end: item['end'],
  //             formattedAddress: item['formattedAddress'],
  //             latitude: item['lat'],
  //             longitude: item['lon']);
  //       }).toList();

  //       return BookingBlocModel(
  //         id: booking['id'],
  //         status: booking['bookingStatus'],
  //         startDate: booking['startDate'] == null
  //             ? DateTime.now().toString()
  //             : booking['startDate'],
  //         endDate: booking['endDate'] ?? DateTime.now().toString(),
  //         serviceName: booking['serviceName'] ?? 'Không có dịch vụ nào',
  //         price: booking['price'] ?? 0,
  //         location: booking['location'] ?? '',
  //         customer: customer,
  //         listTimeAndLocations: listTimeAndLocations,
  //       );
  //     }).toList();
  //     print('Tất cả các bookings $bookings');
  //     return bookings;
  //   } else {
  //     throw Exception('Error getting list of bookings');
  //   }
  // }

  Future<List<BookingBlocModel>> getListPendingBookingByPhotographerId() async {
    print(
      BaseApi.BOOKING_URL + '/photographer/$globalPtgId/with-warnings',
    );
    print(globalPtgToken);
    final response = await this.httpClient.get(
        BaseApi.BOOKING_URL + '/photographer/$globalPtgId/with-warnings',
        headers: {HttpHeaders.authorizationHeader: 'Bearer ' + globalPtgToken});
    if (response.statusCode == 200) {
      final body = jsonDecode(utf8.decode(response.bodyBytes)) as Map;
      final data = body['data'] as List;
      print(data);

      final List<BookingBlocModel> bookings = data.map((booking) {
        final listTimeWarning = booking['timeWarnings'] as List;
        final listDistanceWarning = booking['distanceWarning'] as List;
        final listWeatherWarning = booking['weatherWarning'] as List;
        final listSelfWarnDistance = booking['selfWarnDistance'] as List;

        List<String> timeWarnings = listTimeWarning.map((notice) {
          return notice.toString();
        }).toList();
        List<String> distanceWarning = listDistanceWarning.map((notice) {
          return notice.toString();
        }).toList();

        List<String> weatherWarning = listWeatherWarning.map((notice) {
          return notice.toString();
        }).toList();

        List<String> selfWarnDistance = listSelfWarnDistance.map((notice) {
          return notice.toString();
        }).toList();

        final tempCustomer = booking['booking']['customer'] as Map;
        CustomerBlocModel customer = CustomerBlocModel(
            id: tempCustomer['id'],
            fullname: tempCustomer['fullname'] ?? 'Ẩn danh',
            phone: tempCustomer['phone'],
            avatar: tempCustomer['avatar'] ??
                'https://upload.wikimedia.org/wikipedia/commons/7/7c/Profile_avatar_placeholder_large.png');

        final tempTimeAndLocations =
            booking['booking']['timeLocationDetails'] as List;
        bool isMultiDay = false;
        if (tempTimeAndLocations.length > 1) {
          isMultiDay = true;
        }
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
            id: booking['booking']['id'],
            status: booking['booking']['bookingStatus'],
            startDate: booking['booking']['startDate'] == null
                ? DateTime.now().toString()
                : booking['booking']['startDate'],
            endDate: booking['booking']['endDate'] ?? DateTime.now().toString(),
            serviceName:
                booking['booking']['serviceName'] ?? 'Không có dịch vụ nào',
            price: booking['booking']['price'] ?? 0,
            location: booking['booking']['location'] ?? '',
            customer: customer,
            listTimeAndLocations: listTimeAndLocations,
            weatherWarnings: weatherWarning,
            locationWarnings: distanceWarning,
            timeWarnings: timeWarnings,
            selfWarnDistance: selfWarnDistance,
            isMultiday: isMultiDay);
      }).toList();
      print('Tất cả các bookings $bookings');
      return bookings;
    } else if (response.statusCode == 401) {
      throw Exception('Unauthorized');
    } else {
      throw Exception('Error getting list of bookings');
    }
  }

  Future<BookingBlocModel> getBookingDetailById(int id) async {
    final response = await this.httpClient.get(
        BaseApi.BOOKING_URL + '/with-warnings/' + id.toString(),
        headers: {HttpHeaders.authorizationHeader: 'Bearer ' + globalPtgToken});
    if (response.statusCode == 200) {
      final listData = jsonDecode(utf8.decode(response.bodyBytes));
      final data = listData['booking'] as Map;
      final listTimeWarning = listData['timeWarnings'] as List ?? [];
      final listDistanceWarning = listData['distanceWarning'] as List ?? [];
      final listWeatherWarning = listData['weatherWarning'] as List ?? [];
      final listSelfWarnDistance = listData['selfWarnDistance'] as List ?? [];

      List<String> timeWarnings = listTimeWarning.map((notice) {
        return notice.toString();
      }).toList();
      List<String> distanceWarning = listDistanceWarning.map((notice) {
        return notice.toString();
      }).toList();

      List<String> weatherWarning = listWeatherWarning.map((notice) {
        return notice.toString();
      }).toList();

      List<WeatherBlocModel> listWeatherNoticeDetails =
          listWeatherWarning.map((notice) {
        return WeatherBlocModel(
            noti: notice['noti'],
            humidity: notice['humidity'],
            outlook: notice['outlook'],
            temperature: notice['temperature'],
            windSpeed: notice['windSpeed']);
      }).toList();

      List<String> selfWarnDistance = listSelfWarnDistance.map((notice) {
        return notice.toString();
      }).toList();

      final tempCustomer = data['customer'] as Map;
      CustomerBlocModel customer = CustomerBlocModel(
          id: tempCustomer['id'],
          phone: tempCustomer['phone'],
          fullname: tempCustomer['fullname'] ?? 'Ẩn danh',
          avatar: tempCustomer['avatar'] ??
              'https://upload.wikimedia.org/wikipedia/commons/7/7c/Profile_avatar_placeholder_large.png');

      final tempPhotographer = data['photographer'] as Map;
      Photographer photographer = Photographer(
          id: tempPhotographer['id'],
          phone: tempPhotographer['phone'],
          fullname: tempPhotographer['fullname'] ?? 'Ẩn danh',
          ratingCount: tempPhotographer['ratingCount'],
          avatar: tempPhotographer['avatar'] ??
              'https://upload.wikimedia.org/wikipedia/commons/7/7c/Profile_avatar_placeholder_large.png');

      final tempPackage = data['servicePackage'] as Map;
      PackageBlocModel package = PackageBlocModel(
        id: tempPackage['id'],
        name: tempPackage['name'],
      );

      final tempServices = data['bookingDetails'] as List;

      final List<String> services = new List();
      for (final service in tempServices) {
        services.add(service['serviceName']);
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
            longitude: item['lon'],
            isCheckin: item['isCheckin'],
            qrCheckinCode: item['qrCheckinCode']);
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
          location: data['location'] ?? '',
          commentDate: data['commentDate'],
          customer: customer,
          isMultiday: data['servicePackage']['supportMultiDays'],
          editDeadLine: data['editDeadline'],
          returningType: data['returningType']['id'],
          listTimeAndLocations: listTimeAndLocations,
          services: services ?? [],
          packageDescription: data['servicePackage']['description'] ?? '',
          package: package ?? [],
          timeWarnings: timeWarnings,
          locationWarnings: distanceWarning,
          weatherWarnings: weatherWarning,
          selfWarnDistance: selfWarnDistance,
          listWeatherNoticeDetails: listWeatherNoticeDetails,
          timeAnticipate: data['timeAnticipate'],
          photographer: photographer,
          isCheckin: data['isCheckin'] ?? false,
          qrCheckinCode: data['qrCheckinCode'],
          returningLink: data['returningLink']);

      return booking;
    } else if (response.statusCode == 401) {
      throw Exception('Unauthorized');
    } else {
      throw Exception('Error getting list of bookings');
    }
  }

  Future<bool> createBooking(BookingBlocModel booking) async {
    var resBody = {};
    var ptgResBody = {};
    var cusResBody = {};
    var packageResBody = {};
    var bookingDetailResBody = [];
    var serviceResBody = {};

    resBody["startDate"] = booking.startDate;
    resBody["endDate"] = booking.endDate;
    resBody["serviceName"] = booking.serviceName;
    resBody["price"] = booking.price;
    resBody["location"] = booking.location;

    ptgResBody["id"] = globalPtgId;
    resBody["photographer"] = ptgResBody;

    for (var service in booking.package.serviceDtos) {
      serviceResBody["serviceName"] = service.name;
      serviceResBody["serviceDescription"] = service.description;
      bookingDetailResBody.add(serviceResBody);
    }
    packageResBody["id"] = booking.package.id;
    resBody["servicePackage"] = packageResBody;

    resBody["bookingDetails"] = bookingDetailResBody;

    cusResBody["id"] = booking.customer.id ?? 2;
    resBody["customer"] = cusResBody;

    String str = json.encode(resBody);
    print(str);

    final response = await httpClient.post(BaseApi.BOOKING_URL,
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          HttpHeaders.authorizationHeader: 'Bearer ' + globalPtgToken
        },
        body: str);

    bool result = false;
    if (response.statusCode == 200) {
      print('cancel $result');
      result = true;
    } else if (response.statusCode == 401) {
      throw Exception('Unauthorized');
    } else {
      throw Exception('Error Create a Booking');
    }

    return result;
  }

  Future<bool> acceptBooking(BookingBlocModel booking) async {
    var resBody = {};
    var ptgResBody = {};
    var cusResBody = {};
    var packageResBody = {};

    resBody["id"] = booking.id;

    cusResBody["id"] = booking.customer.id;
    resBody["customer"] = cusResBody;

    packageResBody["id"] = booking.package.id;
    resBody["servicePackage"] = packageResBody;

    ptgResBody["id"] = globalPtgId;
    resBody["photographer"] = ptgResBody;

    String str = json.encode(resBody);
    print(str);

    final response = await httpClient.put(BaseApi.BOOKING_URL + '/accept',
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          HttpHeaders.authorizationHeader: 'Bearer ' + globalPtgToken
        },
        body: str);

    bool result = false;
    if (response.statusCode == 200) {
      result = true;
    } else if (response.statusCode == 401) {
      throw Exception('Unauthorized');
    } else {
      throw Exception('Error at accept a booking');
    }

    return result;
  }

  Future<bool> moveToEditBooking(BookingBlocModel booking) async {
    var resBody = {};
    var ptgResBody = {};
    var cusResBody = {};
    var packageResBody = {};

    resBody["id"] = booking.id;

    cusResBody["id"] = booking.customer.id;
    resBody["customer"] = cusResBody;

    packageResBody["id"] = booking.package.id;
    resBody["servicePackage"] = packageResBody;

    ptgResBody["id"] = globalPtgId;
    resBody["photographer"] = ptgResBody;

    String str = json.encode(resBody);
    print(str);

    final response = await httpClient.put(BaseApi.BOOKING_URL + '/editing',
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          HttpHeaders.authorizationHeader: 'Bearer ' + globalPtgToken
        },
        body: str);

    bool result = false;
    if (response.statusCode == 200) {
      result = true;
    } else if (response.statusCode == 401) {
      throw Exception('Unauthorized');
    } else {
      throw Exception('Error at accept a booking');
    }

    return result;
  }

  Future<bool> moveToDoneBooking(BookingBlocModel booking) async {
    var resBody = {};
    var ptgResBody = {};
    var cusResBody = {};
    var packageResBody = {};

    resBody["id"] = booking.id;

    cusResBody["id"] = booking.customer.id;
    resBody["customer"] = cusResBody;

    packageResBody["id"] = booking.package.id;
    resBody["servicePackage"] = packageResBody;

    ptgResBody["id"] = globalPtgId;
    resBody["photographer"] = ptgResBody;

    resBody["returningLink"] = booking.returningLink;

    String str = json.encode(resBody);
    print(str);

    final response = await httpClient.put(BaseApi.BOOKING_URL + '/done',
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          HttpHeaders.authorizationHeader: 'Bearer ' + globalPtgToken
        },
        body: str);

    bool result = false;
    if (response.statusCode == 200) {
      result = true;
    } else if (response.statusCode == 401) {
      throw Exception('Unauthorized');
    } else {
      throw Exception('Error at accept a booking');
    }

    return result;
  }

  Future<bool> rejectBooking(BookingBlocModel booking) async {
    var resBody = {};
    var ptgResBody = {};
    var cusResBody = {};
    var packageResBody = {};

    resBody["id"] = booking.id;

    resBody["rejectedReason"] = booking.rejectedReason;

    cusResBody["id"] = booking.customer.id;
    resBody["customer"] = cusResBody;

    packageResBody["id"] = booking.package.id;
    resBody["servicePackage"] = packageResBody;

    ptgResBody["id"] = globalPtgId;
    resBody["photographer"] = ptgResBody;

    String str = json.encode(resBody);
    print(str);

    final response = await httpClient.put(BaseApi.BOOKING_URL + '/reject',
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          HttpHeaders.authorizationHeader: 'Bearer ' + globalPtgToken
        },
        body: str);

    bool result = false;
    if (response.statusCode == 200) {
      result = true;
    } else if (response.statusCode == 401) {
      throw Exception('Unauthorized');
    } else {
      throw Exception('Error at reject a booking');
    }
    return result;
  }

  Future<bool> cancelBooking(BookingBlocModel booking) async {
    var resBody = {};
    var ptgResBody = {};
    var cusResBody = {};
    var packageResBody = {};

    resBody["id"] = booking.id;
    resBody["photographerCanceledReason"] = booking.photographerCanceledReason;
    cusResBody["id"] = booking.customer.id;
    resBody["customer"] = cusResBody;
    packageResBody["id"] = booking.package.id;
    resBody["servicePackage"] = packageResBody;
    ptgResBody["id"] = globalPtgId;
    resBody["photographer"] = ptgResBody;
    String str = json.encode(resBody);
    print(str);

    final response = await httpClient.put(
        BaseApi.BOOKING_URL + '/cancellation-submit/photographer',
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          HttpHeaders.authorizationHeader: 'Bearer ' + globalPtgToken
        },
        body: str);

    // final response =
    //     await httpClient.put(BaseApi.BOOKING_URL + '/cancel/photographer',
    //         headers: {
    //           'Content-Type': 'application/json; charset=UTF-8',
    //           HttpHeaders.authorizationHeader: 'Bearer ' + globalPtgToken
    //         },
    //         body: str);
    bool result = false;
    if (response.statusCode == 200) {
      result = true;
    } else if (response.statusCode == 401) {
      throw Exception('Unauthorized');
    } else {
      throw Exception('Error at cancel a booking');
    }

    return result;
  }

  Future<bool> checkIn(int bookingId, int timeAndLocationId) async {
    final response = await httpClient.put(
      BaseApi.BOOKING_URL + '/checkin/$bookingId/$timeAndLocationId',
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        HttpHeaders.authorizationHeader: 'Bearer ' + globalPtgToken
      },
    );

    bool result = false;
    if (response.statusCode == 200) {
      result = true;
    } else if (response.statusCode == 401) {
      throw Exception('Unauthorized');
    } else {
      throw Exception('Error at checkin a qr code');
    }

    return result;
  }
}
