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
  setDefault() {
    fetchProfile = null;
    badges = [];
    profileStatus = false;
    profileIsLoading = true;
    dashboardIsLoading = true;
    searchIsLoading = false;
    providerIsVerified = false;
    userName = null;
    profilePerentage = '';
    serviceJobs = null;
    filterDataList = [];
    currentPageIndex = 0;
    rowsPerPage = 10;
    startIndex = 0;
    endIndex = 0;
    totalRowsCount = 0;
  }

  // fetchPRofile
  ProfileGiverModel? fetchProfile;
  List? badges = [];
  bool profileStatus = false;
  bool profileIsLoading = true;
  bool dashboardIsLoading = true;
  bool searchIsLoading = false;
  bool providerIsVerified = false;
  Future<bool> fetchProfileGiverModel() async {
    try {
      getUserName();
      var token = await getToken();
      final response = await getRequesthandler(
        url: CareGiverUrl.serviceProviderProfile,
        token: token,
      );
      if (response != null && response.statusCode == 200) {
        // await getProfilePercentage();
        fetchProfile = ProfileGiverModel.fromJson(response.data);
        profileStatus = fetchProfile!.data!.status == 1;
        providerIsVerified = response.data['isVerified'] == 1;
        profileIsLoading = false;
        profilePerentage = response.data['percentage'].toString();
        badges = fetchProfile!.data!.userdetailprovider!.badge != null ? fetchProfile!.data!.userdetailprovider!.badge.toString().split(',') : null;
        notifyListeners();
      }
      return true;
    } catch (e) {
      showErrorToast("Failed to fetch profile");
      return false;
    }
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
  // getProfilePercentage() async {
  //   var token = await getToken();

  //   final response = await postRequesthandler(
  //     url: CareGiverUrl.serviceProviderProfilePercentage,
  //     token: token,
  //   );
  //   if (response != null && response.statusCode == 200) {
  //     profilePerentage = response.data['percentage'].toString();
  //   }
  // }

// Dashborad work
  ServiceProviderDashboardModel? serviceJobs;
  fetchProviderDashboardModel() async {
    try {
      var token = await getToken();
      final response = await getRequesthandler(
        url: CareGiverUrl.serviceProviderDashboard,
        token: token,
      );
      dashboardIsLoading = false;
      notifyListeners();
      if (response != null && response.statusCode == 200) {
        // await getProfilePercentage();
        serviceJobs = ServiceProviderDashboardModel.fromJson(response.data);
        currentPageIndex = 0;
        setPaginationList(serviceJobs!.jobs);
        notifyListeners();
      } else {
        throw Exception(
          'Failed to load Service Provider Dashboard',
        );
      }
    } catch (e) {
      //
    }
  }

  Future<void> fetchFindedJobsDashboardModel(title, service, area, rate) async {
    searchIsLoading = true;
    notifyListeners();
    var token = await getToken();
    var serviceId = '';
    if (service != null) {
      serviceId = service;
    }
    final response = await postRequesthandler(
      url: CareGiverUrl.serviceProviderDashboardSearch,
      formData: FormData.fromMap({
        "title": title,
        "serviceType": serviceId,
        "area": area,
        "rate": rate,
      }),
      token: token,
    );

    searchIsLoading = false;
    notifyListeners();

    if (response != null && response.statusCode == 200) {
      serviceJobs = ServiceProviderDashboardModel.fromJson(response.data);
      currentPageIndex = 0;
      notifyListeners();
      setPaginationList(serviceJobs!.jobs);
    } else {
      throw Exception('Failed to load Service Jobs Dashboard');
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
      startIndex = currentPageIndex * rowsPerPage;
      endIndex = min(startIndex + rowsPerPage, data!.length);

      filterDataList = data.sublist(startIndex, endIndex).toList();
      totalRowsCount = (data.length / 10).ceil();
      notifyListeners();
      getCurrentPageData();
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
    currentPageIndex = 0;
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
    currentPageIndex = 0;
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
