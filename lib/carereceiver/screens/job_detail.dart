// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:island_app/caregiver/models/child_care_detail-dashbaord_model.dart';
import 'package:island_app/caregiver/models/house_keeping_detail_dashboard_model.dart';
import 'package:island_app/caregiver/models/pet_care_detail_dashboard_model.dart';
import 'package:island_app/caregiver/models/school_support_detail_dashboard.dart';
import 'package:island_app/carereceiver/screens/edit_job_post.dart';
import 'package:island_app/utils/app_colors.dart';
import 'package:island_app/widgets/assistance_container.dart';
import 'package:island_app/widgets/job_detail_tile.dart';
import 'package:island_app/widgets/job_info_container.dart';
import 'package:island_app/widgets/job_schedule_container.dart';
import 'package:island_app/caregiver/models/senior_care_detail_dashboard_model.dart';
import 'package:island_app/carereceiver/utils/colors.dart';
import 'package:island_app/widgets/progress_dialog.dart';

class ReceiverJobDetail extends StatefulWidget {
  // final String? id;
  final dynamic jobData;
  final String? serviceId;
  const ReceiverJobDetail({
    super.key,
    // this.id,
    required this.serviceId,
    this.jobData,
  });

  @override
  State<ReceiverJobDetail> createState() => _ReceiverJobDetailState();
}

class _ReceiverJobDetailState extends State<ReceiverJobDetail> {
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

  // Future<Response> jobApply() async {
  //   var token = await Provider.of<RecieverUserProvider>(context, listen: false).getUserToken();
  //   final response = await Dio().put(
  //     "${CareReceiverURl.serviceReceiverJobBoardDetail}/${widget.id}",
  //     options: Options(
  //       headers: {
  //         'Authorization': 'Bearer $token',
  //       },
  //     ),
  //   );
  //   if (response.statusCode == 200) {
  //     customSuccesSnackBar(
  //       context,
  //       "Job applied successfully",
  //     );
  //     return response;
  //   } else {
  //     customErrorSnackBar(
  //       context,
  //       "Server Error",
  //     );
  //   }
  //   return response;
  // }

  SeniorCareDetailDashboardModel? futureSeniorCareDetailDashboard;
  SchoolSupportDetailDashboardModel? futureSchoolSupportDetailDashboard;
  ChildCareDetailDashboardModel? futureChildCareDetailDashboard;
  HouseKeepingDetailDashboardModel? futureHouseKeepingDetailDashboard;
  PetCareDetailDashboardModel? futurePetCareDetailDashboard;

  // Future<SeniorCareDetailDashboardModel> fetchSeniorCareDetailDashboardModel() async {
  //   var token = await Provider.of<RecieverUserProvider>(context, listen: false).getUserToken();
  //   final response = await Dio().get(
  //     '${CareReceiverURl.serviceReceiverJobBoardDetail}/${widget.id}',
  //     options: Options(
  //       headers: {
  //         'Authorization': 'Bearer $token',
  //         'Accept': 'application/json',
  //       },
  //     ),
  //   );
  //   if (response.statusCode == 200) {
  //     return SeniorCareDetailDashboardModel.fromJson({"job_detail": response.data['job']});
  //   } else {
  //     throw Exception(
  //       'Failed to load Service Provider Dashboard',
  //     );
  //   }
  // }

  // Future<SchoolSupportDetailDashboardModel> fetchSchoolSupportDetailDashboardModel() async {
  //   var token = await Provider.of<RecieverUserProvider>(context, listen: false).getUserToken();
  //   // print(token);
  //   final response = await Dio().get(
  //     '${CareReceiverURl.serviceReceiverJobBoardDetail}/${widget.id}',
  //     options: Options(
  //       headers: {
  //         'Authorization': 'Bearer $token',
  //         'Accept': 'application/json',
  //       },
  //     ),
  //   );
  //   if (response.statusCode == 200) {
  //     return SchoolSupportDetailDashboardModel.fromJson({"job_detail": response.data['job']});
  //   } else {
  //     throw Exception(
  //       'Failed to load Service Provider Dashboard',
  //     );
  //   }
  // }

