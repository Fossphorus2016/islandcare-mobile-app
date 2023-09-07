// ignore_for_file: use_build_context_synchronously, await_only_futures

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:island_app/carereceiver/models/receiver_reviews_given.dart';
import 'package:island_app/carereceiver/utils/colors.dart';
// import 'package:http/http.dart' as http;
import 'package:island_app/carereceiver/widgets/reviews_given_widget.dart';
import 'package:island_app/res/app_url.dart';
import 'package:island_app/utils/utils.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ReceiverReviewsScreen extends StatefulWidget {
  const ReceiverReviewsScreen({super.key});

  @override
  State<ReceiverReviewsScreen> createState() => _ReceiverReviewsScreenState();
}

class _ReceiverReviewsScreenState extends State<ReceiverReviewsScreen> {
  List? allJobs = [];
  // Get all jobs
  late Future<ReceiverReviewsModel> futurereviews;
  Future<ReceiverReviewsModel> fetchReviewsModel() async {
    var token = await getUserToken();
    final response = await Dio().get(
      CareReceiverURl.serviceReceiverAdd,
      options: Options(
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      ),
    );
    if (response.statusCode == 200) {
      // if (kDebugMode) {
      //   print("Job Applicant == ${jsonDecode(response.body)}");
      // }
      var data = response.data;
      // print(data);
      if (data.isNotEmpty) {
        return ReceiverReviewsModel.fromJson(data);
      } else {
        return ReceiverReviewsModel.fromJson({});
      }
    } else {
      throw Exception(
        customErrorSnackBar(
          context,
          'Failed to load Reviews Model',
        ),
      );
    }
  }

  getUserToken() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    var userToken = await preferences.getString(
      'userToken',
    );
    if (kDebugMode) {
      print(userToken);
    }
    return userToken.toString();
  }

  @override
  void initState() {
    getUserToken();
    super.initState();
    // fetchJobBoardDetail();
    futurereviews = fetchReviewsModel();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
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
            "Reviews",
            style: TextStyle(
              fontSize: 19,
              fontWeight: FontWeight.w600,
              fontFamily: "Rubik",
              color: CustomColors.primaryText,
            ),
          ),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Column(
              children: [
                const SizedBox(
                  height: 20,
                ),

                // Listing
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
                  decoration: BoxDecoration(
                    color: CustomColors.blackLight,
                    border: Border(
                      bottom: BorderSide(
                        color: CustomColors.borderLight,
                        width: 0.1,
                      ),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Name",
                        style: TextStyle(
                          color: CustomColors.black,
                          fontSize: 12,
                          fontFamily: "Poppins",
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        "Ratings",
                        style: TextStyle(
                          color: CustomColors.black,
                          fontSize: 12,
                          fontFamily: "Poppins",
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        "Comment",
                        style: TextStyle(
                          color: CustomColors.black,
                          fontSize: 12,
                          fontFamily: "Poppins",
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
                FutureBuilder<ReceiverReviewsModel>(
                  future: futurereviews,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return ListView.builder(
                        itemCount: snapshot.data!.ratings!.length,
                        shrinkWrap: true,
                        padding: const EdgeInsets.only(top: 16),
                        physics: const NeverScrollableScrollPhysics(),
                        itemBuilder: (context, index) {
                          return ReviewsGivenWidget(
                            name: '${snapshot.data!.ratings![index].provider!.firstName} ${snapshot.data!.ratings![index].provider!.lastName}',
                            email: snapshot.data!.ratings![index].provider!.email.toString(),
                            rating: snapshot.data!.ratings![index].rating!.toDouble(),
                            comment: snapshot.data!.ratings![index].comment.toString() == "null" ? "Not Available" : snapshot.data!.ratings![index].comment.toString(),
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
            ),
          ),
        ),
      ),
    );
  }
}
