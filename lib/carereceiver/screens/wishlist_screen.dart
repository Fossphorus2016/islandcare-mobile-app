// ignore_for_file: prefer_typing_uninitialized_variables, prefer_interpolation_to_compose_strings

import 'dart:async';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:island_app/carereceiver/models/favourite_get_model.dart';
import 'package:island_app/carereceiver/screens/provider_profile_detail_for_giver.dart';
import 'package:island_app/carereceiver/utils/colors.dart';
import 'package:island_app/carereceiver/widgets/recommendation_widget.dart';
// import 'package:http/http.dart' as http;
import 'package:island_app/res/app_url.dart';
import 'package:shared_preferences/shared_preferences.dart';

class WishlistScreen extends StatefulWidget {
  const WishlistScreen({super.key});

  @override
  State<WishlistScreen> createState() => _WishlistScreenState();
}

class _WishlistScreenState extends State<WishlistScreen> {
  // Rating Bar
  late final ratingController;
  late double rating;
  final double userRating = 3.0;
  final int ratingBarMode = 1;
  final double initialRating = 2.0;
  final bool isRTLMode = false;
  final bool isVertical = false;
  List providerList = [];

  // Service Receiver Dashboard
  late Future<FavouriteGetModel>? futureFavourite;
  Future<FavouriteGetModel> fetchFavourite() async {
    var token = await getUserToken();
    final response = await Dio().get(
      CareReceiverURl.serviceReceiverFavourite,
      options: Options(
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      ),
    );
    // Map<String, dynamic> map = json.decode(response.body);
    // List<dynamic> data = map["data"];

    if (response.statusCode == 200) {
      // print("mapdata $data");
      var json = response.data as Map;
      var listOfProviders = json['data'] as List;
      // print("IsNotEmpty== ${jsonDecode(response.body)}");
      setState(() {
        providerList = listOfProviders;
        foundProviders = listOfProviders;
      });
      // print("providerList= $providerList");
      return FavouriteGetModel.fromJson(response.data);
    } else {
      throw Exception(
        'Failed to load Service Provider Dashboard',
      );
    }
  }

  // Favourite API
  var favouriteList = [];
  var providerId;
  Future<Response> favourited(url) async {
    var token = await getUserToken();
    var url = '${CareReceiverURl.serviceReceiverAddFavourite}?favourite_id=$providerId';
    var response = await Dio().post(
      url,
      options: Options(
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      ),
    );
    if (response.statusCode == 200) {
      // Utils.customSuccesSnackBar( context,"Added To Favourite",);
      // print("isFavourite = ${response.body}");
      setState(() {
        futureFavourite = fetchFavourite();
        favouriteList;
        foundProviders;
        fetchFavourite();
      });
    } else {
      // print("isFavouriteerror = ${response.body}");
    }
    return response;
  }

