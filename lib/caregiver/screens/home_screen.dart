// ignore_for_file: prefer_typing_uninitialized_variables, use_build_context_synchronously

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:island_app/caregiver/models/profile_model.dart';
import 'package:island_app/caregiver/utils/profile_provider.dart';
import 'package:island_app/caregiver/widgets/giver_app_bar.dart';
import 'package:island_app/utils/app_url.dart';
import 'package:island_app/utils/http_handlers.dart';
import 'package:island_app/utils/navigation_service.dart';
import 'package:island_app/utils/utils.dart';
import 'package:island_app/widgets/custom_pagination.dart';
import 'package:island_app/widgets/profile_complete_widget.dart';
import 'package:provider/provider.dart';
import 'package:island_app/caregiver/widgets/drawer_widget.dart';
import 'package:island_app/carereceiver/utils/colors.dart';

String? token1;

class HomeGiverScreen extends StatefulWidget {
  const HomeGiverScreen({super.key});

  @override
  State<HomeGiverScreen> createState() => _HomeGiverScreenState();
}

class _HomeGiverScreenState extends State<HomeGiverScreen> {
  // Search bar
  List foundUsers = [];
  List foundUsers2 = [];
  List findJobs = [];
  List appliedList = [];
  List completedList = [];

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
      "id": "4",
      "name": "Child Care",
    },
    {
      "id": "5",
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
      "name": "All Parishes",
    },
  ];
  List<Map>? rate = [
    {
      "id": 0,
      "name": "select",
    },
    {
      "id": 1,
      "name": "\$17-\$25",
      "minValue": "17",
      "maxValue": "25",
    },
    {
      "id": 2,
      "name": "\$25-\$50",
      "minValue": "25",
      "maxValue": "50",
    },
    {
      "id": 3,
      "name": "\$50-\$100",
      "minValue": "50",
      "maxValue": "100",
    },
    {
      "id": 4,
      "name": "\$100+",
      "minValue": "100",
      "maxValue": "100",
    },
  ];
  String? findSelected;
  String? findtitle;
  String? findArea;
  Map? findRate;
  String serviceId = '';

  // fetchPRofile
  late Future<ProfileGiverModel> fetchProfile;
  Future<ProfileGiverModel> fetchProfileGiverModel() async {
    var token = await Provider.of<ServiceGiverProvider>(context, listen: false).getUserToken();
    final response = await getRequesthandler(
      url: CareGiverUrl.serviceProviderProfile,
      token: token,
      data: null,
    );
    if (response.statusCode == 200) {
      return ProfileGiverModel.fromJson(response.data);
    } else {
      throw Exception(
        customErrorSnackBar(
          context,
          'Failed to load Profile Model',
        ),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    fetchProfile = fetchProfileGiverModel();
    Provider.of<ServiceGiverProvider>(context, listen: false).fetchProviderDashboardModel();
  }

  bool? isRecommended = true;
  @override
  Widget build(BuildContext context) {
    bool profileStatus = Provider.of<ServiceGiverProvider>(context).profileStatus;
    bool dashboardLoading = Provider.of<ServiceGiverProvider>(context).dashboardIsLoading;

    return Consumer<ServiceGiverProvider>(
      builder: (context, provider, child) {
        return SafeArea(
          child: Scaffold(
            backgroundColor: CustomColors.loginBg,
            appBar: PreferredSize(
              preferredSize: const Size.fromHeight(60),
              child: GiverCustomAppBar(
                profileStatus: profileStatus,
                // fetchProfile: fetchProfile,
                showProfileIcon: true,
              ),
            ),
            drawer: const DrawerGiverWidget(),
            body: dashboardLoading || provider.searchIsLoading
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : profileStatus
                    ? SizedBox(
                        height: MediaQuery.of(context).size.height,
                        width: MediaQuery.of(context).size.width,
                        child: Column(
                          children: [
                            Expanded(
                              child: RefreshIndicator(
                                onRefresh: () => provider.fetchProviderDashboardModel(),
                                child: CustomScrollView(
                                  slivers: [
                                    // Overlay Search bar
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
                                                child: Consumer<ServiceGiverProvider>(
                                                  builder: (context, provider, child) {
                                                    return Text(
                                                      provider.userName ?? "",
                                                      style: TextStyle(
                                                        fontSize: 20,
                                                        fontWeight: FontWeight.w700,
                                                        fontFamily: "Rubik",
                                                        color: CustomColors.white,
                                                      ),
                                                    );
                                                  },
                                                ),
                                              ),
                                            ),
                                            Positioned(
                                              bottom: 5,
                                              right: 20,
                                              left: 20,
                                              child: Container(
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
                                                alignment: Alignment.center,
                                                width: MediaQuery.of(context).size.width,
                                                height: 50,
                                                child: TextFormField(
                                                  readOnly: true,
                                                  onTap: () {
                                                    showModalBottomSheet(
                                                      isScrollControlled: true,
                                                      context: context,
                                                      backgroundColor: Colors.white,
                                                      shape: const RoundedRectangleBorder(
                                                        borderRadius: BorderRadius.only(
                                                          topLeft: Radius.circular(30.0),
                                                          topRight: Radius.circular(30.0),
                                                        ),
                                                      ),
                                                      builder: (BuildContext context) {
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
                                                                        mainAxisAlignment: MainAxisAlignment.center,
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
                                                                          const SizedBox(height: 40),
                                                                          Container(
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
                                                                            alignment: Alignment.center,
                                                                            width: MediaQuery.of(context).size.width,
                                                                            height: 50,
                                                                            child: TextFormField(
                                                                              style: const TextStyle(
                                                                                fontSize: 16,
                                                                                fontFamily: "Rubik",
                                                                                fontWeight: FontWeight.w400,
                                                                              ),
                                                                              textAlignVertical: TextAlignVertical.bottom,
                                                                              maxLines: 1,
                                                                              onChanged: (value) {
                                                                                setState(
                                                                                  () {
                                                                                    findtitle = value;
                                                                                  },
                                                                                );
                                                                              },
                                                                              decoration: InputDecoration(
                                                                                prefixIcon: Icon(
                                                                                  Icons.search,
                                                                                  size: 17,
                                                                                  color: CustomColors.hintText,
                                                                                ),
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
                                                                          const SizedBox(height: 20),
                                                                          Center(
                                                                            child: Column(
                                                                              crossAxisAlignment: CrossAxisAlignment.start,
                                                                              children: [
                                                                                Text(
                                                                                  "Find",
                                                                                  style: TextStyle(
                                                                                    fontSize: 15,
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
                                                                                    child: DropdownButtonHideUnderline(
                                                                                      child: DropdownButton(
                                                                                        hint: const Text("Find"),
                                                                                        isExpanded: true,
                                                                                        items: data!.map((item) {
                                                                                          return DropdownMenuItem(
                                                                                            value: item['id'].toString(),
                                                                                            child: Text(item['name']),
                                                                                          );
                                                                                        }).toList(),
                                                                                        onChanged: (newVal) {
                                                                                          setState(() {
                                                                                            findSelected = newVal;
                                                                                          });
                                                                                        },
                                                                                        value: findSelected,
                                                                                      ),
                                                                                    ),
                                                                                  ),
                                                                                ),
                                                                              ],
                                                                            ),
                                                                          ),
                                                                          const SizedBox(height: 20),
                                                                          Center(
                                                                            child: Column(
                                                                              crossAxisAlignment: CrossAxisAlignment.start,
                                                                              children: [
                                                                                Text(
                                                                                  "Area",
                                                                                  style: TextStyle(
                                                                                    fontSize: 15,
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
                                                                                    child: DropdownButtonHideUnderline(
                                                                                      child: DropdownButton(
                                                                                        hint: const Text("Select Area"),
                                                                                        isExpanded: true,
                                                                                        items: area!.map((item) {
                                                                                          return DropdownMenuItem(
                                                                                            value: item['id'].toString(),
                                                                                            child: Text(item['name']),
                                                                                          );
                                                                                        }).toList(),
                                                                                        onChanged: (newVal) {
                                                                                          setState(() {
                                                                                            findArea = newVal;
                                                                                          });
                                                                                        },
                                                                                        value: findArea,
                                                                                      ),
                                                                                    ),
                                                                                  ),
                                                                                ),
                                                                              ],
                                                                            ),
                                                                          ),
                                                                          const SizedBox(height: 20),
                                                                          Center(
                                                                            child: Column(
                                                                              crossAxisAlignment: CrossAxisAlignment.start,
                                                                              children: [
                                                                                Text(
                                                                                  "Rate",
                                                                                  style: TextStyle(
                                                                                    fontSize: 15,
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
                                                                                    child: DropdownButtonHideUnderline(
                                                                                      child: DropdownButton(
                                                                                        hint: const Text("Select Rate"),
                                                                                        isExpanded: true,
                                                                                        items: rate!.map((item) {
                                                                                          return DropdownMenuItem(
                                                                                            value: item,
                                                                                            child: Text(item['name']),
                                                                                          );
                                                                                        }).toList(),
                                                                                        onChanged: (newVal) {
                                                                                          setState(() {
                                                                                            findRate = newVal!;
                                                                                          });
                                                                                        },
                                                                                        value: findRate,
                                                                                      ),
                                                                                    ),
                                                                                  ),
                                                                                ),
                                                                              ],
                                                                            ),
                                                                          ),
                                                                          // OTP
                                                                          const SizedBox(height: 20),
                                                                          GestureDetector(
                                                                            onTap: () async {
                                                                              Provider.of<ServiceGiverProvider>(context, listen: false).fetchFindedJobsDashboardModel(findtitle, findSelected, findArea, findRate);
                                                                              Navigator.pop(context);
                                                                              setState(() {
                                                                                findtitle = '';
                                                                                findSelected = null;
                                                                                findArea = null;
                                                                                findRate = null;
                                                                              });
                                                                            },
                                                                            child: Container(
                                                                              width: MediaQuery.of(context).size.width,
                                                                              height: 54,
                                                                              decoration: BoxDecoration(
                                                                                color: CustomColors.primaryColor,
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
                                                  style: const TextStyle(
                                                    fontSize: 16,
                                                    fontFamily: "Rubik",
                                                    fontWeight: FontWeight.w400,
                                                  ),
                                                  textAlignVertical: TextAlignVertical.bottom,
                                                  maxLines: 1,
                                                  decoration: InputDecoration(
                                                    prefixIcon: Icon(
                                                      Icons.search,
                                                      size: 17,
                                                      color: CustomColors.hintText,
                                                    ),
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
                                              shrinkWrap: true,
                                              scrollDirection: Axis.vertical,
                                              physics: const NeverScrollableScrollPhysics(),
                                              itemCount: provider.filterDataList.length,
                                              itemBuilder: (BuildContext context, int index) {
                                                var job = provider.filterDataList[index];
                                                // if (provider.searchIsLoading) {
                                                //   return const Center(
                                                //     child: CircularProgressIndicator(),
                                                //   );
                                                // }
                                                return JobCardContainer(
                                                  jobId: job!.id.toString(),
                                                  serviceId: job!.service!.id.toString(),
                                                  imageUrl: "${AppUrl.webStorageUrl}/${job!.userImage}",
                                                  serviceName: job!.service!.name.toString(),
                                                  userName: "${job!.userFirstName} ${job!.userLastName}",
                                                  jobAddress: job!.address.toString(),
                                                  jobTitle: job!.jobTitle ?? "",
                                                  hourlyRate: job!.hourlyRate.toString(),
                                                  jobArea: job!.location.toString(),
                                                  jobDuration: job!.totalDuration.toString(),
                                                  jobAmount: job!.totalAmount.toString(),
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
                      )
                    : const ProfileCompletContainer(),
          ),
        );
      },
    );
  }
}

class JobCardContainer extends StatelessWidget {
  const JobCardContainer({
    super.key,
    required this.jobId,
    required this.serviceId,
    required this.serviceName,
    required this.userName,
    required this.jobAddress,
    required this.jobTitle,
    required this.imageUrl,
    required this.hourlyRate,
    required this.jobArea,
    required this.jobDuration,
    required this.jobAmount,
  });
  final String jobId;
  final String serviceId;
  final String jobArea;
  final String jobDuration;
  final String imageUrl;
  final String jobAmount;
  final String serviceName;
  final String userName;
  final String jobAddress;
  final String jobTitle;
  final String hourlyRate;
  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * .90,
      margin: const EdgeInsets.symmetric(vertical: 10),
      padding: const EdgeInsets.all(20),
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
          bottomLeft: Radius.circular(20),
          bottomRight: Radius.circular(20),
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            jobTitle,
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              const Text("Job Type: "),
              Text(
                serviceName,
                style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              const Text("Job Area: "),
              Text(
                jobArea.toUpperCase(),
                style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              const Text("Job Total Duration: "),
              Text(
                jobDuration,
                style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              const Text("Hourly Rate: "),
              Text(
                hourlyRate,
                style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Text("Job Total Pay: "),
                  Text(
                    jobAmount,
                    style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                  ),
                ],
              ),
              GestureDetector(
                onTap: () {
                  navigationService.push('/job-detail-giver', arguments: {
                    "id": jobId.toString(),
                    "serviceId": serviceId,
                  });
                },
                child: Container(
                  height: 25,
                  width: 90,
                  decoration: BoxDecoration(
                    color: const Color(0xfff1416c),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Center(
                    child: Text(
                      "View More",
                      style: TextStyle(
                        fontFamily: "Poppins",
                        color: CustomColors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
        ],
      ),
    );
  }
}
