// ignore_for_file: use_build_context_synchronously

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:island_app/caregiver/models/child_care_detail-dashbaord_model.dart';
import 'package:island_app/caregiver/models/house_keeping_detail_dashboard_model.dart';
import 'package:island_app/caregiver/models/pet_care_detail_dashboard_model.dart';
import 'package:island_app/caregiver/models/school_support_detail_dashboard.dart';
import 'package:island_app/caregiver/utils/profile_provider.dart';
import 'package:island_app/res/app_url.dart';
import 'package:island_app/utils/utils.dart';
import 'package:island_app/widgets/assistance_container.dart';
import 'package:island_app/widgets/job_detail_tile.dart';
import 'package:island_app/widgets/job_info_container.dart';
import 'package:island_app/widgets/job_schedule_container.dart';
import 'package:provider/provider.dart';
import 'package:island_app/caregiver/models/senior_care_detail_dashboard_model.dart';
import 'package:island_app/carereceiver/utils/colors.dart';
import 'package:island_app/widgets/progress_dialog.dart';

class JobDetailGiver extends StatefulWidget {
  final String? id;
  final String? serviceId;
  const JobDetailGiver({
    Key? key,
    this.id,
    required this.serviceId,
  }) : super(key: key);

  @override
  State<JobDetailGiver> createState() => _JobDetailGiverState();
}

class _JobDetailGiverState extends State<JobDetailGiver> {
  List childInfo = [];
  List scheduleInfo = [];
  // Post Email Verification
  ProgressDialog? pr;
  void showProgress(context) async {
    pr ??= ProgressDialog(context);
    await pr!.show();
  }

  void hideProgress() async {
    if (pr != null && pr!.isShowing()) {
      await pr!.hide();
    }
  }

  Future<Response> jobApply() async {
    var token = await Provider.of<ServiceGiverProvider>(context, listen: false).getUserToken();
    final response = await Dio().put(
      "${CareGiverUrl.serviceProviderJobApply}/${widget.id}",
      options: Options(
        headers: {
          'Authorization': 'Bearer $token',
        },
      ),
    );
    if (response.statusCode == 200) {
      customSuccesSnackBar(
        context,
        "Job applied successfully",
      );
      return response;
    } else {
      customErrorSnackBar(
        context,
        "Server Error",
      );
    }
    return response;
  }

  late Future<SeniorCareDetailDashboardModel>? futureSeniorCareDetailDashboard;
  late Future<SchoolSupportDetailDashboardModel>? futureSchoolSupportDetailDashboard;
  late Future<ChildCareDetailDashboardModel>? futureChildCareDetailDashboard;
  late Future<HouseKeepingDetailDashboardModel>? futureHouseKeepingDetailDashboard;
  late Future<PetCareDetailDashboardModel>? futurePetCareDetailDashboard;
  Future<SeniorCareDetailDashboardModel> fetchSeniorCareDetailDashboardModel() async {
    var token = await Provider.of<ServiceGiverProvider>(context, listen: false).getUserToken();
    final response = await Dio().get(
      '${CareGiverUrl.serviceProviderJobDetail}/${widget.id}',
      options: Options(
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      ),
    );
    if (response.statusCode == 200) {
      return SeniorCareDetailDashboardModel.fromJson(response.data);
    } else {
      throw Exception(
        'Failed to load Service Provider Dashboard',
      );
    }
  }

  Future<SchoolSupportDetailDashboardModel> fetchSchoolSupportDetailDashboardModel() async {
    var token = await Provider.of<ServiceGiverProvider>(context, listen: false).getUserToken();
    // print(token);
    final response = await Dio().get(
      '${CareGiverUrl.serviceProviderJobDetail}/${widget.id}',
      options: Options(
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      ),
    );
    if (response.statusCode == 200) {
      return SchoolSupportDetailDashboardModel.fromJson(response.data);
    } else {
      throw Exception(
        'Failed to load Service Provider Dashboard',
      );
    }
  }

  Future<ChildCareDetailDashboardModel> fetchChildCareDetailDashboardModel() async {
    var token = await Provider.of<ServiceGiverProvider>(context, listen: false).getUserToken();
    final response = await Dio().get(
      '${CareGiverUrl.serviceProviderJobDetail}/${widget.id}',
      options: Options(
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      ),
    );
    if (response.statusCode == 200) {
      return ChildCareDetailDashboardModel.fromJson(response.data);
    } else {
      throw Exception(
        'Failed to load Service Provider Dashboard',
      );
    }
  }

