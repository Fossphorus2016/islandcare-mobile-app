import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:island_app/caregiver/models/profile_model.dart';
import 'package:island_app/res/app_url.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileProvider extends ChangeNotifier {
  // fetchPRofile
  ProfileGiverModel? fetchProfile;
  List badges = [];
  fetchProfileGiverModel() async {
    var token = await getUserToken();
    final response = await Dio().get(
      CareGiverUrl.serviceProviderProfile,
      options: Options(headers: {'Authorization': 'Bearer $token', 'Accept': 'application/json'}),
    );
    if (response.statusCode == 200) {
      fetchProfile = ProfileGiverModel.fromJson(response.data);
      badges = fetchProfile!.data!.userdetailprovider!.badge.toString().split(',');
      notifyListeners();
    }
  }

  getUserToken() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    var userToken = preferences.getString(
      'userToken',
    );
    return userToken.toString();
  }
}
