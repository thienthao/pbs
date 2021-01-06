import 'dart:convert';
import 'dart:io';

import 'package:customer_app_java_support/globals.dart';
import 'package:customer_app_java_support/models/notification_bloc_model.dart';
import 'package:customer_app_java_support/shared/base_api.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class NotificationRepository {
  final http.Client httpClient;

  NotificationRepository({
    @required this.httpClient,
  }) : assert(httpClient != null);

  Future<List<NotificationBlocModel>> getNotificationsByUserId() async {
    final response = await this.httpClient.get(
        BaseApi.NOTIFICATION_URL + '/$globalCusId',
        headers: {HttpHeaders.authorizationHeader: 'Bearer ' + globalCusToken});

    if (response.statusCode == 200) {
      final data = jsonDecode(utf8.decode(response.bodyBytes)) as List;

      final List<NotificationBlocModel> notifications =
          data.map((notification) {
        return NotificationBlocModel(
            id: notification['id'],
            title: notification['title'],
            content: notification['content'],
            notificationType: notification['notificationType'],
            createdAt: notification['createdAt'],
            receiverId: notification['receiverId'],
            isRead: notification['isRead'],
            bookingId: notification['bookingId']);
      }).toList();

      return notifications;
    } else if (response.statusCode == 401) {
      throw Exception('Unauthorized');
    } else {
      throw Exception('Error getting list of photographers');
    }
  }

  Future<bool> removeNotification(int id) async {
    final response = await this.httpClient.delete(
        BaseApi.NOTIFICATION_URL + '/$id',
        headers: {HttpHeaders.authorizationHeader: 'Bearer ' + globalCusToken});
    bool isDeleted = false;
    if (response.statusCode == 200) {
      isDeleted = true;
    } else if (response.statusCode == 401) {
      throw Exception('Unauthorized');
    } else {
      throw Exception('Error getting list of photographers');
    }
    return isDeleted;
  }
}
