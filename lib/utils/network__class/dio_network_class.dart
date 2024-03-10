import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import '../../main.dart';
import '../common_utils.dart';
import '../common_widgets.dart';
import 'api_url_constants.dart';
import 'network_response.dart';

class DioNetworkClass {
  Dio dio = Dio();
  String endUrl = "";
  String filePath = "";
  String param = "";
  List<String> imageArray = [];
  late NetworkResponse networkResponse;
  Map<String, dynamic> jsonBody = {};
  late StateSetter stateSetter;
  AlertDialog? alertDialog;
  int requestCode = 0;
  bool isShowing = false;
  double progress = 0;

  DioNetworkClass(
      {required this.endUrl,
      required this.networkResponse,
      required this.requestCode});

  DioNetworkClass.fromNetworkClass(
      {required this.endUrl,
      required this.networkResponse,
      required this.requestCode,
      required this.jsonBody});

  DioNetworkClass.fromDioMultiPartSingleImage(
      {required this.endUrl,
      required this.networkResponse,
      required this.requestCode,
      required this.jsonBody,
      required this.filePath,
      required this.param});

  DioNetworkClass.fromDioMultiPartMultiImage(
      {required this.endUrl,
      required this.networkResponse,
      required this.requestCode,
      required this.jsonBody,
      required this.imageArray,
      required this.param});

  // GET     /posts
  // POST    /posts
  // PUT     /posts/1
  // PATCH   /posts/1
  // DELETE

  Future<void> callRequestService(
    bool showLoader,
    String requestType,
  ) async {
    try {
      var fromData = FormData.fromMap(jsonBody);

      Options options = Options(method: requestType.toUpperCase());
      dio.options.connectTimeout = const Duration(seconds: 90);
      options.sendTimeout = const Duration(seconds: 90); //5s
      dio.options.receiveTimeout = const Duration(seconds: 90);
      dio.options.contentType = Headers.jsonContentType;
      testingLog("7===> ");

      // Append API key as a query parameter
      String apiUrl = "$baseURL$endUrl";
      if (jsonBody.containsKey("api_key")) {
        apiUrl += "?api_key=${jsonBody["api_key"]}";
        jsonBody.remove("api_key");
      }

      printDataLog("${requestType}Url: $apiUrl");

      if (requestType == "get" ||
          requestType == "post" && jsonBody.isNotEmpty) {
        dio.options.queryParameters = jsonBody;
        printDataLog(
            "${requestType.toUpperCase()} Query Parameters: ${dio.options.queryParameters}");
      } else {
        printDataLog("${requestType}Map: $jsonBody");
      }

      late Response response;

      if (imageArray.isNotEmpty || filePath.isNotEmpty) {
        response = await dio.request(
          apiUrl,
          data: fromData,
          options: options,
        );
      } else {
        testingLog("====I am here");
        response = await dio.request(apiUrl, options: options);
        testingLog("====I am here");
      }

      printDataLog("ResultBody=========>: ${response.data.toString()}");

      if (alertDialog != null && isShowing) {
        isShowing = false;
        Navigator.of(navigatorKey.currentContext!, rootNavigator: true).pop();
      }

      if (response.statusCode! <= 201) {
        networkResponse.onResponse(
            requestCode: requestCode, response: jsonEncode(response.data));
      }
    } on DioException catch (e) {
      if (alertDialog != null && isShowing) {
        isShowing = false;
        Navigator.of(navigatorKey.currentContext!, rootNavigator: true).pop();
      }
      errorLog("Error========>${e.error}");
      errorLog("Error Type ========>${e.type}");
      if (e.error is SocketException) {
        commonSocketException((e.error as SocketException).osError!.errorCode,
            (e.error as SocketException).message);
      } else if (e.type == DioExceptionType.badResponse) {
        networkResponse.onApiError(
            requestCode: requestCode, response: jsonEncode(e.response!.data));
      } else if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout ||
          e.type == DioExceptionType.sendTimeout) {
        showToastMessage(color: Colors.red, message: "Connection Time Out");
      }
    } catch (err) {
      if (alertDialog != null && isShowing) {
        errorLog("SocketException");
        isShowing = false;
        Navigator.of(navigatorKey.currentContext!, rootNavigator: true).pop();
      }
      errorLog('Error While Making network call -> $err');
    }
  }

  Future<void> showLoaderDialog(BuildContext context) async {
    if (alertDialog != null && isShowing) {
      isShowing = false;
    }
    alertDialog = AlertDialog(
      elevation: 0,
      backgroundColor: Colors.white.withOpacity(0),
      content: const Center(
        child: CircularProgressIndicator(
          color: CommonColors.appThemeColor,
        ),
      ),
    );
    await showDialog(
      barrierDismissible: false,
      barrierColor: Colors.white.withOpacity(0),
      context: context,
      builder: (BuildContext context) {
        return WillPopScope(
            onWillPop: () => Future.value(false), child: alertDialog!);
      },
    );
  }

  void commonSocketException(int errorCode, String errorMessage) {
    switch (errorCode) {
      case 7:
        debugPrint("Internet Connection Error");
        showToastMessage(
            color: Colors.red, message: "Internet Connection Error");
        break;

      case 8:
        debugPrint("Internet Connection Error");
        showToastMessage(
            color: Colors.red, message: "Internet Connection Error");
        break;

      case 111:
        debugPrint("Unable to connect Server");
        showToastMessage(
            color: Colors.red, message: "Unable to connect to Server");
        break;

      default:
        debugPrint("Unknown Error :$errorMessage");
        showToastMessage(
            color: Colors.red, message: "Unknown Error :$errorMessage");
    }
  }
}
