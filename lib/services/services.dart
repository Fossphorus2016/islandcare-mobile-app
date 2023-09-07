// import 'dart:convert';
// import 'dart:io';
// import 'package:http/http.dart' as http;
// import 'package:island_app/carereceiver/models/service_receiver_dashboard_model.dart';

// class Services {
//   static const String? url = 'https://jsonplaceholder.typicode.com/users';
 
//   static Future<ServiceReceiverDashboardModel> getUsers() async {
//     try {
//       final response = await http.get(Uri.parse(url!));
//       if (200 == response.statusCode) {
//         ServiceReceiverDashboardModel? users = parseUsers(response.body) as ServiceReceiverDashboardModel?;
//         return users!;
//         //throw Exception('Unknown Error');
//       } else {
//         return ServiceReceiverDashboardModel();
//       }
//     } on SocketException catch (e) {
//       throw NoInternetException('No Internet');
//     } on HttpException {
//       throw NoServiceFoundException('No Service Found');
//     } on FormatException {
//       throw InvalidFormatException('Invalid Data Format');
//     } catch (e) {
//       throw UnknownException(e.message);
//     }
//   }
 
//   static ServiceReceiverDashboardModel parseUsers(String responseBody) {
//     final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();
//     return parsed.map<ServiceReceiverDashboardModel>((json) => User.fromJson(json)).toList();
//   }
// }