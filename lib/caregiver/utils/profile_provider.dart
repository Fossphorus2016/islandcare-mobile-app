// ignore_for_file: prefer_null_aware_operators

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:island_app/caregiver/models/profile_model.dart';
import 'package:island_app/caregiver/models/service_provider_dashboard_model.dart';
import 'package:island_app/res/app_url.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ServiceGiverProvider extends ChangeNotifier {
  // fetchPRofile
  ProfileGiverModel? fetchProfile;
  List? badges = [];
  bool profileStatus = false;
  bool profileIsLoading = true;
  bool dashboardIsLoading = true;
  bool searchIsLoading = false;
  fetchProfileGiverModel() async {
    getUserName();
    var token = await getUserToken();
    final response = await Dio().get(
      CareGiverUrl.serviceProviderProfile,
      options: Options(headers: {'Authorization': 'Bearer $token', 'Accept': 'application/json'}),
    );
    if (response.statusCode == 200) {
      // print(response.data['data']["avg_rating"].runtimeType);
      fetchProfile = ProfileGiverModel.fromJson(response.data);
      profileStatus = fetchProfile!.data!.status == 1;
      profileIsLoading = false;
      badges = fetchProfile!.data!.userdetailprovider!.badge != null ? fetchProfile!.data!.userdetailprovider!.badge.toString().split(',') : null;
      notifyListeners();
    }
  }

  getUserToken() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    var userToken = preferences.getString('userToken');
    // print(userToken);
    return userToken.toString();
  }

  getUserId() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    var userId = preferences.getString('userId');
    return userId.toString();
  }

  String? userName;
  getUserName() async {
    SharedPreferences? prefs = await SharedPreferences.getInstance();
    await prefs.reload();
    var getUserName = prefs.getString('userName');
    userName = getUserName;
    notifyListeners();
  }

  String profilePerentage = '';
  getProfilePercentage() async {
    var token = await getUserToken();

    final response = await Dio().post(
      CareGiverUrl.serviceProviderProfilePercentage,
      options: Options(headers: {'Authorization': 'Bearer $token', 'Accept': 'application/json'}),
    );
    if (response.statusCode == 200) {
      profilePerentage = response.data['percentage'].toString();
    }
  }

// Dashborad work
  ServiceProviderDashboardModel? serviceJobs;
  fetchProviderDashboardModel() async {
    try {
      var token = await getUserToken();
      final response = await Dio().get(
        CareGiverUrl.serviceProviderDashboard,
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Accept': 'application/json',
          },
        ),
      );
      dashboardIsLoading = false;
      notifyListeners();
      if (response.statusCode == 200) {
        serviceJobs = ServiceProviderDashboardModel.fromJson(response.data);
        notifyListeners();
      } else {
        throw Exception(
          'Failed to load Service Provider Dashboard',
        );
      }
    } catch (e) {
      // print(e.toString());
    }
  }

  fetchFindedJobsDashboardModel(title, service, area, rate) async {
    searchIsLoading = true;
    notifyListeners();
    var token = await getUserToken();
    // print(token);
    var minRate = "";
    var maxRate = "";
    if (rate != null && rate!['id'] != 0) {
      maxRate = rate!['maxValue'];
      minRate = rate!['minValue'];
    }
    var serviceId = '';
    // print(service);
    if (service != null) {
      serviceId = service;
    }
    final response = await Dio().post(
      CareGiverUrl.serviceProviderDashboardSearch,
      data: {
        "title": title,
        "serviceType": serviceId,
        "area": area,
        "priceMin": minRate,
        "priceMax": maxRate,
      },
      options: Options(
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      ),
    );
    // print(response);
    searchIsLoading = false;
    notifyListeners();

    // Navigator.pop(context);
    if (response.statusCode == 200) {
      serviceJobs = ServiceProviderDashboardModel.fromJson(response.data);
      notifyListeners();
    } else {
      throw Exception(
        'Failed to load Service Jobs Dashboard',
      );
    }
  }
}
