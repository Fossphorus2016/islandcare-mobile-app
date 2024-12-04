// ignore_for_file: deprecated_member_use

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:island_app/carereceiver/models/profile_model.dart';
import 'package:island_app/utils/app_url.dart';
import 'package:island_app/utils/functions.dart';
import 'package:island_app/utils/http_handlers.dart';
// import 'package:island_app/utils/navigation_service.dart';
// import 'package:island_app/utils/routes_name.dart';
import 'package:island_app/utils/storage_service.dart';

class RecieverUserProvider extends ChangeNotifier {
  // static String userToken = '';

  getUserId() async {
    var userId = await storageService.readSecureStorage('userId');
    return userId.toString();
  }

  bool profileIsLoading = true;
  int? profilePerentage;

  ProfileReceiverModel? _userProfile;
  Future<bool> fetchProfileReceiverModel() async {
    var token = await getToken();
    try {
      final response = await getRequesthandler(
        url: CareReceiverURl.serviceReceiverProfile,
        token: token,
      );
      if (response != null && response.statusCode == 200) {
        profilePerentage = response.data['data']['percentage'];
        profileIsLoading = false;
        _userProfile = ProfileReceiverModel.fromJson(response.data);
        notifyListeners();
        return true;
      } else {
        // if (response != null && response.statusCode == 400 && response.data["message"] == "No Internet Connected") {
        //   navigationService.pushNamedAndRemoveUntil(RoutesName.login);
        // }
        showErrorToast("Failed to load Profile");

        // throw Exception('Failed to load Profile Model');
        return false;
      }
    } on DioError {
      showErrorToast("Failed to load Profile");

      return true;
    }
  }

  bool profileIsApprove() {
    if (gWAUserProfile != null && gWAUserProfile!.data != null && gWAUserProfile!.data!.status == 1) {
      return true;
    } else {
      return false;
    }
  }

  Future<ProfileReceiverModel?> get userProfile async => _userProfile;
  ProfileReceiverModel? get gWAUserProfile => _userProfile;
}
