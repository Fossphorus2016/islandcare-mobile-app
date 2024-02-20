// ignore_for_file: use_build_context_synchronously

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:island_app/caregiver/models/provider_reviews_model.dart';
import 'package:island_app/caregiver/utils/profile_provider.dart';
import 'package:island_app/carereceiver/utils/colors.dart';
import 'package:island_app/res/app_url.dart';
// import 'package:island_app/widgets/review_expansion_list.dart';
import 'package:provider/provider.dart';

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
    var token = await Provider.of<ServiceGiverProvider>(context, listen: false).getUserToken();
    final response = await Dio().get(
      CareGiverUrl.serviceProviderProfileReviews,
      options: Options(
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      ),
    );
    // print(response.data);
    if (response.statusCode == 200 && response.data['data'] != null) {
      setState(() {
        futurereviews = ProviderReviewsModel.fromJson(response.data);
        isLoading = false;
      });
    } else {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    fetchReviewsModel();
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
                          color: CustomColors.greenhighlight,
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
                            // Text(
                            //   "Ratings",
                            //   style: TextStyle(
                            //     color: CustomColors.black,
                            //     fontSize: 12,
                            //     fontFamily: "Poppins",
                            //     fontWeight: FontWeight.w600,
                            //   ),
                            // ),
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
                      if (futurereviews != null && futurereviews!.data!.isNotEmpty) ...[
                        ListView.builder(
                          itemCount: futurereviews!.data!.length,
                          shrinkWrap: true,
                          padding: const EdgeInsets.only(top: 16),
                          physics: const NeverScrollableScrollPhysics(),
                          itemBuilder: (context, index) {
                            return Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '${futurereviews!.data![index].receiverRating!.firstName} ${futurereviews!.data![index].receiverRating!.lastName}',
                                ),
                                IconButton(
                                  onPressed: () {
                                    showDialog(
                                      context: context,
                                      builder: (context) => AlertDialog(
                                        title: Center(child: Text('${futurereviews!.data![index].receiverRating!.firstName} ${futurereviews!.data![index].receiverRating!.lastName}')),
                                        alignment: Alignment.center,
                                        content: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            RatingBar.builder(
                                              initialRating: futurereviews!.data![index].rating!.toDouble(),
                                              minRating: 1,
                                              direction: Axis.horizontal,
                                              allowHalfRating: true,
                                              ignoreGestures: false,
                                              itemSize: 24,
                                              itemCount: 5,
                                              itemBuilder: (context, _) => const Icon(
                                                Icons.star,
                                                color: Colors.amber,
                                              ),
                                              onRatingUpdate: (rating) {},
                                            ),
                                            Text(
                                              futurereviews!.data![index].comment.toString() == "null" ? "Not Available" : futurereviews!.data![index].comment.toString(),
                                              maxLines: 20,
                                              softWrap: true,
                                              style: TextStyle(
                                                fontSize: 16,
                                                fontFamily: "Poppins",
                                                fontWeight: FontWeight.w400,
                                                color: CustomColors.primaryText,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                  icon: Icon(
                                    Icons.arrow_circle_right_rounded,
                                    color: CustomColors.greenLight,
                                  ),
                                ),
                              ],
                            );
                          },
                        ),
                        // ListView.builder(
                        //   itemCount: futurereviews!.data!.length,
                        //   shrinkWrap: true,
                        //   padding: const EdgeInsets.only(top: 16),
                        //   physics: const NeverScrollableScrollPhysics(),
                        //   itemBuilder: (context, index) {
                        //     return ReviewExpansionList(
                        //       name: '${futurereviews!.data![index].receiverRating!.firstName} ${futurereviews!.data![index].receiverRating!.lastName}',
                        //       comment: futurereviews!.data![index].comment.toString() == "null" ? "Not Available" : futurereviews!.data![index].comment.toString(),
                        //       rating: futurereviews!.data![index].rating!,
                        //     );
                        //   },
                        // ),
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
