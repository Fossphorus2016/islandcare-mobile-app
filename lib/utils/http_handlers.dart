import 'package:dio/dio.dart';
import 'package:island_app/utils/functions.dart';
import 'package:island_app/utils/internet_service.dart';
import 'package:island_app/utils/navigation_service.dart';
import 'package:island_app/utils/routes_name.dart';

ConnectionStatusSingleton connectionStatusSingleton = ConnectionStatusSingleton.getInstance();

Future<Response?> getRequesthandler({required String url, String? token, FormData? data}) async {
  bool isNetConnected = await connectionStatusSingleton.checkConnection();
  if (isNetConnected) {
    try {
      Map<String, dynamic> headers = {};

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
        navigationService.pushNamedAndRemoveUntil(RoutesName.login);
      } else if (err.response?.statusCode == 422) {
        showErrorToast(err.response?.data['message']);
        return Response(
          statusCode: err.response!.statusCode,
          statusMessage: err.response!.statusMessage,
          data: err.response!.data,
          requestOptions: RequestOptions(data: err.response!.data),
        );
      } else if (err.response?.statusCode == 400) {
        showErrorToast(err.response?.data['message']);
      } else if (err.response != null) {
        showErrorToast("something went wrong");
        return Response(
          statusCode: err.response!.statusCode,
          statusMessage: err.response!.statusMessage,
          data: err.response!.data,
          requestOptions: RequestOptions(data: err.response!.data),
        );
      } else {
        return Response(
          statusCode: 500,
          statusMessage: "Something went wrong",
          data: {"success": false, "data": null},
          requestOptions: RequestOptions(data: {"success": false, "data": null}),
        );
      }
    }
  } else {
    showNetworkErrorToast("No internet connected");
    // navigationService.pushNamedAndRemoveUntil(RoutesName.login);
    return Response(
      statusCode: 400,
      data: {"message": "No Internet Connected"},
      requestOptions: RequestOptions(
        data: {"message": "No Internet Connected"},
      ),
    );
  }
  return null;
}

Future<Response?> postRequesthandler({required String url, String? token, FormData? formData}) async {
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
        navigationService.pushNamedAndRemoveUntil(RoutesName.login);
      } else if (err.response?.statusCode == 422) {
        if (err.response?.data['message'] != null) {
          showErrorToast(err.response?.data['message']);
          return Response(
            statusCode: err.response!.statusCode,
            statusMessage: err.response!.statusMessage,
            data: err.response!.data,
            requestOptions: RequestOptions(data: err.response!.data),
          );
        } else {
          showErrorToast("something went wrong");
          return Response(
            statusCode: 422,
            statusMessage: "Validation Error",
            requestOptions: RequestOptions(
              data: {"error": "Validation Error"},
            ),
          );
        }
      } else if (err.response?.statusCode == 400) {
        showErrorToast(err.response?.data['message']);
      } else if (err.response?.statusCode == 400) {
        showErrorToast(err.response?.data['message']);
      } else if (err.response != null) {
        showErrorToast("something went wrong");
        return Response(
          statusCode: err.response!.statusCode,
          statusMessage: err.response!.statusMessage,
          data: err.response!.data,
          requestOptions: RequestOptions(data: err.response!.data),
        );
      } else {
        return Response(
          statusCode: 500,
          statusMessage: "Something went wrong",
          data: {"success": false, "data": null},
          requestOptions: RequestOptions(data: {"success": false, "data": null}),
        );
      }
    }
  } else {
    showNetworkErrorToast("No Internet Connected");
    // navigationService.pushNamedAndRemoveUntil(RoutesName.login);
    return Response(
      statusCode: 400,
      data: {"message": "No Internet Connected"},
      requestOptions: RequestOptions(
        data: {"message": "No Internet Connected"},
      ),
    );
  }
  return null;
}

Future<Response?> putRequesthandler({required String url, String? token, FormData? formData}) async {
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
        navigationService.pushNamedAndRemoveUntil(RoutesName.login);
      } else if (err.response?.statusCode == 422) {
        if (err.response?.data['message'] != null) {
          showErrorToast(err.response?.data['message']);
          return Response(
            statusCode: err.response!.statusCode,
            statusMessage: err.response!.statusMessage,
            data: err.response!.data,
            requestOptions: RequestOptions(data: err.response!.data),
          );
        } else {
          showErrorToast("something went wrong");
        }
      } else if (err.response?.statusCode == 400) {
        showErrorToast(err.response?.data['message']);
      } else if (err.response?.statusCode == 400) {
        showErrorToast(err.response?.data['message']);
      } else if (err.response != null) {
        showErrorToast("something went wrong");
        return Response(
          statusCode: err.response!.statusCode,
          statusMessage: err.response!.statusMessage,
          data: err.response!.data,
          requestOptions: RequestOptions(data: err.response!.data),
        );
      } else {
        return Response(
          statusCode: 500,
          statusMessage: "Something went wrong",
          data: {"success": false, "data": null},
          requestOptions: RequestOptions(data: {"success": false, "data": null}),
        );
      }
    }
  } else {
    showNetworkErrorToast("No internet connected");
    navigationService.pushNamedAndRemoveUntil(RoutesName.login);
    return Response(
      statusCode: 400,
      data: {"message": "No Internet Connected"},
      requestOptions: RequestOptions(
        data: {"message": "No Internet Connected"},
      ),
    );
  }
  return null;
}
