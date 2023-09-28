// ignore_for_file: unused_local_variable, prefer_typing_uninitialized_variables, use_build_context_synchronously, prefer_interpolation_to_compose_strings, library_private_types_in_public_api

import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:island_app/carereceiver/models/profile_model.dart';
import 'package:island_app/providers/user_provider.dart';
import 'package:island_app/screens/notification.dart';
import 'package:island_app/res/app_url.dart';
import 'package:island_app/utils/utils.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';
import 'package:island_app/carereceiver/models/service_receiver_dashboard_model.dart';
import 'package:island_app/carereceiver/screens/provider_profile_detail_for_giver.dart';
import 'package:island_app/carereceiver/utils/colors.dart';
import 'package:island_app/carereceiver/widgets/drawer_widget.dart';
import 'package:island_app/carereceiver/widgets/recommendation_widget.dart';

String? token1;

class HomeScreen extends StatefulWidget {
  final String? passedToken;
  const HomeScreen({
    Key? key,
    this.passedToken,
  }) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List providerList = [];
  List favouriteListTwo = [];
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
  String? findSelected;
  String? findArea;
  String? findRate;
  String? serviceId = '';
  late Future<ServiceReceiverDashboardModel>? futureReceiverDashboard;

  Future<ServiceReceiverDashboardModel> fetchReceiverDashboardModel() async {
    var token = await getUserToken();
    final response = await Dio().get(
      CareReceiverURl.serviceReceiverDashboard,
      options: Options(headers: {
        'Authorization': 'Bearer $token',
        'Accept': 'application/json',
        "Connection": "Keep-Alive",
      }),
    );
    if (response.statusCode == 200) {
      var json = response.data as Map;
      var listOfProviders = json['data'] as List;
      var listOfFavourites = json['favourites'] as List;
      setState(() {
        providerList = listOfProviders;
        favouriteList = listOfFavourites;
        foundProviders = listOfProviders;
      });

      return ServiceReceiverDashboardModel.fromJson(response.data);
    } else {
      throw Exception(
        'Failed to load Service Provider Dashboard',
      );
    }
  }

  Future<ServiceReceiverDashboardModel> fetchFindedReceiverDashboardModel() async {
    var token = await getUserToken();
    final response = await Dio().get(
      '${CareReceiverURl.serviceReceiverDashboard}?service=${findSelected ?? ""}&search=${serviceId ?? ""}&area=${findArea ?? ""}&rate=${findRate ?? ""}',
      options: Options(headers: {
        'Authorization': 'Bearer ${token ?? widget.passedToken}',
        'Accept': 'application/json',
      }),
    );

    if (response.statusCode == 200) {
      var json = response.data as Map;
      var listOfProviders = json['data'] as List;
      var listOfFavourites = json['favourites'] as List;
      setState(() {
        findProviders = listOfProviders;
      });

      return ServiceReceiverDashboardModel.fromJson(response.data);
    } else {
      throw Exception(
        'Failed to load Service Provider Dashboard',
      );
    }
  }

  // Favourite API

  var providerId;
  Future<Response> favourited(url) async {
    var url = '${CareReceiverURl.serviceReceiverAddFavourite}?favourite_id=$providerId';
    var response = await Dio().post(
      url,
      options: Options(
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      ),
    );
    if (response.statusCode == 200) {
      customSuccesSnackBar(
        context,
        "Added To Favourite",
      );
    } else {
      customSuccesSnackBar(
        context,
        "Favourite Is Not Added",
      );
    }
    return response;
  }

  var token;
  Future getUserToken() async {
    SharedPreferences? prefs = await SharedPreferences.getInstance();
    await prefs.reload();
    var userToken = prefs.getString('userToken');
    setState(() {
      token = userToken;
    });
    return userToken.toString();
  }

