import 'dart:math';

import 'package:flutter/material.dart';

class HomePaginationProvider extends ChangeNotifier {
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