  // Future<ChildCareDetailDashboardModel> fetchChildCareDetailDashboardModel() async {
  //   var token = await Provider.of<RecieverUserProvider>(context, listen: false).getUserToken();
  //   final response = await Dio().get(
  //     '${CareReceiverURl.serviceReceiverJobBoardDetail}/${widget.id}',
  //     options: Options(
  //       headers: {
  //         'Authorization': 'Bearer $token',
  //         'Accept': 'application/json',
  //       },
  //     ),
  //   );
  //   if (response.statusCode == 200) {
  //     return ChildCareDetailDashboardModel.fromJson({"job_detail": response.data['job']});
  //   } else {
  //     throw Exception(
  //       'Failed to load Service Provider Dashboard',
  //     );
  //   }
  // }

  // Future<HouseKeepingDetailDashboardModel> fetchHouseKeepingDetailDashboardModel() async {
  //   var token = await Provider.of<RecieverUserProvider>(context, listen: false).getUserToken();
  //   final response = await Dio().get(
  //     '${CareReceiverURl.serviceReceiverJobBoardDetail}/${widget.id}',
  //     options: Options(
  //       headers: {
  //         'Authorization': 'Bearer $token',
  //         'Accept': 'application/json',
  //       },
  //     ),
  //   );
  //   if (response.statusCode == 200) {
  //     return HouseKeepingDetailDashboardModel.fromJson({"job_detail": response.data['job']});
  //   } else {
  //     throw Exception(
  //       'Failed to load Service Provider Dashboard',
  //     );
  //   }
  // }

  // Future<PetCareDetailDashboardModel> fetchPetCareDetailDashboardModel() async {
  //   var token = await Provider.of<RecieverUserProvider>(context, listen: false).getUserToken();
  //   final response = await Dio().get(
  //     '${CareReceiverURl.serviceReceiverJobBoardDetail}/${widget.id}',
  //     options: Options(
  //       headers: {
  //         'Authorization': 'Bearer $token',
  //         'Accept': 'application/json',
  //       },
  //     ),
  //   );
  //   if (response.statusCode == 200) {
  //     return PetCareDetailDashboardModel.fromJson({"job_detail": response.data['job']});
  //   } else {
  //     throw Exception(
  //       'Failed to load Service Provider Dashboard',
  //     );
  //   }
  // }

