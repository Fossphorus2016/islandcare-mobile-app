// ignore_for_file: prefer_null_aware_operators

import 'dart:math';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:island_app/caregiver/models/profile_model.dart';
import 'package:island_app/caregiver/models/service_provider_dashboard_model.dart';
import 'package:island_app/utils/app_url.dart';
import 'package:island_app/utils/functions.dart';
import 'package:island_app/utils/http_handlers.dart';
import 'package:island_app/utils/storage_service.dart';

class ServiceGiverProvider extends ChangeNotifier {
  // fetchPRofile
  ProfileGiverModel? fetchProfile;
  List? badges = [];
  bool profileStatus = false;
  bool profileIsLoading = true;
  bool dashboardIsLoading = true;
  bool searchIsLoading = false;
  bool providerIsVerified = false;
  fetchProfileGiverModel() async {
    getUserName();
    var token = await getUserToken();
    final response = await getRequesthandler(
      url: CareGiverUrl.serviceProviderProfile,
      token: token,
    );
    if (response.statusCode == 200) {
      fetchProfile = ProfileGiverModel.fromJson(response.data);
      profileStatus = fetchProfile!.data!.status == 1;
      providerIsVerified = response.data['isVerified'] == 1;
      profileIsLoading = false;
      badges = fetchProfile!.data!.userdetailprovider!.badge != null ? fetchProfile!.data!.userdetailprovider!.badge.toString().split(',') : null;
      notifyListeners();
    }
  }

  static String userToken = '';
  getUserToken() async {
    var token = await getToken();
    // print(userToken);
    if (token != null) {
      userToken = token;
    }
    return token.toString();
  }

  getUserId() async {
    var userId = await storageService.readSecureStorage('userId');
    return userId.toString();
  }

  String? userName;
  getUserName() async {
    var getUserName = await storageService.readSecureStorage('userName');
    userName = getUserName;
    notifyListeners();
  }

  String profilePerentage = '';
  getProfilePercentage() async {
    var token = await getUserToken();

    final response = await postRequesthandler(
      url: CareGiverUrl.serviceProviderProfilePercentage,
      token: token,
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
      final response = await getRequesthandler(
        url: CareGiverUrl.serviceProviderDashboard,
        token: token,
      );
      dashboardIsLoading = false;
      notifyListeners();
      if (response.statusCode == 200) {
        serviceJobs = ServiceProviderDashboardModel.fromJson(response.data);
        setPaginationList(serviceJobs!.jobs);
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

  Future<void> fetchFindedJobsDashboardModel(title, service, area, rate) async {
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
    final response = await postRequesthandler(
      url: CareGiverUrl.serviceProviderDashboardSearch,
      formData: FormData.fromMap({
        "title": title,
        "serviceType": serviceId,
        "area": area,
        "priceMin": minRate,
        "priceMax": maxRate,
      }),
      token: token,
    );
    // print(response);
    searchIsLoading = false;
    notifyListeners();

    // Navigator.pop(context);
    if (response.statusCode == 200) {
      serviceJobs = ServiceProviderDashboardModel.fromJson(response.data);
      setPaginationList(serviceJobs!.jobs);
      notifyListeners();
    } else {
      throw Exception(
        'Failed to load Service Jobs Dashboard',
      );
    }
  }

  // pagination start here

  List filterDataList = [];
  int currentPageIndex = 0;
  int rowsPerPage = 10;
  int startIndex = 0;
  int endIndex = 0;
  int totalRowsCount = 0;

  setPaginationList(List? data) async {
    try {
      // if (data != null && data.isNotEmpty) {
      // hiredCandidates = data;
      startIndex = currentPageIndex * rowsPerPage;
      endIndex = min(startIndex + rowsPerPage, data!.length);

      filterDataList = data.sublist(startIndex, endIndex).toList();
      totalRowsCount = (data.length / 10).floor();
      notifyListeners();
      // }
    } catch (error) {
      //
    }
  }

  setFilter(String searchText) {
    var filterData = serviceJobs!.jobs!.where((element) {
      if (element.jobTitle.toString().toLowerCase().contains(searchText.toLowerCase()) || element.address.toString().toLowerCase().contains(searchText.toLowerCase())) {
        return true;
      } else {
        return false;
      }
    }).toList();

    setPaginationList(filterData);

    notifyListeners();
  }

  clearFilter() {
    setPaginationList(serviceJobs!.jobs);
    notifyListeners();
  }

  setFilterByTime(DateTime startTime, DateTime endTime) {
    var filterData = serviceJobs!.jobs!.where((element) {
      var docTime = element.updatedAt;
      if (startTime.isBefore(DateTime.parse(docTime!)) && endTime.isAfter(DateTime.parse(docTime))) {
        return true;
      } else {
        return false;
      }
    }).toList();
    setPaginationList(filterData);
    notifyListeners();
  }

  // Generate List per page
  getCurrentPageData() {
    startIndex = currentPageIndex * rowsPerPage;
    endIndex = min(startIndex + rowsPerPage, serviceJobs!.jobs!.length);
    filterDataList = serviceJobs!.jobs!.sublist(startIndex, endIndex).toList();
    notifyListeners();
  }

  // handle page change function
  void handlePageChange(int pageIndex) {
    currentPageIndex = pageIndex;
    getCurrentPageData();
    notifyListeners();
  }

  // handle row change function
  void handleRowsPerPageChange(int rowsperPage) {
    rowsPerPage = rowsperPage;
    getCurrentPageData();
    notifyListeners();
  }
}
