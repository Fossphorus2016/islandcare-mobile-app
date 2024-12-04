import 'dart:math';

import 'package:flutter/material.dart';
import 'package:island_app/carereceiver/models/service_receiver_dashboard_model.dart';
import 'package:island_app/utils/app_url.dart';
import 'package:island_app/utils/functions.dart';
import 'package:island_app/utils/http_handlers.dart';

class HomePaginationProvider extends ChangeNotifier {
  // List favouriteListTwo = [];
  var favouriteList = [];
  var ratingList = [];
  List<Map>? data = [
    {
      "id": "1",
      "name": "Senior Care",
    },
    {
      "id": "2",
      "name": "Pet Care",
    },
    {
      "id": "3",
      "name": "House Keeping",
    },
    {
      "id": "5",
      "name": "Child Care",
    },
    {
      "id": "4",
      "name": "School Support",
    },
  ];
  List<Map>? area = [
    {
      "id": 0,
      "name": "East",
    },
    {
      "id": 1,
      "name": "Central",
    },
    {
      "id": 2,
      "name": "West",
    },
    {
      "id": 3,
      "name": "No Preference",
    },
  ];
  List<Map>? rate = [
    {
      "id": 0,
      "name": "\$17-\$25",
    },
    {
      "id": 1,
      "name": "\$25-\$50",
    },
    {
      "id": 2,
      "name": "\$50-\$100",
    },
    {
      "id": 3,
      "name": "\$100+",
    },
    {
      "id": 4,
      "name": "No Prefrences",
    },
  ];
  bool showFoundText = false;
  String searchServiceName = "";
  Future<void> fetchReceiverDashboardModel(
      {required String? name, required String? serviceType, required String? location, required String? rate}) async {
    var token = await getToken();
    final response = await getRequesthandler(
      url:
          '${CareReceiverURl.serviceReceiverDashboard}?name=${name ?? ""}&serviceType=${serviceType ?? ""}&location=${location ?? ""}&rate=${rate ?? ""}',
      token: token,
    );

    if (response != null && response.statusCode == 200 && response.data["status"] == true) {
      if (response.data["data"] != null) {
        var data = response.data["data"];
        var listOfFavourites = data['favourites'] as List;
        favouriteList = listOfFavourites;
        searchServiceName = data["serviceName"];
        showFoundText = true;
        var modelData = ServiceReceiverDashboardModel.fromJson(response.data["data"]);
        setPaginationList(modelData.data);
        notifyListeners();
      }
    } else {
      showErrorToast("Failed to load Dashboard");
    }
  }

  fetchReceiverDashboardModelInInitCall() async {
    var token = await getToken();

    final response = await getRequesthandler(
      url: '${CareReceiverURl.serviceReceiverDashboard}?service=&search=&area=&rate=',
      token: token,
    );
    if (response != null && response.statusCode == 200 && response.data["status"] == true) {
      if (response.data["data"] != null) {
        var data = response.data["data"];
        // var listOfProviders = data['providers'] as List;
        var listOfFavourites = data['favourites'] as List;

        // providerList = listOfProviders;
        favouriteList = listOfFavourites;
        // foundProviders = listOfProviders;
        showFoundText = false;
        var modelData = ServiceReceiverDashboardModel.fromJson(response.data["data"]);

        // Double-check if widget is still mounted before using context
        setPaginationList(modelData.data);
        notifyListeners();
      }
    } else {
      showErrorToast("Failed to load Dashboard");
    }
  }

  // Favourite API
  Future<void> favourited(providerId) async {
    var url = '${CareReceiverURl.serviceReceiverAddFavourite}?favourite_id=$providerId';
    var token = await getToken();
    var response = await postRequesthandler(
      url: url,
      token: token,
    );
    if (response != null && response.statusCode == 200) {
      if (response.data["data"].toString() == "1") {
        favouriteList.add(providerId);
        showSuccessToast("Added To Favourite");
      } else {
        favouriteList.remove(providerId);
        showErrorToast("Remove from favourite");
      }
    } else {
      showSuccessToast("Favourite Is Not Added");
    }
    notifyListeners();
  }

  // Search bar
  // List foundProviders = [];
  List findProviders = [];
  setDefault() {
    isLoading = true;
    dataList = [];
    filterDataList = [];
    currentPageIndex = 0;
    rowsPerPage = 10;
    startIndex = 0;
    endIndex = 0;
    totalRowsCount = 0;
  }

  bool isLoading = true;
  // Get Documents
  List dataList = [];
  List filterDataList = [];
  int currentPageIndex = 0;
  int rowsPerPage = 10;
  int startIndex = 0;
  int endIndex = 0;
  int totalRowsCount = 0;

  setPaginationList(List? data) async {
    try {
      if (data != null && data.isNotEmpty) {
        dataList = data;
        startIndex = currentPageIndex * rowsPerPage;
        endIndex = min(startIndex + rowsPerPage, data.length);

        filterDataList = data.sublist(startIndex, endIndex).toList();
        totalRowsCount = (data.length / 10).ceil();
        // print("Total Rows Count $totalRowsCount");
        notifyListeners();
      } else {
        dataList = [];
        startIndex = 0;
        endIndex = 0;
        filterDataList = [];
        totalRowsCount = 0;
        notifyListeners();
      }
    } catch (error) {
      isLoading = false;
      notifyListeners();
    }
  }

  // Generate List per page
  getCurrentPageData() {
    startIndex = currentPageIndex * rowsPerPage;
    endIndex = min(startIndex + rowsPerPage, dataList.length);
    filterDataList = dataList.sublist(startIndex, endIndex).toList();
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
