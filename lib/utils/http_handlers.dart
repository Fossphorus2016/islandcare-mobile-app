// import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:island_app/utils/app_url.dart';
import 'package:island_app/utils/functions.dart';
import 'package:island_app/utils/internet_service.dart';
import 'package:island_app/utils/navigation_service.dart';
// import 'package:flutter_dotenv/flutter_dotenv.dart';

ConnectionStatusSingleton connectionStatusSingleton = ConnectionStatusSingleton.getInstance();
// String secretKey = dotenv.env["SECRET_KEY"]!;

Future<Response> getRequesthandler({required String url, String? token, FormData? data}) async {
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
      if (err.response != null) {
        return Response(
          statusCode: err.response!.statusCode,
          statusMessage: err.response!.statusMessage,
          requestOptions: RequestOptions(data: err.response!.data),
        );
      } else {
        return Response(
          statusCode: 500,
          statusMessage: "Something went wrong",
          requestOptions: RequestOptions(data: {"success": false, "data": null}),
        );
      }
    }
  } else {
    showNetworkErrorToast("No internet connected");
    return Response(
      statusCode: 400,
      requestOptions: RequestOptions(
        data: {"message": "No Internet Connected"},
      ),
    );
  }
}

Future<Response> postRequesthandler({required String url, String? token, FormData? formData}) async {
  bool isNetConnected = await connectionStatusSingleton.checkConnection();

  if (isNetConnected) {
    try {
      Map<String, dynamic> headers = {};

      if (token != null) {
        headers.addAll({'Authorization': "Bearer $token"});
      }

      headers.addAll({"Accept": "application/json"});

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
      if (err.response != null) {
        return Response(
          statusCode: err.response!.statusCode,
          statusMessage: err.response!.statusMessage,
          requestOptions: RequestOptions(data: err.response!.data),
        );
      } else {
        return Response(
          statusCode: 500,
          statusMessage: "Something went wrong",
          requestOptions: RequestOptions(data: {"success": false, "data": null}),
        );
      }
    }
  } else {
    showNetworkErrorToast("No internet connected");
    return Response(
      statusCode: 400,
      requestOptions: RequestOptions(
        data: {"message": "No Internet Connected"},
      ),
    );
  }
}

Future<Response> putRequesthandler({required String url, String? token, FormData? formData}) async {
  bool isNetConnected = await connectionStatusSingleton.checkConnection();

  if (isNetConnected) {
    try {
      Map<String, dynamic> headers = {};

      if (token != null) {
        headers.addAll({'Authorization': "Bearer $token"});
      }

      headers.addAll({"Accept": "application/json"});

      var resp = await Dio().put(
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
      if (err.response != null) {
        return Response(
          statusCode: err.response!.statusCode,
          statusMessage: err.response!.statusMessage,
          requestOptions: RequestOptions(data: err.response!.data),
        );
      } else {
        return Response(
          statusCode: 500,
          statusMessage: "Something went wrong",
          requestOptions: RequestOptions(data: {"success": false, "data": null}),
        );
      }
    }
  } else {
    showNetworkErrorToast("No internet connected");
    return Response(
      statusCode: 400,
      requestOptions: RequestOptions(
        data: {"message": "No Internet Connected"},
      ),
    );
  }
}
