// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:island_app/carereceiver/models/job_applicant_detail.dart';
import 'package:island_app/utils/app_colors.dart';
import 'package:island_app/utils/app_url.dart';
import 'package:island_app/carereceiver/utils/colors.dart';
import 'package:island_app/carereceiver/widgets/job_applicants_widget.dart';
import 'package:island_app/utils/functions.dart';
import 'package:island_app/utils/http_handlers.dart';
import 'package:island_app/utils/navigation_service.dart';
import 'package:island_app/utils/routes_name.dart';

class JobApplicantsDetail extends StatefulWidget {
  final String name;
  final String? jobId;
  const JobApplicantsDetail({
    super.key,
    required this.name,
    this.jobId,
  });

  @override
  State<JobApplicantsDetail> createState() => _JobApplicantsDetailState();
}

class _JobApplicantsDetailState extends State<JobApplicantsDetail> {
  List? allJobs = [];
  bool isLoading = true;
  // Get all jobs
  late JobApplicantDetailModel futureJobApplicantModel;
  fetchJobApplicantModel() async {
    if (widget.jobId == null || widget.jobId == "null" || widget.name == "null") {
      showErrorToast("No user found");
      setState(() {
        isLoading = false;
      });
      return;
    }
    var token = await getToken();
    final response = await getRequesthandler(
      url: '${CareReceiverURl.serviceReceiverApplicantionApplicants}/${widget.name}/${widget.jobId}',
      token: token,
    );
    setState(() {
      isLoading = false;
    });

    if (response != null && response.statusCode == 200) {
      futureJobApplicantModel = JobApplicantDetailModel.fromJson(response.data);
    } else {
      showErrorToast('Failed to load job applicant detail');
    }
  }

  @override
  void initState() {
    super.initState();
    fetchJobApplicantModel();
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
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: isLoading
              ? Center(
                  child: CircularProgressIndicator(backgroundColor: ServiceRecieverColor.green),
                )
              : Column(
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

                    if (futureJobApplicantModel.data != null) ...[
                      Expanded(
                        child: ListView.builder(
                          itemCount: futureJobApplicantModel.data!.length,
                          shrinkWrap: true,
                          padding: const EdgeInsets.only(top: 16),
                          physics: const NeverScrollableScrollPhysics(),
                          itemBuilder: (context, index) {
                            var item = futureJobApplicantModel.data![index];
                            return JobApplicantsWidget(
                              name: "${item.firstName} ${item.lastName}",
                              jobType: item.userdetail!.gender.toString() == '1' ? "Male" : "Female",
                              count: '',
                              onTap: () {
                                navigationService.push(
                                  RoutesName.recieverProviderDetailApplicantProfileDetail,
                                  arguments: {
                                    "jobId": widget.jobId!,
                                    "jobTitle": widget.name,
                                    "profileId": item.id.toString(),
                                  },
                                );
                              },
                            );
                          },
                        ),
                      ),
                    ] else ...[
                      Container(
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
                    ],
                  ],
                ),
        ),
      ),
    );
  }
}
