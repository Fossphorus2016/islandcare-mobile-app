// import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:island_app/utils/app_url.dart';
import 'package:island_app/utils/functions.dart';
import 'package:island_app/utils/internet_service.dart';
import 'package:island_app/utils/navigation_service.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

ConnectionStatusSingleton connectionStatusSingleton = ConnectionStatusSingleton.getInstance();
String secretKey = dotenv.env["SECRET_KEY"]!;

Future<Response?> getRequesthandler(String url, String? token, Map? data) async {
  bool isNetConnected = await connectionStatusSingleton.checkConnection();
  if (isNetConnected) {
    try {
      Map<String, dynamic> headers = {};
      // Define the payload (should match the body of your request)

      // dynamic payload;
      // if (data != null) {
      //   payload = data;
      // } else {
      //   payload = '';
      // }
      // Generate the current timestamp in seconds
      // int timestamp = DateTime.now().millisecondsSinceEpoch ~/ 1000;

      // Generate the HMAC-SHA256 signature using CryptoJS
      // var key = utf8.encode(secretKey);
      // var message = utf8.encode('$payload.$timestamp');

      // Hmac hmac = Hmac(sha256, key); // HMAC-SHA256
      // Digest signature = hmac.convert(message);

      // Set the headers dynamically
      // headers.addAll({'X-SIGNATURE': signature});

      // headers.addAll({'X-TIMESTAMP': timestamp.toString()});
      // headers.addAll({'X-SECRET-KEY': secretKey});
      if (token != null) {
        headers.addAll({'Authorization': "Bearer $token"});
      }

      headers.addAll({"Accept": "application/json"});
      var resp = await Dio().get(
        url,
        data: data,
        options: Options(
          headers: headers,
        ),
      );
      return resp;
    } on DioException catch (err) {
      if (err.response?.statusCode == 401) {
        showErrorToast("Unauthenticated");
        navigationService.pushNamedAndRemoveUntil(SessionUrl.login);
      } else if (err.response?.statusCode == 422) {
        showErrorToast(err.response?.data['message']);
      } else if (err.response?.statusCode == 400) {
        showErrorToast(err.response?.data['message']);
      } else {
        showErrorToast("something went wrong");
      }
      return err.response;
    }
  } else {
    showNetworkErrorToast("No internet connected");
    return null;
  }
}

Future<Response?> postRequesthandler(String url, String? token, Map<String, dynamic>? data) async {
  bool isNetConnected = await connectionStatusSingleton.checkConnection();

  if (isNetConnected) {
    try {
      Map<String, dynamic> headers = {};
      // Define the payload (should match the body of your request)
      // dynamic payload;
      // if (data != null) {
      //   payload = jsonEncode(data);
      // } else {
      //   payload = '';
      // }
      // // Generate the current timestamp in seconds
      // int timestamp = DateTime.now().millisecondsSinceEpoch ~/ 1000;

      // // Generate the HMAC-SHA256 signature using CryptoJS
      // var key = utf8.encode(secretKey);
      // var message = utf8.encode('$payload.$timestamp');
      // // log('$payload.$timestamp');
      // Hmac hmac = Hmac(sha256, key); // HMAC-SHA256
      // Digest signature = hmac.convert(message);

      // // Set the headers dynamically
      // headers.addAll({'X-SIGNATURE': signature});
      // headers.addAll({'X-TIMESTAMP': timestamp.toString()});
      // headers.addAll({'X-SECRET-KEY': secretKey});
      if (token != null) {
        headers.addAll({'Authorization': "Bearer $token"});
      }

      headers.addAll({"Accept": "application/json"});
      FormData? formData;
      if (data != null) {
        formData = FormData.fromMap(data);
      } else {
        formData = null;
      }
      var resp = await Dio().post(
        url,
        data: formData,
        options: Options(
          headers: headers,
        ),
      );
      return resp;
    } on DioException catch (err) {
      if (err.response?.statusCode == 401) {
        showErrorToast("Unauthenticated");
        navigationService.pushNamedAndRemoveUntil(SessionUrl.login);
      } else if (err.response?.statusCode == 422) {
        if (err.response?.data['message'] != null) {
          showErrorToast(err.response?.data['message']);
        } else {
          showErrorToast("something went wrong");
        }
      } else if (err.response?.statusCode == 400) {
        showErrorToast(err.response?.data['message']);
      } else {
        showErrorToast("something went wrong");
      }
      return err.response;
    }
  } else {
    showNetworkErrorToast("No internet connected");
    return null;
  }
}
