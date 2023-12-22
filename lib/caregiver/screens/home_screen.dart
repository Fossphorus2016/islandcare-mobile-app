// ignore_for_file: prefer_typing_uninitialized_variables, use_build_context_synchronously

import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import 'package:island_app/caregiver/models/profile_model.dart';
import 'package:island_app/caregiver/widgets/receommend_job_widget.dart';
import 'package:island_app/res/app_url.dart';
import 'package:island_app/screens/notification.dart';
import 'package:island_app/utils/utils.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:island_app/caregiver/models/service_provider_dashboard_model.dart';
import 'package:island_app/caregiver/screens/job_detail.dart';
import 'package:island_app/caregiver/widgets/drawer_widget.dart';
import 'package:island_app/carereceiver/utils/colors.dart';
import 'package:shimmer/shimmer.dart';

String? token1;

class HomeGiverScreen extends StatefulWidget {
  const HomeGiverScreen({super.key});

  @override
  State<HomeGiverScreen> createState() => _HomeGiverScreenState();
}

class _HomeGiverScreenState extends State<HomeGiverScreen> {
  // fetchDashboardJobs
  List recommendedJob = [];
  List recentJob = [];

  late Future<ServiceProviderDashboardModel>? futureProviderDashboard;
  Future<ServiceProviderDashboardModel> fetchProviderDashboardModel() async {
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
    if (response.statusCode == 200) {
      return ServiceProviderDashboardModel.fromJson(response.data);
    } else {
      throw Exception(
        'Failed to load Service Provider Dashboard',
      );
    }
  }

  Future<ServiceProviderDashboardModel> fetchFindedJobsDashboardModel() async {
    var token = await getUserToken();
    final response = await Dio().get(
      '${CareGiverUrl.serviceProviderDashboard}?service=${findSelected ?? ""}&search=$serviceId&area=${findArea ?? ""}&rate=${findRate ?? ""}',
      options: Options(
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      ),
    );

    if (response.statusCode == 200) {
      var json = response.data as Map;
      var listOfJobs = json['jobs'] as List;
      var applied = json['applied_jobs'] as List;
      var completed = json['completed_jobs'] as List;
      setState(() {
        findJobs = listOfJobs;
        appliedList = applied;
        completedList = completed;
      });
      return ServiceProviderDashboardModel.fromJson(response.data);
    } else {
      throw Exception(
        'Failed to load Service Jobs Dashboard',
      );
    }
  }

  var token = '';
  Future getUserToken() async {
    SharedPreferences? prefs = await SharedPreferences.getInstance();
    await prefs.reload();
    var userToken = prefs.getString('userToken');
    setState(() {
      token = userToken!;
    });

    return userToken.toString();
  }

  var name;
  Future getUserName() async {
    SharedPreferences? prefs = await SharedPreferences.getInstance();
    await prefs.reload();
    var userName = prefs.getString('userName');
    setState(() {
      name = userName;
    });
    return userName.toString();
  }

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
  String? findSelected;
  String? findArea;
  String? findRate;
  String serviceId = '';

