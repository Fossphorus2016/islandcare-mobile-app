// ignore_for_file: use_build_context_synchronously

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
// import 'package:island_app/caregiver/models/child_care_detail-dashbaord_model.dart';
// import 'package:island_app/caregiver/models/house_keeping_detail_dashboard_model.dart';
// import 'package:island_app/caregiver/models/pet_care_detail_dashboard_model.dart';
// import 'package:island_app/caregiver/models/school_support_detail_dashboard.dart';
// import 'package:island_app/caregiver/models/senior_care_detail_dashboard_model.dart';
import 'package:island_app/caregiver/utils/profile_provider.dart';
import 'package:island_app/carereceiver/models/child_care_model.dart';
import 'package:island_app/carereceiver/models/house_keeping_model.dart';
import 'package:island_app/carereceiver/models/pet_care_model.dart';
import 'package:island_app/carereceiver/models/school_support_model.dart';
import 'package:island_app/utils/app_url.dart';
import 'package:island_app/widgets/assistance_container.dart';
import 'package:island_app/widgets/job_detail_tile.dart';
import 'package:island_app/widgets/job_info_container.dart';
import 'package:island_app/widgets/job_schedule_container.dart';
import 'package:provider/provider.dart';
import 'package:island_app/carereceiver/models/senior_care_model.dart';
import 'package:island_app/carereceiver/utils/colors.dart';
import 'package:island_app/utils/utils.dart';

class ServiceProviderJobsDetail extends StatefulWidget {
  final String? id;
  final String? service;
  const ServiceProviderJobsDetail({
    super.key,
    this.id,
    this.service,
  });

  @override
  State<ServiceProviderJobsDetail> createState() => _ServiceProviderJobsDetailState();
}

class _ServiceProviderJobsDetailState extends State<ServiceProviderJobsDetail> {
  // Get Detail jobs
  // late Future<SeniorCareDetailModel> futureSeniorCareDetail;
  // late Future<PetCareDetailModel> futurePetCareDetail;
  // late Future<HouseKeepingDetailModel> futureHouseKeepingDetail;
  // late Future<ChildCareDetailModel> futureChildCareDetail;
  // late Future<SchoolSupportDetailModel> futureSchoolSupportDetail;
  // Future<SeniorCareDetailModel> fetchSeniorCareDetailModel() async {
  //   var token = await getUserToken();
  //   final response = await Dio().get(
  //     '${CareGiverUrl.serviceProviderJobDetail}/${widget.id}',
  //     options: Options(
  //       headers: {
  //         'Authorization': 'Bearer $token',
  //         'Accept': 'application/json',
  //       },
  //     ),
  //   );
  //   if (response.statusCode == 200) {
  //     return SeniorCareDetailModel.fromJson(response.data);
  //   } else {
  //     throw Exception(
  //       customErrorSnackBar(
  //         context,
  //         'Failed to load Services Model',
  //       ),
  //     );
  //   }
  // }

  // Future<PetCareDetailModel> fetchPetCareDetailModel() async {
  //   var token = await getUserToken();
  //   final response = await Dio().get(
  //     '${CareGiverUrl.serviceProviderJobDetail}/${widget.id}',
  //     options: Options(
  //       headers: {
  //         'Authorization': 'Bearer $token',
  //         'Accept': 'application/json',
  //       },
  //     ),
  //   );
  //   if (response.statusCode == 200) {
  //     return PetCareDetailModel.fromJson(response.data);
  //   } else {
  //     throw Exception(
  //       customErrorSnackBar(
  //         context,
  //         'Failed to load Services Model',
  //       ),
  //     );
  //   }
  // }