  var userPic;
  getUserAvatar() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    var userAvatar = preferences.getString(
      'userAvatar',
    );
    setState(() {
      userPic = userAvatar;
    });
    return userPic.toString();
  }

  // Search bar
  List foundProviders = [];
  List findProviders = [];

  @override
  void initState() {
    getUserToken();

    getUserAvatar();
    super.initState();
    futureReceiverDashboard = fetchReceiverDashboardModel();
    // fetchProfile = fetchProfileReceiverModel();
  }

  @override
  void dispose() {
    Timer(const Duration(seconds: 2), () {
      setState(() {
        foundProviders = providerList;
      });
    }).cancel();

    super.dispose();
  }

  int? age;
  calculateAge(int? age) {
    DateTime birthday = DateTime(age!);
  }

  String isAdult(String enteredAge) {
    var birthDate = DateFormat('yyyy-mm-dd').parse(enteredAge);
    var today = DateTime.now();

    final difference = today.difference(birthDate).inDays;
    final year = difference / 365;
    return year.toStringAsFixed(0);
  }

  mybirth(birthdayy) {
    final birthday = DateTime(birthdayy);
    final date2 = DateTime.now();
    final difference = date2.difference(birthday).inDays;
    return difference;
  }

  @override
  Widget build(BuildContext context) {
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
                    Icons.notifications_none,
                    size: 30,
                  ),
                ),
              ),
            ),
            FutureBuilder<ProfileReceiverModel?>(
              future: context.watch<UserProvider>().userProfile,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  // print(snapshot.data!.data!.userSubscriptionDetail!.periodType);
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
                              imageUrl: "${AppUrl.localStorageUrl}/${snapshot.data!.data!.avatar}",
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
                    baseColor: CustomColors.primaryColor,
                    highlightColor: const Color.fromARGB(255, 95, 95, 95),
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
          child: const DrawerWidget(),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              // Overlay Search bar
              Stack(
                children: [
                  Container(
                    decoration: const BoxDecoration(
                      color: Colors.transparent,
                    ),
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
                        "Find Your Caregiver",
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
                                                    fetchFindedReceiverDashboardModel();
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
              // Jobss
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 17),
                child: Column(
                  children: [
                    findProviders.isEmpty
                        ? FutureBuilder<ServiceReceiverDashboardModel>(
                            future: futureReceiverDashboard,
                            builder: (context, snapshot) {
                              if (snapshot.hasData) {
                                return ListView.builder(
                                  shrinkWrap: true,
                                  scrollDirection: Axis.vertical,
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemCount: foundProviders.length,
                                  itemBuilder: (BuildContext context, int index) {
                                    return RecommendationReceiverWidget(
                                      imgPath: "${AppUrl.webStorageUrl}" '/' + foundProviders[index]['avatar'].toString(),
                                      title: "${foundProviders[index]['first_name']} ${foundProviders[index]['last_name']}",
                                      experience: foundProviders[index]['userdetailprovider']['experience'] == null ? "0" : foundProviders[index]['userdetailprovider']['experience'].toString(),
                                      hourly: foundProviders[index]['userdetailprovider']['hourly_rate'].toString() == "null" ? "0" : foundProviders[index]['userdetailprovider']['hourly_rate'].toString(),
                                      price: foundProviders[index]['userdetailprovider']['hourly_rate'].toString() == "null" ? "0" : foundProviders[index]['userdetailprovider']['hourly_rate'].toString(),
                                      dob: isAdult(foundProviders[index]['userdetail']['dob'] != null ? "${foundProviders[index]['userdetail']['dob']}" : "00-00-0000").toString(),
                                      ratingCount: double.parse("${snapshot.data!.data![index].avgRating!.isEmpty ? "0.0" : snapshot.data!.data![index].avgRating![0].rating}"),
                                      isFavouriteIcon: GestureDetector(
                                        onTap: () {
                                          setState(() {});
                                          if (favouriteList.contains(foundProviders[index]['id'])) {
                                            favouriteList.remove(foundProviders[index]['id']);
                                            setState(() {});
                                          } else {
                                            favouriteList.add(foundProviders[index]['id']);
                                            setState(() {});
                                          }
                                          providerId = foundProviders[index]['id'];
                                          favourited("${CareReceiverURl.serviceReceiverAddFavourite}?favourite_id=${foundProviders[index]['id'].toString()}");
                                        },
                                        child: favouriteList.contains(foundProviders[index]['id'])
                                            ? Icon(
                                                Icons.favorite,
                                                color: CustomColors.red,
                                                size: 24,
                                              )
                                            : Icon(
                                                Icons.favorite_outline,
                                                color: CustomColors.darkGreyRecommended,
                                                size: 24,
                                              ),
                                      ),
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => ProviderProfileDetailForReceiver(
                                              id: snapshot.data!.data![index].id.toString(),
                                              rating: double.parse("${snapshot.data!.data![index].avgRating!.isEmpty ? "0.0" : snapshot.data!.data![index].avgRating![0].rating}"),
                                            ),
                                          ),
                                        );
                                      },
                                    );
                                  },
                                );
                              } else if (snapshot.hasError) {
                                return Text(
                                  snapshot.error.toString(),
                                );
                              } else if (snapshot.connectionState == ConnectionState.waiting) {
                                return Shimmer.fromColors(
                                  baseColor: CustomColors.white,
                                  highlightColor: CustomColors.primaryLight,
                                  child: Column(
                                    children: [
                                      Container(
                                        height: 200,
                                        width: MediaQuery.of(context).size.width,
                                        margin: const EdgeInsets.symmetric(
                                          vertical: 10,
                                        ),
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
                                        child: const Text("data"),
                                      ),
                                      Container(
                                        height: 200,
                                        width: MediaQuery.of(context).size.width,
                                        margin: const EdgeInsets.symmetric(
                                          vertical: 10,
                                        ),
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
                                        child: const Text("data"),
                                      ),
                                      Container(
                                        height: 200,
                                        width: MediaQuery.of(context).size.width,
                                        margin: const EdgeInsets.symmetric(
                                          vertical: 10,
                                        ),
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
                                        child: const Text("data"),
                                      ),
                                    ],
                                  ),
                                );
                              } else if (snapshot.connectionState == ConnectionState.none) {
                                return const Text("Cannot Establish Connection with server..");
                              } else {
                                return Shimmer.fromColors(
                                  baseColor: CustomColors.white,
                                  highlightColor: CustomColors.primaryLight,
                                  child: Column(
                                    children: [
                                      Container(
                                        height: 200,
                                        width: MediaQuery.of(context).size.width,
                                        margin: const EdgeInsets.symmetric(
                                          vertical: 10,
                                        ),
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
                                        child: const Text("data"),
                                      ),
                                    ],
                                  ),
                                );
                              }
                            },
                          )
                        : FutureBuilder<ServiceReceiverDashboardModel>(
                            future: futureReceiverDashboard,
                            builder: (context, snapshot) {
                              if (snapshot.hasData) {
                                return ListView.builder(
                                  shrinkWrap: true,
                                  scrollDirection: Axis.vertical,
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemCount: findProviders.length,
                                  itemBuilder: (BuildContext context, int index) {
                                    return RecommendationReceiverWidget(
                                      imgPath: findProviders[index]['avatar'] == null ? "${AppUrl.webStorageUrl}" '/' + findProviders[index]['avatar'].toString() : "https://fastly.picsum.photos/id/553/200/300.jpg?hmac=-A3VLW_dBmwUaXOe7bHhCt-lnmROrPFyTLslwNHVH1A",
                                      title: "${findProviders[index]['first_name']} ${findProviders[index]['last_name']}",
                                      experience: findProviders[index]['userdetailprovider']['experience'] == null ? "0" : findProviders[index]['userdetailprovider']['experience'].toString(),
                                      hourly: findProviders[index]['userdetailprovider']['hourly_rate'].toString() == "null" ? "0" : findProviders[index]['userdetailprovider']['hourly_rate'].toString(),
                                      price: findProviders[index]['userdetailprovider']['hourly_rate'].toString() == "null" ? "0" : findProviders[index]['userdetailprovider']['hourly_rate'].toString(),
                                      dob: isAdult(findProviders[index]['userdetail']['dob'] != null ? "${findProviders[index]['userdetail']['dob']}" : "00-00-0000").toString(),
                                      ratingCount: double.parse("${snapshot.data!.data![index].avgRating!.isEmpty ? "0.0" : snapshot.data!.data![index].avgRating![0].rating}"),
                                      isFavouriteIcon: GestureDetector(
                                        onTap: () {
                                          setState(() {});
                                          if (favouriteList.contains(findProviders[index]['id'])) {
                                            favouriteList.remove(findProviders[index]['id']);
                                            setState(() {});
                                          } else {
                                            favouriteList.add(findProviders[index]['id']);
                                            setState(() {});
                                          }
                                          providerId = findProviders[index]['id'];
                                          favourited("${CareReceiverURl.serviceReceiverAddFavourite}?favourite_id=${findProviders[index]['id'].toString()}");
                                        },
                                        child: favouriteList.contains(findProviders[index]['id'])
                                            ? Icon(
                                                Icons.favorite,
                                                color: CustomColors.red,
                                                size: 24,
                                              )
                                            : Icon(
                                                Icons.favorite_outline,
                                                color: CustomColors.darkGreyRecommended,
                                                size: 24,
                                              ),
                                      ),
                                      onTap: () {},
                                    );
                                  },
                                );
                              } else if (snapshot.hasError) {
                                return Text(
                                  snapshot.error.toString(),
                                );
                              } else if (snapshot.connectionState == ConnectionState.waiting) {
                                return const Text("Waiting...");
                              } else if (snapshot.connectionState == ConnectionState.none) {
                                return const Text("Cannot Establish Connection with server..");
                              } else {
                                return Shimmer.fromColors(
                                  baseColor: CustomColors.white,
                                  highlightColor: const Color.fromARGB(255, 95, 95, 95),
                                  child: Column(
                                    children: [
                                      Container(
                                        height: 200,
                                        width: MediaQuery.of(context).size.width,
                                        margin: const EdgeInsets.symmetric(
                                          vertical: 10,
                                        ),
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
                                        child: const Text("data"),
                                      ),
                                    ],
                                  ),
                                );
                              }
                            },
                          )
                  ],
                ),
              ),
              const SizedBox(
                height: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
