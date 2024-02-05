// import 'dart:io';
// // import 'package:http/http.dart';
// import 'package:dio/dio.dart';
// import 'package:island_app/data/app_exceptions.dart';
// // import 'package:http/http.dart' as http;
// import 'package:island_app/data/network/base_api_service.dart';

// class NetworkApiService extends BaseApiServices {
//   @override
//   Future getGetApiResponse(String url, String token) async {
//     dynamic responseJson;
//     try {
//       final response = await Dio()
//           .get(
//             url,
//             options: Options(
//               headers: {
//                 'Authorization': 'Bearer $token',
//                 'Accept': 'application/json',
//               },
//             ),
//           )
//           .timeout(const Duration(seconds: 10));
//       responseJson = returnResponse(response);
//     } on SocketException {
//       throw FetchDataException('No Internet Connection');
//     }

//     return responseJson;
//   }

//   @override
//   Future getPostApiResponse(String url, dynamic data) async {
//     dynamic responseJson;
//     try {
//       Response response = await Dio().post(url, data: data).timeout(const Duration(seconds: 10));

//       responseJson = returnResponse(response);
//     } on SocketException {
//       throw FetchDataException('No Internet Connection');
//     }

//     return responseJson;
//   }

//   dynamic returnResponse(Response response) {
//     switch (response.statusCode) {
//       case 200:
//         dynamic responseJson = response.data;
//         return responseJson;
//       case 400:
//         throw BadRequestException(response.data.toString());
//       case 500:
//       case 404:
//         throw UnauthorisedException(response.data.toString());
//       default:
//         throw FetchDataException('Error accured while communicating with serverwith status code${response.statusCode}');
//     }
//   }
// }
