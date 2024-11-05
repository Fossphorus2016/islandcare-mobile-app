// ignore_for_file: use_build_context_synchronously, unnecessary_null_comparison

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:island_app/caregiver/models/service_provider_job_board_model.dart';
import 'package:island_app/utils/app_colors.dart';
import 'package:island_app/utils/functions.dart';
import 'package:island_app/utils/http_handlers.dart';
import 'package:island_app/carereceiver/utils/colors.dart';
import 'package:island_app/carereceiver/widgets/job_cart_widget.dart';
import 'package:island_app/utils/app_url.dart';
import 'package:island_app/utils/navigation_service.dart';
import 'package:island_app/utils/routes_name.dart';
import 'package:island_app/widgets/custom_pagination.dart';
import 'package:provider/provider.dart';

class ServiceProviderJobs extends StatefulWidget {
  const ServiceProviderJobs({super.key});

  @override
  State<ServiceProviderJobs> createState() => _ServiceProviderJobsState();
}

class _ServiceProviderJobsState extends State<ServiceProviderJobs> {
  String? dropdownValue = 'All Relevance';
  Future<void> _showDeleteDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(
                  'Deleted',
                  style: TextStyle(
                    color: CustomColors.primaryText,
                    fontSize: 26,
                    fontFamily: "Rubik",
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Text(
                  'Are you sure you want to Delete?',
                  style: TextStyle(
                    color: CustomColors.hintText,
                    fontSize: 16,
                    fontFamily: "Rubik",
                    fontWeight: FontWeight.w300,
                  ),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text(
                'Cancel',
                style: TextStyle(
                  color: CustomColors.primaryColor,
                  fontSize: 16,
                  fontFamily: "Rubik",
                  fontWeight: FontWeight.w600,
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text(
                'Ok',
                style: TextStyle(
                  color: CustomColors.primaryColor,
                  fontSize: 16,
                  fontFamily: "Rubik",
                  fontWeight: FontWeight.w600,
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    Provider.of<GiverMyJobsProvider>(context, listen: false).fetchServiceProviderJobBoardModel(context);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<GiverMyJobsProvider>(builder: (context, provider, __) {
      return SafeArea(
        child: Scaffold(
          appBar: AppBar(
            centerTitle: false,
            elevation: 0,
            backgroundColor: Colors.transparent,
            automaticallyImplyLeading: false,
            leading: GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: Padding(
                padding: const EdgeInsets.all(13.0),
                child: Container(
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: const Color(0xffffffff),
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: const [
                      BoxShadow(
                        color: Color.fromARGB(30, 0, 0, 0),
                        offset: Offset(2, 2),
                        spreadRadius: 1,
                        blurRadius: 7,
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 4.0),
                    child: Icon(
                      Icons.arrow_back_ios,
                      color: CustomColors.primaryColor,
                      size: 18,
                    ),
                  ),
                ),
              ),
            ),
            title: Text(
              "My Jobs",
              style: TextStyle(
                fontSize: 19,
                fontWeight: FontWeight.w600,
                fontFamily: "Rubik",
                color: CustomColors.primaryText,
              ),
            ),
          ),
          body: provider.isLoading
              ? const Center(
                  child: CircularProgressIndicator(),
                )
              : SizedBox(
                  height: MediaQuery.of(context).size.height,
                  width: MediaQuery.of(context).size.width,
                  child: Column(
                    children: [
                      Expanded(
                        child: RefreshIndicator(
                          onRefresh: () => provider.fetchServiceProviderJobBoardModel(context),
                          child: CustomScrollView(
                            slivers: [
                              SliverToBoxAdapter(
                                child: SizedBox(
                                  child: Stack(
                                    children: [
                                      Container(
                                        decoration: const BoxDecoration(color: Colors.transparent),
                                        alignment: Alignment.centerRight,
                                        width: MediaQuery.of(context).size.width,
                                        height: 100,
                                        child: const RotatedBox(
                                          quarterTurns: 1,
                                          child: Text(
                                            'Container 1',
                                            style: TextStyle(fontSize: 18.0, color: Colors.white),
                                          ),
                                        ),
                                      ),
                                      Positioned(
                                        top: -25,
                                        child: Container(
                                          padding: const EdgeInsets.symmetric(horizontal: 20),
                                          decoration: BoxDecoration(
                                            color: ServiceGiverColor.black,
                                            borderRadius: const BorderRadius.only(
                                              bottomLeft: Radius.circular(12),
                                              bottomRight: Radius.circular(12),
                                            ),
                                          ),
                                          alignment: Alignment.centerLeft,
                                          width: MediaQuery.of(context).size.width,
                                          height: 100,
                                          child: Text(
                                            "My Jobs",
                                            style: TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.w700,
                                              fontFamily: "Rubik",
                                              color: CustomColors.white,
                                            ),
                                          ),
                                        ),
                                      ),
                                      Positioned(
                                        bottom: 10,
                                        right: 20,
                                        left: 20,
                                        child: Container(
                                          decoration: const BoxDecoration(
                                            borderRadius: BorderRadius.only(
                                              topLeft: Radius.circular(6),
                                              bottomLeft: Radius.circular(6),
                                              bottomRight: Radius.circular(6),
                                              topRight: Radius.circular(6),
                                            ),
                                          ),
                                          alignment: Alignment.center,
                                          width: MediaQuery.of(context).size.width,
                                          height: 40,
                                          child: Row(
                                            children: [
                                              Expanded(
                                                child: DecoratedBox(
                                                  decoration: const BoxDecoration(
                                                    boxShadow: [
                                                      BoxShadow(
                                                        color: Color.fromARGB(13, 0, 0, 0),
                                                        blurRadius: 4.0,
                                                        spreadRadius: 2.0,
                                                        offset: Offset(2.0, 2.0),
                                                      ),
                                                    ],
                                                  ),
                                                  child: TextFormField(
                                                    onChanged: (value) {
                                                      if (value.isEmpty) {
                                                        provider.clearFilter();
                                                        return;
                                                      }
                                                      provider.setFilter(value);
                                                    },
                                                    maxLines: 1,
                                                    textAlignVertical: TextAlignVertical.bottom,
                                                    style: const TextStyle(fontSize: 16, fontFamily: "Rubik", fontWeight: FontWeight.w400),
                                                    decoration: InputDecoration(
                                                      hintText: "Search...",
                                                      fillColor: CustomColors.white,
                                                      focusColor: CustomColors.white,
                                                      hoverColor: CustomColors.white,
                                                      filled: true,
                                                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(4)),
                                                      focusedBorder: OutlineInputBorder(
                                                        borderSide: BorderSide(color: CustomColors.white, width: 2.0),
                                                        borderRadius: BorderRadius.circular(4.0),
                                                      ),
                                                      enabledBorder: OutlineInputBorder(
                                                        borderSide: BorderSide(color: CustomColors.white, width: 2.0),
                                                        borderRadius: BorderRadius.circular(4.0),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              const SizedBox(width: 10),
                                              TextButton(
                                                onPressed: () {
                                                  showModalBottomSheet(
                                                    isScrollControlled: true,
                                                    shape: const RoundedRectangleBorder(
                                                      borderRadius: BorderRadius.only(topLeft: Radius.circular(30.0), topRight: Radius.circular(30.0)),
                                                    ),
                                                    context: context,
                                                    backgroundColor: Colors.white,
                                                    builder: (BuildContext context) {
                                                      String? startTime;
                                                      String? endTime;
                                                      return StatefulBuilder(
                                                        builder: (BuildContext context, StateSetter setState) {
                                                          return SingleChildScrollView(
                                                            child: Padding(
                                                              padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
                                                              child: Container(
                                                                padding: const EdgeInsets.symmetric(horizontal: 25),
                                                                child: Column(
                                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                                  mainAxisSize: MainAxisSize.min,
                                                                  children: [
                                                                    const SizedBox(height: 20),
                                                                    Center(
                                                                      child: Container(
                                                                        width: 130,
                                                                        height: 5,
                                                                        decoration: BoxDecoration(
                                                                          color: const Color(0xffC4C4C4),
                                                                          borderRadius: BorderRadius.circular(6),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                    const SizedBox(height: 10),
                                                                    Column(
                                                                      mainAxisAlignment: MainAxisAlignment.start,
                                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                                      children: [
                                                                        Center(
                                                                          child: Text(
                                                                            "Apply Filter",
                                                                            style: TextStyle(
                                                                              fontSize: 18,
                                                                              color: CustomColors.primaryText,
                                                                              fontFamily: "Poppins",
                                                                              fontWeight: FontWeight.w600,
                                                                            ),
                                                                          ),
                                                                        ),
                                                                        const SizedBox(height: 20),
                                                                        Column(
                                                                          crossAxisAlignment: CrossAxisAlignment.start,
                                                                          children: [
                                                                            Text(
                                                                              "Start Date",
                                                                              style: TextStyle(
                                                                                fontFamily: "Rubik",
                                                                                fontWeight: FontWeight.w600,
                                                                                color: CustomColors.primaryText,
                                                                              ),
                                                                            ),
                                                                            const SizedBox(height: 5),
                                                                            DecoratedBox(
                                                                              decoration: BoxDecoration(
                                                                                borderRadius: const BorderRadius.only(
                                                                                  topLeft: Radius.circular(6),
                                                                                  bottomLeft: Radius.circular(6),
                                                                                  bottomRight: Radius.circular(6),
                                                                                  topRight: Radius.circular(6),
                                                                                ),
                                                                                color: CustomColors.white,
                                                                                boxShadow: const [
                                                                                  BoxShadow(
                                                                                    color: Color.fromARGB(13, 0, 0, 0),
                                                                                    blurRadius: 4.0,
                                                                                    spreadRadius: 2.0,
                                                                                    offset: Offset(2.0, 2.0),
                                                                                  ),
                                                                                ],
                                                                              ),
                                                                              child: Padding(
                                                                                padding: const EdgeInsets.symmetric(
                                                                                  horizontal: 7,
                                                                                  vertical: 1,
                                                                                ),
                                                                                child: InkWell(
                                                                                  onTap: () async {
                                                                                    var tt = await showDatePicker(
                                                                                      context: context,
                                                                                      initialEntryMode: DatePickerEntryMode.calendarOnly,
                                                                                      firstDate: DateTime(2020, 1, 1),
                                                                                      lastDate: DateTime.now(),
                                                                                    );

                                                                                    if (tt != null) {
                                                                                      setState(() {
                                                                                        startTime = DateFormat('yyyy-MM-dd').format(tt);
                                                                                      });
                                                                                    }
                                                                                  },
                                                                                  child: Container(
                                                                                    height: 50,
                                                                                    width: double.infinity,
                                                                                    alignment: Alignment.centerLeft,
                                                                                    child: Text(
                                                                                      startTime != null ? startTime.toString() : "Start Date",
                                                                                    ),
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                            ),
                                                                          ],
                                                                        ),
                                                                        const SizedBox(height: 20),
                                                                        Column(
                                                                          crossAxisAlignment: CrossAxisAlignment.start,
                                                                          children: [
                                                                            Text(
                                                                              "End Date",
                                                                              style: TextStyle(
                                                                                fontFamily: "Rubik",
                                                                                fontWeight: FontWeight.w600,
                                                                                color: CustomColors.primaryText,
                                                                              ),
                                                                            ),
                                                                            const SizedBox(height: 5),
                                                                            DecoratedBox(
                                                                              decoration: BoxDecoration(
                                                                                borderRadius: const BorderRadius.only(
                                                                                  topLeft: Radius.circular(6),
                                                                                  bottomLeft: Radius.circular(6),
                                                                                  bottomRight: Radius.circular(6),
                                                                                  topRight: Radius.circular(6),
                                                                                ),
                                                                                color: CustomColors.white,
                                                                                boxShadow: const [
                                                                                  BoxShadow(
                                                                                    color: Color.fromARGB(13, 0, 0, 0),
                                                                                    blurRadius: 4.0,
                                                                                    spreadRadius: 2.0,
                                                                                    offset: Offset(2.0, 2.0),
                                                                                  ),
                                                                                ],
                                                                              ),
                                                                              child: Padding(
                                                                                padding: const EdgeInsets.symmetric(
                                                                                  horizontal: 7,
                                                                                  vertical: 1,
                                                                                ),
                                                                                child: InkWell(
                                                                                  onTap: () async {
                                                                                    var tt = await showDatePicker(
                                                                                      context: context,
                                                                                      initialEntryMode: DatePickerEntryMode.calendarOnly,
                                                                                      firstDate: DateTime(2020, 1, 1),
                                                                                      lastDate: DateTime.now(),
                                                                                    );
                                                                                    if (tt != null) {
                                                                                      setState(() {
                                                                                        endTime = DateFormat('yyyy-MM-dd').format(tt);
                                                                                      });
                                                                                    }
                                                                                  },
                                                                                  child: Container(
                                                                                    height: 50,
                                                                                    width: double.infinity,
                                                                                    decoration: const BoxDecoration(color: Colors.white),
                                                                                    alignment: Alignment.centerLeft,
                                                                                    child: Text(
                                                                                      endTime != null ? endTime.toString() : "End Date",
                                                                                    ),
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                            ),
                                                                          ],
                                                                        ),
                                                                        const SizedBox(height: 30),
                                                                        GestureDetector(
                                                                          onTap: () {
                                                                            if (startTime != null && endTime != null) {
                                                                              provider.setFilterByTime(DateTime.parse(startTime!), DateTime.parse(endTime!));
                                                                              Navigator.pop(context);
                                                                            } else {
                                                                              showErrorToast("Please select start and end date.");
                                                                            }
                                                                          },
                                                                          child: Container(
                                                                            width: MediaQuery.of(context).size.width,
                                                                            height: 54,
                                                                            decoration: BoxDecoration(
                                                                              color: ServiceRecieverColor.primaryColor,
                                                                              borderRadius: BorderRadius.circular(10),
                                                                            ),
                                                                            child: Center(
                                                                              child: Text(
                                                                                "Search",
                                                                                style: TextStyle(
                                                                                  color: CustomColors.white,
                                                                                  fontFamily: "Rubik",
                                                                                  fontStyle: FontStyle.normal,
                                                                                  fontWeight: FontWeight.w500,
                                                                                  fontSize: 18,
                                                                                ),
                                                                              ),
                                                                            ),
                                                                          ),
                                                                        ),
                                                                        const SizedBox(height: 15),
                                                                        GestureDetector(
                                                                          onTap: () {
                                                                            provider.clearFilter();
                                                                            Navigator.pop(context);
                                                                          },
                                                                          child: Container(
                                                                            width: MediaQuery.of(context).size.width,
                                                                            height: 54,
                                                                            decoration: BoxDecoration(
                                                                              color: ServiceRecieverColor.redButton,
                                                                              borderRadius: BorderRadius.circular(10),
                                                                            ),
                                                                            child: Center(
                                                                              child: Text(
                                                                                "Clear",
                                                                                style: TextStyle(
                                                                                  color: CustomColors.white,
                                                                                  fontFamily: "Rubik",
                                                                                  fontStyle: FontStyle.normal,
                                                                                  fontWeight: FontWeight.w500,
                                                                                  fontSize: 18,
                                                                                ),
                                                                              ),
                                                                            ),
                                                                          ),
                                                                        ),
                                                                        const SizedBox(height: 30),
                                                                      ],
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                            ),
                                                          );
                                                        },
                                                      );
                                                    },
                                                  );
                                                },
                                                style: ButtonStyle(
                                                  shape: WidgetStateProperty.resolveWith(
                                                    (states) => RoundedRectangleBorder(borderRadius: BorderRadius.circular(08)),
                                                  ),
                                                  backgroundColor: WidgetStateProperty.resolveWith(
                                                    (states) => ServiceRecieverColor.redButton,
                                                  ),
                                                ),
                                                child: const Row(
                                                  children: [
                                                    Icon(
                                                      Icons.calendar_month,
                                                      color: Colors.white,
                                                      size: 20,
                                                    ),
                                                    SizedBox(width: 05),
                                                    Text(
                                                      "Filter",
                                                      style: TextStyle(color: Colors.white, fontSize: 18),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              SliverToBoxAdapter(
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                                  child: Column(
                                    children: [
                                      ListView.builder(
                                        itemCount: provider.filterDataList.length,
                                        shrinkWrap: true,
                                        padding: const EdgeInsets.only(top: 16),
                                        physics: const NeverScrollableScrollPhysics(),
                                        itemBuilder: (context, index) {
                                          if (provider.allJobs!.isEmpty) {
                                            return Container(
                                                width: MediaQuery.of(context).size.width,
                                                alignment: Alignment.center,
                                                padding: const EdgeInsets.all(20),
                                                decoration: const BoxDecoration(
                                                  borderRadius: BorderRadius.only(
                                                    topLeft: Radius.circular(10),
                                                    topRight: Radius.circular(10),
                                                    bottomLeft: Radius.circular(10),
                                                    bottomRight: Radius.circular(10),
                                                  ),
                                                  boxShadow: [
                                                    BoxShadow(
                                                      color: Color.fromRGBO(26, 41, 96, 0.05999999865889549),
                                                      offset: Offset(0, 4),
                                                      blurRadius: 45,
                                                    )
                                                  ],
                                                  color: Color.fromRGBO(255, 255, 255, 1),
                                                ),
                                                child: const Text("0 Jobs Found"));
                                          }
                                          var job = provider.filterDataList[index];
                                          return Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: JobBoardCartWidget(
                                              jobTitle: job.jobTitle.toString(),
                                              jobType: job.service!.name.toString(),
                                              delete: () {
                                                _showDeleteDialog();
                                              },
                                              detail: () {
                                                navigationService.push(RoutesName.myJobDetailGiver, arguments: {"id": job.id.toString(), "service": job.service!.name.toString()});
                                              },
                                            ),
                                          );
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width,
                        child: CustomPagination(
                          nextPage: (provider.currentPageIndex) < provider.totalRowsCount
                              ? () {
                                  provider.handlePageChange(provider.currentPageIndex + 1);
                                }
                              : null,
                          previousPage: provider.currentPageIndex > 0 ? () => provider.handlePageChange(provider.currentPageIndex - 1) : null,
                          gotoPage: provider.handlePageChange,
                          gotoFirstPage: provider.currentPageIndex > 0 ? () => provider.handlePageChange(0) : null,
                          gotoLastPage: (provider.currentPageIndex) < provider.totalRowsCount ? () => provider.handlePageChange(provider.totalRowsCount) : null,
                          currentPageIndex: provider.currentPageIndex,
                          totalRowsCount: provider.totalRowsCount,
                        ),
                      ),
                    ],
                  ),
                ),
        ),
      );
    });
  }
}

class GiverMyJobsProvider extends ChangeNotifier {
  setDefault() {
    isLoading = true;
    allJobs = [];
    fetchJobBoard = null;
    filterDataList = [];
    currentPageIndex = 0;
    rowsPerPage = 10;
    startIndex = 0;
    endIndex = 0;
    totalRowsCount = 0;
  }

  bool isLoading = true;
  List? allJobs = [];
  ServiceProviderJobBoardModel? fetchJobBoard;

  fetchServiceProviderJobBoardModel(BuildContext context) async {
    var token = await getToken();
    final response = await getRequesthandler(
      url: CareGiverUrl.serviceProviderAllJob,
      token: token,
    );
    isLoading = false;
    notifyListeners();
    if (response.statusCode == 200) {
      fetchJobBoard = ServiceProviderJobBoardModel.fromJson(response.data);
      allJobs = fetchJobBoard!.job;
      setPaginationList(allJobs);
      notifyListeners();
    } else {
      showErrorToast('Failed to load Profile Model');
    }
  }

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
      totalRowsCount = (data.length / 10).floor();
      notifyListeners();
    } catch (error) {
      //
    }
  }

  setFilter(String searchText) {
    var filterData = allJobs!.where((element) {
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
    setPaginationList(allJobs!);
    notifyListeners();
  }

  setFilterByTime(DateTime startTime, DateTime endTime) {
    var filterData = allJobs!
        .map((element) {
          // print(element.updatedAt);
          var docTime = element.updatedAt;
          if (startTime.isBefore(DateTime.parse(docTime!)) && endTime.isAfter(DateTime.parse(docTime))) {
            return element;
          }
        })
        .nonNulls
        .toList();
    setPaginationList(filterData);
    notifyListeners();
  }

  // Generate List per page
  getCurrentPageData() {
    startIndex = currentPageIndex * rowsPerPage;
    endIndex = min(startIndex + rowsPerPage, allJobs!.length);
    filterDataList = allJobs!.sublist(startIndex, endIndex).toList();
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