  // fetchPRofile
  late Future<ProfileGiverModel> fetchProfile;
  Future<ProfileGiverModel> fetchProfileGiverModel() async {
    var token = await getUserToken();
    final response = await Dio().get(
      CareGiverUrl.serviceProviderProfile,
      options: Options(headers: {
        'Authorization': 'Bearer $token',
        "Accept": "application/json",
      }),
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
    getUserToken();
    getUserName();

    super.initState();
    futureProviderDashboard = fetchProviderDashboardModel();
    fetchProfile = fetchProfileGiverModel();
  }

  bool? isRecommended = true;
  @override
  Widget build(BuildContext context) {
    // print(token);
    return SafeArea(
      child: Scaffold(
        backgroundColor: CustomColors.loginBg,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: CustomColors.primaryColor,
          actions: [
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const NotificationScreen(),
                  ),
                );
              },
              child: const Padding(
                padding: EdgeInsets.all(12.0),
                child: Badge(
                  child: Icon(
                    Icons.message_outlined,
                    size: 30,
                  ),
                ),
              ),
            ),
            FutureBuilder<ProfileGiverModel>(
              future: fetchProfile,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      decoration: BoxDecoration(
                        color: const Color(0xffFFFFFF),
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: const [
                          BoxShadow(
                            color: Color.fromARGB(15, 0, 0, 0),
                            blurRadius: 4,
                            spreadRadius: 4,
                            offset: Offset(2, 2), // Shadow position
                          ),
                        ],
                      ),
                      child: CircleAvatar(
                        radius: 20,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(40),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(100),
                            child: CachedNetworkImage(
                              width: 100,
                              height: 100,
                              fit: BoxFit.cover,
                              imageUrl: "${snapshot.data!.folderPath}/${snapshot.data!.data!.avatar}",
                              placeholder: (context, url) => const CircularProgressIndicator(),
                              errorWidget: (context, url, error) => const Icon(Icons.error),
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                } else {
                  return Shimmer.fromColors(
                    baseColor: CustomColors.white,
                    highlightColor: CustomColors.primaryLight,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        decoration: BoxDecoration(
                          color: const Color(0xffFFFFFF),
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: const [
                            BoxShadow(
                              color: Color.fromARGB(15, 0, 0, 0),
                              blurRadius: 4,
                              spreadRadius: 4,
                              offset: Offset(2, 2), // Shadow position
                            ),
                          ],
                        ),
                        child: CircleAvatar(
                          radius: 20,
                          backgroundColor: CustomColors.paraColor,
                        ),
                      ),
                    ),
                  );
                }
              },
            ),
          ],
        ),
        drawer: Drawer(
          backgroundColor: CustomColors.primaryColor,
          child: const DrawerGiverWidget(),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              // Overlay Search bar
              Stack(
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
                        color: CustomColors.primaryColor,
                        borderRadius: const BorderRadius.only(
                          bottomLeft: Radius.circular(12),
                          bottomRight: Radius.circular(12),
                        ),
                      ),
                      alignment: Alignment.centerLeft,
                      width: MediaQuery.of(context).size.width,
                      height: 100,
                      child: Text(
                        name ?? "",
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
                                            const SizedBox(
                                              height: 20,
                                            ),
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
                                            const SizedBox(
                                              height: 10,
                                            ),
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
                                                const SizedBox(
                                                  height: 40,
                                                ),
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
                                                          serviceId = value;
                                                        },
                                                      );
                                                      serviceId = value;
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
                                                      border: OutlineInputBorder(
                                                        borderRadius: BorderRadius.circular(4),
                                                      ),
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
                                                const SizedBox(
                                                  height: 20,
                                                ),
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
                                                      const SizedBox(
                                                        height: 5,
                                                      ),
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
                                                const SizedBox(
                                                  height: 20,
                                                ),
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
                                                      const SizedBox(
                                                        height: 5,
                                                      ),
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
                                                const SizedBox(
                                                  height: 20,
                                                ),
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
                                                      const SizedBox(
                                                        height: 5,
                                                      ),
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
                                                                  value: item['id'].toString(),
                                                                  child: Text(item['name']),
                                                                );
                                                              }).toList(),
                                                              onChanged: (newVal) {
                                                                setState(() {
                                                                  findRate = newVal;
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
                                                const SizedBox(
                                                  height: 20,
                                                ),
                                                GestureDetector(
                                                  onTap: () {
                                                    fetchFindedJobsDashboardModel();
                                                    Navigator.pop(context);
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
                                                const SizedBox(
                                                  height: 30,
                                                ),
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
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(4),
                          ),
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
              // isRecommended
              const SizedBox(height: 5),
              Column(
                children: [
                  findJobs.isEmpty
                      ? FutureBuilder<ServiceProviderDashboardModel>(
                          future: futureProviderDashboard,
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              return ListView.builder(
                                shrinkWrap: true,
                                scrollDirection: Axis.vertical,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: snapshot.data!.jobs!.length,
                                itemBuilder: (BuildContext context, int index) {
                                  return Container(
                                    width: MediaQuery.of(context).size.width * .90,
                                    margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
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
                                        Row(
                                          children: [
                                            ClipRRect(
                                              borderRadius: BorderRadius.circular(50),
                                              child: Image(
                                                image: NetworkImage("${AppUrl.webStorageUrl}/${snapshot.data!.jobs![index].userImage}"),
                                                height: 50,
                                                width: 50,
                                                fit: BoxFit.contain,
                                              ),
                                            ),
                                            const SizedBox(width: 05),
                                            Expanded(
                                              child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    snapshot.data!.jobs![index].service!.name.toString(),
                                                    overflow: TextOverflow.ellipsis,
                                                    maxLines: 1,
                                                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                                                  ),
                                                  // const SizedBox(height: 05),
                                                  Text(
                                                    "${snapshot.data!.jobs![index].userFirstName} ${snapshot.data!.jobs![index].userLastName}",
                                                    overflow: TextOverflow.ellipsis,
                                                    maxLines: 1,
                                                    style: TextStyle(
                                                      fontSize: 14,
                                                      fontWeight: FontWeight.w600,
                                                      color: Colors.grey.shade700,
                                                    ),
                                                  ),
                                                  // const SizedBox(height: 05),
                                                  Text(
                                                    snapshot.data!.jobs![index].address.toString(),
                                                    overflow: TextOverflow.clip,
                                                    maxLines: 2,
                                                    style: const TextStyle(color: Colors.grey, fontSize: 10),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 15),
                                        Text(
                                          "${snapshot.data!.jobs![index].jobTitle}",
                                        ),
                                        const SizedBox(height: 15),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            GestureDetector(
                                              onTap: () {
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) => JobDetailGiver(
                                                      id: snapshot.data!.jobs![index].id.toString(),
                                                      serviceId: snapshot.data!.jobs![index].service!.id.toString(),
                                                    ),
                                                  ),
                                                );
                                              },
                                              child: Container(
                                                height: 43,
                                                width: 110,
                                                decoration: BoxDecoration(
                                                  color: CustomColors.primaryColor,
                                                  borderRadius: BorderRadius.circular(12),
                                                ),
                                                child: Center(
                                                  child: Text(
                                                    "Read More",
                                                    style: TextStyle(
                                                      fontFamily: "Poppins",
                                                      color: CustomColors.white,
                                                      fontSize: 14,
                                                      fontWeight: FontWeight.w600,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            RichText(
                                              text: TextSpan(
                                                style: TextStyle(
                                                  fontFamily: 'Poppins',
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w400,
                                                  height: 1.1849999428,
                                                  color: CustomColors.primaryText,
                                                ),
                                                children: [
                                                  TextSpan(
                                                    text: '\$${snapshot.data!.jobs![index].hourlyRate.toString()}',
                                                    style: TextStyle(
                                                      fontFamily: 'Poppins',
                                                      fontSize: 16,
                                                      fontWeight: FontWeight.w600,
                                                      height: 1.2575,
                                                      color: CustomColors.primaryText,
                                                    ),
                                                  ),
                                                  TextSpan(
                                                    text: '/hour',
                                                    style: TextStyle(
                                                      fontFamily: 'Rubik',
                                                      fontSize: 15,
                                                      fontWeight: FontWeight.w500,
                                                      height: 1.185,
                                                      color: CustomColors.primaryText,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  );

                                  // RecommendationWidget(
                                  //   title: snapshot.data!.jobs![index].jobTitle.toString(),
                                  //   subTitle: snapshot.data!.jobs![index].service!.name.toString(),
                                  //   country: snapshot.data!.jobs![index].address.toString(),
                                  //   price: snapshot.data!.jobs![index].hourlyRate.toString(),
                                  //   isApplied: snapshot.data!.appliedJobs!.contains(snapshot.data!.jobs![index].id) ? 1 : 0,
                                  //   isCompleted: snapshot.data!.completedJobs!.contains(snapshot.data!.jobs![index].id) ? 1 : 0,
                                  //   onTap: () {
                                  //     Navigator.push(
                                  //       context,
                                  //       MaterialPageRoute(
                                  //         builder: (context) => JobDetailGiver(
                                  //           id: snapshot.data!.jobs![index].id.toString(),
                                  //           serviceId: snapshot.data!.jobs![index].service!.id.toString(),
                                  //         ),
                                  //       ),
                                  //     );
                                  //   },
                                  // );
                                },
                              );
                            } else {
                              return const Center(child: CircularProgressIndicator());
                            }
                          },
                        )
                      : FutureBuilder<ServiceProviderDashboardModel>(
                          future: futureProviderDashboard,
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              return ListView.builder(
                                shrinkWrap: true,
                                scrollDirection: Axis.vertical,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: findJobs.length,
                                itemBuilder: (BuildContext context, int index) {
                                  return RecommendationWidget(
                                    title: findJobs[index]['job_title'].toString(),
                                    subTitle: findJobs[index]['service']['name'].toString(),
                                    country: findJobs[index]['address'].toString(),
                                    price: findJobs[index]['hourly_rate'].toString(),
                                    isApplied: appliedList.contains(findJobs[index]['id']) ? 1 : 0,
                                    isCompleted: completedList.contains(findJobs[index]['id']) ? 1 : 0,
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => JobDetailGiver(
                                            id: findJobs[index]['id'].toString(),
                                            serviceId: findJobs[index]['service']['id'].toString(),
                                          ),
                                        ),
                                      );
                                    },
                                  );
                                },
                              );
                            } else {
                              return const Center(
                                child: CircularProgressIndicator(),
                              );
                            }
                          },
                        ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
