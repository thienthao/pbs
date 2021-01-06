import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:photographer_app_java_support/globals.dart';
import 'package:photographer_app_java_support/models/report_bloc_model.dart';
import 'package:photographer_app_java_support/widgets/shared/base_api.dart';

class ReportRepository {
  final http.Client httpClient;

  ReportRepository({
    @required this.httpClient,
  }) : assert(httpClient != null);

  Future<bool> postReport(ReportBlocModel report) async {
    var resBody = {};

    resBody["title"] = report.title;
    resBody["reason"] = report.reason;
    resBody["reporterId"] = report.reporterId;
    resBody["reportedId"] = report.reportedId;
    resBody["createdAt"] = report.createdAt;

    String str = json.encode(resBody);
    print(str);

    final response = await this.httpClient.post(BaseApi.REPORT_URL,
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          HttpHeaders.authorizationHeader: 'Bearer $globalPtgToken'
        },
        body: str);
    bool isPosted = false;
    if (response.statusCode == 200) {
      isPosted = true;
    }else if (response.statusCode == 401) {
      throw Exception('Unauthorized');
    } else {
      throw Exception('Error at posting report!!');
    }
    return isPosted;
  }
}
