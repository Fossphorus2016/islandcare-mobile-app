// ignore_for_file: unused_field

import 'package:island_app/data/network/base_api_service.dart';
import 'package:island_app/data/network/network_api_service.dart';

class HomeRepository {
  final BaseApiServices _apiServices = NetworkApiService();

  // Future<ServiceReceiverDashboardModel> fetchReceiverDashboardList() async {
  //   try {
  //     dynamic response = await _apiServices.getGetApiResponse("${CareReceiverURl.serviceReceiverDashboard}", "9|Z85ckdGNzOkpi2RlAs9CMKkfZRuC3ElvfDebRhCR");
  //     return response = serviceReceiverDashboardModelFromJson(response);
  //   } catch (e) {
  //     throw e;
  //   }
  // }

  //   @override
  // Future<ServiceReceiverDashboardModel?> fetchReceiverDashboardList() async {
  //   try {
  //     dynamic response = await _apiServices.getGetApiResponse(CareReceiverURl.serviceReceiverDashboard, "9|Z85ckdGNzOkpi2RlAs9CMKkfZRuC3ElvfDebRhCR");
  //     print("MARAJ $response");
  //     final jsonData = ServiceReceiverDashboardModel.fromJson(response);
  //     return jsonData;
  //   } catch (e) {
  //     throw e;
  //   }
  // }
}
