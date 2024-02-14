// ignore_for_file: use_build_context_synchronously

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:island_app/carereceiver/models/job_applicant_model.dart';
import 'package:island_app/carereceiver/screens/job_applicant_detail.dart';
import 'package:island_app/carereceiver/utils/colors.dart';
import 'package:island_app/carereceiver/widgets/job_applicants_widget.dart';
import 'package:island_app/res/app_url.dart';
import 'package:island_app/utils/utils.dart';
import 'package:shared_preferences/shared_preferences.dart';

class JobApplicants extends StatefulWidget {
  const JobApplicants({super.key});

  @override
  State<JobApplicants> createState() => _JobApplicantsState();
}

class _JobApplicantsState extends State<JobApplicants> {
  String? dropdownValue = 'All Relevance';
  Future<void> showDeleteDialog() async {
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

  List? allJobs = [];
  // Get all jobs
  late Future<ServiceReceiverJobApplicantModel> futureJobApplicantModel;
  Future<ServiceReceiverJobApplicantModel> fetchJobApplicantModel() async {
    var token = await getUserToken();
    final response = await Dio().get(
      CareReceiverURl.serviceReceiverApplication,
      options: Options(
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      ),
    );
    if (response.statusCode == 200) {
      var data = response.data;
      if (data['data'] != "No Job Found!") {
        return ServiceReceiverJobApplicantModel.fromJson(response.data);
      } else {
        return ServiceReceiverJobApplicantModel.fromJson({});
      }
    } else {
      throw Exception(
        customErrorSnackBar(
          context,
          'Failed to load Job Applicant Model',
        ),
      );
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
    futureJobApplicantModel = fetchJobApplicantModel();
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
            "Job Applicants",
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
                        "Job Title & Type",
                        style: TextStyle(
                          color: CustomColors.black,
                          fontSize: 12,
                          fontFamily: "Poppins",
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        "Application Count",
                        style: TextStyle(
                          color: CustomColors.black,
                          fontSize: 12,
                          fontFamily: "Poppins",
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        "Details",
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
                FutureBuilder<ServiceReceiverJobApplicantModel>(
                  future: futureJobApplicantModel,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return ListView.builder(
                        itemCount: snapshot.data!.data!.length,
                        shrinkWrap: true,
                        padding: const EdgeInsets.only(top: 16),
                        physics: const NeverScrollableScrollPhysics(),
                        itemBuilder: (context, index) {
                          return JobApplicantsWidget(
                            name: snapshot.data!.data![index].jobTitle.toString(),
                            jobType: (snapshot.data!.data![index].serviceId.toString() == "1")
                                ? "Senior Care"
                                : (snapshot.data!.data![index].serviceId.toString() == "2")
                                    ? "Pet Care"
                                    : (snapshot.data!.data![index].serviceId.toString() == "3")
                                        ? "House Keeping"
                                        : (snapshot.data!.data![index].serviceId.toString() == "4")
                                            ? "Child Care"
                                            : "School Support",
                            count: snapshot.data!.applicationCounts![index].count.toString(),
                            onTap: () {
                              if (snapshot.data!.data![index].isFunded == 1) {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => JobApplicantsDetail(
                                      name: snapshot.data!.data![index].jobTitle.toString(),
                                      jobId: snapshot.data!.data![index].id.toString(),
                                    ),
                                  ),
                                );
                              } else {
                                showDialog(
                                  context: context,
                                  builder: (context) => AlertDialog(
                                    content: Column(
                                      children: [
                                        Text("Total Applications Available : ${snapshot.data!.applicationCounts![index].count.toString()}"),
                                        Text("Fund The Job Amount ${snapshot.data!.data![index].totalAmount}  With Service Charges of 7.5%"),
                                        Text(" Total Amount To Be Paid  \$ ${(double.parse(snapshot.data!.data![index].totalAmount.toString()) + double.parse(snapshot.data!.data![index].totalAmount.toString()))}  To View Applicant"),
                                      ],
                                    ),
                                    actions: [
                                      TextButton(
                                        style: ButtonStyle(
                                          backgroundColor: MaterialStateProperty.resolveWith(
                                            (states) => CustomColors.darkRed,
                                          ),
                                        ),
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                        child: const Text(
                                          "close",
                                          style: TextStyle(color: Colors.white),
                                        ),
                                      ),
                                      TextButton(
                                        style: ButtonStyle(
                                          backgroundColor: MaterialStateProperty.resolveWith(
                                            (states) => CustomColors.greenLight,
                                          ),
                                        ),
                                        onPressed: () {},
                                        child: const Text(
                                          "Payment Now",
                                          style: TextStyle(color: Colors.white),
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              }
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
            ),
          ),
        ),
      ),
    );
  }
}
