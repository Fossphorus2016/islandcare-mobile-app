// ignore_for_file: use_build_context_synchronously

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:island_app/caregiver/models/provider_reviews_model.dart';
import 'package:island_app/carereceiver/utils/colors.dart';
import 'package:island_app/carereceiver/widgets/reviews_given_widget.dart';
import 'package:island_app/res/app_url.dart';
// import 'package:island_app/utils/utils.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProviderReviewsScreen extends StatefulWidget {
  const ProviderReviewsScreen({super.key});

  @override
  State<ProviderReviewsScreen> createState() => _ProviderReviewsScreenState();
}

class _ProviderReviewsScreenState extends State<ProviderReviewsScreen> {
  List? allJobs = [];
  bool isLoading = true;
  // Get all jobs
  ProviderReviewsModel? futurereviews;
  fetchReviewsModel() async {
    var token = await getUserToken();
    final response = await Dio().get(
      CareGiverUrl.serviceProviderProfileReviews,
      options: Options(
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      ),
    );
    print(response.data);
    if (response.statusCode == 200 && response.data['data'] != null) {
      setState(() {
        futurereviews = ProviderReviewsModel.fromJson(response.data);
        isLoading = false;
      });
    } else {
      setState(() {
        isLoading = false;
      });
      // customErrorSnackBar(
      //   context,
      //   'Failed to load Reviews Model',
      // );
      // throw Exception();
    }
  }

  getUserToken() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    var userToken = preferences.getString(
      'userToken',
    );

    return userToken.toString();
  }

  @override
  void initState() {
    getUserToken();
    super.initState();
    fetchReviewsModel();
    // futurereviews = fetchReviewsModel();
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
        body: isLoading
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Column(
                    children: [
                      const SizedBox(height: 20),

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
                      // FutureBuilder<ProviderReviewsModel>(
                      //   future: futurereviews,
                      //   builder: (context, snapshot) {
                      //     if (snapshot.hasData) {
                      // return
                      if (futurereviews != null && futurereviews!.data!.isNotEmpty) ...[
                        ListView.builder(
                          itemCount: futurereviews!.data!.length,
                          shrinkWrap: true,
                          padding: const EdgeInsets.only(top: 16),
                          physics: const NeverScrollableScrollPhysics(),
                          itemBuilder: (context, index) {
                            return ReviewsGivenWidget(
                              name: '${futurereviews!.data![index].receiverRating!.firstName} ${futurereviews!.data![index].receiverRating!.lastName}',
                              rating: futurereviews!.data![index].rating!.toDouble(),
                              comment: futurereviews!.data![index].comment.toString() == "null" ? "Not Available" : futurereviews!.data![index].comment.toString(),
                            );
                          },
                        ),
                      ] else ...[
                        const Center(
                          child: Text("No Review Yet!"),
                        )
                      ],
                    ],
                  ),
                ),
              ),
      ),
    );
  }
}
