// ignore_for_file: deprecated_member_use

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:island_app/carereceiver/models/profile_model.dart';
import 'package:island_app/utils/app_url.dart';
import 'package:island_app/utils/functions.dart';
import 'package:island_app/utils/http_handlers.dart';
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
  fetchProfileReceiverModel() async {
    var token = await getToken();
    try {
      final response = await getRequesthandler(
        url: CareReceiverURl.serviceReceiverProfile,
        token: token,
      );
      if (response.statusCode == 200) {
        profilePerentage = response.data['data']['percentage'];
        profileIsLoading = false;
        _userProfile = ProfileReceiverModel.fromJson(response.data);
        notifyListeners();
      } else {
        throw Exception('Failed to load Profile Model');
      }
    } on DioError {
      //
    }
  }

  Future<ProfileReceiverModel?> get userProfile async => _userProfile;
  ProfileReceiverModel? get gWAUserProfile => _userProfile;
}
