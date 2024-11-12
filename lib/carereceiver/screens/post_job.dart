// ignore_for_file: use_build_context_synchronously

import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:island_app/carereceiver/utils/colors.dart';
import 'package:island_app/models/service_model.dart';
import 'package:island_app/utils/app_colors.dart';
import 'package:island_app/utils/app_url.dart';
import 'package:island_app/utils/functions.dart';
import 'package:island_app/utils/http_handlers.dart';
import 'package:island_app/utils/navigation_service.dart';
import 'package:island_app/utils/routes_name.dart';
import 'package:island_app/widgets/custom_pagination.dart';
import 'package:provider/provider.dart';

class PostJobScreen extends StatefulWidget {
  const PostJobScreen({super.key});

  @override
  State<PostJobScreen> createState() => _PostJobScreenState();
}

class _PostJobScreenState extends State<PostJobScreen> {
  @override
  void initState() {
    super.initState();
    Provider.of<PostedJobsProvider>(context, listen: false).fetchAllJobs();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Consumer<PostedJobsProvider>(builder: (context, provider, index) {
        return Scaffold(
          appBar: AppBar(
            centerTitle: false,
            elevation: 0,
            backgroundColor: Colors.transparent,
            automaticallyImplyLeading: false,
            title: const Text(
              "My Jobs",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  navigationService.push(RoutesName.recieverPostNewJob);
                },
                style: ButtonStyle(
                  shape: WidgetStateProperty.resolveWith((states) => RoundedRectangleBorder(borderRadius: BorderRadius.circular(08))),
                  backgroundColor: WidgetStateProperty.resolveWith((states) => ServiceRecieverColor.redButton),
                ),
                child: const Row(
                  children: [
                    Icon(
                      Icons.add,
                      color: Colors.white,
                      size: 20,
                    ),
                    SizedBox(width: 05),
                    Text(
                      "Add New Post",
                      style: TextStyle(color: Colors.white, fontSize: 14),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 20),
            ],
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
                      color: ServiceRecieverColor.primaryColor,
                      size: 18,
                    ),
                  ),
                ),
              ),
            ),
          ),
          body: provider.isLoading
              ? Center(
                  child: CircularProgressIndicator(
                    color: ServiceRecieverColor.primaryColor,
                  ),
                )
              : SizedBox(
                  height: MediaQuery.of(context).size.height - // total height
                      kToolbarHeight - // top AppBar height
                      MediaQuery.of(context).padding.top - // top padding
                      kBottomNavigationBarHeight -
                      10,
                  child: Column(
                    children: [
                      Expanded(
                        child: RefreshIndicator(
                          onRefresh: () => provider.fetchAllJobs(),
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
                                            color: ServiceRecieverColor.primaryColor,
                                            borderRadius: const BorderRadius.only(
                                              bottomLeft: Radius.circular(12),
                                              bottomRight: Radius.circular(12),
                                            ),
                                          ),
                                          alignment: Alignment.centerLeft,
                                          width: MediaQuery.of(context).size.width,
                                          height: 100,
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                "Find Your Job",
                                                style: TextStyle(
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.w700,
                                                  fontFamily: "Rubik",
                                                  color: CustomColors.white,
                                                ),
                                              ),
                                            ],
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
                                                  child: TextField(
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
                                                        borderRadius: BorderRadius.circular(8),
                                                      ),
                                                      enabledBorder: OutlineInputBorder(
                                                        borderSide: BorderSide(color: CustomColors.white, width: 2.0),
                                                        borderRadius: BorderRadius.circular(8),
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
                                                      String startTime = '';
                                                      String endTime = '';
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
                                                                                      // ignore: unnecessary_null_comparison
                                                                                      startTime != null && startTime.isNotEmpty ? startTime.toString() : "Start Date",
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
                                                                                      // ignore: unnecessary_null_comparison
                                                                                      endTime != null && endTime.isNotEmpty ? endTime.toString() : "End Date",
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
                                                                            if (startTime.isNotEmpty && endTime.isNotEmpty) {
                                                                              provider.setFilterByTime(DateTime.parse(startTime), DateTime.parse(endTime));
                                                                            } else {
                                                                              provider.clearFilter();
                                                                            }
                                                                            Navigator.pop(context);
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
                                                                        const SizedBox(height: 10),
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
                                        physics: const NeverScrollableScrollPhysics(),
                                        cacheExtent: 10,
                                        itemBuilder: (context, index) {
                                          var item = provider.filterDataList[index];

                                          return Container(
                                            padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
                                            width: MediaQuery.of(context).size.width,
                                            decoration: BoxDecoration(
                                              border: Border(
                                                bottom: BorderSide(
                                                  color: CustomColors.borderLight,
                                                  width: 0.1,
                                                ),
                                              ),
                                            ),
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              crossAxisAlignment: CrossAxisAlignment.center,
                                              children: [
                                                Expanded(
                                                  child: Column(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      Text(
                                                        item.jobTitle.toString(),
                                                        maxLines: 2,
                                                        overflow: TextOverflow.ellipsis,
                                                        style: TextStyle(
                                                          color: CustomColors.primaryText,
                                                          fontFamily: "Poppins",
                                                          fontWeight: FontWeight.w600,
                                                          fontSize: 14,
                                                        ),
                                                      ),
                                                      Text(
                                                        item!.service!.name.toString(),
                                                        style: TextStyle(
                                                          color: CustomColors.hintText,
                                                          fontFamily: "Poppins",
                                                          fontWeight: FontWeight.w500,
                                                          fontSize: 12,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                GestureDetector(
                                                  onTap: () {
                                                    navigationService.push(RoutesName.serviceRecieverJobDetail, arguments: {
                                                      "serviceId": item!.serviceId.toString(),
                                                      "jobData": item.data,
                                                    });
                                                  },
                                                  child: Container(
                                                    height: 24,
                                                    width: 24,
                                                    decoration: BoxDecoration(
                                                      borderRadius: BorderRadius.circular(05),
                                                      color: ServiceRecieverColor.redButton,
                                                    ),
                                                    child: const Center(
                                                      child: Icon(
                                                        Icons.arrow_forward_outlined,
                                                        color: Colors.white,
                                                        size: 16,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
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
        );
      }),
    );
  }
}

class AllJobModel {
  AllJobModel({
    this.jobList,
  });

  List<JobDetail>? jobList;

  factory AllJobModel.fromJson(Map<String, dynamic> json) => AllJobModel(
        jobList: json["job"] == null ? [] : List<JobDetail>.from(json["job"]!.map((x) => JobDetail.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "job": jobList == null ? [] : List<dynamic>.from(jobList!.map((x) => x.toJson())),
      };
}

class JobDetail {
  JobDetail({
    this.data,
    this.id,
    this.jobTitle,
    this.serviceId,
    this.address,
    this.location,
    this.deletedAt,
    this.createdAt,
    this.updatedAt,
    this.isFunded,
    this.service,
  });
  Map? data;
  int? id;
  String? jobTitle;
  int? serviceId;
  String? address;
  String? location;
  dynamic deletedAt;
  String? createdAt;
  String? updatedAt;
  int? isFunded;
  Service? service;

  factory JobDetail.fromJson(Map<String, dynamic> json) => JobDetail(
        data: json,
        id: json["id"],
        jobTitle: json["job_title"],
        serviceId: json["service_id"],
        address: json["address"],
        location: json["location"],
        deletedAt: json["deleted_at"],
        createdAt: json["created_at"],
        updatedAt: json["updated_at"],
        isFunded: json["is_funded"],
        service: json["service"] == null ? null : Service.fromJson(json["service"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "job_title": jobTitle,
        "service_id": serviceId,
        "address": address,
        "location": location,
        "deleted_at": deletedAt,
        "created_at": createdAt,
        "updated_at": updatedAt,
        "is_funded": isFunded,
        "service": service?.toJson(),
      };
}

class PostedJobsProvider extends ChangeNotifier {
  setDefault() {
    allJobs = null;
    isLoading = true;
    filterDataList = [];
    currentPageIndex = 0;
    rowsPerPage = 10;
    startIndex = 0;
    endIndex = 0;
    totalRowsCount = 0;
  }

  AllJobModel? allJobs;
  // Get all jobs

  bool isLoading = true;
  fetchAllJobs() async {
    try {
      var token = await getToken();
      final response = await getRequesthandler(
        url: CareReceiverURl.serviceReceiverJobBoard,
        token: token,
      );
      if (response != null && response.statusCode == 200) {
        var data = response.data;
        if (data['job'] != "No Job Found!") {
          setDataList(data);
          isLoading = false;
          notifyListeners();
        } else {
          isLoading = false;

          notifyListeners();
        }
      } else {
        throw 'Failed to load Posted Jobs';
      }
    } catch (e) {
      if (kDebugMode) {
        print(e.toString());
      }
    }
  }

  // Pagination List
  List filterDataList = [];
  int currentPageIndex = 0;
  int rowsPerPage = 10;
  int startIndex = 0;
  int endIndex = 0;
  int totalRowsCount = 0;
  setDataList(data) {
    allJobs = AllJobModel.fromJson(data!);
    if (allJobs!.jobList!.isNotEmpty) {
      allJobs!.jobList!.sort((a, b) {
        DateTime dateA = DateTime.parse(a.createdAt.toString());
        DateTime dateB = DateTime.parse(b.createdAt.toString());
        return dateB.compareTo(dateA);
      });
    }
    if (kDebugMode) {
      var ch = allJobs;
      print(ch);
    }
    notifyListeners();
    setPaginationList(allJobs!.jobList);
  }

  setPaginationList(List<JobDetail>? data) async {
    try {
      startIndex = currentPageIndex * rowsPerPage;
      endIndex = min(startIndex + rowsPerPage, data!.length);

      filterDataList = data.sublist(startIndex, endIndex).toList();
      totalRowsCount = (data.length / 10).floor();
      notifyListeners();
    } catch (error) {
      isLoading = false;
      notifyListeners();
    }
  }

  setFilter(String searchText) {
    var filterData = allJobs!.jobList!.where((element) {
      if (element.jobTitle.toString().toLowerCase().contains(searchText.toLowerCase()) || element.address.toString().toLowerCase().contains(searchText.toLowerCase()) || element.location.toString().toLowerCase().contains(searchText.toLowerCase()) || element.updatedAt.toString().toLowerCase().contains(searchText.toLowerCase())) {
        return true;
      } else {
        return false;
      }
    }).toList();

    setPaginationList(filterData);

    notifyListeners();
  }

  clearFilter() {
    setPaginationList(allJobs!.jobList);
    notifyListeners();
  }

  setFilterByTime(DateTime startTime, DateTime endTime) {
    var filterData = allJobs!.jobList!.where((element) {
      var docTime = element.updatedAt;
      if (startTime.isBefore(DateTime.parse(docTime!)) && endTime.isAfter(DateTime.parse(docTime.toString()))) {
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
    endIndex = min(startIndex + rowsPerPage, allJobs!.jobList!.length);
    filterDataList = allJobs!.jobList!.sublist(startIndex, endIndex).toList();
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
