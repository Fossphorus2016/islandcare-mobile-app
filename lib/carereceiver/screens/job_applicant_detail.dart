// ignore_for_file: use_build_context_synchronously

import 'package:dio/dio.dart';
// import 'package:flutter/foundation.dart';s
import 'package:flutter/material.dart';
import 'package:island_app/carereceiver/models/job_applicant_detail.dart';
import 'package:island_app/carereceiver/screens/applicant_profile_detail.dart';
import 'package:island_app/res/app_url.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:island_app/carereceiver/utils/colors.dart';
import 'package:island_app/carereceiver/widgets/job_applicants_widget.dart';
import 'package:island_app/utils/utils.dart';

class JobApplicantsDetail extends StatefulWidget {
  final String name;
  final String jobId;
  const JobApplicantsDetail({
    Key? key,
    required this.name,
    required this.jobId,
  }) : super(key: key);

  @override
  State<JobApplicantsDetail> createState() => _JobApplicantsDetailState();
}

class _JobApplicantsDetailState extends State<JobApplicantsDetail> {
  List? allJobs = [];
  // Get all jobs
  late Future<JobApplicantDetailModel> futureJobApplicantModel;
  Future<JobApplicantDetailModel> fetchJobApplicantModel() async {
    var token = await getUserToken();
    final response = await Dio().get(
      '${CareReceiverURl.serviceReceiverApplicantionApplicants}/${widget.name}/${widget.jobId}',
      options: Options(headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      }),
    );
    if (response.statusCode == 200) {
      return JobApplicantDetailModel.fromJson(response.data);
    } else {
      throw Exception(
        customErrorSnackBar(
          context,
          'Failed to load job applicant detail',
        ),
      );
    }
  }

  getUserToken() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    var userToken = preferences.getString(
      'userToken',
    );
    // if (kDebugMode) {
    //   print(userToken);
    // }
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
            "Job Applicants Detail",
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
                        "Date of birth",
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
                FutureBuilder<JobApplicantDetailModel>(
                  future: futureJobApplicantModel,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return snapshot.data!.data!.isEmpty
                          ? Container(
                              width: MediaQuery.of(context).size.width,
                              height: 40,
                              margin: const EdgeInsets.symmetric(vertical: 15),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(6),
                                border: Border.all(
                                  color: CustomColors.red,
                                  width: 1,
                                ),
                              ),
                              child: const Center(
                                child: Text("Data does not exist"),
                              ),
                            )
                          : ListView.builder(
                              itemCount: snapshot.data!.data!.length,
                              shrinkWrap: true,
                              padding: const EdgeInsets.only(top: 16),
                              physics: const NeverScrollableScrollPhysics(),
                              itemBuilder: (context, index) {
                                return JobApplicantsWidget(
                                  name: "${snapshot.data!.data![index].firstName} ${snapshot.data!.data![index].lastName}",
                                  jobType: snapshot.data!.data![index].userdetail!.gender.toString() == '1' ? "Male" : "Female",
                                  count: '',
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => ApplicantProfileDetail(
                                          jobTitle: widget.name,
                                          jobId: widget.jobId,
                                          profileId: snapshot.data!.data![index].id.toString(),
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
            ),
          ),
        ),
      ),
    );
  }
}