  // Future<HouseKeepingDetailModel> fetchHouseKeepingDetailModel() async {
  //   var token = await getUserToken();
  //   final response = await Dio().get(
  //     '${CareGiverUrl.serviceProviderJobDetail}/${widget.id}',
  //     options: Options(
  //       headers: {
  //         'Authorization': 'Bearer $token',
  //         'Accept': 'application/json',
  //       },
  //     ),
  //   );
  //   if (response.statusCode == 200) {
  //     return HouseKeepingDetailModel.fromJson(response.data);
  //   } else {
  //     throw Exception(
  //       customErrorSnackBar(
  //         context,
  //         'Failed to load Services Model',
  //       ),
  //     );
  //   }
  // }

  // Future<ChildCareDetailModel> fetchChildCareDetailModel() async {
  //   var token = await getUserToken();
  //   final response = await Dio().get(
  //     '${CareGiverUrl.serviceProviderJobDetail}/${widget.id}',
  //     options: Options(
  //       headers: {
  //         'Authorization': 'Bearer $token',
  //         'Accept': 'application/json',
  //       },
  //     ),
  //   );
  //   if (response.statusCode == 200) {
  //     return ChildCareDetailModel.fromJson(response.data);
  //   } else {
  //     throw Exception(
  //       customErrorSnackBar(
  //         context,
  //         'Failed to load Services Model',
  //       ),
  //     );
  //   }
  // }

