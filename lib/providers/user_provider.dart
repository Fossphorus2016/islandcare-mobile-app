// ignore_for_file: deprecated_member_use

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:island_app/carereceiver/models/profile_model.dart';
import 'package:island_app/utils/app_url.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RecieverUserProvider extends ChangeNotifier {
  static String userToken = '';
  getUserToken() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    var token = preferences.getString('userToken');
    // print(userToken);
    if (token != null) {
      userToken = token;
    }

    return userToken.toString();
  }

  getUserId() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    var userId = preferences.getString(
      'userId',
    );
    return userId.toString();
  }

  bool profileIsLoading = true;
  int? profilePerentage;
  // fetchPRofile
  ProfileReceiverModel? _userProfile;
  fetchProfileReceiverModel() async {
    await getUserToken();
    try {
      final response = await Dio().get(
        CareReceiverURl.serviceReceiverProfile,
        options: Options(
          headers: {
            'Authorization': 'Bearer $userToken',
            'Accept': 'application/json',
          },
        ),
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