  Future<HouseKeepingDetailDashboardModel> fetchHouseKeepingDetailDashboardModel() async {
    var token = await Provider.of<ServiceGiverProvider>(context, listen: false).getUserToken();
    final response = await Dio().get(
      '${CareGiverUrl.serviceProviderJobDetail}/${widget.id}',
      options: Options(
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      ),
    );
    if (response.statusCode == 200) {
      return HouseKeepingDetailDashboardModel.fromJson(response.data);
    } else {
      throw Exception(
        'Failed to load Service Provider Dashboard',
      );
    }
  }

  Future<PetCareDetailDashboardModel> fetchPetCareDetailDashboardModel() async {
    var token = await Provider.of<ServiceGiverProvider>(context, listen: false).getUserToken();
    final response = await Dio().get(
      '${CareGiverUrl.serviceProviderJobDetail}/${widget.id}',
      options: Options(
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      ),
    );
    if (response.statusCode == 200) {
      return PetCareDetailDashboardModel.fromJson(response.data);
    } else {
      throw Exception(
        'Failed to load Service Provider Dashboard',
      );
    }
  }

  @override
  void initState() {
    super.initState();
    futureSeniorCareDetailDashboard = fetchSeniorCareDetailDashboardModel();
    futureSchoolSupportDetailDashboard = fetchSchoolSupportDetailDashboardModel();
    futureChildCareDetailDashboard = fetchChildCareDetailDashboardModel();
    futureHouseKeepingDetailDashboard = fetchHouseKeepingDetailDashboardModel();
    futurePetCareDetailDashboard = fetchPetCareDetailDashboardModel();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CustomColors.loginBg,
      appBar: AppBar(
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
        // elevation: 0,
        // backgroundColor: CustomColors.white,
        centerTitle: true,
        title: Text(
          "Job Detail",
          style: TextStyle(
            fontSize: 20,
            color: CustomColors.primaryText,
            fontFamily: "Poppins",
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            if (widget.serviceId == "1") ...[
              // service id 1
              serviceSeniorCare(context),
            ] else if (widget.serviceId == "2") ...[
              // service id 2
              servicePetCare(context),
            ] else if (widget.serviceId == "3") ...[
              // service id 3
              serviceHouseKeeping(context),
            ] else if (widget.serviceId == "4") ...[
              // Service Id 4
              serviceSchoolSupport(context),
            ] else if (widget.serviceId == "5") ...[
              // Service Id 5
              serviceChildCare(context),
            ],
          ],
        ),
      ),
    );
  }

  GestureDetector applyButton(bool isApplied) {
    return GestureDetector(
      onTap: () {
        if (isApplied) {
          jobApply();
        } else {
          customSuccesSnackBar(context, "Already Applied");
        }
      },
      child: Container(
        height: 60,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          color: isApplied ? ServiceGiverColor.redButton : ServiceGiverColor.redButtonLigth,
        ),
        margin: const EdgeInsets.symmetric(horizontal: 10),
        child: Center(
          child: Text(
            isApplied ? "Apply Now" : "Applied",
            style: TextStyle(
              color: CustomColors.white,
              fontFamily: "Poppins",
              fontSize: 16,
              fontStyle: FontStyle.normal,
              fontWeight: FontWeight.w900,
            ),
          ),
        ),
      ),
    );
  }