  @override
  void initState() {
    super.initState();
    if (widget.serviceId == "1") {
      // service id 1
      // serviceSeniorCare(context);
      futureSeniorCareDetailDashboard = SeniorCareDetailDashboardModel.fromJson({
        "job_detail": [widget.jobData]
      });
    } else if (widget.serviceId == "2") {
      // service id 2;
      // servicePetCare(context);
      futurePetCareDetailDashboard = PetCareDetailDashboardModel.fromJson({
        "job_detail": [widget.jobData]
      });
    } else if (widget.serviceId == "3") {
      // service id 3
      // serviceHouseKeeping(context);
      futureHouseKeepingDetailDashboard = HouseKeepingDetailDashboardModel.fromJson({
        "job_detail": [widget.jobData]
      });
    } else if (widget.serviceId == "4") {
      // Service Id 4
      // serviceSchoolSupport(context);
      futureSchoolSupportDetailDashboard = SchoolSupportDetailDashboardModel.fromJson({
        "job_detail": [widget.jobData]
      });
    } else if (widget.serviceId == "5") {
      // Service Id 5
      // serviceChildCare(context);
      futureChildCareDetailDashboard = ChildCareDetailDashboardModel.fromJson({
        "job_detail": [widget.jobData]
      });
    }
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

  GestureDetector deleteButton(int? id) {
    return GestureDetector(
      onTap: () {
        // jobApply();
      },
      child: Container(
        height: 60,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          color: ServiceGiverColor.redButton,
        ),
        margin: const EdgeInsets.symmetric(horizontal: 10),
        child: Center(
          child: Text(
            "Delete",
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

  GestureDetector editButton(String? serviceId, id) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => EditPostSchedule(
              jobData: id,
              serviceId: serviceId,
            ),
          ),
        );
      },
      child: Container(
        height: 60,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          color: ServiceGiverColor.green,
        ),
        margin: const EdgeInsets.symmetric(horizontal: 10),
        child: Center(
          child: Text(
            "Edit",
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
    if (futureSeniorCareDetailDashboard!.jobDetail!.isNotEmpty) {
      return ListView.builder(
        shrinkWrap: true,
        scrollDirection: Axis.vertical,
        physics: const NeverScrollableScrollPhysics(),
        padding: const EdgeInsets.all(20),
        itemCount: futureSeniorCareDetailDashboard!.jobDetail!.length,
        itemBuilder: (BuildContext context, int index) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              JobInfoContainer(
                title: futureSeniorCareDetailDashboard!.jobDetail![index].jobTitle.toString(),
                address: futureSeniorCareDetailDashboard!.jobDetail![index].address.toString(),
                location: futureSeniorCareDetailDashboard!.jobDetail![index].location.toString(),
                hourlyRate: "\$${futureSeniorCareDetailDashboard!.jobDetail![index].hourlyRate.toString()}/hour",
              ),
              const SizedBox(height: 10),
              JobDetailTile(
                name: "Senior Initials",
                title: futureSeniorCareDetailDashboard!.jobDetail![index].seniorCare!.seniorName.toString(),
              ),
              const SizedBox(height: 10),
              JobDetailTile(
                name: "Date of Birth",
                title: futureSeniorCareDetailDashboard!.jobDetail![index].seniorCare!.dob.toString(),
              ),
              const SizedBox(height: 10),
              JobDetailTile(
                name: "Medical Condition",
                title: futureSeniorCareDetailDashboard!.jobDetail![index].seniorCare!.medicalCondition.toString(),
              ),
              const SizedBox(height: 10),
              JobDetailTile(
                name: "Additional Info",
                title: futureSeniorCareDetailDashboard!.jobDetail![index].additionalInfo ?? "",
              ),
              const SizedBox(height: 10),
              // Assistancce Container
              if (futureSeniorCareDetailDashboard!.jobDetail![index].seniorCare != null) ...[
                AssistanceContainer(
                  dd: [
                    if (futureSeniorCareDetailDashboard!.jobDetail![index].seniorCare!.bathing.toString() == "1") ...[
                      futureSeniorCareDetailDashboard!.jobDetail![index].seniorCare!.bathing.toString() == "1" ? "bathing" : futureSeniorCareDetailDashboard!.jobDetail![index].seniorCare!.bathing.toString(),
                    ],
                    if (futureSeniorCareDetailDashboard!.jobDetail![index].seniorCare!.dressing.toString() == "1") ...[
                      futureSeniorCareDetailDashboard!.jobDetail![index].seniorCare!.dressing.toString() == "1" ? "dressing" : futureSeniorCareDetailDashboard!.jobDetail![index].seniorCare!.dressing.toString(),
                    ],
                    if (futureSeniorCareDetailDashboard!.jobDetail![index].seniorCare!.feeding.toString() == "1") ...[
                      futureSeniorCareDetailDashboard!.jobDetail![index].seniorCare!.feeding.toString() == "1" ? "feeding" : futureSeniorCareDetailDashboard!.jobDetail![index].seniorCare!.feeding.toString(),
                    ],
                    if (futureSeniorCareDetailDashboard!.jobDetail![index].seniorCare!.mealPreparation.toString() == "1") ...[
                      futureSeniorCareDetailDashboard!.jobDetail![index].seniorCare!.mealPreparation.toString() == "1" ? "mealPreparation" : futureSeniorCareDetailDashboard!.jobDetail![index].seniorCare!.mealPreparation.toString(),
                    ],
                    if (futureSeniorCareDetailDashboard!.jobDetail![index].seniorCare!.groceryShopping.toString() == "1") ...[
                      futureSeniorCareDetailDashboard!.jobDetail![index].seniorCare!.groceryShopping.toString() == "1" ? "groceryShopping" : futureSeniorCareDetailDashboard!.jobDetail![index].seniorCare!.groceryShopping.toString(),
                    ],
                    if (futureSeniorCareDetailDashboard!.jobDetail![index].seniorCare!.walking.toString() == "1") ...[
                      futureSeniorCareDetailDashboard!.jobDetail![index].seniorCare!.walking.toString() == "1" ? "walking" : futureSeniorCareDetailDashboard!.jobDetail![index].seniorCare!.walking.toString(),
                    ],
                    if (futureSeniorCareDetailDashboard!.jobDetail![index].seniorCare!.bedTransfer.toString() == "1") ...[
                      futureSeniorCareDetailDashboard!.jobDetail![index].seniorCare!.bedTransfer.toString() == "1" ? "bedTransfer" : futureSeniorCareDetailDashboard!.jobDetail![index].seniorCare!.bedTransfer.toString(),
                    ],
                    if (futureSeniorCareDetailDashboard!.jobDetail![index].seniorCare!.lightCleaning.toString() == "1") ...[
                      futureSeniorCareDetailDashboard!.jobDetail![index].seniorCare!.lightCleaning.toString() == "1" ? "lightCleaning" : futureSeniorCareDetailDashboard!.jobDetail![index].seniorCare!.lightCleaning.toString(),
                    ],
                    if (futureSeniorCareDetailDashboard!.jobDetail![index].seniorCare!.companionship.toString() == "1") ...[
                      futureSeniorCareDetailDashboard!.jobDetail![index].seniorCare!.companionship.toString() == "1" ? "companionship" : futureSeniorCareDetailDashboard!.jobDetail![index].seniorCare!.companionship.toString(),
                    ],
                    if (futureSeniorCareDetailDashboard!.jobDetail![index].seniorCare!.medicationAdministration.toString() == "1") ...[
                      futureSeniorCareDetailDashboard!.jobDetail![index].seniorCare!.medicationAdministration.toString() == "1" ? "medicationAdministration" : futureSeniorCareDetailDashboard!.jobDetail![index].seniorCare!.medicationAdministration.toString(),
                    ],
                    if (futureSeniorCareDetailDashboard!.jobDetail![index].seniorCare!.dressingWoundCare.toString() == "1") ...[
                      futureSeniorCareDetailDashboard!.jobDetail![index].seniorCare!.dressingWoundCare.toString() == "1" ? "dressingWoundCare" : futureSeniorCareDetailDashboard!.jobDetail![index].seniorCare!.dressingWoundCare.toString(),
                    ],
                    if (futureSeniorCareDetailDashboard!.jobDetail![index].seniorCare!.bloodPressureMonetoring.toString() == "1") ...[
                      futureSeniorCareDetailDashboard!.jobDetail![index].seniorCare!.bloodPressureMonetoring.toString() == "1" ? "bloodPressureMonetoring" : futureSeniorCareDetailDashboard!.jobDetail![index].seniorCare!.bloodPressureMonetoring.toString(),
                    ],
                    if (futureSeniorCareDetailDashboard!.jobDetail![index].seniorCare!.bloodSugarMonetoring.toString() == "1") ...[
                      futureSeniorCareDetailDashboard!.jobDetail![index].seniorCare!.bloodSugarMonetoring.toString() == "1" ? "bloodSugarMonetoring" : futureSeniorCareDetailDashboard!.jobDetail![index].seniorCare!.bloodSugarMonetoring.toString(),
                    ],
                    if (futureSeniorCareDetailDashboard!.jobDetail![index].seniorCare!.groomingHairAndNailTrimming.toString() == "1") ...[
                      futureSeniorCareDetailDashboard!.jobDetail![index].seniorCare!.groomingHairAndNailTrimming.toString() == "1" ? "groomingHairAndNailTrimming" : futureSeniorCareDetailDashboard!.jobDetail![index].seniorCare!.groomingHairAndNailTrimming.toString(),
                    ],
                  ],
                ),
              ],

              const SizedBox(height: 10),
              if (futureSeniorCareDetailDashboard!.jobDetail![index].schedule!.isNotEmpty) ...[
                JobScheduleContainer(
                  data: futureSeniorCareDetailDashboard!.jobDetail![index].schedule,
                ),
              ],
              const SizedBox(height: 20),
              if (futureSeniorCareDetailDashboard!.jobDetail![index].isFunded == 0) ...[
                editButton(futureSeniorCareDetailDashboard!.jobDetail![index].serviceId.toString(), widget.jobData),
                const SizedBox(height: 10),
                deleteButton(futureSeniorCareDetailDashboard!.jobDetail![index].id),
              ]
            ],
          );
        },
      );
    } else {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }
  }

