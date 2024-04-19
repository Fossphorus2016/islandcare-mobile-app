import 'dart:math';

import 'package:flutter/material.dart';

class HomePaginationProvider extends ChangeNotifier {
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
        totalRowsCount = (data.length / 10).floor();
        notifyListeners();
      }
    } catch (error) {
      isLoading = false;
      notifyListeners();
    }
  }

  // setFilter(String searchText) {
  //   filterDocuments = filterDocuments.where((element) {
  //     if (element.expandedValue['document_title']
  //             .toString()
  //             .toLowerCase()
  //             .contains(searchText.toLowerCase()) ||
  //         element.expandedValue['file_type']
  //             .toString()
  //             .toLowerCase()
  //             .contains(searchText.toLowerCase()) ||
  //         element.expandedValue['property']['property_name']
  //             .toString()
  //             .toLowerCase()
  //             .contains(searchText.toLowerCase()) ||
  //         element.expandedValue['category']
  //             .toString()
  //             .toLowerCase()
  //             .contains(searchText.toLowerCase())) {
  //       return true;
  //     } else {
  //       return false;
  //     }
  //   }).toList();
  //   notifyListeners();
  // }

  // clearFilter() {
  //   filterDocuments.clear();
  //   notifyListeners();
  // }

  // setDefaultFilter() {
  //   filterDocuments = documents.sublist(startIndex, endIndex).toList();
  //   notifyListeners();
  // }

  // setFilterByTime(DateTime startTime, DateTime endTime) {
  //   filterDocuments = filterDocuments.where((element) {
  //     var docTime = element.expandedValue['updated_at'];
  //     if (startTime.isBefore(DateTime.parse(docTime)) &&
  //         endTime.isAfter(DateTime.parse(docTime))) {
  //       return true;
  //     } else {
  //       return false;
  //     }
  //   }).toList();
  //   notifyListeners();
  // }

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