// Done
  Widget serviceSeniorCare(BuildContext context) {
    return FutureBuilder<SeniorCareDetailDashboardModel>(
      future: futureSeniorCareDetailDashboard,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return ListView.builder(
            shrinkWrap: true,
            scrollDirection: Axis.vertical,
            physics: const NeverScrollableScrollPhysics(),
            padding: const EdgeInsets.all(20),
            itemCount: snapshot.data!.jobDetail!.length,
            itemBuilder: (BuildContext context, int index) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  JobInfoContainer(
                    title: snapshot.data!.jobDetail![index].jobTitle.toString(),
                    address: snapshot.data!.jobDetail![index].address.toString(),
                    location: snapshot.data!.jobDetail![index].location.toString(),
                    hourlyRate: "\$${snapshot.data!.jobDetail![index].hourlyRate.toString()}/hour",
                  ),
                  const SizedBox(height: 10),
                  JobDetailTile(
                    name: "Senior Initials",
                    title: snapshot.data!.jobDetail![index].seniorCare!.seniorName.toString(),
                  ),
                  const SizedBox(height: 10),
                  JobDetailTile(
                    name: "Date of Birth",
                    title: snapshot.data!.jobDetail![index].seniorCare!.dob.toString(),
                  ),
                  const SizedBox(height: 10),
                  JobDetailTile(
                    name: "Medical Condition",
                    title: snapshot.data!.jobDetail![index].seniorCare!.medicalCondition.toString(),
                  ),
                  const SizedBox(height: 10),
                  JobDetailTile(
                    name: "Additional Info",
                    title: snapshot.data!.jobDetail![index].additionalInfo ?? "",
                  ),
                  const SizedBox(height: 10),
                  // Assistancce Container
                  if (snapshot.data!.jobDetail![index].seniorCare != null) ...[
                    AssistanceContainer(
                      dd: [
                        if (snapshot.data!.jobDetail![index].seniorCare!.bathing.toString() == "1") ...[
                          snapshot.data!.jobDetail![index].seniorCare!.bathing.toString() == "1"
                              ? "bathing"
                              : snapshot.data!.jobDetail![index].seniorCare!.bathing.toString(),
                        ],
                        if (snapshot.data!.jobDetail![index].seniorCare!.dressing.toString() == "1") ...[
                          snapshot.data!.jobDetail![index].seniorCare!.dressing.toString() == "1"
                              ? "dressing"
                              : snapshot.data!.jobDetail![index].seniorCare!.dressing.toString(),
                        ],
                        if (snapshot.data!.jobDetail![index].seniorCare!.feeding.toString() == "1") ...[
                          snapshot.data!.jobDetail![index].seniorCare!.feeding.toString() == "1"
                              ? "feeding"
                              : snapshot.data!.jobDetail![index].seniorCare!.feeding.toString(),
                        ],
                        if (snapshot.data!.jobDetail![index].seniorCare!.mealPreparation.toString() == "1") ...[
                          snapshot.data!.jobDetail![index].seniorCare!.mealPreparation.toString() == "1"
                              ? "mealPreparation"
                              : snapshot.data!.jobDetail![index].seniorCare!.mealPreparation.toString(),
                        ],
                        if (snapshot.data!.jobDetail![index].seniorCare!.groceryShopping.toString() == "1") ...[
                          snapshot.data!.jobDetail![index].seniorCare!.groceryShopping.toString() == "1"
                              ? "groceryShopping"
                              : snapshot.data!.jobDetail![index].seniorCare!.groceryShopping.toString(),
                        ],
                        if (snapshot.data!.jobDetail![index].seniorCare!.walking.toString() == "1") ...[
                          snapshot.data!.jobDetail![index].seniorCare!.walking.toString() == "1"
                              ? "walking"
                              : snapshot.data!.jobDetail![index].seniorCare!.walking.toString(),
                        ],
                        if (snapshot.data!.jobDetail![index].seniorCare!.bedTransfer.toString() == "1") ...[
                          snapshot.data!.jobDetail![index].seniorCare!.bedTransfer.toString() == "1"
                              ? "bedTransfer"
                              : snapshot.data!.jobDetail![index].seniorCare!.bedTransfer.toString(),
                        ],
                        if (snapshot.data!.jobDetail![index].seniorCare!.lightCleaning.toString() == "1") ...[
                          snapshot.data!.jobDetail![index].seniorCare!.lightCleaning.toString() == "1"
                              ? "lightCleaning"
                              : snapshot.data!.jobDetail![index].seniorCare!.lightCleaning.toString(),
                        ],
                        if (snapshot.data!.jobDetail![index].seniorCare!.companionship.toString() == "1") ...[
                          snapshot.data!.jobDetail![index].seniorCare!.companionship.toString() == "1"
                              ? "companionship"
                              : snapshot.data!.jobDetail![index].seniorCare!.companionship.toString(),
                        ],
                        if (snapshot.data!.jobDetail![index].seniorCare!.medicationAdministration.toString() == "1") ...[
                          snapshot.data!.jobDetail![index].seniorCare!.medicationAdministration.toString() == "1"
                              ? "medicationAdministration"
                              : snapshot.data!.jobDetail![index].seniorCare!.medicationAdministration.toString(),
                        ],
                        if (snapshot.data!.jobDetail![index].seniorCare!.dressingWoundCare.toString() == "1") ...[
                          snapshot.data!.jobDetail![index].seniorCare!.dressingWoundCare.toString() == "1"
                              ? "dressingWoundCare"
                              : snapshot.data!.jobDetail![index].seniorCare!.dressingWoundCare.toString(),
                        ],
                        if (snapshot.data!.jobDetail![index].seniorCare!.bloodPressureMonetoring.toString() == "1") ...[
                          snapshot.data!.jobDetail![index].seniorCare!.bloodPressureMonetoring.toString() == "1"
                              ? "bloodPressureMonetoring"
                              : snapshot.data!.jobDetail![index].seniorCare!.bloodPressureMonetoring.toString(),
                        ],
                        if (snapshot.data!.jobDetail![index].seniorCare!.bloodSugarMonetoring.toString() == "1") ...[
                          snapshot.data!.jobDetail![index].seniorCare!.bloodSugarMonetoring.toString() == "1"
                              ? "bloodSugarMonetoring"
                              : snapshot.data!.jobDetail![index].seniorCare!.bloodSugarMonetoring.toString(),
                        ],
                        if (snapshot.data!.jobDetail![index].seniorCare!.groomingHairAndNailTrimming.toString() == "1") ...[
                          snapshot.data!.jobDetail![index].seniorCare!.groomingHairAndNailTrimming.toString() == "1"
                              ? "groomingHairAndNailTrimming"
                              : snapshot.data!.jobDetail![index].seniorCare!.groomingHairAndNailTrimming.toString(),
                        ],
                      ],
                    ),
                  ],

                  const SizedBox(height: 10),
                  if (snapshot.data!.jobDetail![index].schedule!.isNotEmpty) ...[
                    JobScheduleContainer(
                      data: snapshot.data!.jobDetail![index].schedule,
                    ),
                  ],
                  const SizedBox(height: 20),
                  applyButton(snapshot.data!.isApplied == 0)
                ],
              );
            },
          );
        } else {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }

  // done

  Widget serviceSchoolSupport(BuildContext context) {
    return FutureBuilder<SchoolSupportDetailDashboardModel>(
      future: futureSchoolSupportDetailDashboard,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return ListView.builder(
            shrinkWrap: true,
            scrollDirection: Axis.vertical,
            physics: const NeverScrollableScrollPhysics(),
            padding: const EdgeInsets.all(20),
            itemCount: snapshot.data!.jobDetail!.length,
            itemBuilder: (BuildContext context, int index) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  JobInfoContainer(
                    title: snapshot.data!.jobDetail![index].jobTitle.toString(),
                    address: snapshot.data!.jobDetail![index].address.toString(),
                    location: snapshot.data!.jobDetail![index].location.toString(),
                    hourlyRate: "\$${snapshot.data!.jobDetail![index].hourlyRate.toString()}/hour",
                  ),
                  const SizedBox(height: 10),
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Information About Child",
                      style: TextStyle(
                        fontFamily: "Poppins",
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  for (var i = 0; i < snapshot.data!.jobDetail![index].childinfo!.length; i++) ...[
                    if (snapshot.data!.jobDetail![index].childinfo!.length > 1) ...[
                      const SizedBox(height: 10),
                      Text(
                        "Child ${i + 1}",
                        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(height: 10),
                    ],
                    JobDetailTile(
                      name: "Child Initials",
                      title: snapshot.data!.jobDetail![index].childinfo![i].name.toString(),
                    ),
                    const SizedBox(height: 10),
                    JobDetailTile(
                      name: "Child Age",
                      title: snapshot.data!.jobDetail![index].childinfo![i].age.toString(),
                    ),
                    const SizedBox(height: 10),
                    JobDetailTile(
                      name: "Child Grade",
                      title: snapshot.data!.jobDetail![index].childinfo![i].grade.toString(),
                    ),
                    const SizedBox(height: 10),
                  ],

                  // SizedBox(
                  //   child: Column(
                  //     crossAxisAlignment: CrossAxisAlignment.start,
                  //     children: [
                  // snapshot.data!.jobDetail![index].childinfo!.isEmpty
                  //     ? Container()
                  //     : Container(
                  //         padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 12),
                  //         alignment: Alignment.topLeft,
                  //         child: Text(
                  //           "Information About Child",
                  //           style: TextStyle(
                  //             color: CustomColors.primaryText,
                  //             fontFamily: "Poppins",
                  //             fontSize: 18,
                  //             fontWeight: FontWeight.w600,
                  //           ),
                  //         ),
                  //       ),
                  // snapshot.data!.jobDetail![index].childinfo!.isEmpty
                  //     ? Container()
                  //     : Container(
                  //         padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                  //         margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 0),
                  //         alignment: Alignment.center,
                  //         decoration: BoxDecoration(
                  //           color: CustomColors.white,
                  //         ),
                  //         child: Column(
                  //           children: [
                  //             SizedBox(
                  //               child: Column(
                  //                 children: [
                  //                   Row(
                  //                     children: [
                  //                       Container(
                  //                         alignment: Alignment.topLeft,
                  //                         width: 150,
                  //                         child: Text(
                  //                           "Child Name :",
                  //                           style: TextStyle(
                  //                             color: CustomColors.primaryText,
                  //                             fontFamily: "Poppins",
                  //                             fontSize: 13,
                  //                             fontWeight: FontWeight.w400,
                  //                           ),
                  //                         ),
                  //                       ),
                  //                       Expanded(
                  //                         child: Text(
                  //                           snapshot.data!.jobDetail![index].childinfo!.isEmpty ? "Data Not Available" : snapshot.data!.jobDetail![index].childinfo![index].name.toString(),
                  //                           style: TextStyle(
                  //                             color: CustomColors.primaryText,
                  //                             fontFamily: "Poppins",
                  //                             fontSize: 13,
                  //                             fontWeight: FontWeight.w600,
                  //                           ),
                  //                         ),
                  //                       ),
                  //                     ],
                  //                   ),
                  //                   const SizedBox(
                  //                     height: 5,
                  //                   ),
                  //                   Row(
                  //                     children: [
                  //                       Container(
                  //                         alignment: Alignment.topLeft,
                  //                         width: 150,
                  //                         child: Text(
                  //                           "Child Age :",
                  //                           style: TextStyle(
                  //                             color: CustomColors.primaryText,
                  //                             fontFamily: "Poppins",
                  //                             fontSize: 13,
                  //                             fontWeight: FontWeight.w400,
                  //                           ),
                  //                         ),
                  //                       ),
                  //                       Expanded(
                  //                         child: Text(
                  //                           snapshot.data!.jobDetail![index].childinfo!.isEmpty ? "Data Not Available" : snapshot.data!.jobDetail![index].childinfo![index].age.toString(),
                  //                           style: TextStyle(
                  //                             color: CustomColors.primaryText,
                  //                             fontFamily: "Poppins",
                  //                             fontSize: 13,
                  //                             fontWeight: FontWeight.w400,
                  //                           ),
                  //                         ),
                  //                       ),
                  //                     ],
                  //                   ),
                  //                 ],
                  //               ),
                  //             ),
                  //           ],
                  //         ),
                  //       ),
                  //     ],
                  //   ),
                  // ),
                  if (snapshot.data!.jobDetail![index].schoolCamp != null) ...[
                    JobDetailTile(
                      name: "Interest for Child",
                      title: snapshot.data!.jobDetail![index].schoolCamp!.interestForChild.toString(),
                    ),
                    // Row(
                    //   crossAxisAlignment: CrossAxisAlignment.center,
                    //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    //   children: [
                    //     SizedBox(
                    //       width: MediaQuery.of(context).size.width * .4,
                    //       child: Text(
                    //         "Interest for Child",
                    //         style: TextStyle(
                    //           fontSize: 14,
                    //           fontFamily: "Poppins",
                    //           fontWeight: FontWeight.w500,
                    //           color: CustomColors.primaryTextLight,
                    //         ),
                    //       ),
                    //     ),
                    //     if (snapshot.data!.jobDetail![index].schoolCamp != null) ...[
                    //       SizedBox(
                    //         width: MediaQuery.of(context).size.width * .5,
                    //         child: Text(
                    //           snapshot.data!.jobDetail![index].schoolCamp!.interestForChild.toString(),
                    //           style: TextStyle(
                    //             fontSize: 14,
                    //             fontFamily: "Poppins",
                    //             fontWeight: FontWeight.w600,
                    //             color: CustomColors.primaryTextLight,
                    //           ),
                    //         ),
                    //       ),
                    //     ]
                    //   ],
                    // ),
                    const SizedBox(height: 10),
                    JobDetailTile(
                      name: "Cost Range For Camp",
                      title: snapshot.data!.jobDetail![index].schoolCamp!.costRange.toString(),
                    ),
                    // Row(
                    //   crossAxisAlignment: CrossAxisAlignment.center,
                    //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    //   children: [
                    //     SizedBox(
                    //       width: MediaQuery.of(context).size.width * .4,
                    //       child: Text(
                    //         "Cost Range For Camp",
                    //         style: TextStyle(
                    //           fontSize: 14,
                    //           fontFamily: "Poppins",
                    //           fontWeight: FontWeight.w500,
                    //           color: CustomColors.primaryTextLight,
                    //         ),
                    //       ),
                    //     ),
                    //     if (snapshot.data!.jobDetail![index].schoolCamp != null) ...[
                    //       SizedBox(
                    //         width: MediaQuery.of(context).size.width * .5,
                    //         child: Text(
                    //           snapshot.data!.jobDetail![index].schoolCamp!.costRange.toString(),
                    //           style: TextStyle(
                    //             fontSize: 14,
                    //             fontFamily: "Poppins",
                    //             fontWeight: FontWeight.w600,
                    //             color: CustomColors.primaryTextLight,
                    //           ),
                    //         ),
                    //       ),
                    //     ],
                    //   ],
                    // ),
                    const SizedBox(height: 10),
                  ],
                  if (snapshot.data!.jobDetail![index].learning != null) ...[
                    const SizedBox(height: 10),
                    AssistanceContainer(
                      dd: [
                        if (snapshot.data!.jobDetail![index].learning!.assistanceInReading == 1) ...["Reading"],
                        if (snapshot.data!.jobDetail![index].learning!.assistanceInEnglish == 1) ...["English"],
                        if (snapshot.data!.jobDetail![index].learning!.assistanceInMath == 1) ...["Math"],
                        if (snapshot.data!.jobDetail![index].learning!.assistanceInScience == 1) ...["Science"],
                        if (snapshot.data!.jobDetail![index].learning!.assistanceInOther != null) ...[
                          snapshot.data!.jobDetail![index].learning!.assistanceInOther.toString()
                        ],
                      ],
                    ),
                  ],
                  const SizedBox(height: 10),
                  if (snapshot.data!.jobDetail![index].learning != null && snapshot.data!.jobDetail![index].learning!.learningStyle != null) ...[
                    JobDetailTile(
                      name: "Learning Style",
                      title: snapshot.data!.jobDetail![index].learning!.learningStyle.toString(),
                    ),
                    const SizedBox(height: 10),
                  ],
                  if (snapshot.data!.jobDetail![index].learning != null && snapshot.data!.jobDetail![index].learning!.learningChallenge != null) ...[
                    JobDetailTile(
                      name: "Learning Challenge",
                      title: snapshot.data!.jobDetail![index].learning!.learningChallenge.toString(),
                    ),
                    const SizedBox(height: 10),
                  ],
                  if (snapshot.data!.jobDetail![index].additionalInfo != null) ...[
                    JobDetailTile(
                      name: "Additional Info",
                      title: snapshot.data!.jobDetail![index].additionalInfo ?? "",
                    ),
                    const SizedBox(height: 10),
                  ],
                  if (snapshot.data!.jobDetail![index].schedule!.isNotEmpty) ...[
                    JobScheduleContainer(
                      data: snapshot.data!.jobDetail![index].schedule,
                    ),
                  ],
                  const SizedBox(height: 20),
                  applyButton(snapshot.data!.isApplied == 0)
                ],
              );
            },
          );
        } else {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }
  //  Done

  Widget serviceChildCare(BuildContext context) {
    return FutureBuilder<ChildCareDetailDashboardModel>(
      future: futureChildCareDetailDashboard,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return ListView.builder(
            shrinkWrap: true,
            scrollDirection: Axis.vertical,
            physics: const NeverScrollableScrollPhysics(),
            padding: const EdgeInsets.all(20),
            itemCount: snapshot.data!.jobDetail!.length,
            itemBuilder: (BuildContext context, int index) {
              return Column(
                children: [
                  JobInfoContainer(
                    title: snapshot.data!.jobDetail![index].jobTitle.toString(),
                    address: snapshot.data!.jobDetail![index].address.toString(),
                    location: snapshot.data!.jobDetail![index].location.toString(),
                    hourlyRate: "\$${snapshot.data!.jobDetail![index].hourlyRate.toString()}/hour",
                  ),
                  const SizedBox(height: 10),
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Information About Child",
                      style: TextStyle(
                        fontFamily: "Poppins",
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  for (var i = 0; i < snapshot.data!.jobDetail![index].childinfo!.length; i++) ...[
                    if (snapshot.data!.jobDetail![index].childinfo!.length > 1) ...[
                      const SizedBox(height: 10),
                      Text(
                        "Child ${i + 1}",
                        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(height: 10),
                    ],
                    JobDetailTile(
                      name: "Child Initials",
                      title: snapshot.data!.jobDetail![index].childinfo![i].name.toString(),
                    ),
                    const SizedBox(height: 10),
                    JobDetailTile(
                      name: "Child Age",
                      title: snapshot.data!.jobDetail![index].childinfo![i].age.toString(),
                    ),
                    const SizedBox(height: 10),
                  ],
                  if (snapshot.data!.jobDetail![index].schoolCamp != null) ...[
                    JobDetailTile(
                      name: "Interest for Child",
                      title: snapshot.data!.jobDetail![index].schoolCamp!.interestForChild.toString(),
                    ),
                    const SizedBox(height: 10),
                    JobDetailTile(
                      name: "Cost Range For Camp",
                      title: snapshot.data!.jobDetail![index].schoolCamp!.costRange.toString(),
                    ),
                    const SizedBox(height: 10),
                  ],
                  // const SizedBox(height: 10),
                  // JobDetailTile(
                  //   name: "Additional Info",
                  //   title: snapshot.data!.jobDetail![index].additionalInfo ?? "",
                  // ),
                  const SizedBox(height: 10),
                  if (snapshot.data!.jobDetail![index].schedule!.isNotEmpty) ...[
                    JobScheduleContainer(
                      data: snapshot.data!.jobDetail![index].schedule,
                    ),
                  ],
                  const SizedBox(height: 20),
                  applyButton(snapshot.data!.isApplied == 0)
                ],
              );
            },
          );
        } else {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }

  // done

  Widget serviceHouseKeeping(BuildContext context) {
    return FutureBuilder<HouseKeepingDetailDashboardModel>(
      future: futureHouseKeepingDetailDashboard,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return ListView.builder(
            shrinkWrap: true,
            scrollDirection: Axis.vertical,
            physics: const NeverScrollableScrollPhysics(),
            padding: const EdgeInsets.all(20),
            itemCount: snapshot.data!.jobDetail!.length,
            itemBuilder: (BuildContext context, int index) {
              return Column(
                children: [
                  Container(
                    alignment: Alignment.center,
                    child: Column(
                      children: [
                        JobInfoContainer(
                          title: snapshot.data!.jobDetail![index].jobTitle.toString(),
                          address: snapshot.data!.jobDetail![index].address.toString(),
                          location: snapshot.data!.jobDetail![index].location.toString(),
                          hourlyRate: snapshot.data!.jobDetail![index].hourlyRate.toString(),
                        ),
                        const SizedBox(height: 10),
                        JobDetailTile(
                          name: "Cleaning Type",
                          title: snapshot.data!.jobDetail![index].houseKeeping!.cleaningType.toString(),
                        ),
                        const SizedBox(height: 10),
                        JobDetailTile(
                          name: "Number of Bedrooms",
                          title: snapshot.data!.jobDetail![index].houseKeeping!.numberOfBedrooms.toString(),
                        ),
                        const SizedBox(height: 10),
                        JobDetailTile(
                          name: "Number of Bathrooms",
                          title: snapshot.data!.jobDetail![index].houseKeeping!.numberOfBathrooms.toString(),
                        ),
                        const SizedBox(height: 10),
                        JobDetailTile(
                          name: "Laundary",
                          title: snapshot.data!.jobDetail![index].houseKeeping!.laundry.toString() == "1" ? "Yes" : "No",
                        ),
                        const SizedBox(height: 10),
                        JobDetailTile(
                          name: "Ironing",
                          title: snapshot.data!.jobDetail![index].houseKeeping!.ironing.toString() == "1" ? "Yes" : "No",
                        ),
                        const SizedBox(height: 10),
                        JobDetailTile(
                          name: "Other",
                          title: snapshot.data!.jobDetail![index].houseKeeping!.other.toString() == "null"
                              ? ""
                              : snapshot.data!.jobDetail![index].houseKeeping!.other.toString(),
                        ),
                        const SizedBox(height: 10),
                        JobDetailTile(
                          name: "Additional Info",
                          title: snapshot.data!.jobDetail![index].additionalInfo ?? "",
                        ),
                        const SizedBox(height: 10),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  JobScheduleContainer(
                    data: snapshot.data!.jobDetail![index].schedule,
                  ),
                  const SizedBox(height: 20),
                  applyButton(snapshot.data!.isApplied == 0),
                ],
              );
            },
          );
        } else {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }

// done
  Widget servicePetCare(BuildContext context) {
    return FutureBuilder<PetCareDetailDashboardModel>(
      future: futurePetCareDetailDashboard,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return ListView.builder(
            shrinkWrap: true,
            scrollDirection: Axis.vertical,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: snapshot.data!.jobDetail!.length,
            padding: const EdgeInsets.all(20),
            itemBuilder: (BuildContext context, int index) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    children: [
                      JobInfoContainer(
                        title: snapshot.data!.jobDetail![index].jobTitle.toString(),
                        address: snapshot.data!.jobDetail![index].address.toString(),
                        location: snapshot.data!.jobDetail![index].location.toString(),
                        hourlyRate: "\$${snapshot.data!.jobDetail![index].hourlyRate.toString()}/hour",
                      ),
                      const SizedBox(height: 10),
                      JobDetailTile(
                        name: "Pet Type",
                        title: snapshot.data!.jobDetail![index].petCare!.petType.toString(),
                      ),
                      const SizedBox(height: 10),
                      JobDetailTile(
                        name: "Number of Pet",
                        title: snapshot.data!.jobDetail![index].petCare!.numberOfPets.toString(),
                      ),
                      const SizedBox(height: 10),
                      JobDetailTile(
                        name: "Pet Breed",
                        title: snapshot.data!.jobDetail![index].petCare!.petBreed.toString(),
                      ),
                      const SizedBox(height: 10),
                      JobDetailTile(
                        name: "Size Of Pet",
                        title: snapshot.data!.jobDetail![index].petCare!.sizeOfPet.toString(),
                      ),
                      const SizedBox(height: 10),
                      JobDetailTile(
                        name: "Temperament",
                        title: snapshot.data!.jobDetail![index].petCare!.temperament.toString(),
                      ),
                      const SizedBox(height: 10),
                      JobDetailTile(
                        name: "Additional Info",
                        title: snapshot.data!.jobDetail![index].additionalInfo ?? "",
                      ),
                      const SizedBox(height: 10),
                    ],
                  ),
                  const SizedBox(height: 10),
                  AssistanceContainer(
                    dd: [
                      if (snapshot.data!.jobDetail![index].petCare!.walking.toString() == "1") ...[
                        snapshot.data!.jobDetail![index].petCare!.walking.toString() == "1"
                            ? "Walking"
                            : snapshot.data!.jobDetail![index].petCare!.walking.toString(),
                      ],
                      if (snapshot.data!.jobDetail![index].petCare!.daycare.toString() == "1") ...[
                        snapshot.data!.jobDetail![index].petCare!.daycare.toString() == "1"
                            ? "Day Care"
                            : snapshot.data!.jobDetail![index].petCare!.daycare.toString(),
                      ],
                      if (snapshot.data!.jobDetail![index].petCare!.feeding.toString() == "1") ...[
                        snapshot.data!.jobDetail![index].petCare!.feeding.toString() == "1"
                            ? "Feeding"
                            : snapshot.data!.jobDetail![index].petCare!.feeding.toString(),
                      ],
                      if (snapshot.data!.jobDetail![index].petCare!.socialization.toString() == "1") ...[
                        snapshot.data!.jobDetail![index].petCare!.socialization.toString() == "1"
                            ? "Socialization"
                            : snapshot.data!.jobDetail![index].petCare!.socialization.toString(),
                      ],
                      if (snapshot.data!.jobDetail![index].petCare!.grooming.toString() == "1") ...[
                        snapshot.data!.jobDetail![index].petCare!.grooming.toString() == "1"
                            ? "Grooming"
                            : snapshot.data!.jobDetail![index].petCare!.grooming.toString(),
                      ],
                      if (snapshot.data!.jobDetail![index].petCare!.boarding.toString() == "1") ...[
                        snapshot.data!.jobDetail![index].petCare!.boarding.toString() == "1"
                            ? "Boarding"
                            : snapshot.data!.jobDetail![index].petCare!.boarding.toString(),
                      ],
                    ],
                  ),
                  const SizedBox(height: 10),
                  if (snapshot.data!.jobDetail![index].schedule!.isNotEmpty) ...[
                    JobScheduleContainer(
                      data: snapshot.data!.jobDetail![index].schedule,
                      // date: snapshot.data!.jobDetail![index].schedule!.isEmpty ? "Data Not Available" : snapshot.data!.jobDetail![index].schedule![index].startingDate.toString(),
                      // startTime: snapshot.data!.jobDetail![index].schedule!.isEmpty ? "Data Not Available" : snapshot.data!.jobDetail![index].schedule![index].startingTime.toString(),
                      // duration: "${snapshot.data!.jobDetail![index].schedule!.isEmpty ? "Data Not Available" : snapshot.data!.jobDetail![index].schedule![index].duration.toString()} hours",
                    ),
                  ],
                  const SizedBox(height: 10),
                  applyButton(snapshot.data!.isApplied == 0)
                ],
              );
            },
          );
        } else {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }
}
