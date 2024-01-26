// ignore_for_file: use_build_context_synchronously

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:island_app/caregiver/screens/job_detail.dart';
import 'package:island_app/carereceiver/models/child_care_model.dart';
import 'package:island_app/carereceiver/models/house_keeping_model.dart';
import 'package:island_app/carereceiver/models/pet_care_model.dart';
import 'package:island_app/carereceiver/models/school_support_model.dart';
import 'package:island_app/res/app_url.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:island_app/carereceiver/models/senior_care_model.dart';
import 'package:island_app/carereceiver/utils/colors.dart';
import 'package:island_app/utils/utils.dart';

class ServiceProviderJobsDetail extends StatefulWidget {
  final String? id;
  final String? service;
  const ServiceProviderJobsDetail({
    Key? key,
    this.id,
    this.service,
  }) : super(key: key);

  @override
  State<ServiceProviderJobsDetail> createState() => _ServiceProviderJobsDetailState();
}

class _ServiceProviderJobsDetailState extends State<ServiceProviderJobsDetail> {
  // Get Detail jobs
  late Future<SeniorCareDetailModel> futureSeniorCareDetail;
  late Future<PetCareDetailModel> futurePetCareDetail;
  late Future<HouseKeepingDetailModel> futureHouseKeepingDetail;
  late Future<ChildCareDetailModel> futureChildCareDetail;
  late Future<SchoolSupportDetailModel> futureSchoolSupportDetail;
  Future<SeniorCareDetailModel> fetchSeniorCareDetailModel() async {
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
      return SeniorCareDetailModel.fromJson(response.data);
    } else {
      throw Exception(
        customErrorSnackBar(
          context,
          'Failed to load Services Model',
        ),
      );
    }
  }

  Future<PetCareDetailModel> fetchPetCareDetailModel() async {
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
      return PetCareDetailModel.fromJson(response.data);
    } else {
      throw Exception(
        customErrorSnackBar(
          context,
          'Failed to load Services Model',
        ),
      );
    }
  }

  Future<HouseKeepingDetailModel> fetchHouseKeepingDetailModel() async {
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
      return HouseKeepingDetailModel.fromJson(response.data);
    } else {
      throw Exception(
        customErrorSnackBar(
          context,
          'Failed to load Services Model',
        ),
      );
    }
  }

  Future<ChildCareDetailModel> fetchChildCareDetailModel() async {
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
      return ChildCareDetailModel.fromJson(response.data);
    } else {
      throw Exception(
        customErrorSnackBar(
          context,
          'Failed to load Services Model',
        ),
      );
    }
  }

  Future<SchoolSupportDetailModel> fetchSchoolSupportDetailModel() async {
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
      return SchoolSupportDetailModel.fromJson(response.data);
    } else {
      throw Exception(
        customErrorSnackBar(
          context,
          'Failed to load Services Model',
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
    futureSeniorCareDetail = fetchSeniorCareDetailModel();
    futurePetCareDetail = fetchPetCareDetailModel();
    futureHouseKeepingDetail = fetchHouseKeepingDetailModel();
    futureChildCareDetail = fetchChildCareDetailModel();
    futureSchoolSupportDetail = fetchSchoolSupportDetailModel();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: CustomColors.myJobDetail,
        appBar: AppBar(
          centerTitle: true,
          elevation: 0,
          backgroundColor: Colors.white,
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
            "Details",
            style: TextStyle(
              fontSize: 19,
              fontWeight: FontWeight.w600,
              fontFamily: "Rubik",
              color: CustomColors.primaryText,
            ),
          ),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              if (widget.service == "Senior Care") ...[
                // service
                seniorCare(context),
              ] else if (widget.service == "Pet Care") ...[
                // service id 2
                petCare(context),
              ] else if (widget.service == "House Keeping") ...[
                // service id 3
                houseKeeping(context),
              ] else if (widget.service == "Child Care") ...[
                // Service Id 4
                childCare(context),
              ] else if (widget.service == "School Support") ...[
                // Service Id 5
                schoolSupport(context),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget seniorCare(BuildContext context) {
    return FutureBuilder<SeniorCareDetailModel>(
      future: futureSeniorCareDetail,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return ListView.builder(
            itemCount: snapshot.data!.job!.length,
            shrinkWrap: true,
            padding: const EdgeInsets.all(20),
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Job Information",
                    style: TextStyle(
                      fontFamily: "Poppins",
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  JobDetailTile(
                    name: "Job Title",
                    title: snapshot.data!.job![index].jobTitle.toString(),
                  ),
                  const SizedBox(height: 10),
                  JobDetailTile(
                    name: "Job Address",
                    title: snapshot.data!.job![index].address.toString(),
                  ),
                  const SizedBox(height: 10),
                  JobDetailTile(
                    name: "Job Area",
                    title: snapshot.data!.job![index].location.toString(),
                  ),
                  const SizedBox(height: 10),
                  JobDetailTile(
                    name: "Hourly Rate",
                    title: snapshot.data!.job![index].hourlyRate.toString(),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    "Job Information",
                    style: TextStyle(
                      fontFamily: "Poppins",
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  JobDetailTile(
                    name: "Senior Name",
                    title: snapshot.data!.job![index].seniorCare!.seniorName.toString(),
                  ),
                  const SizedBox(height: 10),
                  JobDetailTile(
                    name: "Date Of Birth",
                    title: snapshot.data!.job![index].seniorCare!.dob.toString(),
                  ),
                  const SizedBox(height: 10),
                  JobDetailTile(
                    name: "Medical Condition",
                    title: snapshot.data!.job![index].seniorCare!.medicalCondition.toString() == "null" ? "Not Available" : snapshot.data!.job![index].seniorCare!.medicalCondition.toString(),
                  ),
                  const SizedBox(height: 10),
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                    margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 0),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: CustomColors.white,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          alignment: Alignment.topLeft,
                          // width: 150,
                          child: const Text(
                            "Requires Assistance ",
                            style: TextStyle(
                              // color: CustomColors.primaryColor,
                              fontFamily: "Poppins",
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: Wrap(
                                runSpacing: 5.0,
                                spacing: 5.0,
                                children: [
                                  if (snapshot.data!.job![index].seniorCare!.bathing.toString() == "1") ...[
                                    CustomBadge(
                                      text: snapshot.data!.job![index].seniorCare!.bathing.toString() == "1" ? "Bathing" : snapshot.data!.job![index].seniorCare!.bathing.toString(),
                                    ),
                                  ],
                                  if (snapshot.data!.job![index].seniorCare!.dressing.toString() == "1") ...[
                                    CustomBadge(
                                      text: snapshot.data!.job![index].seniorCare!.dressing.toString() == "1" ? "Dressing" : snapshot.data!.job![index].seniorCare!.dressing.toString(),
                                    ),
                                  ],
                                  if (snapshot.data!.job![index].seniorCare!.feeding.toString() == "1") ...[
                                    CustomBadge(
                                      text: snapshot.data!.job![index].seniorCare!.feeding.toString() == "1" ? "Feeding" : snapshot.data!.job![index].seniorCare!.feeding.toString(),
                                    ),
                                  ],
                                  if (snapshot.data!.job![index].seniorCare!.mealPreparation.toString() == "1") ...[
                                    Container(
                                      margin: const EdgeInsets.symmetric(horizontal: 3),
                                      padding: const EdgeInsets.all(4),
                                      decoration: BoxDecoration(color: CustomColors.primaryLight, borderRadius: BorderRadius.circular(6)),
                                      child: Text(
                                        snapshot.data!.job![index].seniorCare!.mealPreparation.toString() == "1" ? "Meal Preparation" : snapshot.data!.job![index].seniorCare!.mealPreparation.toString(),
                                        style: TextStyle(
                                          fontSize: 13,
                                          fontFamily: "Poppins",
                                          fontWeight: FontWeight.w500,
                                          color: CustomColors.primaryTextLight,
                                        ),
                                      ),
                                    ),
                                  ],
                                  if (snapshot.data!.job![index].seniorCare!.groceryShopping.toString() == "1") ...[
                                    CustomBadge(
                                      text: snapshot.data!.job![index].seniorCare!.groceryShopping.toString() == "1" ? "Grocery Shopping" : snapshot.data!.job![index].seniorCare!.groceryShopping.toString(),
                                    ),
                                  ],
                                  if (snapshot.data!.job![index].seniorCare!.walking.toString() == "1") ...[
                                    CustomBadge(
                                      text: snapshot.data!.job![index].seniorCare!.walking.toString() == "1" ? "Walking" : snapshot.data!.job![index].seniorCare!.walking.toString(),
                                    ),
                                  ],
                                  if (snapshot.data!.job![index].seniorCare!.bedTransfer.toString() == "1") ...[
                                    CustomBadge(
                                      text: snapshot.data!.job![index].seniorCare!.bedTransfer.toString() == "1" ? "Bed Transfer" : snapshot.data!.job![index].seniorCare!.bedTransfer.toString(),
                                    ),
                                  ],
                                  if (snapshot.data!.job![index].seniorCare!.lightCleaning.toString() == "1") ...[
                                    CustomBadge(
                                      text: snapshot.data!.job![index].seniorCare!.lightCleaning.toString() == "1" ? "Light Cleaning" : snapshot.data!.job![index].seniorCare!.lightCleaning.toString(),
                                    ),
                                  ],
                                  if (snapshot.data!.job![index].seniorCare!.companionship.toString() == "1") ...[
                                    CustomBadge(
                                      text: snapshot.data!.job![index].seniorCare!.companionship.toString() == "1" ? "Companionship" : snapshot.data!.job![index].seniorCare!.companionship.toString(),
                                    ),
                                  ],
                                  if (snapshot.data!.job![index].seniorCare!.medicationAdministration.toString() == "1") ...[
                                    CustomBadge(
                                      text: snapshot.data!.job![index].seniorCare!.medicationAdministration.toString() == "1" ? "Medication Administration" : snapshot.data!.job![index].seniorCare!.medicationAdministration.toString(),
                                    ),
                                  ],
                                  if (snapshot.data!.job![index].seniorCare!.dressingWoundCare.toString() == "1") ...[
                                    CustomBadge(
                                      text: snapshot.data!.job![index].seniorCare!.dressingWoundCare.toString() == "1" ? "Dressing Wound Care" : snapshot.data!.job![index].seniorCare!.dressingWoundCare.toString(),
                                    ),
                                  ],
                                  if (snapshot.data!.job![index].seniorCare!.bloodPressureMonetoring.toString() == "1") ...[
                                    CustomBadge(
                                      text: snapshot.data!.job![index].seniorCare!.bloodPressureMonetoring.toString() == "1" ? "Blood Pressure Monetoring" : snapshot.data!.job![index].seniorCare!.bloodPressureMonetoring.toString(),
                                    ),
                                  ],
                                  if (snapshot.data!.job![index].seniorCare!.bloodSugarMonetoring.toString() == "1") ...[
                                    CustomBadge(
                                      text: snapshot.data!.job![index].seniorCare!.bloodSugarMonetoring.toString() == "1" ? "Blood Sugar Monetoring" : snapshot.data!.job![index].seniorCare!.bloodSugarMonetoring.toString(),
                                    ),
                                  ],
                                  if (snapshot.data!.job![index].seniorCare!.groomingHairAndNailTrimming.toString() == "1") ...[
                                    CustomBadge(
                                      text: snapshot.data!.job![index].seniorCare!.groomingHairAndNailTrimming.toString() == "1" ? "Grooming Hair And Nail Trimming" : snapshot.data!.job![index].seniorCare!.groomingHairAndNailTrimming.toString(),
                                    ),
                                  ],
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    "Job Schedule",
                    style: TextStyle(
                      fontFamily: "Poppins",
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  JobDetailTile(
                    name: "Date :",
                    title: snapshot.data!.job![index].schedule![index].startingDate.toString(),
                  ),
                  const SizedBox(height: 10),
                  JobDetailTile(
                    name: "Start Time :",
                    title: snapshot.data!.job![index].schedule![index].startingTime.toString(),
                  ),
                  const SizedBox(height: 10),
                  JobDetailTile(
                    name: "Duration :",
                    title: "${snapshot.data!.job![index].schedule![index].duration.toString()} hour",
                  ),
                  const SizedBox(height: 10),
                ],
              );
            },
          );
        } else {
          return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }

  Widget petCare(BuildContext context) {
    return FutureBuilder<PetCareDetailModel>(
      future: futurePetCareDetail,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return ListView.builder(
            itemCount: snapshot.data!.job!.length,
            shrinkWrap: true,
            padding: const EdgeInsets.all(20),
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Job Information",
                    style: TextStyle(
                      fontFamily: "Poppins",
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  JobDetailTile(
                    name: "Job Title",
                    title: snapshot.data!.job![index].jobTitle.toString(),
                  ),
                  const SizedBox(height: 10),
                  JobDetailTile(
                    name: "Job Address",
                    title: snapshot.data!.job![index].address.toString(),
                  ),
                  const SizedBox(height: 10),
                  JobDetailTile(
                    name: "Job Area",
                    title: snapshot.data!.job![index].location.toString(),
                  ),
                  const SizedBox(height: 10),
                  JobDetailTile(
                    name: "Hourly Rate",
                    title: snapshot.data!.job![index].hourlyRate.toString(),
                  ),
                  const SizedBox(height: 10),
                  JobDetailTile(
                    name: "Pet Type",
                    title: snapshot.data!.job![index].petCare!.petType.toString(),
                  ),
                  const SizedBox(height: 10),
                  JobDetailTile(
                    name: "Number of Pets",
                    title: snapshot.data!.job![index].petCare!.numberOfPets.toString(),
                  ),
                  const SizedBox(height: 10),
                  JobDetailTile(
                    name: "Pet Breed",
                    title: snapshot.data!.job![index].petCare!.petBreed.toString(),
                  ),
                  const SizedBox(height: 10),
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                    margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 0),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: CustomColors.white,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          alignment: Alignment.topLeft,
                          // width: 150,
                          child: const Text(
                            "Requires Assistance ",
                            style: TextStyle(
                              // color: CustomColors.primaryColor,
                              fontFamily: "Poppins",
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: Wrap(
                                runSpacing: 5.0,
                                spacing: 5.0,
                                children: [
                                  if (snapshot.data!.job![index].petCare!.walking.toString() == "1") ...[
                                    Container(
                                      margin: const EdgeInsets.symmetric(horizontal: 3),
                                      padding: const EdgeInsets.all(4),
                                      decoration: BoxDecoration(color: CustomColors.primaryLight, borderRadius: BorderRadius.circular(6)),
                                      child: Text(
                                        snapshot.data!.job![index].petCare!.walking.toString() == "1" ? "Walking" : snapshot.data!.job![index].petCare!.walking.toString(),
                                        style: TextStyle(
                                          fontSize: 13,
                                          fontFamily: "Poppins",
                                          fontWeight: FontWeight.w500,
                                          color: CustomColors.primaryTextLight,
                                        ),
                                      ),
                                    ),
                                  ],
                                  if (snapshot.data!.job![index].petCare!.daycare.toString() == "1") ...[
                                    Container(
                                      margin: const EdgeInsets.symmetric(horizontal: 3),
                                      padding: const EdgeInsets.all(4),
                                      decoration: BoxDecoration(color: CustomColors.primaryLight, borderRadius: BorderRadius.circular(6)),
                                      child: Text(
                                        snapshot.data!.job![index].petCare!.daycare.toString() == "1" ? "Day Care" : snapshot.data!.job![index].petCare!.daycare.toString(),
                                        style: TextStyle(
                                          fontSize: 13,
                                          fontFamily: "Poppins",
                                          fontWeight: FontWeight.w500,
                                          color: CustomColors.primaryTextLight,
                                        ),
                                      ),
                                    ),
                                  ],
                                  if (snapshot.data!.job![index].petCare!.feeding.toString() == "1") ...[
                                    Container(
                                      margin: const EdgeInsets.symmetric(horizontal: 3),
                                      padding: const EdgeInsets.all(4),
                                      decoration: BoxDecoration(color: CustomColors.primaryLight, borderRadius: BorderRadius.circular(6)),
                                      child: Text(
                                        snapshot.data!.job![index].petCare!.feeding.toString() == "1" ? "Feeding" : snapshot.data!.job![index].petCare!.feeding.toString(),
                                        style: TextStyle(
                                          fontSize: 13,
                                          fontFamily: "Poppins",
                                          fontWeight: FontWeight.w500,
                                          color: CustomColors.primaryTextLight,
                                        ),
                                      ),
                                    )
                                  ],
                                  if (snapshot.data!.job![index].petCare!.socialization.toString() == "1") ...[
                                    Container(
                                      margin: const EdgeInsets.symmetric(horizontal: 3),
                                      padding: const EdgeInsets.all(4),
                                      decoration: BoxDecoration(color: CustomColors.primaryLight, borderRadius: BorderRadius.circular(6)),
                                      child: Text(
                                        snapshot.data!.job![index].petCare!.socialization.toString() == "1" ? "Socialization" : snapshot.data!.job![index].petCare!.socialization.toString(),
                                        style: TextStyle(
                                          fontSize: 13,
                                          fontFamily: "Poppins",
                                          fontWeight: FontWeight.w500,
                                          color: CustomColors.primaryTextLight,
                                        ),
                                      ),
                                    )
                                  ],
                                  if (snapshot.data!.job![index].petCare!.grooming.toString() == "1") ...[
                                    Container(
                                      margin: const EdgeInsets.symmetric(horizontal: 3),
                                      padding: const EdgeInsets.all(4),
                                      decoration: BoxDecoration(color: CustomColors.primaryLight, borderRadius: BorderRadius.circular(6)),
                                      child: Text(
                                        snapshot.data!.job![index].petCare!.grooming.toString() == "1" ? "Grooming" : snapshot.data!.job![index].petCare!.grooming.toString(),
                                        style: TextStyle(
                                          fontSize: 13,
                                          fontFamily: "Poppins",
                                          fontWeight: FontWeight.w500,
                                          color: CustomColors.primaryTextLight,
                                        ),
                                      ),
                                    ),
                                  ],
                                  if (snapshot.data!.job![index].petCare!.boarding.toString() == "1") ...[
                                    Container(
                                      margin: const EdgeInsets.symmetric(horizontal: 3),
                                      padding: const EdgeInsets.all(4),
                                      decoration: BoxDecoration(color: CustomColors.primaryLight, borderRadius: BorderRadius.circular(6)),
                                      child: Text(
                                        snapshot.data!.job![index].petCare!.boarding.toString() == "1" ? "Boarding" : snapshot.data!.job![index].petCare!.boarding.toString(),
                                        style: TextStyle(
                                          fontSize: 13,
                                          fontFamily: "Poppins",
                                          fontWeight: FontWeight.w500,
                                          color: CustomColors.primaryTextLight,
                                        ),
                                      ),
                                    ),
                                  ],
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    "Job Information",
                    style: TextStyle(
                      fontFamily: "Poppins",
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  JobDetailTile(
                    name: "Date :",
                    title: snapshot.data!.job![index].schedule![index].startingDate.toString(),
                  ),
                  const SizedBox(height: 10),
                  JobDetailTile(
                    name: "Start Time :",
                    title: snapshot.data!.job![index].schedule![index].startingTime.toString(),
                  ),
                  const SizedBox(height: 10),
                  JobDetailTile(
                    name: "Duration :",
                    title: "${snapshot.data!.job![index].schedule![index].duration.toString()} hour",
                  ),
                ],
              );
            },
          );
        } else {
          return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }

  Widget houseKeeping(BuildContext context) {
    return FutureBuilder<HouseKeepingDetailModel>(
      future: futureHouseKeepingDetail,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return ListView.builder(
            itemCount: snapshot.data!.job!.length,
            shrinkWrap: true,
            padding: const EdgeInsets.only(top: 16),
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Job Information",
                    style: TextStyle(
                      fontFamily: "Poppins",
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  JobDetailTile(
                    name: "Job Title",
                    title: snapshot.data!.job![index].jobTitle.toString(),
                  ),
                  const SizedBox(height: 10),
                  JobDetailTile(
                    name: "Job Address",
                    title: snapshot.data!.job![index].address.toString(),
                  ),
                  const SizedBox(height: 10),
                  JobDetailTile(
                    name: "Job Area",
                    title: snapshot.data!.job![index].location.toString(),
                  ),
                  const SizedBox(height: 10),
                  JobDetailTile(
                    name: "Hourly Rate",
                    title: snapshot.data!.job![index].hourlyRate.toString(),
                  ),
                  const SizedBox(height: 10),
                  JobDetailTile(
                    name: "Cleaning Type",
                    title: snapshot.data!.job![index].houseKeeping!.cleaningType.toString() == "null" ? "Not Available" : snapshot.data!.job![index].houseKeeping!.cleaningType.toString(),
                  ),
                  const SizedBox(height: 10),
                  JobDetailTile(
                    name: "Number of Bedrooms",
                    title: snapshot.data!.job![index].houseKeeping!.numberOfBedrooms.toString(),
                  ),
                  const SizedBox(height: 10),
                  JobDetailTile(
                    name: "Number of Bathrooms",
                    title: snapshot.data!.job![index].houseKeeping!.numberOfBathrooms.toString(),
                  ),
                  const SizedBox(height: 10),
                  JobDetailTile(
                    name: "Laundary",
                    title: snapshot.data!.job![index].houseKeeping!.laundry.toString() == "1" ? "Yes" : "No",
                  ),
                  const SizedBox(height: 10),
                  JobDetailTile(
                    name: "Ironing",
                    title: snapshot.data!.job![index].houseKeeping!.ironing.toString() == "1" ? "Yes" : "No",
                  ),
                  const SizedBox(height: 10),
                  JobDetailTile(
                    name: "Other",
                    title: snapshot.data!.job![index].houseKeeping!.other.toString() == "null" ? "Not Available" : snapshot.data!.job![index].houseKeeping!.other.toString(),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    "Job Schedule",
                    style: TextStyle(
                      fontFamily: "Poppins",
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  JobDetailTile(
                    name: "Date :",
                    title: snapshot.data!.job![index].schedule![index].startingDate.toString(),
                  ),
                  const SizedBox(height: 10),
                  JobDetailTile(
                    name: "Start Time :",
                    title: snapshot.data!.job![index].schedule![index].startingTime.toString(),
                  ),
                  const SizedBox(height: 10),
                  JobDetailTile(
                    name: "Duration :",
                    title: "${snapshot.data!.job![index].schedule![index].duration.toString()} hour",
                  ),
                ],
              );
            },
          );
        } else {
          return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }

  Widget childCare(BuildContext context) {
    return FutureBuilder<ChildCareDetailModel>(
      future: futureChildCareDetail,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return ListView.builder(
            itemCount: snapshot.data!.job!.length,
            shrinkWrap: true,
            padding: const EdgeInsets.all(20),
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Job Information",
                    style: TextStyle(
                      fontFamily: "Poppins",
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  JobDetailTile(
                    name: "Job Title",
                    title: snapshot.data!.job![index].jobTitle.toString(),
                  ),
                  const SizedBox(height: 10),
                  JobDetailTile(
                    name: "Job Address",
                    title: snapshot.data!.job![index].address.toString(),
                  ),
                  const SizedBox(height: 10),
                  JobDetailTile(
                    name: "Job Area",
                    title: snapshot.data!.job![index].location.toString(),
                  ),
                  const SizedBox(height: 10),
                  JobDetailTile(
                    name: "Hourly Rate",
                    title: snapshot.data!.job![index].hourlyRate.toString(),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    "Information About Child",
                    style: TextStyle(
                      fontFamily: "Poppins",
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  JobDetailTile(
                    name: "Child Name",
                    title: snapshot.data!.job![index].childinfo![index].name.toString(),
                  ),
                  const SizedBox(height: 10),
                  JobDetailTile(
                    name: "Child Age",
                    title: snapshot.data!.job![index].childinfo![index].age.toString(),
                  ),
                  const SizedBox(height: 10),
                  if (snapshot.data!.job![index].childinfo![index].grade != null) ...[
                    JobDetailTile(
                      name: "Child Grade",
                      title: snapshot.data!.job![index].childinfo![index].grade.toString(),
                    ),
                    const SizedBox(height: 10),
                  ],
                  const SizedBox(
                    height: 10,
                  ),
                  if (snapshot.data!.job![index].learning != null) ...[
                    Container(
                      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                      margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 0),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: CustomColors.white,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            alignment: Alignment.topLeft,
                            // width: 150,
                            child: const Text(
                              "Requires Assistance ",
                              style: TextStyle(
                                // color: CustomColors.primaryColor,
                                fontFamily: "Poppins",
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          Row(
                            children: [
                              Expanded(
                                child: Wrap(
                                  runSpacing: 5.0,
                                  spacing: 5.0,
                                  children: [
                                    if (snapshot.data!.job![index].learning!.assistanceInMath != null) ...[
                                      CustomBadge(
                                        text: snapshot.data!.job![index].learning!.assistanceInMath.toString() == "1" ? "Math" : snapshot.data!.job![index].learning!.assistanceInMath.toString(),
                                      ),
                                    ],
                                    if (snapshot.data!.job![index].learning!.assistanceInEnglish != null) ...[
                                      CustomBadge(
                                        text: snapshot.data!.job![index].learning!.assistanceInEnglish.toString() == "1" ? "English" : snapshot.data!.job![index].learning!.assistanceInEnglish.toString(),
                                      ),
                                    ],
                                    if (snapshot.data!.job![index].learning!.assistanceInScience != null) ...[
                                      CustomBadge(
                                        text: snapshot.data!.job![index].learning!.assistanceInScience.toString() == "1" ? "Science" : snapshot.data!.job![index].learning!.assistanceInScience.toString(),
                                      ),
                                    ],
                                    if (snapshot.data!.job![index].learning!.assistanceInReading != null) ...[
                                      CustomBadge(
                                        text: snapshot.data!.job![index].learning!.assistanceInReading.toString() == "1" ? "Reading" : snapshot.data!.job![index].learning!.assistanceInReading.toString(),
                                      ),
                                    ],
                                    if (snapshot.data!.job![index].learning!.assistanceInOther != null)
                                      Container(
                                        margin: const EdgeInsets.symmetric(horizontal: 3),
                                        padding: const EdgeInsets.all(4),
                                        decoration: BoxDecoration(color: CustomColors.primaryLight, borderRadius: BorderRadius.circular(6)),
                                        child: Text(
                                          snapshot.data!.job![index].learning!.assistanceInOther.toString(),
                                          style: TextStyle(
                                            fontSize: 13,
                                            fontFamily: "Poppins",
                                            fontWeight: FontWeight.w500,
                                            color: CustomColors.primaryTextLight,
                                          ),
                                        ),
                                      ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    if (snapshot.data!.job![index].learning!.learningStyle != null) ...[
                      const SizedBox(height: 10),
                      JobDetailTile(
                        name: "Learning Style",
                        title: snapshot.data!.job![index].learning!.learningStyle.toString(),
                      ),
                      const SizedBox(height: 10),
                      JobDetailTile(
                        name: "Learning Challenge",
                        title: snapshot.data!.job![index].learning!.learningChallenge.toString(),
                      ),
                    ],
                  ],
                  const SizedBox(height: 10),
                  const Text(
                    "Job Schedule",
                    style: TextStyle(
                      fontFamily: "Poppins",
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  JobDetailTile(
                    name: "Date :",
                    title: snapshot.data!.job![index].schedule![index].startingDate.toString(),
                  ),
                  const SizedBox(height: 10),
                  JobDetailTile(
                    name: "Start Time :",
                    title: snapshot.data!.job![index].schedule![index].startingTime.toString(),
                  ),
                  const SizedBox(height: 10),
                  JobDetailTile(
                    name: "Duration :",
                    title: "${snapshot.data!.job![index].schedule![index].duration.toString()} hour",
                  ),
                ],
              );
            },
          );
        } else {
          return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }

  Widget schoolSupport(BuildContext context) {
    return FutureBuilder<SchoolSupportDetailModel>(
      future: futureSchoolSupportDetail,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return ListView.builder(
            itemCount: snapshot.data!.job!.length,
            shrinkWrap: true,
            padding: const EdgeInsets.all(16),
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Job Information",
                    style: TextStyle(
                      fontFamily: "Poppins",
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  JobDetailTile(
                    name: "Job Title",
                    title: snapshot.data!.job![index].jobTitle.toString(),
                  ),
                  const SizedBox(height: 10),
                  JobDetailTile(
                    name: "Job Address",
                    title: snapshot.data!.job![index].address.toString(),
                  ),
                  const SizedBox(height: 10),
                  JobDetailTile(
                    name: "Job Area",
                    title: snapshot.data!.job![index].location.toString(),
                  ),
                  const SizedBox(height: 10),
                  JobDetailTile(
                    name: "Hourly Rate",
                    title: snapshot.data!.job![index].hourlyRate.toString(),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    "Information About Child",
                    style: TextStyle(
                      fontFamily: "Poppins",
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  JobDetailTile(
                    name: "Child Name",
                    title: snapshot.data!.job![index].childinfo![index].name.toString(),
                  ),
                  const SizedBox(height: 10),
                  JobDetailTile(
                    name: "Child Age",
                    title: snapshot.data!.job![index].childinfo![index].age.toString(),
                  ),
                  if (snapshot.data!.job![index].schoolCamp != null) ...[
                    const SizedBox(height: 10),
                    JobDetailTile(
                      name: "Interest for Child",
                      title: snapshot.data!.job![index].schoolCamp!.interestForChild.toString(),
                    ),
                    const SizedBox(height: 10),
                    JobDetailTile(
                      name: "Cost Range For Camp",
                      title: "\$${snapshot.data!.job![index].schoolCamp!.costRange.toString()}",
                    ),
                  ],
                  const SizedBox(height: 10),
                  const SizedBox(height: 10),
                  const Text(
                    "Job schedule",
                    style: TextStyle(
                      fontFamily: "Poppins",
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  JobDetailTile(
                    name: "Date :",
                    title: snapshot.data!.job![index].schedule![index].startingDate.toString(),
                  ),
                  const SizedBox(height: 10),
                  JobDetailTile(
                    name: "Start Time :",
                    title: snapshot.data!.job![index].schedule![index].startingTime.toString(),
                  ),
                  const SizedBox(height: 10),
                  JobDetailTile(
                    name: "Duration :",
                    title: "${snapshot.data!.job![index].schedule![index].duration.toString()} hour",
                  ),
                ],
              );
            },
          );
        } else {
          return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}

class CustomBadge extends StatelessWidget {
  const CustomBadge({super.key, required this.text});
  final String text;
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 3),
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: CustomColors.primaryLight,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 13,
          fontFamily: "Poppins",
          fontWeight: FontWeight.w500,
          color: CustomColors.primaryTextLight,
        ),
      ),
    );
  }
}