  // done

  Widget serviceSchoolSupport(BuildContext context) {
    if (futureSchoolSupportDetailDashboard!.jobDetail!.isNotEmpty) {
      return ListView.builder(
        shrinkWrap: true,
        scrollDirection: Axis.vertical,
        physics: const NeverScrollableScrollPhysics(),
        padding: const EdgeInsets.all(20),
        itemCount: futureSchoolSupportDetailDashboard!.jobDetail!.length,
        itemBuilder: (BuildContext context, int index) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              JobInfoContainer(
                title: futureSchoolSupportDetailDashboard!.jobDetail![index].jobTitle.toString(),
                address: futureSchoolSupportDetailDashboard!.jobDetail![index].address.toString(),
                location: futureSchoolSupportDetailDashboard!.jobDetail![index].location.toString(),
                hourlyRate: "\$${futureSchoolSupportDetailDashboard!.jobDetail![index].hourlyRate.toString()}/hour",
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
              for (var i = 0; i < futureSchoolSupportDetailDashboard!.jobDetail![index].childinfo!.length; i++) ...[
                if (futureSchoolSupportDetailDashboard!.jobDetail![index].childinfo!.length > 1) ...[
                  const SizedBox(height: 10),
                  Text(
                    "Child ${i + 1}",
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 10),
                ],
                JobDetailTile(
                  name: "Child Initials",
                  title: futureSchoolSupportDetailDashboard!.jobDetail![index].childinfo![i].name.toString(),
                ),
                const SizedBox(height: 10),
                JobDetailTile(
                  name: "Child Age",
                  title: futureSchoolSupportDetailDashboard!.jobDetail![index].childinfo![i].age.toString(),
                ),
                const SizedBox(height: 10),
                JobDetailTile(
                  name: "Child Grade",
                  title: futureSchoolSupportDetailDashboard!.jobDetail![index].childinfo![i].grade.toString(),
                ),
                const SizedBox(height: 10),
              ],
              // if (futureSchoolSupportDetailDashboard!.jobDetail![index].schoolCamp != null) ...[
              //   JobDetailTile(
              //     name: "Interest for Child",
              //     title: futureSchoolSupportDetailDashboard!.jobDetail![index].schoolCamp!.interestForChild.toString(),
              //   ),
              //   const SizedBox(height: 10),
              //   JobDetailTile(
              //     name: "Cost Range For Camp",
              //     title: futureSchoolSupportDetailDashboard!.jobDetail![index].schoolCamp!.costRange.toString(),
              //   ),
              //   const SizedBox(height: 10),
              // ],
              if (futureSchoolSupportDetailDashboard!.jobDetail![index].learning != null) ...[
                const SizedBox(height: 10),
                AssistanceContainer(
                  dd: [
                    if (futureSchoolSupportDetailDashboard!.jobDetail![index].learning!.assistanceInReading == 1) ...["Reading"],
                    if (futureSchoolSupportDetailDashboard!.jobDetail![index].learning!.assistanceInEnglish == 1) ...["English"],
                    if (futureSchoolSupportDetailDashboard!.jobDetail![index].learning!.assistanceInMath == 1) ...["Math"],
                    if (futureSchoolSupportDetailDashboard!.jobDetail![index].learning!.assistanceInScience == 1) ...["Science"],
                    if (futureSchoolSupportDetailDashboard!.jobDetail![index].learning!.assistanceInOther != null) ...[futureSchoolSupportDetailDashboard!.jobDetail![index].learning!.assistanceInOther.toString()],
                  ],
                ),
              ],
              const SizedBox(height: 10),
              if (futureSchoolSupportDetailDashboard!.jobDetail![index].learning != null && futureSchoolSupportDetailDashboard!.jobDetail![index].learning!.learningStyle != null) ...[
                JobDetailTile(
                  name: "Learning Style",
                  title: futureSchoolSupportDetailDashboard!.jobDetail![index].learning!.learningStyle.toString(),
                ),
                const SizedBox(height: 10),
              ],
              if (futureSchoolSupportDetailDashboard!.jobDetail![index].learning != null && futureSchoolSupportDetailDashboard!.jobDetail![index].learning!.learningChallenge != null) ...[
                JobDetailTile(
                  name: "Learning Challenge",
                  title: futureSchoolSupportDetailDashboard!.jobDetail![index].learning!.learningChallenge.toString(),
                ),
                const SizedBox(height: 10),
              ],
              if (futureSchoolSupportDetailDashboard!.jobDetail![index].additionalInfo != null) ...[
                JobDetailTile(
                  name: "Additional Info",
                  title: futureSchoolSupportDetailDashboard!.jobDetail![index].additionalInfo ?? "",
                ),
                const SizedBox(height: 10),
              ],
              if (futureSchoolSupportDetailDashboard!.jobDetail![index].schedule!.isNotEmpty) ...[
                JobScheduleContainer(
                  data: futureSchoolSupportDetailDashboard!.jobDetail![index].schedule,
                ),
              ],
              const SizedBox(height: 20),
              if (futureSchoolSupportDetailDashboard!.jobDetail![index].isFunded == 0) ...[
                editButton(futureSchoolSupportDetailDashboard!.jobDetail![index].serviceId.toString(), widget.jobData),
                const SizedBox(height: 10),
                deleteButton(futureSchoolSupportDetailDashboard!.jobDetail![index].id),
              ]
            ],
          );
        },
      );
    } else {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }
  }
  //  Done

  Widget serviceChildCare(BuildContext context) {
    if (futureChildCareDetailDashboard!.jobDetail!.isNotEmpty) {
      return ListView.builder(
        shrinkWrap: true,
        scrollDirection: Axis.vertical,
        physics: const NeverScrollableScrollPhysics(),
        padding: const EdgeInsets.all(20),
        itemCount: futureChildCareDetailDashboard!.jobDetail!.length,
        itemBuilder: (BuildContext context, int index) {
          return Column(
            children: [
              JobInfoContainer(
                title: futureChildCareDetailDashboard!.jobDetail![index].jobTitle.toString(),
                address: futureChildCareDetailDashboard!.jobDetail![index].address.toString(),
                location: futureChildCareDetailDashboard!.jobDetail![index].location.toString(),
                hourlyRate: "\$${futureChildCareDetailDashboard!.jobDetail![index].hourlyRate.toString()}/hour",
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
              for (var i = 0; i < futureChildCareDetailDashboard!.jobDetail![index].childinfo!.length; i++) ...[
                if (futureChildCareDetailDashboard!.jobDetail![index].childinfo!.length > 1) ...[
                  const SizedBox(height: 10),
                  Text(
                    "Child ${i + 1}",
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 10),
                ],
                JobDetailTile(
                  name: "Child Initials",
                  title: futureChildCareDetailDashboard!.jobDetail![index].childinfo![i].name.toString(),
                ),
                const SizedBox(height: 10),
                JobDetailTile(
                  name: "Child Age",
                  title: futureChildCareDetailDashboard!.jobDetail![index].childinfo![i].age.toString(),
                ),
                const SizedBox(height: 10),
              ],
              if (futureChildCareDetailDashboard!.jobDetail![index].schoolCamp != null) ...[
                JobDetailTile(
                  name: "Interest for Child",
                  title: futureChildCareDetailDashboard!.jobDetail![index].schoolCamp!.interestForChild.toString(),
                ),
                const SizedBox(height: 10),
                JobDetailTile(
                  name: "Cost Range For Camp",
                  title: "\$ ${futureChildCareDetailDashboard!.jobDetail![index].schoolCamp!.costRange.toString()}",
                ),
                const SizedBox(height: 10),
              ],
              const SizedBox(height: 10),
              if (futureChildCareDetailDashboard!.jobDetail![index].schedule!.isNotEmpty) ...[
                JobScheduleContainer(
                  data: futureChildCareDetailDashboard!.jobDetail![index].schedule,
                ),
              ],
              const SizedBox(height: 20),
              if (futureChildCareDetailDashboard!.jobDetail![index].isFunded == 0) ...[
                editButton(futureChildCareDetailDashboard!.jobDetail![index].serviceId.toString(), widget.jobData),
                const SizedBox(height: 10),
                deleteButton(futureChildCareDetailDashboard!.jobDetail![index].id),
              ]
            ],
          );
        },
      );
    } else {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }
  }

  // done

  Widget serviceHouseKeeping(BuildContext context) {
    if (futureHouseKeepingDetailDashboard!.jobDetail!.isNotEmpty) {
      return ListView.builder(
        shrinkWrap: true,
        scrollDirection: Axis.vertical,
        physics: const NeverScrollableScrollPhysics(),
        padding: const EdgeInsets.all(20),
        itemCount: futureHouseKeepingDetailDashboard!.jobDetail!.length,
        itemBuilder: (BuildContext context, int index) {
          return Column(
            children: [
              Container(
                alignment: Alignment.center,
                child: Column(
                  children: [
                    JobInfoContainer(
                      title: futureHouseKeepingDetailDashboard!.jobDetail![index].jobTitle.toString(),
                      address: futureHouseKeepingDetailDashboard!.jobDetail![index].address.toString(),
                      location: futureHouseKeepingDetailDashboard!.jobDetail![index].location.toString(),
                      hourlyRate: futureHouseKeepingDetailDashboard!.jobDetail![index].hourlyRate.toString(),
                    ),
                    const SizedBox(height: 10),
                    JobDetailTile(
                      name: "Cleaning Type",
                      title: futureHouseKeepingDetailDashboard!.jobDetail![index].houseKeeping!.cleaningType.toString(),
                    ),
                    const SizedBox(height: 10),
                    JobDetailTile(
                      name: "Number of Bedrooms",
                      title: futureHouseKeepingDetailDashboard!.jobDetail![index].houseKeeping!.numberOfBedrooms.toString(),
                    ),
                    const SizedBox(height: 10),
                    JobDetailTile(
                      name: "Number of Bathrooms",
                      title: futureHouseKeepingDetailDashboard!.jobDetail![index].houseKeeping!.numberOfBathrooms.toString(),
                    ),
                    const SizedBox(height: 10),
                    JobDetailTile(
                      name: "Laundary",
                      title: futureHouseKeepingDetailDashboard!.jobDetail![index].houseKeeping!.laundry.toString() == "1" ? "Yes" : "No",
                    ),
                    const SizedBox(height: 10),
                    JobDetailTile(
                      name: "Ironing",
                      title: futureHouseKeepingDetailDashboard!.jobDetail![index].houseKeeping!.ironing.toString() == "1" ? "Yes" : "No",
                    ),
                    const SizedBox(height: 10),
                    JobDetailTile(
                      name: "Other",
                      title: futureHouseKeepingDetailDashboard!.jobDetail![index].houseKeeping!.other.toString() == "null" ? "" : futureHouseKeepingDetailDashboard!.jobDetail![index].houseKeeping!.other.toString(),
                    ),
                    const SizedBox(height: 10),
                    JobDetailTile(
                      name: "Additional Info",
                      title: futureHouseKeepingDetailDashboard!.jobDetail![index].additionalInfo ?? "",
                    ),
                    const SizedBox(height: 10),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              JobScheduleContainer(
                data: futureHouseKeepingDetailDashboard!.jobDetail![index].schedule,
              ),
              const SizedBox(height: 20),
              if (futureHouseKeepingDetailDashboard!.jobDetail![index].isFunded == 0) ...[
                editButton(futureHouseKeepingDetailDashboard!.jobDetail![index].serviceId.toString(), widget.jobData),
                const SizedBox(height: 10),
                deleteButton(futureHouseKeepingDetailDashboard!.jobDetail![index].id),
              ]
            ],
          );
        },
      );
    } else {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }
  }

// done
  Widget servicePetCare(BuildContext context) {
    if (futurePetCareDetailDashboard!.jobDetail!.isNotEmpty) {
      return ListView.builder(
        shrinkWrap: true,
        scrollDirection: Axis.vertical,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: futurePetCareDetailDashboard!.jobDetail!.length,
        padding: const EdgeInsets.all(20),
        itemBuilder: (BuildContext context, int index) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                children: [
                  JobInfoContainer(
                    title: futurePetCareDetailDashboard!.jobDetail![index].jobTitle.toString(),
                    address: futurePetCareDetailDashboard!.jobDetail![index].address.toString(),
                    location: futurePetCareDetailDashboard!.jobDetail![index].location.toString(),
                    hourlyRate: "\$${futurePetCareDetailDashboard!.jobDetail![index].hourlyRate.toString()}/hour",
                  ),
                  const SizedBox(height: 10),
                  JobDetailTile(
                    name: "Pet Type",
                    title: futurePetCareDetailDashboard!.jobDetail![index].petCare!.petType.toString(),
                  ),
                  const SizedBox(height: 10),
                  JobDetailTile(
                    name: "Number of Pet",
                    title: futurePetCareDetailDashboard!.jobDetail![index].petCare!.numberOfPets.toString(),
                  ),
                  const SizedBox(height: 10),
                  JobDetailTile(
                    name: "Pet Breed",
                    title: futurePetCareDetailDashboard!.jobDetail![index].petCare!.petBreed.toString(),
                  ),
                  const SizedBox(height: 10),
                  JobDetailTile(
                    name: "Size Of Pet",
                    title: futurePetCareDetailDashboard!.jobDetail![index].petCare!.sizeOfPet.toString(),
                  ),
                  const SizedBox(height: 10),
                  JobDetailTile(
                    name: "Temperament",
                    title: futurePetCareDetailDashboard!.jobDetail![index].petCare!.temperament.toString(),
                  ),
                  const SizedBox(height: 10),
                  JobDetailTile(
                    name: "Additional Info",
                    title: futurePetCareDetailDashboard!.jobDetail![index].additionalInfo ?? "",
                  ),
                  const SizedBox(height: 10),
                ],
              ),
              const SizedBox(height: 10),
              AssistanceContainer(
                dd: [
                  if (futurePetCareDetailDashboard!.jobDetail![index].petCare!.walking.toString() == "1") ...[
                    futurePetCareDetailDashboard!.jobDetail![index].petCare!.walking.toString() == "1" ? "Walking" : futurePetCareDetailDashboard!.jobDetail![index].petCare!.walking.toString(),
                  ],
                  if (futurePetCareDetailDashboard!.jobDetail![index].petCare!.daycare.toString() == "1") ...[
                    futurePetCareDetailDashboard!.jobDetail![index].petCare!.daycare.toString() == "1" ? "Day Care" : futurePetCareDetailDashboard!.jobDetail![index].petCare!.daycare.toString(),
                  ],
                  if (futurePetCareDetailDashboard!.jobDetail![index].petCare!.feeding.toString() == "1") ...[
                    futurePetCareDetailDashboard!.jobDetail![index].petCare!.feeding.toString() == "1" ? "Feeding" : futurePetCareDetailDashboard!.jobDetail![index].petCare!.feeding.toString(),
                  ],
                  if (futurePetCareDetailDashboard!.jobDetail![index].petCare!.socialization.toString() == "1") ...[
                    futurePetCareDetailDashboard!.jobDetail![index].petCare!.socialization.toString() == "1" ? "Socialization" : futurePetCareDetailDashboard!.jobDetail![index].petCare!.socialization.toString(),
                  ],
                  if (futurePetCareDetailDashboard!.jobDetail![index].petCare!.grooming.toString() == "1") ...[
                    futurePetCareDetailDashboard!.jobDetail![index].petCare!.grooming.toString() == "1" ? "Grooming" : futurePetCareDetailDashboard!.jobDetail![index].petCare!.grooming.toString(),
                  ],
                  if (futurePetCareDetailDashboard!.jobDetail![index].petCare!.boarding.toString() == "1") ...[
                    futurePetCareDetailDashboard!.jobDetail![index].petCare!.boarding.toString() == "1" ? "Boarding" : futurePetCareDetailDashboard!.jobDetail![index].petCare!.boarding.toString(),
                  ],
                ],
              ),
              const SizedBox(height: 10),
              if (futurePetCareDetailDashboard!.jobDetail![index].schedule!.isNotEmpty) ...[
                JobScheduleContainer(
                  data: futurePetCareDetailDashboard!.jobDetail![index].schedule,
                ),
              ],
              const SizedBox(height: 10),
              if (futurePetCareDetailDashboard!.jobDetail![index].isFunded == 0) ...[
                editButton(futurePetCareDetailDashboard!.jobDetail![index].serviceId.toString(), widget.jobData),
                const SizedBox(height: 10),
                deleteButton(futurePetCareDetailDashboard!.jobDetail![index].id),
              ]
            ],
          );
        },
      );
    } else {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }
  }
}
