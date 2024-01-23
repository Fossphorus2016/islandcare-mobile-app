// ignore_for_file: prefer_typing_uninitialized_variables, await_only_futures, use_build_context_synchronously

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:intl/intl.dart';
import 'package:island_app/carereceiver/models/hired_candidate_model.dart';
import 'package:island_app/carereceiver/utils/colors.dart';
// import 'package:island_app/providers/user_provider.dart';
import 'package:island_app/res/app_url.dart';
import 'package:island_app/utils/utils.dart';
import 'package:island_app/widgets/custom_text_field.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HiredCandidatesScreen extends StatefulWidget {
  const HiredCandidatesScreen({super.key});

  @override
  State<HiredCandidatesScreen> createState() => _HiredCandidatesScreenState();
}

class _HiredCandidatesScreenState extends State<HiredCandidatesScreen> {
  TextEditingController commentController = TextEditingController();
  String currentDate = DateFormat('yyyy-MM-dd').format(DateTime.now());

  // Service Receiver Hired Candidates
  late Future<HiredCandidateModel>? futureHiredCandidate;
  List hiredCandidates = [];

  Future<HiredCandidateModel> fetchHiredCandidateModel() async {
    var token = await getUserToken();
    final response = await Dio().get(
      '${CareReceiverURl.serviceReceiverHireCandicate}?start_date=2022-01-01&end_date=$currentDate',
      options: Options(
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      ),
    );
    if (response.statusCode == 200) {
      var json = response.data as Map;
      // print(response.data);
      if (json['data'].isNotEmpty) {
        var hired = json['data'] as List;
        setState(() {
          hiredCandidates = hired;
        });
        // print(hired);
        return HiredCandidateModel.fromJson(response.data);
      } else {
        return HiredCandidateModel.fromJson({});
      }
    } else {
      throw Exception('Failed to load Hired Candidates');
    }
  }

  var providerId;
  var rating;
  var jobId;
  jobCompleted() async {
    var url = '${CareReceiverURl.serviceReceiverJobCompleted}?provider_id=$providerId&rating=$rating&comment=${commentController.text}&job_id=$jobId';
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
      customSuccesSnackBar(
        context,
        "Added To Favourite",
      );
      commentController.clear();
      setState(
        () {
          rating = 0;
        },
      );

      Navigator.pop(context);
    } else {
      if (kDebugMode) {
        print("jobCompleted = ${response.data}");
      }
    }
  }

  var token;
  Future getUserToken() async {
    SharedPreferences? prefs = await SharedPreferences.getInstance();
    await prefs.reload();
    var userToken = await prefs.getString('userToken');
    setState(() {
      token = userToken;
    });
    // if (kDebugMode) {
    //   print("token == $token");
    // }
    return userToken.toString();
  }

  @override
  void initState() {
    getUserToken();
    super.initState();
    futureHiredCandidate = fetchHiredCandidateModel();
  }

  @override
  Widget build(BuildContext context) {
    // print('${CareReceiverURl.serviceReceiverHireCandicate}?start_date=2022-01-01&end_date=$currentDate');
    // print(UserProvider.userToken);
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
            "Hired Candidates",
            style: TextStyle(
              fontSize: 19,
              fontWeight: FontWeight.w600,
              fontFamily: "Rubik",
              color: CustomColors.primaryText,
            ),
          ),
        ),
        body: ListView.builder(
          shrinkWrap: true,
          scrollDirection: Axis.vertical,
          itemCount: hiredCandidates.length,
          itemBuilder: (BuildContext context, int index) {
            return Column(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
                  height: 80,
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
                        flex: 6,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "${hiredCandidates[index]['users']['first_name']} ${hiredCandidates[index]['users']['last_name']}",
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
                              hiredCandidates[index]['jobs']['job_title'].toString(),
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
                      Expanded(
                        flex: 4,
                        child: GestureDetector(
                          onTap: () {
                            providerId = hiredCandidates[index]['provider_id'];
                            jobId = hiredCandidates[index]['job_id'];
                            hiredCandidates[index]['status'] == 3
                                ? () {}
                                : showModalBottomSheet(
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
                                                Center(
                                                  child: Text(
                                                    "Candidate Rating",
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(
                                                      color: CustomColors.black,
                                                      fontFamily: "Rubik",
                                                      fontStyle: FontStyle.normal,
                                                      fontSize: 22,
                                                      fontWeight: FontWeight.w600,
                                                    ),
                                                  ),
                                                ),
                                                const SizedBox(
                                                  height: 40,
                                                ),
                                                Container(
                                                  alignment: Alignment.center,
                                                  child: RatingBar.builder(
                                                    initialRating: 0,
                                                    minRating: 1,
                                                    direction: Axis.horizontal,
                                                    itemSize: 24,
                                                    itemCount: 5,
                                                    itemBuilder: (context, _) => const Icon(
                                                      Icons.star,
                                                      color: Colors.amber,
                                                    ),
                                                    onRatingUpdate: (ratingValue) {
                                                      setState(() {
                                                        rating = ratingValue.ceil();
                                                      });
                                                    },
                                                  ),
                                                ),
                                                const SizedBox(
                                                  height: 15,
                                                ),
                                                Column(
                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                  children: [
                                                    CustomTextFieldWidget(
                                                      borderColor: CustomColors.loginBorder,
                                                      textStyle: TextStyle(
                                                        fontSize: 15,
                                                        color: CustomColors.hintText,
                                                        fontFamily: "Calibri",
                                                        fontWeight: FontWeight.w400,
                                                      ),
                                                      hintText: "Comment",
                                                      controller: commentController,
                                                      obsecure: false,
                                                    ),
                                                    const SizedBox(
                                                      height: 20,
                                                    ),
                                                    GestureDetector(
                                                      onTap: () async {
                                                        var url = '${CareReceiverURl.serviceReceiverJobCompleted}?provider_id=$providerId&rating=$rating&comment=${commentController.text}&job_id=$jobId';
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
                                                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(response.data['message'].toString())));
                                                          commentController.clear();
                                                          setState(
                                                            () {
                                                              rating = 0;
                                                            },
                                                          );
                                                          fetchHiredCandidateModel();
                                                        }
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
                                                            "Continue",
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
                                                      height: 15,
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
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8),
                            height: 24,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(2),
                              color: hiredCandidates[index]['status'] == 3 ? CustomColors.primaryLight : CustomColors.primaryColor,
                            ),
                            child: Center(
                              child: Text(
                                hiredCandidates[index]['status'] == 3 ? "Job Completed" : "Mark As Complete",
                                style: TextStyle(
                                  color: CustomColors.white,
                                  fontSize: 12,
                                  fontFamily: "Poppins",
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              ],
            );
          },
        ),
      ),
    );
  }
}
