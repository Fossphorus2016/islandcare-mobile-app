// ignore_for_file: deprecated_member_use

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:island_app/carereceiver/models/profile_model.dart';
import 'package:island_app/utils/app_url.dart';
import 'package:island_app/utils/http_handlers.dart';
import 'package:island_app/utils/storage_service.dart';

class RecieverUserProvider extends ChangeNotifier {
  static String userToken = '';
  getUserToken() async {
    var token = await storageService.readSecureStorage('userToken');
    // print(userToken);
    if (token != null) {
      userToken = token;
    }

    return userToken.toString();
  }

  getUserId() async {
    var userId = await storageService.readSecureStorage('userId');
    return userId.toString();
  }

  bool profileIsLoading = true;
  int? profilePerentage;
  // fetchPRofile
  ProfileReceiverModel? _userProfile;
  fetchProfileReceiverModel() async {
    var token = await getUserToken();
    try {
      final response = await getRequesthandler(
        url: CareReceiverURl.serviceReceiverProfile,
        token: token,
      );
      if (response.statusCode == 200) {
        // print("data fetched ${response.data}");
        profilePerentage = response.data['data']['percentage'];
        profileIsLoading = false;
        _userProfile = ProfileReceiverModel.fromJson(response.data);
        notifyListeners();
      } else {
        throw Exception('Failed to load Profile Model');
      }
    } on DioError {
      // print("error on fetch profile ${e.response!.data}");
    }
  }

  Future<ProfileReceiverModel?> get userProfile async => _userProfile;
  ProfileReceiverModel? get gWAUserProfile => _userProfile;
}
