// import 'package:http/http.dart' as http;
import 'package:dio/dio.dart';
import 'package:island_app/carereceiver/models/service_receiver_dashboard_model.dart';

class ErrorController {
  Future<ServiceReceiverDashboardModel>? getReqServiceDashboard(String url, var token) async {
    try {
      var response = await Dio().get(
        url,
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Accept': 'application/json',
          },
        ),
      );
      if (response.statusCode == 200) {
        return ServiceReceiverDashboardModel.fromJson(response.data);
      }
      throw "Some unexpected error occured";
    } catch (e) {
      rethrow;
    }
  }
}