  // Future<SchoolSupportDetailModel> fetchSchoolSupportDetailModel() async {
  //   var token = await getUserToken();
  //   final response = await Dio().get(
  //     '${CareGiverUrl.serviceProviderJobDetail}/${widget.id}',
  //     options: Options(
  //       headers: {
  //         'Authorization': 'Bearer $token',
  //         'Accept': 'application/json',
  //       },
  //     ),
  //   );
  //   if (response.statusCode == 200) {
  //     return SchoolSupportDetailModel.fromJson(response.data);
  //   } else {
  //     throw Exception(
  //       customErrorSnackBar(
  //         context,
  //         'Failed to load Services Model',
  //       ),
  //     );
  //   }
  // }
  SeniorCareDetailModel? futureSeniorCareDetailDashboard;
  SchoolSupportDetailModel? futureSchoolSupportDetailDashboard;
  ChildCareDetailModel? futureChildCareDetailDashboard;
  HouseKeepingDetailModel? futureHouseKeepingDetailDashboard;
  PetCareDetailModel? futurePetCareDetailDashboard;
  String serviceName = '';
  bool? noDataFound;
  fetchJobDetail() async {
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
      // print(response.data['job_detail'][0]['service']);
      if (response.data['job_detail'] != null) {
        serviceName = response.data['job_detail'][0]['service']['name'];
        if (serviceName.toLowerCase() == "senior care") {
          futureSeniorCareDetailDashboard = SeniorCareDetailModel.fromJson(response.data);
        } else if (serviceName.toLowerCase() == "pet care") {
          futurePetCareDetailDashboard = PetCareDetailModel.fromJson(response.data);
        } else if (serviceName.toLowerCase() == "house keeping") {
          futureHouseKeepingDetailDashboard = HouseKeepingDetailModel.fromJson(response.data);
        } else if (serviceName.toLowerCase() == "school support") {
          futureSchoolSupportDetailDashboard = SchoolSupportDetailModel.fromJson(response.data);
        } else if (serviceName.toLowerCase() == "child care") {
          futureChildCareDetailDashboard = ChildCareDetailModel.fromJson(response.data);
        } else {
          noDataFound = true;
        }
        setState(() {});
      }
      // return PetCareDetailDashboardModel.fromJson(response.data);
    } else {
      throw Exception(
        'Failed to load Service Provider Dashboard',
      );
    }
  }

  @override
  void initState() {
    super.initState();
    fetchJobDetail();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: CustomColors.loginBg,
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
              if (noDataFound == true) ...[
                const Text("NO Data Found"),
              ] else if (serviceName.toLowerCase() == "senior care") ...[
                // service id 1
                seniorCare(context),
              ] else if (serviceName.toLowerCase() == "pet care") ...[
                // service id 2
                petCare(context),
              ] else if (serviceName.toLowerCase() == "house keeping") ...[
                // service id 3
                houseKeeping(context),
              ] else if (serviceName.toLowerCase() == "school support") ...[
                // Service Id 4
                schoolSupport(context),
              ] else if (serviceName.toLowerCase() == "child care") ...[
                // Service Id 5
                childCare(context),
              ] else ...[
                const SizedBox(height: 50),
                Center(child: CircularProgressIndicator(color: ServiceRecieverColor.primaryColor))
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget seniorCare(BuildContext context) {
    // return FutureBuilder<SeniorCareDetailModel>(
    //   future: futureSeniorCareDetail,
    //   builder: (context, snapshot) {
    //     if (snapshot.hasData) {
    return ListView.builder(
      itemCount: futureSeniorCareDetailDashboard!.job!.length,
      shrinkWrap: true,
      padding: const EdgeInsets.all(20),
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        var job = futureSeniorCareDetailDashboard!.job![index];
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
              title: job.jobTitle.toString(),
            ),
            const SizedBox(height: 10),
            JobDetailTile(
              name: "Job Address",
              title: job.address.toString(),
            ),
            const SizedBox(height: 10),
            JobDetailTile(
              name: "Job Area",
              title: job.location.toString(),
            ),
            const SizedBox(height: 10),
            JobDetailTile(
              name: "Hourly Rate",
              title: job.hourlyRate.toString(),
            ),
            const SizedBox(height: 10),
            JobDetailTile(
              name: "Senior Initials",
              title: job.seniorCare!.seniorName.toString(),
            ),
            const SizedBox(height: 10),
            JobDetailTile(
              name: "Date Of Birth",
              title: job.seniorCare!.dob.toString(),
            ),
            const SizedBox(height: 10),
            JobDetailTile(
              name: "Medical Condition",
              title: job.seniorCare!.medicalCondition != null ? "Not Available" : job.seniorCare!.medicalCondition.toString(),
            ),
            const SizedBox(height: 10),
            AssistanceContainer(
              dd: [
                if (job.seniorCare!.bathing.toString() == "1") ...[
                  job.seniorCare!.bathing.toString() == "1" ? "bathing" : job.seniorCare!.bathing.toString(),
                ],
                if (job.seniorCare!.dressing.toString() == "1") ...[
                  job.seniorCare!.dressing.toString() == "1" ? "dressing" : job.seniorCare!.dressing.toString(),
                ],
                if (job.seniorCare!.feeding.toString() == "1") ...[
                  job.seniorCare!.feeding.toString() == "1" ? "feeding" : job.seniorCare!.feeding.toString(),
                ],
                if (job.seniorCare!.mealPreparation.toString() == "1") ...[
                  job.seniorCare!.mealPreparation.toString() == "1" ? "mealPreparation" : job.seniorCare!.mealPreparation.toString(),
                ],
                if (job.seniorCare!.groceryShopping.toString() == "1") ...[
                  job.seniorCare!.groceryShopping.toString() == "1" ? "groceryShopping" : job.seniorCare!.groceryShopping.toString(),
                ],
                if (job.seniorCare!.walking.toString() == "1") ...[
                  job.seniorCare!.walking.toString() == "1" ? "walking" : job.seniorCare!.walking.toString(),
                ],
                if (job.seniorCare!.bedTransfer.toString() == "1") ...[
                  job.seniorCare!.bedTransfer.toString() == "1" ? "bedTransfer" : job.seniorCare!.bedTransfer.toString(),
                ],
                if (job.seniorCare!.lightCleaning.toString() == "1") ...[
                  job.seniorCare!.lightCleaning.toString() == "1" ? "lightCleaning" : job.seniorCare!.lightCleaning.toString(),
                ],
                if (job.seniorCare!.companionship.toString() == "1") ...[
                  job.seniorCare!.companionship.toString() == "1" ? "companionship" : job.seniorCare!.companionship.toString(),
                ],
                if (job.seniorCare!.medicationAdministration.toString() == "1") ...[
                  job.seniorCare!.medicationAdministration.toString() == "1" ? "medicationAdministration" : job.seniorCare!.medicationAdministration.toString(),
                ],
                if (job.seniorCare!.dressingWoundCare.toString() == "1") ...[
                  job.seniorCare!.dressingWoundCare.toString() == "1" ? "dressingWoundCare" : job.seniorCare!.dressingWoundCare.toString(),
                ],
                if (job.seniorCare!.bloodPressureMonetoring.toString() == "1") ...[
                  job.seniorCare!.bloodPressureMonetoring.toString() == "1" ? "bloodPressureMonetoring" : job.seniorCare!.bloodPressureMonetoring.toString(),
                ],
                if (job.seniorCare!.bloodSugarMonetoring.toString() == "1") ...[
                  job.seniorCare!.bloodSugarMonetoring.toString() == "1" ? "bloodSugarMonetoring" : job.seniorCare!.bloodSugarMonetoring.toString(),
                ],
                if (job.seniorCare!.groomingHairAndNailTrimming.toString() == "1") ...[
                  job.seniorCare!.groomingHairAndNailTrimming.toString() == "1" ? "groomingHairAndNailTrimming" : job.seniorCare!.groomingHairAndNailTrimming.toString(),
                ],
              ],
            ),
            const SizedBox(height: 10),
            if (job.schedule!.isNotEmpty) ...[
              JobScheduleContainer(
                data: job.schedule,
              ),
            ],
          ],
        );
      },
    );
    //     } else {
    //       return const Center(child: CircularProgressIndicator());
    //     }
    //   },
    // );
  }

  Widget petCare(BuildContext context) {
    // return FutureBuilder<PetCareDetailModel>(
    //   future: futurePetCareDetail,
    //   builder: (context, snapshot) {
    //     if (snapshot.hasData) {
    return ListView.builder(
      itemCount: futurePetCareDetailDashboard!.job!.length,
      shrinkWrap: true,
      padding: const EdgeInsets.all(20),
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        var job = futurePetCareDetailDashboard!.job![index];
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            JobInfoContainer(
              title: job.jobTitle.toString(),
              address: job.address.toString(),
              location: job.location.toString(),
              hourlyRate: job.hourlyRate.toString(),
            ),
            const SizedBox(height: 10),
            JobDetailTile(
              name: "Pet Type",
              title: job.petCare!.petType.toString(),
            ),
            const SizedBox(height: 10),
            JobDetailTile(
              name: "Number of Pets",
              title: job.petCare!.numberOfPets.toString(),
            ),
            const SizedBox(height: 10),
            JobDetailTile(
              name: "Pet Breed",
              title: job.petCare!.petBreed.toString(),
            ),
            const SizedBox(height: 10),
            JobDetailTile(
              name: "Temperament",
              title: job.petCare!.temperament.toString(),
            ),
            const SizedBox(height: 10),
            JobDetailTile(
              name: "Additional Info",
              title: job.additionalInfo ?? "",
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
                            if (job.petCare!.walking.toString() == "1") ...[
                              Container(
                                margin: const EdgeInsets.symmetric(horizontal: 3),
                                padding: const EdgeInsets.all(4),
                                decoration: BoxDecoration(color: CustomColors.primaryLight, borderRadius: BorderRadius.circular(6)),
                                child: Text(
                                  job.petCare!.walking.toString() == "1" ? "Walking" : job.petCare!.walking.toString(),
                                  style: TextStyle(
                                    fontSize: 13,
                                    fontFamily: "Poppins",
                                    fontWeight: FontWeight.w500,
                                    color: CustomColors.primaryTextLight,
                                  ),
                                ),
                              ),
                            ],
                            if (job.petCare!.daycare.toString() == "1") ...[
                              Container(
                                margin: const EdgeInsets.symmetric(horizontal: 3),
                                padding: const EdgeInsets.all(4),
                                decoration: BoxDecoration(color: CustomColors.primaryLight, borderRadius: BorderRadius.circular(6)),
                                child: Text(
                                  job.petCare!.daycare.toString() == "1" ? "Day Care" : job.petCare!.daycare.toString(),
                                  style: TextStyle(
                                    fontSize: 13,
                                    fontFamily: "Poppins",
                                    fontWeight: FontWeight.w500,
                                    color: CustomColors.primaryTextLight,
                                  ),
                                ),
                              ),
                            ],
                            if (job.petCare!.feeding.toString() == "1") ...[
                              Container(
                                margin: const EdgeInsets.symmetric(horizontal: 3),
                                padding: const EdgeInsets.all(4),
                                decoration: BoxDecoration(color: CustomColors.primaryLight, borderRadius: BorderRadius.circular(6)),
                                child: Text(
                                  job.petCare!.feeding.toString() == "1" ? "Feeding" : job.petCare!.feeding.toString(),
                                  style: TextStyle(
                                    fontSize: 13,
                                    fontFamily: "Poppins",
                                    fontWeight: FontWeight.w500,
                                    color: CustomColors.primaryTextLight,
                                  ),
                                ),
                              )
                            ],
                            if (job.petCare!.socialization.toString() == "1") ...[
                              Container(
                                margin: const EdgeInsets.symmetric(horizontal: 3),
                                padding: const EdgeInsets.all(4),
                                decoration: BoxDecoration(color: CustomColors.primaryLight, borderRadius: BorderRadius.circular(6)),
                                child: Text(
                                  job.petCare!.socialization.toString() == "1" ? "Socialization" : job.petCare!.socialization.toString(),
                                  style: TextStyle(
                                    fontSize: 13,
                                    fontFamily: "Poppins",
                                    fontWeight: FontWeight.w500,
                                    color: CustomColors.primaryTextLight,
                                  ),
                                ),
                              )
                            ],
                            if (job.petCare!.grooming.toString() == "1") ...[
                              Container(
                                margin: const EdgeInsets.symmetric(horizontal: 3),
                                padding: const EdgeInsets.all(4),
                                decoration: BoxDecoration(color: CustomColors.primaryLight, borderRadius: BorderRadius.circular(6)),
                                child: Text(
                                  job.petCare!.grooming.toString() == "1" ? "Grooming" : job.petCare!.grooming.toString(),
                                  style: TextStyle(
                                    fontSize: 13,
                                    fontFamily: "Poppins",
                                    fontWeight: FontWeight.w500,
                                    color: CustomColors.primaryTextLight,
                                  ),
                                ),
                              ),
                            ],
                            if (job.petCare!.boarding.toString() == "1") ...[
                              Container(
                                margin: const EdgeInsets.symmetric(horizontal: 3),
                                padding: const EdgeInsets.all(4),
                                decoration: BoxDecoration(color: CustomColors.primaryLight, borderRadius: BorderRadius.circular(6)),
                                child: Text(
                                  job.petCare!.boarding.toString() == "1" ? "Boarding" : job.petCare!.boarding.toString(),
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
              "Job Schedule",
              style: TextStyle(
                fontFamily: "Poppins",
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            // const SizedBox(height: 10),
            // JobDetailTile(
            //   name: "Date :",
            //   title: job.schedule![index].startingDate.toString(),
            // ),
            // const SizedBox(height: 10),
            // JobDetailTile(
            //   name: "Start Time :",
            //   title: job.schedule![index].startingTime.toString(),
            // ),
            // const SizedBox(height: 10),
            // JobDetailTile(
            //   name: "Duration :",
            //   title: "${job.schedule![index].duration.toString()} hour",
            // ),
            if (job.schedule!.isNotEmpty) ...[
              JobScheduleContainer(
                data: job.schedule,
              ),
            ],
          ],
        );
      },
    );
    //     } else {
    //       return const Center(child: CircularProgressIndicator());
    //     }
    //   },
    // );
  }

  Widget houseKeeping(BuildContext context) {
    // return FutureBuilder<HouseKeepingDetailModel>(
    //   future: futureHouseKeepingDetail,
    //   builder: (context, snapshot) {
    //     if (snapshot.hasData) {
    return ListView.builder(
      itemCount: futureHouseKeepingDetailDashboard!.job!.length,
      shrinkWrap: true,
      padding: const EdgeInsets.all(20),
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        var job = futureHouseKeepingDetailDashboard!.job![index];
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            JobInfoContainer(
              title: job.jobTitle.toString(),
              address: job.address.toString(),
              location: job.location.toString(),
              hourlyRate: job.hourlyRate.toString(),
            ),
            const SizedBox(height: 10),
            JobDetailTile(
              name: "Cleaning Type",
              title: job.houseKeeping!.cleaningType.toString() == "null" ? "Not Available" : job.houseKeeping!.cleaningType.toString(),
            ),
            const SizedBox(height: 10),
            JobDetailTile(
              name: "Number of Bedrooms",
              title: job.houseKeeping!.numberOfBedrooms.toString(),
            ),
            const SizedBox(height: 10),
            JobDetailTile(
              name: "Number of Bathrooms",
              title: job.houseKeeping!.numberOfBathrooms.toString(),
            ),
            const SizedBox(height: 10),
            JobDetailTile(
              name: "Laundary",
              title: job.houseKeeping!.laundry.toString() == "1" ? "Yes" : "No",
            ),
            const SizedBox(height: 10),
            JobDetailTile(
              name: "Ironing",
              title: job.houseKeeping!.ironing.toString() == "1" ? "Yes" : "No",
            ),
            const SizedBox(height: 10),
            JobDetailTile(
              name: "Other",
              title: job.houseKeeping!.other.toString() == "null" ? "Not Available" : job.houseKeeping!.other.toString(),
            ),
            const SizedBox(height: 10),
            JobDetailTile(
              name: "Additional Info",
              title: job.additionalInfo ?? "",
            ),
            JobScheduleContainer(
              data: job.schedule,
            ),
          ],
        );
      },
    );
    //     } else {
    //       return const Center(child: CircularProgressIndicator());
    //     }
    //   },
    // );
  }

  Widget childCare(BuildContext context) {
    // return FutureBuilder<ChildCareDetailModel>(
    //   future: futureChildCareDetail,
    //   builder: (context, snapshot) {
    //     if (snapshot.hasData) {
    return ListView.builder(
      itemCount: futureChildCareDetailDashboard!.job!.length,
      shrinkWrap: true,
      padding: const EdgeInsets.all(20),
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        var job = futureChildCareDetailDashboard!.job![index];
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            JobInfoContainer(
              title: job.jobTitle.toString(),
              address: job.address.toString(),
              location: job.location.toString(),
              hourlyRate: "\$${job.hourlyRate.toString()}/hour",
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
            for (var i = 0; i < job.childinfo!.length; i++) ...[
              if (job.childinfo!.length > 1) ...[
                const SizedBox(height: 10),
                Text(
                  "Child ${i + 1}",
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 10),
              ],
              JobDetailTile(
                name: "Child Initials",
                title: job.childinfo![i].name.toString(),
              ),
              const SizedBox(height: 10),
              JobDetailTile(
                name: "Child Age",
                title: job.childinfo![i].age.toString(),
              ),
              const SizedBox(height: 10),
            ],
            if (job.schoolCamp != null) ...[
              JobDetailTile(
                name: "Interest for Child",
                title: job.schoolCamp!.interestForChild.toString(),
              ),
              const SizedBox(height: 10),
              JobDetailTile(
                name: "Cost Range For Camp",
                title: job.schoolCamp!.costRange.toString(),
              ),
              const SizedBox(height: 10),
            ],
            const SizedBox(height: 10),
            const SizedBox(height: 10),
            if (job.schedule!.isNotEmpty) ...[
              JobScheduleContainer(
                data: job.schedule,
              ),
            ],
          ],
        );
      },
    );
    //     } else {
    //       return const Center(child: CircularProgressIndicator());
    //     }
    //   },
    // );
  }

  Widget schoolSupport(BuildContext context) {
    // return FutureBuilder<SchoolSupportDetailModel>(
    //   future: futureSchoolSupportDetail,
    //   builder: (context, snapshot) {
    //     if (snapshot.hasData) {
    return ListView.builder(
      itemCount: futureSchoolSupportDetailDashboard!.job!.length,
      shrinkWrap: true,
      padding: const EdgeInsets.all(16),
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        var job = futureSchoolSupportDetailDashboard!.job![index];
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            JobInfoContainer(
              title: job.jobTitle.toString(),
              address: job.address.toString(),
              location: job.location.toString(),
              hourlyRate: "\$${job.hourlyRate.toString()}/hour",
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
            for (var i = 0; i < job.childinfo!.length; i++) ...[
              if (job.childinfo!.length > 1) ...[
                const SizedBox(height: 10),
                Text(
                  "Child ${i + 1}",
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 10),
              ],
              JobDetailTile(
                name: "Child Initials",
                title: job.childinfo![i].name.toString(),
              ),
              const SizedBox(height: 10),
              JobDetailTile(
                name: "Child Age",
                title: job.childinfo![i].age.toString(),
              ),
              const SizedBox(height: 10),
              JobDetailTile(
                name: "Child Grade",
                title: job.childinfo![i].grade.toString(),
              ),
              const SizedBox(height: 10),
            ],
            // if (job.schoolCamp != null) ...[
            //   const SizedBox(height: 10),
            //   JobDetailTile(
            //     name: "Interest for Child",
            //     title: job.schoolCamp!.interestForChild.toString(),
            //   ),
            //   const SizedBox(height: 10),
            //   JobDetailTile(
            //     name: "Cost Range For Camp",
            //     title: "\$${job.schoolCamp!.costRange.toString()}",
            //   ),
            // ],
            const SizedBox(height: 10),
            if (job.learning != null) ...[
              AssistanceContainer(
                dd: [
                  if (job.learning!.assistanceInReading == 1) ...["Reading"],
                  if (job.learning!.assistanceInEnglish == 1) ...["English"],
                  if (job.learning!.assistanceInMath == 1) ...["Math"],
                  if (job.learning!.assistanceInScience == 1) ...["Science"],
                  if (job.learning!.assistanceInOther != null) ...[job.learning!.assistanceInOther.toString()],
                ],
              ),
              const SizedBox(height: 10),
            ],
            if (job.learning != null && job.learning!.learningStyle != null) ...[
              JobDetailTile(
                name: "Learning Style",
                title: job.learning!.learningStyle.toString(),
              ),
              const SizedBox(height: 10),
            ],
            if (job.learning != null && job.learning!.learningChallenge != null) ...[
              JobDetailTile(
                name: "Learning Challenge",
                title: job.learning!.learningChallenge.toString(),
              ),
              const SizedBox(height: 10),
            ],
            if (job.additionalInfo != null) ...[
              JobDetailTile(
                name: "Additional Info",
                title: job.additionalInfo ?? "",
              ),
              const SizedBox(height: 10),
            ],
            if (job.schedule!.isNotEmpty) ...[
              JobScheduleContainer(
                data: job.schedule,
              ),
            ],
          ],
        );
      },
    );
    //     } else {
    //       return const Center(child: CircularProgressIndicator());
    //     }
    //   },
    // );
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
