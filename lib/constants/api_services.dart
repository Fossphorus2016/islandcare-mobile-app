import 'dart:async';
import 'dart:io';

import 'package:dio/dio.dart';
// import 'package:http/http.dart' as http;

class ApiService {
  Future<dynamic> get(url) async {
    try {
      final response = await Dio().get(url);
      if (response.statusCode == 200) {
        return response.data;
      }
    } on SocketException {
      rethrow;
    } on Exception catch (e) {
      throw Exception(e);
    }
  }
}
