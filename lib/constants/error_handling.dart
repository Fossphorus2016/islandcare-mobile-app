import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
import 'package:island_app/utils/utils.dart';

void httpErrorHandle({
  required Response response,
  required BuildContext context,
  required VoidCallback onSuccess,
}) {
  switch (response.statusCode) {
    case 200:
      onSuccess();
      break;
    case 400:
      Utils.snackBar(response.data['message'], context);
      break;
    case 401:
      Utils.snackBar(response.data['message'], context);
      break;
    case 500:
      Utils.snackBar(response.data['error'], context);
      break;
    default:
      Utils.snackBar(response.data, context);
  }
}
