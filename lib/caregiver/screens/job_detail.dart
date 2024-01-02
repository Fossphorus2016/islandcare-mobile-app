// ignore_for_file: use_build_context_synchronously

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:island_app/caregiver/models/child_care_detail-dashbaord_model.dart';
import 'package:island_app/caregiver/models/house_keeping_detail_dashboard_model.dart';
import 'package:island_app/caregiver/models/pet_care_detail_dashboard_model.dart';
import 'package:island_app/caregiver/models/school_support_detail_dashboard.dart';
import 'package:island_app/res/app_url.dart';
import 'package:island_app/utils/utils.dart';
import 'package:shared_preferences/shared_preferences.dart';
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
    var token = await getUserToken();
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
    var token = await getUserToken();
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
    var token = await getUserToken();
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
    var token = await getUserToken();
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
    var token = await getUserToken();
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
    var token = await getUserToken();
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
        iconTheme: IconThemeData(
          color: CustomColors.primaryText,
        ),
        elevation: 0,
        backgroundColor: CustomColors.white,
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
              serviceChildCare(context),
            ] else if (widget.serviceId == "5") ...[
              // Service Id 5
              serviceSchoolSupport(context),
            ],
          ],
        ),
      ),
    );
  }

  Widget serviceSeniorCare(BuildContext context) {
    return FutureBuilder<SeniorCareDetailDashboardModel>(
      future: futureSeniorCareDetailDashboard,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return ListView.builder(
            shrinkWrap: true,
            scrollDirection: Axis.vertical,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: snapshot.data!.jobDetail!.length,
            itemBuilder: (BuildContext context, int index) {
              return Column(
                children: [
                  Container(
                    color: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 20),
                    alignment: Alignment.centerLeft,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Job Title",
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                          ),
                        ),
                        Text(
                          snapshot.data!.jobDetail![index].jobTitle.toString(),
                          style: TextStyle(
                            fontSize: 24,
                            fontFamily: "Poppins",
                            fontWeight: FontWeight.w600,
                            color: CustomColors.primaryText,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  Container(
                    color: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text("Date"),
                                  const SizedBox(height: 05),
                                  Text(
                                    snapshot.data!.jobDetail![index].schedule!.isEmpty ? "Data Not Available" : snapshot.data!.jobDetail![index].schedule![index].startingDate.toString(),
                                    style: TextStyle(
                                      color: CustomColors.primaryText,
                                      fontFamily: "Poppins",
                                      fontSize: 13,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text("Start Time"),
                                  const SizedBox(height: 05),
                                  Container(
                                    padding: const EdgeInsets.symmetric(vertical: 00, horizontal: 08),
                                    decoration: BoxDecoration(
                                      color: CustomColors.primaryLight,
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Text(
                                      snapshot.data!.jobDetail![index].schedule!.isEmpty ? "Data Not Available" : snapshot.data!.jobDetail![index].schedule![index].startingTime.toString(),
                                      style: const TextStyle(
                                        fontFamily: "Poppins",
                                        fontSize: 13,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 15),
                        Column(
                          children: [
                            const Text("Duration"),
                            const SizedBox(height: 05),
                            Text(
                              "${snapshot.data!.jobDetail![index].schedule!.isEmpty ? "Data Not Available" : snapshot.data!.jobDetail![index].schedule![index].duration.toString()} hours",
                              style: TextStyle(
                                color: CustomColors.primaryText,
                                fontFamily: "Poppins",
                                fontSize: 13,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  Container(
                    color: Colors.white,
                    alignment: Alignment.centerLeft,
                    padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 20),
                    child: const Column(
                      children: [
                        Text(
                          "INFORMATION",
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                        ),
                        Column(
                          children: [
                            Row(
                              children: [
                                Text("Name: "),
                                Expanded(
                                  child: Text("asdaldwodihawdoagwidsddw"),
                                ),
                              ],
                            ),
                            SizedBox(height: 05),
                            Row(
                              children: [
                                Text("Age: "),
                                Expanded(
                                  child: Text("asdaldwodihawdoagwidsddw"),
                                ),
                              ],
                            ),
                            SizedBox(height: 05),
                            Row(
                              children: [
                                Text(
                                  "Date Of Birth: ",
                                  style: TextStyle(fontSize: 13),
                                ),
                                Expanded(
                                  child: Text("asdaldwodihawdoagwidsddw"),
                                ),
                              ],
                            ),
                            SizedBox(height: 05),
                            Row(
                              children: [
                                Text("Medical Condition: "),
                                Expanded(
                                  child: Text("asdaldwodihawdoagwidsddw"),
                                ),
                              ],
                            ),
                            SizedBox(height: 05),
                            Row(
                              children: [
                                Text("Hourly Rate: "),
                                Expanded(
                                  child: Text("asdaldwodihawdoagwidsddw"),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 12),
                    margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 0),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: CustomColors.white,
                    ),
                    child: Column(
                      children: [
                        if (snapshot.data!.jobDetail![index].jobTitle!.isNotEmpty) ...[
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              SizedBox(
                                width: MediaQuery.of(context).size.width * .4,
                                child: Text(
                                  "Job Title",
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontFamily: "Poppins",
                                    fontWeight: FontWeight.w500,
                                    color: CustomColors.primaryTextLight,
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: MediaQuery.of(context).size.width * .5,
                                child: Text(
                                  snapshot.data!.jobDetail![index].jobTitle.toString(),
                                  style: TextStyle(
                                    fontSize: 24,
                                    fontFamily: "Poppins",
                                    fontWeight: FontWeight.w600,
                                    color: CustomColors.primaryText,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                        const SizedBox(
                          height: 5,
                        ),
                        if (snapshot.data!.jobDetail![index].location!.isNotEmpty) ...[
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              SizedBox(
                                width: MediaQuery.of(context).size.width * .4,
                                child: Text(
                                  "Job Area",
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontFamily: "Poppins",
                                    fontWeight: FontWeight.w500,
                                    color: CustomColors.primaryTextLight,
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: MediaQuery.of(context).size.width * .5,
                                child: Text(
                                  snapshot.data!.jobDetail![index].location.toString(),
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontFamily: "Poppins",
                                    fontWeight: FontWeight.w600,
                                    color: CustomColors.primaryTextLight,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                        const SizedBox(height: 5),
                        if (snapshot.data!.jobDetail![index].hourlyRate != null) ...[
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              SizedBox(
                                width: MediaQuery.of(context).size.width * .4,
                                child: Text(
                                  "Hourly Rate",
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontFamily: "Poppins",
                                    fontWeight: FontWeight.w500,
                                    color: CustomColors.primaryTextLight,
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: MediaQuery.of(context).size.width * .5,
                                child: Text(
                                  "\$${snapshot.data!.jobDetail![index].hourlyRate.toString()}/hour",
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontFamily: "Poppins",
                                    fontWeight: FontWeight.w600,
                                    color: CustomColors.primaryTextLight,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                        const SizedBox(
                          height: 5,
                        ),
                        if (snapshot.data!.jobDetail![index].seniorCare != null) ...[
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              SizedBox(
                                width: MediaQuery.of(context).size.width * .4,
                                child: Text(
                                  "Senior Name",
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontFamily: "Poppins",
                                    fontWeight: FontWeight.w500,
                                    color: CustomColors.primaryTextLight,
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: MediaQuery.of(context).size.width * .5,
                                child: Text(
                                  snapshot.data!.jobDetail![index].seniorCare!.seniorName.toString(),
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontFamily: "Poppins",
                                    fontWeight: FontWeight.w600,
                                    color: CustomColors.primaryTextLight,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                        const SizedBox(
                          height: 5,
                        ),
                        if (snapshot.data!.jobDetail![index].seniorCare != null) ...[
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              SizedBox(
                                width: MediaQuery.of(context).size.width * .4,
                                child: Text(
                                  "Date Of Birth",
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontFamily: "Poppins",
                                    fontWeight: FontWeight.w500,
                                    color: CustomColors.primaryTextLight,
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: MediaQuery.of(context).size.width * .5,
                                child: Text(
                                  snapshot.data!.jobDetail![index].seniorCare!.dob.toString(),
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontFamily: "Poppins",
                                    fontWeight: FontWeight.w600,
                                    color: CustomColors.primaryTextLight,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                        const SizedBox(
                          height: 5,
                        ),
                        if (snapshot.data!.jobDetail![index].seniorCare != null) ...[
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              SizedBox(
                                width: MediaQuery.of(context).size.width * .4,
                                child: Text(
                                  "Medical Condition",
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontFamily: "Poppins",
                                    fontWeight: FontWeight.w500,
                                    color: CustomColors.primaryTextLight,
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: MediaQuery.of(context).size.width * .5,
                                child: Text(
                                  snapshot.data!.jobDetail![index].seniorCare!.medicalCondition.toString(),
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontFamily: "Poppins",
                                    fontWeight: FontWeight.w600,
                                    color: CustomColors.primaryTextLight,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                    margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 0),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: CustomColors.white,
                    ),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Container(
                              alignment: Alignment.topLeft,
                              width: 150,
                              child: Column(
                                children: [
                                  Text(
                                    "Requires Assistance :",
                                    style: TextStyle(
                                      color: CustomColors.primaryText,
                                      fontFamily: "Poppins",
                                      fontSize: 13,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Expanded(
                              child: Wrap(
                                runSpacing: 5.0,
                                spacing: 5.0,
                                children: [
                                  if (snapshot.data!.jobDetail![index].seniorCare != null) ...[
                                    snapshot.data!.jobDetail![index].seniorCare!.bathing.toString() == "1"
                                        ? Container(
                                            margin: const EdgeInsets.symmetric(horizontal: 3),
                                            padding: const EdgeInsets.all(4),
                                            decoration: BoxDecoration(color: CustomColors.primaryLight, borderRadius: BorderRadius.circular(6)),
                                            child: Text(
                                              snapshot.data!.jobDetail![index].seniorCare!.bathing.toString() == "1" ? "bathing" : snapshot.data!.jobDetail![index].seniorCare!.bathing.toString(),
                                              style: TextStyle(
                                                fontSize: 13,
                                                fontFamily: "Poppins",
                                                fontWeight: FontWeight.w500,
                                                color: CustomColors.primaryTextLight,
                                              ),
                                            ),
                                          )
                                        : Container(),
                                  ],
                                  if (snapshot.data!.jobDetail![index].seniorCare != null) ...[
                                    snapshot.data!.jobDetail![index].seniorCare!.dressing.toString() == "1"
                                        ? Container(
                                            margin: const EdgeInsets.symmetric(horizontal: 3),
                                            padding: const EdgeInsets.all(4),
                                            decoration: BoxDecoration(color: CustomColors.primaryLight, borderRadius: BorderRadius.circular(6)),
                                            child: Text(
                                              snapshot.data!.jobDetail![index].seniorCare!.dressing.toString() == "1" ? "dressing" : snapshot.data!.jobDetail![index].seniorCare!.dressing.toString(),
                                              style: TextStyle(
                                                fontSize: 13,
                                                fontFamily: "Poppins",
                                                fontWeight: FontWeight.w500,
                                                color: CustomColors.primaryTextLight,
                                              ),
                                            ),
                                          )
                                        : Container(),
                                  ],
                                  if (snapshot.data!.jobDetail![index].seniorCare != null) ...[
                                    snapshot.data!.jobDetail![index].seniorCare!.feeding.toString() == "1"
                                        ? Container(
                                            margin: const EdgeInsets.symmetric(horizontal: 3),
                                            padding: const EdgeInsets.all(4),
                                            decoration: BoxDecoration(color: CustomColors.primaryLight, borderRadius: BorderRadius.circular(6)),
                                            child: Text(
                                              snapshot.data!.jobDetail![index].seniorCare!.feeding.toString() == "1" ? "feeding" : snapshot.data!.jobDetail![index].seniorCare!.feeding.toString(),
                                              style: TextStyle(
                                                fontSize: 13,
                                                fontFamily: "Poppins",
                                                fontWeight: FontWeight.w500,
                                                color: CustomColors.primaryTextLight,
                                              ),
                                            ),
                                          )
                                        : Container(),
                                  ],
                                  if (snapshot.data!.jobDetail![index].seniorCare != null) ...[
                                    snapshot.data!.jobDetail![index].seniorCare!.mealPreparation.toString() == "1"
                                        ? Container(
                                            margin: const EdgeInsets.symmetric(horizontal: 3),
                                            padding: const EdgeInsets.all(4),
                                            decoration: BoxDecoration(color: CustomColors.primaryLight, borderRadius: BorderRadius.circular(6)),
                                            child: Text(
                                              snapshot.data!.jobDetail![index].seniorCare!.mealPreparation.toString() == "1" ? "mealPreparation" : snapshot.data!.jobDetail![index].seniorCare!.mealPreparation.toString(),
                                              style: TextStyle(
                                                fontSize: 13,
                                                fontFamily: "Poppins",
                                                fontWeight: FontWeight.w500,
                                                color: CustomColors.primaryTextLight,
                                              ),
                                            ),
                                          )
                                        : Container(),
                                  ],
                                  if (snapshot.data!.jobDetail![index].seniorCare != null) ...[
                                    snapshot.data!.jobDetail![index].seniorCare!.groceryShopping.toString() == "1"
                                        ? Container(
                                            margin: const EdgeInsets.symmetric(horizontal: 3),
                                            padding: const EdgeInsets.all(4),
                                            decoration: BoxDecoration(color: CustomColors.primaryLight, borderRadius: BorderRadius.circular(6)),
                                            child: Text(
                                              snapshot.data!.jobDetail![index].seniorCare!.groceryShopping.toString() == "1" ? "groceryShopping" : snapshot.data!.jobDetail![index].seniorCare!.groceryShopping.toString(),
                                              style: TextStyle(
                                                fontSize: 13,
                                                fontFamily: "Poppins",
                                                fontWeight: FontWeight.w500,
                                                color: CustomColors.primaryTextLight,
                                              ),
                                            ),
                                          )
                                        : Container(),
                                  ],
                                  if (snapshot.data!.jobDetail![index].seniorCare != null) ...[
                                    snapshot.data!.jobDetail![index].seniorCare!.walking.toString() == "1"
                                        ? Container(
                                            margin: const EdgeInsets.symmetric(horizontal: 3),
                                            padding: const EdgeInsets.all(4),
                                            decoration: BoxDecoration(color: CustomColors.primaryLight, borderRadius: BorderRadius.circular(6)),
                                            child: Text(
                                              snapshot.data!.jobDetail![index].seniorCare!.walking.toString() == "1" ? "walking" : snapshot.data!.jobDetail![index].seniorCare!.walking.toString(),
                                              style: TextStyle(
                                                fontSize: 13,
                                                fontFamily: "Poppins",
                                                fontWeight: FontWeight.w500,
                                                color: CustomColors.primaryTextLight,
                                              ),
                                            ),
                                          )
                                        : Container(),
                                  ],
                                  if (snapshot.data!.jobDetail![index].seniorCare != null) ...[
                                    snapshot.data!.jobDetail![index].seniorCare!.bedTransfer.toString() == "1"
                                        ? Container(
                                            margin: const EdgeInsets.symmetric(horizontal: 3),
                                            padding: const EdgeInsets.all(4),
                                            decoration: BoxDecoration(color: CustomColors.primaryLight, borderRadius: BorderRadius.circular(6)),
                                            child: Text(
                                              snapshot.data!.jobDetail![index].seniorCare!.bedTransfer.toString() == "1" ? "bedTransfer" : snapshot.data!.jobDetail![index].seniorCare!.bedTransfer.toString(),
                                              style: TextStyle(
                                                fontSize: 13,
                                                fontFamily: "Poppins",
                                                fontWeight: FontWeight.w500,
                                                color: CustomColors.primaryTextLight,
                                              ),
                                            ),
                                          )
                                        : Container(),
                                  ],
                                  if (snapshot.data!.jobDetail![index].seniorCare != null) ...[
                                    snapshot.data!.jobDetail![index].seniorCare!.lightCleaning.toString() == "1"
                                        ? Container(
                                            margin: const EdgeInsets.symmetric(horizontal: 3),
                                            padding: const EdgeInsets.all(4),
                                            decoration: BoxDecoration(color: CustomColors.primaryLight, borderRadius: BorderRadius.circular(6)),
                                            child: Text(
                                              snapshot.data!.jobDetail![index].seniorCare!.lightCleaning.toString() == "1" ? "lightCleaning" : snapshot.data!.jobDetail![index].seniorCare!.lightCleaning.toString(),
                                              style: TextStyle(
                                                fontSize: 13,
                                                fontFamily: "Poppins",
                                                fontWeight: FontWeight.w500,
                                                color: CustomColors.primaryTextLight,
                                              ),
                                            ),
                                          )
                                        : Container(),
                                  ],
                                  if (snapshot.data!.jobDetail![index].seniorCare != null) ...[
                                    snapshot.data!.jobDetail![index].seniorCare!.companionship.toString() == "1"
                                        ? Container(
                                            margin: const EdgeInsets.symmetric(horizontal: 3),
                                            padding: const EdgeInsets.all(4),
                                            decoration: BoxDecoration(color: CustomColors.primaryLight, borderRadius: BorderRadius.circular(6)),
                                            child: Text(
                                              snapshot.data!.jobDetail![index].seniorCare!.companionship.toString() == "1" ? "companionship" : snapshot.data!.jobDetail![index].seniorCare!.companionship.toString(),
                                              style: TextStyle(
                                                fontSize: 13,
                                                fontFamily: "Poppins",
                                                fontWeight: FontWeight.w500,
                                                color: CustomColors.primaryTextLight,
                                              ),
                                            ),
                                          )
                                        : Container(),
                                  ],
                                  if (snapshot.data!.jobDetail![index].seniorCare != null) ...[
                                    snapshot.data!.jobDetail![index].seniorCare!.medicationAdministration.toString() == "1"
                                        ? Container(
                                            margin: const EdgeInsets.symmetric(horizontal: 3),
                                            padding: const EdgeInsets.all(4),
                                            decoration: BoxDecoration(color: CustomColors.primaryLight, borderRadius: BorderRadius.circular(6)),
                                            child: Text(
                                              snapshot.data!.jobDetail![index].seniorCare!.medicationAdministration.toString() == "1" ? "medicationAdministration" : snapshot.data!.jobDetail![index].seniorCare!.medicationAdministration.toString(),
                                              style: TextStyle(
                                                fontSize: 13,
                                                fontFamily: "Poppins",
                                                fontWeight: FontWeight.w500,
                                                color: CustomColors.primaryTextLight,
                                              ),
                                            ),
                                          )
                                        : Container(),
                                  ],
                                  if (snapshot.data!.jobDetail![index].seniorCare != null) ...[
                                    snapshot.data!.jobDetail![index].seniorCare!.dressingWoundCare.toString() == "1"
                                        ? Container(
                                            margin: const EdgeInsets.symmetric(horizontal: 3),
                                            padding: const EdgeInsets.all(4),
                                            decoration: BoxDecoration(color: CustomColors.primaryLight, borderRadius: BorderRadius.circular(6)),
                                            child: Text(
                                              snapshot.data!.jobDetail![index].seniorCare!.dressingWoundCare.toString() == "1" ? "dressingWoundCare" : snapshot.data!.jobDetail![index].seniorCare!.dressingWoundCare.toString(),
                                              style: TextStyle(
                                                fontSize: 13,
                                                fontFamily: "Poppins",
                                                fontWeight: FontWeight.w500,
                                                color: CustomColors.primaryTextLight,
                                              ),
                                            ),
                                          )
                                        : Container(),
                                  ],
                                  if (snapshot.data!.jobDetail![index].seniorCare != null) ...[
                                    snapshot.data!.jobDetail![index].seniorCare!.bloodPressureMonetoring.toString() == "1"
                                        ? Container(
                                            margin: const EdgeInsets.symmetric(horizontal: 3),
                                            padding: const EdgeInsets.all(4),
                                            decoration: BoxDecoration(color: CustomColors.primaryLight, borderRadius: BorderRadius.circular(6)),
                                            child: Text(
                                              snapshot.data!.jobDetail![index].seniorCare!.bloodPressureMonetoring.toString() == "1" ? "bloodPressureMonetoring" : snapshot.data!.jobDetail![index].seniorCare!.bloodPressureMonetoring.toString(),
                                              style: TextStyle(
                                                fontSize: 13,
                                                fontFamily: "Poppins",
                                                fontWeight: FontWeight.w500,
                                                color: CustomColors.primaryTextLight,
                                              ),
                                            ),
                                          )
                                        : Container(),
                                  ],
                                  if (snapshot.data!.jobDetail![index].seniorCare != null) ...[
                                    snapshot.data!.jobDetail![index].seniorCare!.bloodSugarMonetoring.toString() == "1"
                                        ? Container(
                                            margin: const EdgeInsets.symmetric(horizontal: 3),
                                            padding: const EdgeInsets.all(4),
                                            decoration: BoxDecoration(color: CustomColors.primaryLight, borderRadius: BorderRadius.circular(6)),
                                            child: Text(
                                              snapshot.data!.jobDetail![index].seniorCare!.bloodSugarMonetoring.toString() == "1" ? "bloodSugarMonetoring" : snapshot.data!.jobDetail![index].seniorCare!.bloodSugarMonetoring.toString(),
                                              style: TextStyle(
                                                fontSize: 13,
                                                fontFamily: "Poppins",
                                                fontWeight: FontWeight.w500,
                                                color: CustomColors.primaryTextLight,
                                              ),
                                            ),
                                          )
                                        : Container(),
                                  ],
                                  if (snapshot.data!.jobDetail![index].seniorCare != null) ...[
                                    snapshot.data!.jobDetail![index].seniorCare!.groomingHairAndNailTrimming.toString() == "1"
                                        ? Container(
                                            margin: const EdgeInsets.symmetric(horizontal: 3),
                                            padding: const EdgeInsets.all(4),
                                            decoration: BoxDecoration(color: CustomColors.primaryLight, borderRadius: BorderRadius.circular(6)),
                                            child: Text(
                                              snapshot.data!.jobDetail![index].seniorCare!.groomingHairAndNailTrimming.toString() == "1" ? "groomingHairAndNailTrimming" : snapshot.data!.jobDetail![index].seniorCare!.groomingHairAndNailTrimming.toString(),
                                              style: TextStyle(
                                                fontSize: 13,
                                                fontFamily: "Poppins",
                                                fontWeight: FontWeight.w500,
                                                color: CustomColors.primaryTextLight,
                                              ),
                                            ),
                                          )
                                        : Container(),
                                  ],
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Job Schedule
                      snapshot.data!.jobDetail![index].schedule!.isEmpty
                          ? Container()
                          : Container(
                              padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 12),
                              alignment: Alignment.topLeft,
                              child: Text(
                                "Job schedule",
                                style: TextStyle(
                                  color: CustomColors.primaryText,
                                  fontFamily: "Poppins",
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                      snapshot.data!.jobDetail![index].schedule!.isEmpty
                          ? Container()
                          : Container(
                              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                              margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 0),
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                color: CustomColors.white,
                              ),
                              child: Column(
                                children: [
                                  SizedBox(
                                    child: Column(
                                      children: [
                                        Row(
                                          children: [
                                            Container(
                                              alignment: Alignment.topLeft,
                                              width: 150,
                                              child: Text(
                                                "Date :",
                                                style: TextStyle(
                                                  color: CustomColors.primaryText,
                                                  fontFamily: "Poppins",
                                                  fontSize: 13,
                                                  fontWeight: FontWeight.w400,
                                                ),
                                              ),
                                            ),
                                            Expanded(
                                              child: Text(
                                                snapshot.data!.jobDetail![index].schedule!.isEmpty ? "Data Not Available" : snapshot.data!.jobDetail![index].schedule![index].startingDate.toString(),
                                                style: TextStyle(
                                                  color: CustomColors.primaryText,
                                                  fontFamily: "Poppins",
                                                  fontSize: 13,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(
                                          height: 5,
                                        ),
                                        Row(
                                          children: [
                                            Container(
                                              alignment: Alignment.topLeft,
                                              width: 150,
                                              child: Text(
                                                "Start Time :",
                                                style: TextStyle(
                                                  color: CustomColors.primaryText,
                                                  fontFamily: "Poppins",
                                                  fontSize: 13,
                                                  fontWeight: FontWeight.w400,
                                                ),
                                              ),
                                            ),
                                            Expanded(
                                              child: Text(
                                                snapshot.data!.jobDetail![index].schedule!.isEmpty ? "Data Not Available" : snapshot.data!.jobDetail![index].schedule![index].startingTime.toString(),
                                                style: TextStyle(
                                                  color: CustomColors.primaryText,
                                                  fontFamily: "Poppins",
                                                  fontSize: 13,
                                                  fontWeight: FontWeight.w400,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 5,
                                  ),
                                  SizedBox(
                                    child: Row(
                                      children: [
                                        Container(
                                          alignment: Alignment.topLeft,
                                          width: 150,
                                          child: Text(
                                            "Duration :",
                                            style: TextStyle(
                                              color: CustomColors.primaryText,
                                              fontFamily: "Poppins",
                                              fontSize: 13,
                                              fontWeight: FontWeight.w400,
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          child: Text(
                                            "${snapshot.data!.jobDetail![index].schedule!.isEmpty ? "Data Not Available" : snapshot.data!.jobDetail![index].schedule![index].duration.toString()} hours",
                                            style: TextStyle(
                                              color: CustomColors.primaryText,
                                              fontFamily: "Poppins",
                                              fontSize: 13,
                                              fontWeight: FontWeight.w400,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),

                      const SizedBox(
                        height: 10,
                      ),

                      snapshot.data!.isApplied == 0
                          ? GestureDetector(
                              onTap: () {
                                jobApply();
                              },
                              child: Container(
                                height: 60,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(14),
                                  color: CustomColors.primaryColor,
                                ),
                                margin: const EdgeInsets.symmetric(horizontal: 10),
                                child: Center(
                                  child: Text(
                                    "Apply Now",
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
                            )
                          : Container(
                              height: 60,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(14),
                                color: CustomColors.primaryLight,
                              ),
                              margin: const EdgeInsets.symmetric(horizontal: 10),
                              child: Center(
                                child: Text(
                                  "Apply Now",
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
                    ],
                  ),
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

  Widget serviceSchoolSupport(BuildContext context) {
    return FutureBuilder<SchoolSupportDetailDashboardModel>(
      future: futureSchoolSupportDetailDashboard,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return ListView.builder(
            shrinkWrap: true,
            scrollDirection: Axis.vertical,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: snapshot.data!.jobDetail!.length,
            itemBuilder: (BuildContext context, int index) {
              return Column(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 12),
                    margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 0),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: CustomColors.white,
                    ),
                    child: Column(
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            SizedBox(
                              width: MediaQuery.of(context).size.width * .4,
                              child: Text(
                                "Job Title",
                                style: TextStyle(
                                  fontSize: 14,
                                  fontFamily: "Poppins",
                                  fontWeight: FontWeight.w500,
                                  color: CustomColors.primaryTextLight,
                                ),
                              ),
                            ),
                            SizedBox(
                              width: MediaQuery.of(context).size.width * .5,
                              child: Text(
                                snapshot.data!.jobDetail![index].jobTitle.toString(),
                                style: TextStyle(
                                  fontSize: 24,
                                  fontFamily: "Poppins",
                                  fontWeight: FontWeight.w600,
                                  color: CustomColors.primaryText,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            SizedBox(
                              width: MediaQuery.of(context).size.width * .4,
                              child: Text(
                                "Job Area",
                                style: TextStyle(
                                  fontSize: 14,
                                  fontFamily: "Poppins",
                                  fontWeight: FontWeight.w500,
                                  color: CustomColors.primaryTextLight,
                                ),
                              ),
                            ),
                            SizedBox(
                              width: MediaQuery.of(context).size.width * .5,
                              child: Text(
                                snapshot.data!.jobDetail![index].location.toString(),
                                style: TextStyle(
                                  fontSize: 14,
                                  fontFamily: "Poppins",
                                  fontWeight: FontWeight.w600,
                                  color: CustomColors.primaryTextLight,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            SizedBox(
                              width: MediaQuery.of(context).size.width * .4,
                              child: Text(
                                "Hourly Rate",
                                style: TextStyle(
                                  fontSize: 14,
                                  fontFamily: "Poppins",
                                  fontWeight: FontWeight.w500,
                                  color: CustomColors.primaryTextLight,
                                ),
                              ),
                            ),
                            SizedBox(
                              width: MediaQuery.of(context).size.width * .5,
                              child: Text(
                                "\$${snapshot.data!.jobDetail![index].hourlyRate.toString()}/hour",
                                style: TextStyle(
                                  fontSize: 14,
                                  fontFamily: "Poppins",
                                  fontWeight: FontWeight.w600,
                                  color: CustomColors.primaryTextLight,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  SizedBox(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Job Schedule
                        snapshot.data!.jobDetail![index].childinfo!.isEmpty
                            ? Container()
                            : Container(
                                padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 12),
                                alignment: Alignment.topLeft,
                                child: Text(
                                  "Information About Child",
                                  style: TextStyle(
                                    color: CustomColors.primaryText,
                                    fontFamily: "Poppins",
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                        snapshot.data!.jobDetail![index].childinfo!.isEmpty
                            ? Container()
                            : Container(
                                padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                                margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 0),
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  color: CustomColors.white,
                                ),
                                child: Column(
                                  children: [
                                    SizedBox(
                                      child: Column(
                                        children: [
                                          Row(
                                            children: [
                                              Container(
                                                alignment: Alignment.topLeft,
                                                width: 150,
                                                child: Text(
                                                  "Child Name :",
                                                  style: TextStyle(
                                                    color: CustomColors.primaryText,
                                                    fontFamily: "Poppins",
                                                    fontSize: 13,
                                                    fontWeight: FontWeight.w400,
                                                  ),
                                                ),
                                              ),
                                              Expanded(
                                                child: Text(
                                                  snapshot.data!.jobDetail![index].childinfo!.isEmpty ? "Data Not Available" : snapshot.data!.jobDetail![index].childinfo![index].name.toString(),
                                                  style: TextStyle(
                                                    color: CustomColors.primaryText,
                                                    fontFamily: "Poppins",
                                                    fontSize: 13,
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(
                                            height: 5,
                                          ),
                                          Row(
                                            children: [
                                              Container(
                                                alignment: Alignment.topLeft,
                                                width: 150,
                                                child: Text(
                                                  "Child Age :",
                                                  style: TextStyle(
                                                    color: CustomColors.primaryText,
                                                    fontFamily: "Poppins",
                                                    fontSize: 13,
                                                    fontWeight: FontWeight.w400,
                                                  ),
                                                ),
                                              ),
                                              Expanded(
                                                child: Text(
                                                  snapshot.data!.jobDetail![index].childinfo!.isEmpty ? "Data Not Available" : snapshot.data!.jobDetail![index].childinfo![index].age.toString(),
                                                  style: TextStyle(
                                                    color: CustomColors.primaryText,
                                                    fontFamily: "Poppins",
                                                    fontSize: 13,
                                                    fontWeight: FontWeight.w400,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 12),
                    margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 0),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: CustomColors.white,
                    ),
                    child: Column(
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            SizedBox(
                              width: MediaQuery.of(context).size.width * .4,
                              child: Text(
                                "Interest for Child",
                                style: TextStyle(
                                  fontSize: 14,
                                  fontFamily: "Poppins",
                                  fontWeight: FontWeight.w500,
                                  color: CustomColors.primaryTextLight,
                                ),
                              ),
                            ),
                            SizedBox(
                              width: MediaQuery.of(context).size.width * .5,
                              child: Text(
                                snapshot.data!.jobDetail![index].schoolCamp!.interestForChild.toString(),
                                style: TextStyle(
                                  fontSize: 14,
                                  fontFamily: "Poppins",
                                  fontWeight: FontWeight.w600,
                                  color: CustomColors.primaryTextLight,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            SizedBox(
                              width: MediaQuery.of(context).size.width * .4,
                              child: Text(
                                "Cost Range For Camp",
                                style: TextStyle(
                                  fontSize: 14,
                                  fontFamily: "Poppins",
                                  fontWeight: FontWeight.w500,
                                  color: CustomColors.primaryTextLight,
                                ),
                              ),
                            ),
                            SizedBox(
                              width: MediaQuery.of(context).size.width * .5,
                              child: Text(
                                snapshot.data!.jobDetail![index].schoolCamp!.costRange.toString(),
                                style: TextStyle(
                                  fontSize: 14,
                                  fontFamily: "Poppins",
                                  fontWeight: FontWeight.w600,
                                  color: CustomColors.primaryTextLight,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Job Schedule
                        snapshot.data!.jobDetail![index].schedule!.isEmpty
                            ? Container()
                            : Container(
                                padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 12),
                                alignment: Alignment.topLeft,
                                child: Text(
                                  "Job schedule",
                                  style: TextStyle(
                                    color: CustomColors.primaryText,
                                    fontFamily: "Poppins",
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                        snapshot.data!.jobDetail![index].schedule!.isEmpty
                            ? Container()
                            : Container(
                                padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                                margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 0),
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  color: CustomColors.white,
                                ),
                                child: Column(
                                  children: [
                                    SizedBox(
                                      child: Column(
                                        children: [
                                          Row(
                                            children: [
                                              Container(
                                                alignment: Alignment.topLeft,
                                                width: 150,
                                                child: Text(
                                                  "Date :",
                                                  style: TextStyle(
                                                    color: CustomColors.primaryText,
                                                    fontFamily: "Poppins",
                                                    fontSize: 13,
                                                    fontWeight: FontWeight.w400,
                                                  ),
                                                ),
                                              ),
                                              Expanded(
                                                child: Text(
                                                  snapshot.data!.jobDetail![index].schedule!.isEmpty ? "Data Not Available" : snapshot.data!.jobDetail![index].schedule![index].startingDate.toString(),
                                                  style: TextStyle(
                                                    color: CustomColors.primaryText,
                                                    fontFamily: "Poppins",
                                                    fontSize: 13,
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(
                                            height: 5,
                                          ),
                                          Row(
                                            children: [
                                              Container(
                                                alignment: Alignment.topLeft,
                                                width: 150,
                                                child: Text(
                                                  "Start Time :",
                                                  style: TextStyle(
                                                    color: CustomColors.primaryText,
                                                    fontFamily: "Poppins",
                                                    fontSize: 13,
                                                    fontWeight: FontWeight.w400,
                                                  ),
                                                ),
                                              ),
                                              Expanded(
                                                child: Text(
                                                  snapshot.data!.jobDetail![index].schedule!.isEmpty ? "Data Not Available" : snapshot.data!.jobDetail![index].schedule![index].startingTime.toString(),
                                                  style: TextStyle(
                                                    color: CustomColors.primaryText,
                                                    fontFamily: "Poppins",
                                                    fontSize: 13,
                                                    fontWeight: FontWeight.w400,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 5,
                                    ),
                                    SizedBox(
                                      child: Row(
                                        children: [
                                          Container(
                                            alignment: Alignment.topLeft,
                                            width: 150,
                                            child: Text(
                                              "Duration :",
                                              style: TextStyle(
                                                color: CustomColors.primaryText,
                                                fontFamily: "Poppins",
                                                fontSize: 13,
                                                fontWeight: FontWeight.w400,
                                              ),
                                            ),
                                          ),
                                          Expanded(
                                            child: Text(
                                              "${snapshot.data!.jobDetail![index].schedule!.isEmpty ? "Data Not Available" : snapshot.data!.jobDetail![index].schedule![index].duration.toString()} hours",
                                              style: TextStyle(
                                                color: CustomColors.primaryText,
                                                fontFamily: "Poppins",
                                                fontSize: 13,
                                                fontWeight: FontWeight.w400,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                        const SizedBox(
                          height: 10,
                        ),

                        snapshot.data!.isApplied == 0
                            ? GestureDetector(
                                onTap: () {
                                  jobApply();
                                },
                                child: Container(
                                  height: 60,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(14),
                                    color: CustomColors.primaryColor,
                                  ),
                                  margin: const EdgeInsets.symmetric(horizontal: 10),
                                  child: Center(
                                    child: Text(
                                      "Apply Now",
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
                              )
                            : Container(
                                height: 60,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(14),
                                  color: CustomColors.primaryLight,
                                ),
                                margin: const EdgeInsets.symmetric(horizontal: 10),
                                child: Center(
                                  child: Text(
                                    "Apply Now",
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
                      ],
                    ),
                  ),
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

  Widget serviceChildCare(BuildContext context) {
    return FutureBuilder<ChildCareDetailDashboardModel>(
      future: futureChildCareDetailDashboard,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return ListView.builder(
            shrinkWrap: true,
            scrollDirection: Axis.vertical,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: snapshot.data!.jobDetail!.length,
            itemBuilder: (BuildContext context, int index) {
              return Column(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 12),
                    margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 0),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: CustomColors.white,
                    ),
                    child: Column(
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            SizedBox(
                              width: MediaQuery.of(context).size.width * .4,
                              child: Text(
                                "Job Title",
                                style: TextStyle(
                                  fontSize: 14,
                                  fontFamily: "Poppins",
                                  fontWeight: FontWeight.w500,
                                  color: CustomColors.primaryTextLight,
                                ),
                              ),
                            ),
                            SizedBox(
                              width: MediaQuery.of(context).size.width * .5,
                              child: Text(
                                snapshot.data!.jobDetail![index].jobTitle.toString(),
                                style: TextStyle(
                                  fontSize: 24,
                                  fontFamily: "Poppins",
                                  fontWeight: FontWeight.w600,
                                  color: CustomColors.primaryText,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            SizedBox(
                              width: MediaQuery.of(context).size.width * .4,
                              child: Text(
                                "Job Area",
                                style: TextStyle(
                                  fontSize: 14,
                                  fontFamily: "Poppins",
                                  fontWeight: FontWeight.w500,
                                  color: CustomColors.primaryTextLight,
                                ),
                              ),
                            ),
                            SizedBox(
                              width: MediaQuery.of(context).size.width * .5,
                              child: Text(
                                snapshot.data!.jobDetail![index].location.toString(),
                                style: TextStyle(
                                  fontSize: 14,
                                  fontFamily: "Poppins",
                                  fontWeight: FontWeight.w600,
                                  color: CustomColors.primaryTextLight,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            SizedBox(
                              width: MediaQuery.of(context).size.width * .4,
                              child: Text(
                                "Hourly Rate",
                                style: TextStyle(
                                  fontSize: 14,
                                  fontFamily: "Poppins",
                                  fontWeight: FontWeight.w500,
                                  color: CustomColors.primaryTextLight,
                                ),
                              ),
                            ),
                            SizedBox(
                              width: MediaQuery.of(context).size.width * .5,
                              child: Text(
                                "\$${snapshot.data!.jobDetail![index].hourlyRate.toString()}/hour",
                                style: TextStyle(
                                  fontSize: 14,
                                  fontFamily: "Poppins",
                                  fontWeight: FontWeight.w600,
                                  color: CustomColors.primaryTextLight,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  SizedBox(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // // Job Schedule
                        snapshot.data!.jobDetail![index].childinfo!.isEmpty
                            ? Container()
                            : Container(
                                padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 12),
                                alignment: Alignment.topLeft,
                                child: Text(
                                  "Information About Child",
                                  style: TextStyle(
                                    color: CustomColors.primaryText,
                                    fontFamily: "Poppins",
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                        snapshot.data!.jobDetail![index].childinfo!.isEmpty
                            ? Container()
                            : Container(
                                padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                                margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 0),
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  color: CustomColors.white,
                                ),
                                child: Column(
                                  children: [
                                    SizedBox(
                                      child: Column(
                                        children: [
                                          Row(
                                            children: [
                                              Container(
                                                alignment: Alignment.topLeft,
                                                width: 150,
                                                child: Text(
                                                  "Child Name :",
                                                  style: TextStyle(
                                                    color: CustomColors.primaryText,
                                                    fontFamily: "Poppins",
                                                    fontSize: 13,
                                                    fontWeight: FontWeight.w400,
                                                  ),
                                                ),
                                              ),
                                              Expanded(
                                                child: Text(
                                                  snapshot.data!.jobDetail![index].childinfo!.isEmpty ? "Data Not Available" : snapshot.data!.jobDetail![index].childinfo![index].name.toString(),
                                                  style: TextStyle(
                                                    color: CustomColors.primaryText,
                                                    fontFamily: "Poppins",
                                                    fontSize: 13,
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(
                                            height: 5,
                                          ),
                                          Row(
                                            children: [
                                              Container(
                                                alignment: Alignment.topLeft,
                                                width: 150,
                                                child: Text(
                                                  "Child Age :",
                                                  style: TextStyle(
                                                    color: CustomColors.primaryText,
                                                    fontFamily: "Poppins",
                                                    fontSize: 13,
                                                    fontWeight: FontWeight.w400,
                                                  ),
                                                ),
                                              ),
                                              Expanded(
                                                child: Text(
                                                  snapshot.data!.jobDetail![index].childinfo!.isEmpty ? "Data Not Available" : snapshot.data!.jobDetail![index].childinfo![index].age.toString(),
                                                  style: TextStyle(
                                                    color: CustomColors.primaryText,
                                                    fontFamily: "Poppins",
                                                    fontSize: 13,
                                                    fontWeight: FontWeight.w400,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(
                                            height: 5,
                                          ),
                                          Row(
                                            children: [
                                              Container(
                                                alignment: Alignment.topLeft,
                                                width: 150,
                                                child: Text(
                                                  "Child Grade :",
                                                  style: TextStyle(
                                                    color: CustomColors.primaryText,
                                                    fontFamily: "Poppins",
                                                    fontSize: 13,
                                                    fontWeight: FontWeight.w400,
                                                  ),
                                                ),
                                              ),
                                              Expanded(
                                                child: Text(
                                                  snapshot.data!.jobDetail![index].childinfo!.isEmpty ? "Data Not Available" : snapshot.data!.jobDetail![index].childinfo![index].grade.toString(),
                                                  style: TextStyle(
                                                    color: CustomColors.primaryText,
                                                    fontFamily: "Poppins",
                                                    fontSize: 13,
                                                    fontWeight: FontWeight.w400,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                    margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 0),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: CustomColors.white,
                    ),
                    child: Column(
                      children: [
                        SizedBox(
                          child: Row(
                            children: [
                              Container(
                                alignment: Alignment.topLeft,
                                width: 150,
                                child: Column(
                                  children: [
                                    Text(
                                      "Requires Assistance :",
                                      style: TextStyle(
                                        color: CustomColors.primaryText,
                                        fontFamily: "Poppins",
                                        fontSize: 13,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Expanded(
                                child: Wrap(
                                  runSpacing: 5.0,
                                  spacing: 5.0,
                                  children: [
                                    snapshot.data!.jobDetail![index].learning!.assistanceInMath.toString() == "1"
                                        ? Container(
                                            margin: const EdgeInsets.symmetric(horizontal: 3),
                                            padding: const EdgeInsets.all(4),
                                            decoration: BoxDecoration(color: CustomColors.primaryLight, borderRadius: BorderRadius.circular(6)),
                                            child: Text(
                                              snapshot.data!.jobDetail![index].learning!.assistanceInMath.toString() == "1" ? "Math" : snapshot.data!.jobDetail![index].learning!.assistanceInMath.toString(),
                                              style: TextStyle(
                                                fontSize: 13,
                                                fontFamily: "Poppins",
                                                fontWeight: FontWeight.w500,
                                                color: CustomColors.primaryTextLight,
                                              ),
                                            ),
                                          )
                                        : Container(),
                                    snapshot.data!.jobDetail![index].learning!.assistanceInEnglish.toString() == "1"
                                        ? Container(
                                            margin: const EdgeInsets.symmetric(horizontal: 3),
                                            padding: const EdgeInsets.all(4),
                                            decoration: BoxDecoration(color: CustomColors.primaryLight, borderRadius: BorderRadius.circular(6)),
                                            child: Text(
                                              snapshot.data!.jobDetail![index].learning!.assistanceInEnglish.toString() == "1" ? "English" : snapshot.data!.jobDetail![index].learning!.assistanceInEnglish.toString(),
                                              style: TextStyle(
                                                fontSize: 13,
                                                fontFamily: "Poppins",
                                                fontWeight: FontWeight.w500,
                                                color: CustomColors.primaryTextLight,
                                              ),
                                            ),
                                          )
                                        : Container(),
                                    snapshot.data!.jobDetail![index].learning!.assistanceInReading.toString() == "1"
                                        ? Container(
                                            margin: const EdgeInsets.symmetric(horizontal: 3),
                                            padding: const EdgeInsets.all(4),
                                            decoration: BoxDecoration(color: CustomColors.primaryLight, borderRadius: BorderRadius.circular(6)),
                                            child: Text(
                                              snapshot.data!.jobDetail![index].learning!.assistanceInReading.toString() == "1" ? "Reading" : snapshot.data!.jobDetail![index].learning!.assistanceInReading.toString(),
                                              style: TextStyle(
                                                fontSize: 13,
                                                fontFamily: "Poppins",
                                                fontWeight: FontWeight.w500,
                                                color: CustomColors.primaryTextLight,
                                              ),
                                            ),
                                          )
                                        : Container(),
                                    snapshot.data!.jobDetail![index].learning!.assistanceInScience.toString() == "1"
                                        ? Container(
                                            margin: const EdgeInsets.symmetric(horizontal: 3),
                                            padding: const EdgeInsets.all(4),
                                            decoration: BoxDecoration(color: CustomColors.primaryLight, borderRadius: BorderRadius.circular(6)),
                                            child: Text(
                                              snapshot.data!.jobDetail![index].learning!.assistanceInScience.toString() == "1" ? "Science" : snapshot.data!.jobDetail![index].learning!.assistanceInScience.toString(),
                                              style: TextStyle(
                                                fontSize: 13,
                                                fontFamily: "Poppins",
                                                fontWeight: FontWeight.w500,
                                                color: CustomColors.primaryTextLight,
                                              ),
                                            ),
                                          )
                                        : Container(),
                                    snapshot.data!.jobDetail![index].learning!.assistanceInOther.toString() != "null"
                                        ? Container(
                                            margin: const EdgeInsets.symmetric(horizontal: 3),
                                            padding: const EdgeInsets.all(4),
                                            decoration: BoxDecoration(color: CustomColors.primaryLight, borderRadius: BorderRadius.circular(6)),
                                            child: Text(
                                              snapshot.data!.jobDetail![index].learning!.assistanceInOther.toString(),
                                              style: TextStyle(
                                                fontSize: 13,
                                                fontFamily: "Poppins",
                                                fontWeight: FontWeight.w500,
                                                color: CustomColors.primaryTextLight,
                                              ),
                                            ),
                                          )
                                        : Container(),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 12),
                    margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 0),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: CustomColors.white,
                    ),
                    child: Column(
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            SizedBox(
                              width: MediaQuery.of(context).size.width * .4,
                              child: Text(
                                "Learning Style",
                                style: TextStyle(
                                  fontSize: 14,
                                  fontFamily: "Poppins",
                                  fontWeight: FontWeight.w500,
                                  color: CustomColors.primaryTextLight,
                                ),
                              ),
                            ),
                            SizedBox(
                              width: MediaQuery.of(context).size.width * .5,
                              child: Text(
                                snapshot.data!.jobDetail![index].learning!.learningStyle.toString(),
                                style: TextStyle(
                                  fontSize: 14,
                                  fontFamily: "Poppins",
                                  fontWeight: FontWeight.w600,
                                  color: CustomColors.primaryTextLight,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            SizedBox(
                              width: MediaQuery.of(context).size.width * .4,
                              child: Text(
                                "Learning Challenge",
                                style: TextStyle(
                                  fontSize: 14,
                                  fontFamily: "Poppins",
                                  fontWeight: FontWeight.w500,
                                  color: CustomColors.primaryTextLight,
                                ),
                              ),
                            ),
                            SizedBox(
                              width: MediaQuery.of(context).size.width * .5,
                              child: Text(
                                snapshot.data!.jobDetail![index].learning!.learningChallenge.toString(),
                                style: TextStyle(
                                  fontSize: 14,
                                  fontFamily: "Poppins",
                                  fontWeight: FontWeight.w600,
                                  color: CustomColors.primaryTextLight,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Job Schedule
                        snapshot.data!.jobDetail![index].schedule!.isEmpty
                            ? Container()
                            : Container(
                                padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 12),
                                alignment: Alignment.topLeft,
                                child: Text(
                                  "Job schedule",
                                  style: TextStyle(
                                    color: CustomColors.primaryText,
                                    fontFamily: "Poppins",
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                        snapshot.data!.jobDetail![index].schedule!.isEmpty
                            ? Container()
                            : Container(
                                padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                                margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 0),
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  color: CustomColors.white,
                                ),
                                child: Column(
                                  children: [
                                    SizedBox(
                                      child: Column(
                                        children: [
                                          Row(
                                            children: [
                                              Container(
                                                alignment: Alignment.topLeft,
                                                width: 150,
                                                child: Text(
                                                  "Date :",
                                                  style: TextStyle(
                                                    color: CustomColors.primaryText,
                                                    fontFamily: "Poppins",
                                                    fontSize: 13,
                                                    fontWeight: FontWeight.w400,
                                                  ),
                                                ),
                                              ),
                                              Expanded(
                                                child: Text(
                                                  snapshot.data!.jobDetail![index].schedule!.isEmpty ? "Data Not Available" : snapshot.data!.jobDetail![index].schedule![index].startingDate.toString(),
                                                  style: TextStyle(
                                                    color: CustomColors.primaryText,
                                                    fontFamily: "Poppins",
                                                    fontSize: 13,
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(
                                            height: 5,
                                          ),
                                          Row(
                                            children: [
                                              Container(
                                                alignment: Alignment.topLeft,
                                                width: 150,
                                                child: Text(
                                                  "Start Time :",
                                                  style: TextStyle(
                                                    color: CustomColors.primaryText,
                                                    fontFamily: "Poppins",
                                                    fontSize: 13,
                                                    fontWeight: FontWeight.w400,
                                                  ),
                                                ),
                                              ),
                                              Expanded(
                                                child: Text(
                                                  snapshot.data!.jobDetail![index].schedule!.isEmpty ? "Data Not Available" : snapshot.data!.jobDetail![index].schedule![index].startingTime.toString(),
                                                  style: TextStyle(
                                                    color: CustomColors.primaryText,
                                                    fontFamily: "Poppins",
                                                    fontSize: 13,
                                                    fontWeight: FontWeight.w400,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 5,
                                    ),
                                    SizedBox(
                                      child: Row(
                                        children: [
                                          Container(
                                            alignment: Alignment.topLeft,
                                            width: 150,
                                            child: Text(
                                              "Duration :",
                                              style: TextStyle(
                                                color: CustomColors.primaryText,
                                                fontFamily: "Poppins",
                                                fontSize: 13,
                                                fontWeight: FontWeight.w400,
                                              ),
                                            ),
                                          ),
                                          Expanded(
                                            child: Text(
                                              "${snapshot.data!.jobDetail![index].schedule!.isEmpty ? "Data Not Available" : snapshot.data!.jobDetail![index].schedule![index].duration.toString()} hours",
                                              style: TextStyle(
                                                color: CustomColors.primaryText,
                                                fontFamily: "Poppins",
                                                fontSize: 13,
                                                fontWeight: FontWeight.w400,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                        const SizedBox(
                          height: 10,
                        ),

                        snapshot.data!.isApplied == 0
                            ? GestureDetector(
                                onTap: () {
                                  jobApply();
                                },
                                child: Container(
                                  height: 60,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(14),
                                    color: CustomColors.primaryColor,
                                  ),
                                  margin: const EdgeInsets.symmetric(horizontal: 10),
                                  child: Center(
                                    child: Text(
                                      "Apply Now",
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
                              )
                            : Container(
                                height: 60,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(14),
                                  color: CustomColors.primaryLight,
                                ),
                                margin: const EdgeInsets.symmetric(horizontal: 10),
                                child: Center(
                                  child: Text(
                                    "Apply Now",
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
                      ],
                    ),
                  ),
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

  Widget serviceHouseKeeping(BuildContext context) {
    return FutureBuilder<HouseKeepingDetailDashboardModel>(
      future: futureHouseKeepingDetailDashboard,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return ListView.builder(
            shrinkWrap: true,
            scrollDirection: Axis.vertical,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: snapshot.data!.jobDetail!.length,
            itemBuilder: (BuildContext context, int index) {
              return Column(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 12),
                    margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 0),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: CustomColors.white,
                    ),
                    child: Column(
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            SizedBox(
                              width: MediaQuery.of(context).size.width * .4,
                              child: Text(
                                "Job Title",
                                style: TextStyle(
                                  fontSize: 14,
                                  fontFamily: "Poppins",
                                  fontWeight: FontWeight.w500,
                                  color: CustomColors.primaryTextLight,
                                ),
                              ),
                            ),
                            SizedBox(
                              width: MediaQuery.of(context).size.width * .5,
                              child: Text(
                                snapshot.data!.jobDetail![index].jobTitle.toString(),
                                style: TextStyle(
                                  fontSize: 24,
                                  fontFamily: "Poppins",
                                  fontWeight: FontWeight.w600,
                                  color: CustomColors.primaryText,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            SizedBox(
                              width: MediaQuery.of(context).size.width * .4,
                              child: Text(
                                "Job Area",
                                style: TextStyle(
                                  fontSize: 14,
                                  fontFamily: "Poppins",
                                  fontWeight: FontWeight.w500,
                                  color: CustomColors.primaryTextLight,
                                ),
                              ),
                            ),
                            SizedBox(
                              width: MediaQuery.of(context).size.width * .5,
                              child: Text(
                                snapshot.data!.jobDetail![index].location.toString(),
                                style: TextStyle(
                                  fontSize: 14,
                                  fontFamily: "Poppins",
                                  fontWeight: FontWeight.w600,
                                  color: CustomColors.primaryTextLight,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            SizedBox(
                              width: MediaQuery.of(context).size.width * .4,
                              child: Text(
                                "Hourly Rate",
                                style: TextStyle(
                                  fontSize: 14,
                                  fontFamily: "Poppins",
                                  fontWeight: FontWeight.w500,
                                  color: CustomColors.primaryTextLight,
                                ),
                              ),
                            ),
                            SizedBox(
                              width: MediaQuery.of(context).size.width * .5,
                              child: Text(
                                "\$${snapshot.data!.jobDetail![index].hourlyRate.toString()}/hour",
                                style: TextStyle(
                                  fontSize: 14,
                                  fontFamily: "Poppins",
                                  fontWeight: FontWeight.w600,
                                  color: CustomColors.primaryTextLight,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            SizedBox(
                              width: MediaQuery.of(context).size.width * .4,
                              child: Text(
                                "Cleaning Type",
                                style: TextStyle(
                                  fontSize: 14,
                                  fontFamily: "Poppins",
                                  fontWeight: FontWeight.w500,
                                  color: CustomColors.primaryTextLight,
                                ),
                              ),
                            ),
                            SizedBox(
                              width: MediaQuery.of(context).size.width * .5,
                              child: Text(
                                snapshot.data!.jobDetail![index].houseKeeping!.cleaningType.toString(),
                                style: TextStyle(
                                  fontSize: 14,
                                  fontFamily: "Poppins",
                                  fontWeight: FontWeight.w600,
                                  color: CustomColors.primaryTextLight,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            SizedBox(
                              width: MediaQuery.of(context).size.width * .4,
                              child: Text(
                                "Number of Bedrooms",
                                style: TextStyle(
                                  fontSize: 14,
                                  fontFamily: "Poppins",
                                  fontWeight: FontWeight.w500,
                                  color: CustomColors.primaryTextLight,
                                ),
                              ),
                            ),
                            SizedBox(
                              width: MediaQuery.of(context).size.width * .5,
                              child: Text(
                                snapshot.data!.jobDetail![index].houseKeeping!.numberOfBedrooms.toString(),
                                style: TextStyle(
                                  fontSize: 14,
                                  fontFamily: "Poppins",
                                  fontWeight: FontWeight.w600,
                                  color: CustomColors.primaryTextLight,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            SizedBox(
                              width: MediaQuery.of(context).size.width * .4,
                              child: Text(
                                "Number of Bathrooms",
                                style: TextStyle(
                                  fontSize: 14,
                                  fontFamily: "Poppins",
                                  fontWeight: FontWeight.w500,
                                  color: CustomColors.primaryTextLight,
                                ),
                              ),
                            ),
                            SizedBox(
                              width: MediaQuery.of(context).size.width * .5,
                              child: Text(
                                snapshot.data!.jobDetail![index].houseKeeping!.numberOfBathrooms.toString(),
                                style: TextStyle(
                                  fontSize: 14,
                                  fontFamily: "Poppins",
                                  fontWeight: FontWeight.w600,
                                  color: CustomColors.primaryTextLight,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            SizedBox(
                              width: MediaQuery.of(context).size.width * .4,
                              child: Text(
                                "Number of Bathrooms",
                                style: TextStyle(
                                  fontSize: 14,
                                  fontFamily: "Poppins",
                                  fontWeight: FontWeight.w500,
                                  color: CustomColors.primaryTextLight,
                                ),
                              ),
                            ),
                            SizedBox(
                              width: MediaQuery.of(context).size.width * .5,
                              child: Text(
                                snapshot.data!.jobDetail![index].houseKeeping!.numberOfBathrooms.toString(),
                                style: TextStyle(
                                  fontSize: 14,
                                  fontFamily: "Poppins",
                                  fontWeight: FontWeight.w600,
                                  color: CustomColors.primaryTextLight,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            SizedBox(
                              width: MediaQuery.of(context).size.width * .4,
                              child: Text(
                                "Laundary",
                                style: TextStyle(
                                  fontSize: 14,
                                  fontFamily: "Poppins",
                                  fontWeight: FontWeight.w500,
                                  color: CustomColors.primaryTextLight,
                                ),
                              ),
                            ),
                            SizedBox(
                              width: MediaQuery.of(context).size.width * .5,
                              child: Text(
                                snapshot.data!.jobDetail![index].houseKeeping!.laundry.toString() == "1" ? "Yes" : "No",
                                style: TextStyle(
                                  fontSize: 14,
                                  fontFamily: "Poppins",
                                  fontWeight: FontWeight.w600,
                                  color: CustomColors.primaryTextLight,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            SizedBox(
                              width: MediaQuery.of(context).size.width * .4,
                              child: Text(
                                "Ironing",
                                style: TextStyle(
                                  fontSize: 14,
                                  fontFamily: "Poppins",
                                  fontWeight: FontWeight.w500,
                                  color: CustomColors.primaryTextLight,
                                ),
                              ),
                            ),
                            SizedBox(
                              width: MediaQuery.of(context).size.width * .5,
                              child: Text(
                                snapshot.data!.jobDetail![index].houseKeeping!.ironing.toString() == "1" ? "Yes" : "No",
                                style: TextStyle(
                                  fontSize: 14,
                                  fontFamily: "Poppins",
                                  fontWeight: FontWeight.w600,
                                  color: CustomColors.primaryTextLight,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            SizedBox(
                              width: MediaQuery.of(context).size.width * .4,
                              child: Text(
                                "Other",
                                style: TextStyle(
                                  fontSize: 14,
                                  fontFamily: "Poppins",
                                  fontWeight: FontWeight.w500,
                                  color: CustomColors.primaryTextLight,
                                ),
                              ),
                            ),
                            SizedBox(
                              width: MediaQuery.of(context).size.width * .5,
                              child: Text(
                                snapshot.data!.jobDetail![index].houseKeeping!.other.toString() == "null" ? "" : snapshot.data!.jobDetail![index].houseKeeping!.other.toString(),
                                style: TextStyle(
                                  fontSize: 14,
                                  fontFamily: "Poppins",
                                  fontWeight: FontWeight.w600,
                                  color: CustomColors.primaryTextLight,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  SizedBox(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Job Schedule
                        snapshot.data!.jobDetail![index].schedule!.isEmpty
                            ? Container()
                            : Container(
                                padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 12),
                                alignment: Alignment.topLeft,
                                child: Text(
                                  "Job schedule",
                                  style: TextStyle(
                                    color: CustomColors.primaryText,
                                    fontFamily: "Poppins",
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                        snapshot.data!.jobDetail![index].schedule!.isEmpty
                            ? Container()
                            : Container(
                                padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                                margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 0),
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  color: CustomColors.white,
                                ),
                                child: Column(
                                  children: [
                                    SizedBox(
                                      child: Column(
                                        children: [
                                          Row(
                                            children: [
                                              Container(
                                                alignment: Alignment.topLeft,
                                                width: 150,
                                                child: Text(
                                                  "Date :",
                                                  style: TextStyle(
                                                    color: CustomColors.primaryText,
                                                    fontFamily: "Poppins",
                                                    fontSize: 13,
                                                    fontWeight: FontWeight.w400,
                                                  ),
                                                ),
                                              ),
                                              Expanded(
                                                child: Text(
                                                  snapshot.data!.jobDetail![index].schedule!.isEmpty ? "Data Not Available" : snapshot.data!.jobDetail![index].schedule![index].startingDate.toString(),
                                                  style: TextStyle(
                                                    color: CustomColors.primaryText,
                                                    fontFamily: "Poppins",
                                                    fontSize: 13,
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(
                                            height: 5,
                                          ),
                                          Row(
                                            children: [
                                              Container(
                                                alignment: Alignment.topLeft,
                                                width: 150,
                                                child: Text(
                                                  "Start Time :",
                                                  style: TextStyle(
                                                    color: CustomColors.primaryText,
                                                    fontFamily: "Poppins",
                                                    fontSize: 13,
                                                    fontWeight: FontWeight.w400,
                                                  ),
                                                ),
                                              ),
                                              Expanded(
                                                child: Text(
                                                  snapshot.data!.jobDetail![index].schedule!.isEmpty ? "Data Not Available" : snapshot.data!.jobDetail![index].schedule![index].startingTime.toString(),
                                                  style: TextStyle(
                                                    color: CustomColors.primaryText,
                                                    fontFamily: "Poppins",
                                                    fontSize: 13,
                                                    fontWeight: FontWeight.w400,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 5,
                                    ),
                                    SizedBox(
                                      child: Row(
                                        children: [
                                          Container(
                                            alignment: Alignment.topLeft,
                                            width: 150,
                                            child: Text(
                                              "Duration :",
                                              style: TextStyle(
                                                color: CustomColors.primaryText,
                                                fontFamily: "Poppins",
                                                fontSize: 13,
                                                fontWeight: FontWeight.w400,
                                              ),
                                            ),
                                          ),
                                          Expanded(
                                            child: Text(
                                              "${snapshot.data!.jobDetail![index].schedule!.isEmpty ? "Data Not Available" : snapshot.data!.jobDetail![index].schedule![index].duration.toString()} hours",
                                              style: TextStyle(
                                                color: CustomColors.primaryText,
                                                fontFamily: "Poppins",
                                                fontSize: 13,
                                                fontWeight: FontWeight.w400,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                        const SizedBox(
                          height: 10,
                        ),

                        snapshot.data!.isApplied == 0
                            ? GestureDetector(
                                onTap: () {
                                  jobApply();
                                },
                                child: Container(
                                  height: 60,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(14),
                                    color: CustomColors.primaryColor,
                                  ),
                                  margin: const EdgeInsets.symmetric(horizontal: 10),
                                  child: Center(
                                    child: Text(
                                      "Apply Now",
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
                              )
                            : Container(
                                height: 60,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(14),
                                  color: CustomColors.primaryLight,
                                ),
                                margin: const EdgeInsets.symmetric(horizontal: 10),
                                child: Center(
                                  child: Text(
                                    "Apply Now",
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
                      ],
                    ),
                  ),
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
            itemBuilder: (BuildContext context, int index) {
              return Column(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 12),
                    margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 0),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: CustomColors.white,
                    ),
                    child: Column(
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            SizedBox(
                              width: MediaQuery.of(context).size.width * .4,
                              child: Text(
                                "Job Title",
                                style: TextStyle(
                                  fontSize: 14,
                                  fontFamily: "Poppins",
                                  fontWeight: FontWeight.w500,
                                  color: CustomColors.primaryTextLight,
                                ),
                              ),
                            ),
                            SizedBox(
                              width: MediaQuery.of(context).size.width * .5,
                              child: Text(
                                snapshot.data!.jobDetail![index].jobTitle.toString(),
                                style: TextStyle(
                                  fontSize: 24,
                                  fontFamily: "Poppins",
                                  fontWeight: FontWeight.w600,
                                  color: CustomColors.primaryText,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            SizedBox(
                              width: MediaQuery.of(context).size.width * .4,
                              child: Text(
                                "Job Area",
                                style: TextStyle(
                                  fontSize: 14,
                                  fontFamily: "Poppins",
                                  fontWeight: FontWeight.w500,
                                  color: CustomColors.primaryTextLight,
                                ),
                              ),
                            ),
                            SizedBox(
                              width: MediaQuery.of(context).size.width * .5,
                              child: Text(
                                snapshot.data!.jobDetail![index].location.toString(),
                                style: TextStyle(
                                  fontSize: 14,
                                  fontFamily: "Poppins",
                                  fontWeight: FontWeight.w600,
                                  color: CustomColors.primaryTextLight,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            SizedBox(
                              width: MediaQuery.of(context).size.width * .4,
                              child: Text(
                                "Hourly Rate",
                                style: TextStyle(
                                  fontSize: 14,
                                  fontFamily: "Poppins",
                                  fontWeight: FontWeight.w500,
                                  color: CustomColors.primaryTextLight,
                                ),
                              ),
                            ),
                            SizedBox(
                              width: MediaQuery.of(context).size.width * .5,
                              child: Text(
                                "\$${snapshot.data!.jobDetail![index].hourlyRate.toString()}/hour",
                                style: TextStyle(
                                  fontSize: 14,
                                  fontFamily: "Poppins",
                                  fontWeight: FontWeight.w600,
                                  color: CustomColors.primaryTextLight,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            SizedBox(
                              width: MediaQuery.of(context).size.width * .4,
                              child: Text(
                                "Pet Type",
                                style: TextStyle(
                                  fontSize: 14,
                                  fontFamily: "Poppins",
                                  fontWeight: FontWeight.w500,
                                  color: CustomColors.primaryTextLight,
                                ),
                              ),
                            ),
                            SizedBox(
                              width: MediaQuery.of(context).size.width * .5,
                              child: Text(
                                snapshot.data!.jobDetail![index].petCare!.petType.toString(),
                                style: TextStyle(
                                  fontSize: 14,
                                  fontFamily: "Poppins",
                                  fontWeight: FontWeight.w600,
                                  color: CustomColors.primaryTextLight,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            SizedBox(
                              width: MediaQuery.of(context).size.width * .4,
                              child: Text(
                                "Number of Pet",
                                style: TextStyle(
                                  fontSize: 14,
                                  fontFamily: "Poppins",
                                  fontWeight: FontWeight.w500,
                                  color: CustomColors.primaryTextLight,
                                ),
                              ),
                            ),
                            SizedBox(
                              width: MediaQuery.of(context).size.width * .5,
                              child: Text(
                                snapshot.data!.jobDetail![index].petCare!.numberOfPets.toString(),
                                style: TextStyle(
                                  fontSize: 14,
                                  fontFamily: "Poppins",
                                  fontWeight: FontWeight.w600,
                                  color: CustomColors.primaryTextLight,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            SizedBox(
                              width: MediaQuery.of(context).size.width * .4,
                              child: Text(
                                "Pet Breed",
                                style: TextStyle(
                                  fontSize: 14,
                                  fontFamily: "Poppins",
                                  fontWeight: FontWeight.w500,
                                  color: CustomColors.primaryTextLight,
                                ),
                              ),
                            ),
                            SizedBox(
                              width: MediaQuery.of(context).size.width * .5,
                              child: Text(
                                snapshot.data!.jobDetail![index].petCare!.petBreed.toString(),
                                style: TextStyle(
                                  fontSize: 14,
                                  fontFamily: "Poppins",
                                  fontWeight: FontWeight.w600,
                                  color: CustomColors.primaryTextLight,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            SizedBox(
                              width: MediaQuery.of(context).size.width * .4,
                              child: Text(
                                "Size Of Pet",
                                style: TextStyle(
                                  fontSize: 14,
                                  fontFamily: "Poppins",
                                  fontWeight: FontWeight.w500,
                                  color: CustomColors.primaryTextLight,
                                ),
                              ),
                            ),
                            SizedBox(
                              width: MediaQuery.of(context).size.width * .5,
                              child: Text(
                                snapshot.data!.jobDetail![index].petCare!.sizeOfPet.toString(),
                                style: TextStyle(
                                  fontSize: 14,
                                  fontFamily: "Poppins",
                                  fontWeight: FontWeight.w600,
                                  color: CustomColors.primaryTextLight,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            SizedBox(
                              width: MediaQuery.of(context).size.width * .4,
                              child: Text(
                                "Temperament",
                                style: TextStyle(
                                  fontSize: 14,
                                  fontFamily: "Poppins",
                                  fontWeight: FontWeight.w500,
                                  color: CustomColors.primaryTextLight,
                                ),
                              ),
                            ),
                            SizedBox(
                              width: MediaQuery.of(context).size.width * .5,
                              child: Text(
                                snapshot.data!.jobDetail![index].petCare!.temperament.toString(),
                                style: TextStyle(
                                  fontSize: 14,
                                  fontFamily: "Poppins",
                                  fontWeight: FontWeight.w600,
                                  color: CustomColors.primaryTextLight,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                    margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 0),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: CustomColors.white,
                    ),
                    child: Column(
                      children: [
                        SizedBox(
                          child: Row(
                            children: [
                              Container(
                                alignment: Alignment.topLeft,
                                width: 150,
                                child: Column(
                                  children: [
                                    Text(
                                      "Assistance :",
                                      style: TextStyle(
                                        color: CustomColors.primaryText,
                                        fontFamily: "Poppins",
                                        fontSize: 13,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Expanded(
                                child: Wrap(
                                  runSpacing: 5.0,
                                  spacing: 5.0,
                                  children: [
                                    snapshot.data!.jobDetail![index].petCare!.walking.toString() == "1"
                                        ? Container(
                                            margin: const EdgeInsets.symmetric(horizontal: 3),
                                            padding: const EdgeInsets.all(4),
                                            decoration: BoxDecoration(color: CustomColors.primaryLight, borderRadius: BorderRadius.circular(6)),
                                            child: Text(
                                              snapshot.data!.jobDetail![index].petCare!.walking.toString() == "1" ? "Walking" : snapshot.data!.jobDetail![index].petCare!.walking.toString(),
                                              style: TextStyle(
                                                fontSize: 13,
                                                fontFamily: "Poppins",
                                                fontWeight: FontWeight.w500,
                                                color: CustomColors.primaryTextLight,
                                              ),
                                            ),
                                          )
                                        : Container(),
                                    snapshot.data!.jobDetail![index].petCare!.daycare.toString() == "1"
                                        ? Container(
                                            margin: const EdgeInsets.symmetric(horizontal: 3),
                                            padding: const EdgeInsets.all(4),
                                            decoration: BoxDecoration(color: CustomColors.primaryLight, borderRadius: BorderRadius.circular(6)),
                                            child: Text(
                                              snapshot.data!.jobDetail![index].petCare!.daycare.toString() == "1" ? "Day Care" : snapshot.data!.jobDetail![index].petCare!.daycare.toString(),
                                              style: TextStyle(
                                                fontSize: 13,
                                                fontFamily: "Poppins",
                                                fontWeight: FontWeight.w500,
                                                color: CustomColors.primaryTextLight,
                                              ),
                                            ),
                                          )
                                        : Container(),
                                    snapshot.data!.jobDetail![index].petCare!.feeding.toString() == "1"
                                        ? Container(
                                            margin: const EdgeInsets.symmetric(horizontal: 3),
                                            padding: const EdgeInsets.all(4),
                                            decoration: BoxDecoration(color: CustomColors.primaryLight, borderRadius: BorderRadius.circular(6)),
                                            child: Text(
                                              snapshot.data!.jobDetail![index].petCare!.feeding.toString() == "1" ? "Feeding" : snapshot.data!.jobDetail![index].petCare!.feeding.toString(),
                                              style: TextStyle(
                                                fontSize: 13,
                                                fontFamily: "Poppins",
                                                fontWeight: FontWeight.w500,
                                                color: CustomColors.primaryTextLight,
                                              ),
                                            ),
                                          )
                                        : Container(),
                                    snapshot.data!.jobDetail![index].petCare!.socialization.toString() == "1"
                                        ? Container(
                                            margin: const EdgeInsets.symmetric(horizontal: 3),
                                            padding: const EdgeInsets.all(4),
                                            decoration: BoxDecoration(color: CustomColors.primaryLight, borderRadius: BorderRadius.circular(6)),
                                            child: Text(
                                              snapshot.data!.jobDetail![index].petCare!.socialization.toString() == "1" ? "Socialization" : snapshot.data!.jobDetail![index].petCare!.socialization.toString(),
                                              style: TextStyle(
                                                fontSize: 13,
                                                fontFamily: "Poppins",
                                                fontWeight: FontWeight.w500,
                                                color: CustomColors.primaryTextLight,
                                              ),
                                            ),
                                          )
                                        : Container(),
                                    snapshot.data!.jobDetail![index].petCare!.grooming.toString() == "1"
                                        ? Container(
                                            margin: const EdgeInsets.symmetric(horizontal: 3),
                                            padding: const EdgeInsets.all(4),
                                            decoration: BoxDecoration(color: CustomColors.primaryLight, borderRadius: BorderRadius.circular(6)),
                                            child: Text(
                                              snapshot.data!.jobDetail![index].petCare!.grooming.toString() == "1" ? "Grooming" : snapshot.data!.jobDetail![index].petCare!.grooming.toString(),
                                              style: TextStyle(
                                                fontSize: 13,
                                                fontFamily: "Poppins",
                                                fontWeight: FontWeight.w500,
                                                color: CustomColors.primaryTextLight,
                                              ),
                                            ),
                                          )
                                        : Container(),
                                    snapshot.data!.jobDetail![index].petCare!.boarding.toString() == "1"
                                        ? Container(
                                            margin: const EdgeInsets.symmetric(horizontal: 3),
                                            padding: const EdgeInsets.all(4),
                                            decoration: BoxDecoration(color: CustomColors.primaryLight, borderRadius: BorderRadius.circular(6)),
                                            child: Text(
                                              snapshot.data!.jobDetail![index].petCare!.boarding.toString() == "1" ? "Boarding" : snapshot.data!.jobDetail![index].petCare!.boarding.toString(),
                                              style: TextStyle(
                                                fontSize: 13,
                                                fontFamily: "Poppins",
                                                fontWeight: FontWeight.w500,
                                                color: CustomColors.primaryTextLight,
                                              ),
                                            ),
                                          )
                                        : Container(),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  SizedBox(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Job Schedule
                        snapshot.data!.jobDetail![index].schedule!.isEmpty
                            ? Container()
                            : Container(
                                padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 12),
                                alignment: Alignment.topLeft,
                                child: Text(
                                  "Job schedule",
                                  style: TextStyle(
                                    color: CustomColors.primaryText,
                                    fontFamily: "Poppins",
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                        snapshot.data!.jobDetail![index].schedule!.isEmpty
                            ? Container()
                            : Container(
                                padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                                margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 0),
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  color: CustomColors.white,
                                ),
                                child: Column(
                                  children: [
                                    SizedBox(
                                      child: Column(
                                        children: [
                                          Row(
                                            children: [
                                              Container(
                                                alignment: Alignment.topLeft,
                                                width: 150,
                                                child: Text(
                                                  "Date :",
                                                  style: TextStyle(
                                                    color: CustomColors.primaryText,
                                                    fontFamily: "Poppins",
                                                    fontSize: 13,
                                                    fontWeight: FontWeight.w400,
                                                  ),
                                                ),
                                              ),
                                              Expanded(
                                                child: Text(
                                                  snapshot.data!.jobDetail![index].schedule!.isEmpty ? "Data Not Available" : snapshot.data!.jobDetail![index].schedule![index].startingDate.toString(),
                                                  style: TextStyle(
                                                    color: CustomColors.primaryText,
                                                    fontFamily: "Poppins",
                                                    fontSize: 13,
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(
                                            height: 5,
                                          ),
                                          Row(
                                            children: [
                                              Container(
                                                alignment: Alignment.topLeft,
                                                width: 150,
                                                child: Text(
                                                  "Start Time :",
                                                  style: TextStyle(
                                                    color: CustomColors.primaryText,
                                                    fontFamily: "Poppins",
                                                    fontSize: 13,
                                                    fontWeight: FontWeight.w400,
                                                  ),
                                                ),
                                              ),
                                              Expanded(
                                                child: Text(
                                                  snapshot.data!.jobDetail![index].schedule!.isEmpty ? "Data Not Available" : snapshot.data!.jobDetail![index].schedule![index].startingTime.toString(),
                                                  style: TextStyle(
                                                    color: CustomColors.primaryText,
                                                    fontFamily: "Poppins",
                                                    fontSize: 13,
                                                    fontWeight: FontWeight.w400,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 5,
                                    ),
                                    SizedBox(
                                      child: Row(
                                        children: [
                                          Container(
                                            alignment: Alignment.topLeft,
                                            width: 150,
                                            child: Text(
                                              "Duration :",
                                              style: TextStyle(
                                                color: CustomColors.primaryText,
                                                fontFamily: "Poppins",
                                                fontSize: 13,
                                                fontWeight: FontWeight.w400,
                                              ),
                                            ),
                                          ),
                                          Expanded(
                                            child: Text(
                                              "${snapshot.data!.jobDetail![index].schedule!.isEmpty ? "Data Not Available" : snapshot.data!.jobDetail![index].schedule![index].duration.toString()} hours",
                                              style: TextStyle(
                                                color: CustomColors.primaryText,
                                                fontFamily: "Poppins",
                                                fontSize: 13,
                                                fontWeight: FontWeight.w400,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                        const SizedBox(
                          height: 10,
                        ),

                        snapshot.data!.isApplied == 0
                            ? GestureDetector(
                                onTap: () {
                                  jobApply();
                                },
                                child: Container(
                                  margin: const EdgeInsets.symmetric(horizontal: 10),
                                  height: 60,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(14),
                                    color: CustomColors.primaryColor,
                                  ),
                                  child: Center(
                                    child: Text(
                                      "Apply Now",
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
                              )
                            : Container(
                                height: 60,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(14),
                                  color: CustomColors.primaryLight,
                                ),
                                margin: const EdgeInsets.symmetric(horizontal: 10),
                                child: Center(
                                  child: Text(
                                    "Apply Now",
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
                      ],
                    ),
                  ),
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