  getUserToken() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    var userToken = preferences.getString(
      'userToken',
    );
    // print(userToken);
    return userToken.toString();
  }

  // Search bar
  List foundProviders = [];
  void runFilter(String enteredKeyword) {
    List results = [];

    if (enteredKeyword.isEmpty) {
      results = providerList;

      setState(() {});
    } else {
      results = providerList.where((user) => user['first_name'].toLowerCase().contains(enteredKeyword.toLowerCase())).toList();
    }
    setState(() {
      foundProviders = results;
    });
  }

  @override
  void initState() {
    getUserToken();
    super.initState();
    ratingController = TextEditingController(text: '3.0');
    rating = initialRating;
    futureFavourite = fetchFavourite();
    Timer(const Duration(seconds: 1), () {
      if (mounted) {
        setState(() {
          foundProviders = providerList;
        });
      }
    });
  }

  String isAdult(String enteredAge) {
    var birthDate = DateFormat('yyyy-mm-dd').parse(enteredAge);
    // print("set state: $birthDate");
    var today = DateTime.now();

    final difference = today.difference(birthDate).inDays;
    // print(difference);
    final year = difference / 365;
    // print(year);
    return year.toStringAsFixed(0);
  }

  @override
  Widget build(BuildContext context) {
    // double baseWidth = 360;
    // double fem = MediaQuery.of(context).size.width / baseWidth;
    // double ffem = fem * 0.97;
    // print(foundProviders);
    return SafeArea(
      child: Scaffold(
        backgroundColor: CustomColors.loginBg,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.transparent,
          automaticallyImplyLeading: false,
          centerTitle: true,
          title: Text(
            "Find Caregiver",
            textAlign: TextAlign.left,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              fontFamily: "Rubik",
              color: CustomColors.primaryText,
            ),
          ),
        ),
        body: SingleChildScrollView(
          child: Container(
            width: MediaQuery.of(context).size.width,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Column(
              children: [
                // Search Field
                // const SizedBox(
                //   height: 10,
                // ),
                // Container(
                //   decoration: BoxDecoration(
                //     borderRadius: const BorderRadius.only(
                //       topLeft: Radius.circular(6),
                //       bottomLeft: Radius.circular(6),
                //       bottomRight: Radius.circular(6),
                //       topRight: Radius.circular(6),
                //     ),
                //     color: CustomColors.white,
                //     boxShadow: const [
                //       BoxShadow(
                //         color: Color.fromARGB(13, 0, 0, 0),
                //         blurRadius: 4.0,
                //         spreadRadius: 2.0,
                //         offset: Offset(2.0, 2.0),
                //       ),
                //     ],
                //   ),
                //   alignment: Alignment.center,
                //   width: MediaQuery.of(context).size.width,
                //   height: 50,
                //   child: TextFormField(
                //     onChanged: (value) => _runFilter(value),
                //     style: const TextStyle(
                //       fontSize: 16,
                //       fontFamily: "Rubik",
                //       fontWeight: FontWeight.w400,
                //     ),
                //     textAlignVertical: TextAlignVertical.bottom,
                //     maxLines: 1,
                //     decoration: InputDecoration(
                //       prefixIcon: Icon(
                //         Icons.search,
                //         size: 17,
                //         color: CustomColors.hintText,
                //       ),
                //       suffixIcon: Icon(
                //         Icons.close,
                //         size: 17,
                //         color: CustomColors.hintText,
                //       ),
                //       hintText: "Search...",
                //       fillColor: CustomColors.white,
                //       focusColor: CustomColors.white,
                //       hoverColor: CustomColors.white,
                //       filled: true,
                //       border: OutlineInputBorder(
                //         borderRadius: BorderRadius.circular(4),
                //       ),
                //       focusedBorder: OutlineInputBorder(
                //         borderSide: BorderSide(color: CustomColors.white, width: 2.0),
                //         borderRadius: BorderRadius.circular(4.0),
                //       ),
                //       enabledBorder: OutlineInputBorder(
                //         borderSide: BorderSide(color: CustomColors.white, width: 2.0),
                //         borderRadius: BorderRadius.circular(4.0),
                //       ),
                //     ),
                //   ),
                // ),
                // Card Box Widget
                const SizedBox(
                  height: 5,
                ),
                foundProviders.isEmpty
                    ? Container(
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
                        child: const Text("Wishlist Not Available..."))
                    : FutureBuilder<FavouriteGetModel>(
                        future: futureFavourite,
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            return ListView.builder(
                              shrinkWrap: true,
                              scrollDirection: Axis.vertical,
                              physics: const NeverScrollableScrollPhysics(),
                              // itemCount: snapshot.data!.data!.length,
                              itemCount: foundProviders.length,
                              itemBuilder: (BuildContext context, int index) {
                                return foundProviders[index]['data'] == 0
                                    ? Container()
                                    : RecommendationReceiverWidget(
                                        // imgPath: "${AppUrl.webStorageUrl}" '/' + foundProviders[index]['users']['avatar'].toString(),
                                        title: "${foundProviders[index]['users']['first_name']} ${foundProviders[index]['users']['last_name']}",
                                        experience: foundProviders[index]['userdetailproviders']['experience'] == null ? "0" : foundProviders[index]['userdetailproviders']['experience'].toString(),
                                        hourly: foundProviders[index]['userdetailproviders']['hourly_rate'].toString() == "null" ? "0" : foundProviders[index]['userdetailproviders']['hourly_rate'].toString(),
                                        price: foundProviders[index]['userdetailproviders']['hourly_rate'].toString() == "null" ? "0" : foundProviders[index]['userdetailproviders']['hourly_rate'].toString(),
                                        dob: isAdult(foundProviders[index]['userdetails']['dob'] != null ? "${foundProviders[index]['userdetails']['dob']}" : "00-00-0000"),
                                        // dob: Jiffy("${foundProviders[index]['users']['userdetail']['dob']}" == null ? "00-00-0000" : "${foundProviders[index]['users']['userdetail']['dob']}", "yyyy-MM-dd").fromNow(),
                                        // dob: "DOB ${foundProviders[index]['users'].userdetail!.dob.toString()}",
                                        // dob: calAge(DateFormat('yyyy-mm-dd').parse(foundProviders[index]['users'].userdetail!.dob)) as DateDuration,
                                        // ratingCount: double.parse(foundProviders[index]['users']['ratings']['rating'] == null ? "0.0" : "${foundProviders[index]['users']['ratings']['rating']}"),
                                        isRatingShow: false,
                                        isFavouriteIcon: GestureDetector(
                                          onTap: () {
                                            setState(() {});
                                            if (favouriteList.contains(foundProviders[index]['users']['id'].toString())) {
                                              setState(() {
                                                favouriteList.remove(foundProviders[index]['users']['id'].toString());
                                                foundProviders.remove(foundProviders[index].toString());
                                              });
                                            } else {
                                              favouriteList.add(foundProviders[index]['users']['id'].toString());
                                              setState(() {});
                                            }
                                            providerId = foundProviders[index]['users']['id'];
                                            favourited("http://192.168.0.244:9999/api/service-receiver-add-to-favourite?favourite_id=${foundProviders[index]['users']['id'].toString()}");
                                            // Navigator.push(context, new MaterialPageRoute(builder: (context) => this.build(context)));
                                            setState(() {});
                                          },
                                          child: favouriteList.contains(foundProviders[index]['users']['id'].toString())
                                              ? Icon(
                                                  Icons.favorite_outline,
                                                  color: CustomColors.darkGreyRecommended,
                                                  size: 24,
                                                )
                                              : Icon(
                                                  Icons.favorite,
                                                  color: CustomColors.red,
                                                  size: 24,
                                                ),
                                        ),
                                        onTap: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) => ProviderProfileDetailForReceiver(
                                                      id: snapshot.data!.data![index].id.toString(),
                                                    )
                                                // JobDetailGiver(
                                                //   id: snapshot.data!.data![index].id.toString(),
                                                // ),
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
                      )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
