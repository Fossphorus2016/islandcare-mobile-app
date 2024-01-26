// ignore_for_file: deprecated_member_use

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:island_app/carereceiver/models/profile_model.dart';
import 'package:island_app/res/app_url.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserProvider extends ChangeNotifier {
  // UserModel _userModel = UserModel(
  //   token: '',
  //   user: User(
  //     id: 1,
  //     firstName: '',
  //     lastName: '',
  //     email: '',
  //     phone: '',
  //     password: '',
  //     confirmPassword: '',
  //     date: '',
  //     service: '',
  //     emailVerifiedAt: '',
  //     providerId: '',
  //     avatar: '',
  //     role: null,
  //     status: null,
  //     createdAt: '',
  //     updatedAt: '',
  //     deletedAt: '',
  //   ),
  // );
  static String userToken = '';
  Future<dynamic> getUserToken() async {
    SharedPreferences? prefs = await SharedPreferences.getInstance();
    await prefs.reload();
    var token = prefs.getString('userToken');
    if (token != null) {
      userToken = token;
    }
    notifyListeners();
  }

  // String profilePerentage = '';
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
        _userProfile = ProfileReceiverModel.fromJson(response.data);
        // profilePerentage = response.data['percentage'].toString();
        notifyListeners();
      } else {
        throw Exception(
          'Failed to load Profile Model',
        );
      }
    } on DioError {
      // print("error on fetch profile ${e.response!.data}");
    }
  }

  Future<ProfileReceiverModel?> get userProfile async => _userProfile;
  ProfileReceiverModel? get gWAUserProfile => _userProfile;
}
