// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:island_app/caregiver/models/child_care_detail-dashbaord_model.dart';
import 'package:island_app/caregiver/models/house_keeping_detail_dashboard_model.dart';
import 'package:island_app/caregiver/models/pet_care_detail_dashboard_model.dart';
import 'package:island_app/caregiver/models/school_support_detail_dashboard.dart';
import 'package:island_app/utils/app_colors.dart';
import 'package:island_app/utils/app_url.dart';
import 'package:island_app/utils/functions.dart';
import 'package:island_app/utils/http_handlers.dart';
import 'package:island_app/widgets/assistance_container.dart';
import 'package:island_app/widgets/job_detail_tile.dart';
import 'package:island_app/widgets/job_info_container.dart';
import 'package:island_app/widgets/job_schedule_container.dart';
import 'package:island_app/widgets/loading_button.dart';
import 'package:island_app/caregiver/models/senior_care_detail_dashboard_model.dart';
import 'package:island_app/carereceiver/utils/colors.dart';

class JobDetailGiver extends StatefulWidget {
  final String? id;
  final String? serviceId;
  const JobDetailGiver({
    super.key,
    this.id,
    required this.serviceId,
  });

  @override
  State<JobDetailGiver> createState() => _JobDetailGiverState();
}

class _JobDetailGiverState extends State<JobDetailGiver> {
  List childInfo = [];
  List scheduleInfo = [];

  Future<void> jobApply() async {
    var token = await getToken();
    final response = await putRequesthandler(
      url: "${CareGiverUrl.serviceProviderJobApply}/${widget.id}",
      token: token,
    );
    if (response != null && response.statusCode == 200) {
      showSuccessToast("Job applied successfully");
    } else {
      showErrorToast("Server Error");
    }
  }

  SeniorCareDetailDashboardModel? futureSeniorCareDetailDashboard;
  SchoolSupportDetailDashboardModel? futureSchoolSupportDetailDashboard;
  ChildCareDetailDashboardModel? futureChildCareDetailDashboard;
  HouseKeepingDetailDashboardModel? futureHouseKeepingDetailDashboard;
  PetCareDetailDashboardModel? futurePetCareDetailDashboard;
  String serviceName = '';
  bool? noDataFound;
  fetchJobDetail() async {
    var token = await getToken();
    final response = await getRequesthandler(
      url: '${CareGiverUrl.serviceProviderJobDetail}/${widget.id}',
      token: token,
    );
    if (response != null && response.statusCode == 200) {
      if (response.data['job_detail'] != null) {
        serviceName = response.data['job_detail'][0]['service']['name'];
        if (serviceName.toLowerCase() == "senior care") {
          futureSeniorCareDetailDashboard = SeniorCareDetailDashboardModel.fromJson(response.data);
        } else if (serviceName.toLowerCase() == "pet care") {
          futurePetCareDetailDashboard = PetCareDetailDashboardModel.fromJson(response.data);
        } else if (serviceName.toLowerCase() == "house keeping") {
          futureHouseKeepingDetailDashboard = HouseKeepingDetailDashboardModel.fromJson(response.data);
        } else if (serviceName.toLowerCase() == "school support") {
          futureSchoolSupportDetailDashboard = SchoolSupportDetailDashboardModel.fromJson(response.data);
        } else if (serviceName.toLowerCase() == "child care") {
          futureChildCareDetailDashboard = ChildCareDetailDashboardModel.fromJson(response.data);
        } else {
          noDataFound = true;
        }
        setState(() {});
      }
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
            if (noDataFound == true) ...[
              const Text("NO Data Found"),
            ] else if (serviceName.toLowerCase() == "senior care") ...[
              // service id 1
              serviceSeniorCare(context),
            ] else if (serviceName.toLowerCase() == "pet care") ...[
              // service id 2
              servicePetCare(context),
            ] else if (serviceName.toLowerCase() == "house keeping") ...[
              // service id 3
              serviceHouseKeeping(context),
            ] else if (serviceName.toLowerCase() == "school support") ...[
              // Service Id 4
              serviceSchoolSupport(context),
            ] else if (serviceName.toLowerCase() == "child care") ...[
              // Service Id 5
              serviceChildCare(context),
            ] else ...[
              const SizedBox(height: 50),
              Center(child: CircularProgressIndicator(color: ServiceRecieverColor.primaryColor))
            ],
          ],
        ),
      ),
    );
  }

  LoadingButton applyButton(bool isApplied) {
    return LoadingButton(
      title: isApplied ? "Apply Now" : "Applied",
      height: 60,
      backgroundColor: isApplied ? ServiceGiverColor.redButton : ServiceGiverColor.redButtonLigth,
      textStyle: TextStyle(
        color: CustomColors.white,
        fontFamily: "Poppins",
        fontSize: 16,
        fontStyle: FontStyle.normal,
        fontWeight: FontWeight.w900,
      ),
      onPressed: () async {
        if (isApplied) {
          await jobApply();
          return true;
        } else {
          showSuccessToast("Already Applied");
          return true;
        }
      },
    );
  }

// Done
  Widget serviceSeniorCare(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      scrollDirection: Axis.vertical,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.all(20),
      itemCount: futureSeniorCareDetailDashboard!.jobDetail!.length,
      itemBuilder: (BuildContext context, int index) {
        var item = futureSeniorCareDetailDashboard!.jobDetail![index];
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            JobInfoContainer(
              title: item.jobTitle.toString(),
              address: item.address.toString(),
              location: item.location.toString(),
              hourlyRate: "\$${item.hourlyRate.toString()}/hour",
            ),
            const SizedBox(height: 10),
            JobDetailTile(
              name: "Senior Initials",
              title: item.seniorCare!.seniorName.toString(),
            ),
            const SizedBox(height: 10),
            JobDetailTile(
              name: "Date of Birth",
              title: item.seniorCare!.dob.toString(),
            ),
            const SizedBox(height: 10),
            JobDetailTile(
              name: "Medical Condition",
              title: item.seniorCare!.medicalCondition.toString(),
            ),
            const SizedBox(height: 10),
            JobDetailTile(
              name: "Additional Info",
              title: item.additionalInfo ?? "",
            ),
            const SizedBox(height: 10),
            // Assistancce Container
            if (item.seniorCare != null) ...[
              AssistanceContainer(
                dd: [
                  if (item.seniorCare!.bathing.toString() == "1") ...[
                    item.seniorCare!.bathing.toString() == "1" ? "bathing" : item.seniorCare!.bathing.toString(),
                  ],
                  if (item.seniorCare!.dressing.toString() == "1") ...[
                    item.seniorCare!.dressing.toString() == "1" ? "dressing" : item.seniorCare!.dressing.toString(),
                  ],
                  if (item.seniorCare!.feeding.toString() == "1") ...[
                    item.seniorCare!.feeding.toString() == "1" ? "feeding" : item.seniorCare!.feeding.toString(),
                  ],
                  if (item.seniorCare!.mealPreparation.toString() == "1") ...[
                    item.seniorCare!.mealPreparation.toString() == "1" ? "mealPreparation" : item.seniorCare!.mealPreparation.toString(),
                  ],
                  if (item.seniorCare!.groceryShopping.toString() == "1") ...[
                    item.seniorCare!.groceryShopping.toString() == "1" ? "groceryShopping" : item.seniorCare!.groceryShopping.toString(),
                  ],
                  if (item.seniorCare!.walking.toString() == "1") ...[
                    item.seniorCare!.walking.toString() == "1" ? "walking" : item.seniorCare!.walking.toString(),
                  ],
                  if (item.seniorCare!.bedTransfer.toString() == "1") ...[
                    item.seniorCare!.bedTransfer.toString() == "1" ? "bedTransfer" : item.seniorCare!.bedTransfer.toString(),
                  ],
                  if (item.seniorCare!.lightCleaning.toString() == "1") ...[
                    item.seniorCare!.lightCleaning.toString() == "1" ? "lightCleaning" : item.seniorCare!.lightCleaning.toString(),
                  ],
                  if (item.seniorCare!.companionship.toString() == "1") ...[
                    item.seniorCare!.companionship.toString() == "1" ? "companionship" : item.seniorCare!.companionship.toString(),
                  ],
                  if (item.seniorCare!.medicationAdministration.toString() == "1") ...[
                    item.seniorCare!.medicationAdministration.toString() == "1" ? "medicationAdministration" : item.seniorCare!.medicationAdministration.toString(),
                  ],
                  if (item.seniorCare!.dressingWoundCare.toString() == "1") ...[
                    item.seniorCare!.dressingWoundCare.toString() == "1" ? "dressingWoundCare" : item.seniorCare!.dressingWoundCare.toString(),
                  ],
                  if (item.seniorCare!.bloodPressureMonetoring.toString() == "1") ...[
                    item.seniorCare!.bloodPressureMonetoring.toString() == "1" ? "bloodPressureMonetoring" : item.seniorCare!.bloodPressureMonetoring.toString(),
                  ],
                  if (item.seniorCare!.bloodSugarMonetoring.toString() == "1") ...[
                    item.seniorCare!.bloodSugarMonetoring.toString() == "1" ? "bloodSugarMonetoring" : item.seniorCare!.bloodSugarMonetoring.toString(),
                  ],
                  if (item.seniorCare!.groomingHairAndNailTrimming.toString() == "1") ...[
                    item.seniorCare!.groomingHairAndNailTrimming.toString() == "1" ? "groomingHairAndNailTrimming" : item.seniorCare!.groomingHairAndNailTrimming.toString(),
                  ],
                ],
              ),
            ],

            const SizedBox(height: 10),
            if (item.schedule!.isNotEmpty) ...[
              JobScheduleContainer(
                data: item.schedule,
              ),
            ],
            const SizedBox(height: 20),
            applyButton(futureSeniorCareDetailDashboard!.isApplied == 0)
          ],
        );
      },
    );
  }

  Widget serviceSchoolSupport(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      scrollDirection: Axis.vertical,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.all(20),
      itemCount: futureSchoolSupportDetailDashboard!.jobDetail!.length,
      itemBuilder: (BuildContext context, int index) {
        var item = futureSchoolSupportDetailDashboard!.jobDetail![index];
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            JobInfoContainer(
              title: item.jobTitle.toString(),
              address: item.address.toString(),
              location: item.location.toString(),
              hourlyRate: "\$${item.hourlyRate.toString()}/hour",
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
            for (var i = 0; i < item.childinfo!.length; i++) ...[
              if (item.childinfo!.length > 1) ...[
                const SizedBox(height: 10),
                Text(
                  "Child ${i + 1}",
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 10),
              ],
              JobDetailTile(
                name: "Child Initials",
                title: item.childinfo![i].name.toString(),
              ),
              const SizedBox(height: 10),
              JobDetailTile(
                name: "Child Age",
                title: item.childinfo![i].age.toString(),
              ),
              const SizedBox(height: 10),
              JobDetailTile(
                name: "Child Grade",
                title: item.childinfo![i].grade.toString(),
              ),
              const SizedBox(height: 10),
            ],
            if (item.learning != null) ...[
              const SizedBox(height: 10),
              AssistanceContainer(
                dd: [
                  if (item.learning!.assistanceInReading == 1) ...["Reading"],
                  if (item.learning!.assistanceInEnglish == 1) ...["English"],
                  if (item.learning!.assistanceInMath == 1) ...["Math"],
                  if (item.learning!.assistanceInScience == 1) ...["Science"],
                  if (item.learning!.assistanceInOther != null) ...[item.learning!.assistanceInOther.toString()],
                ],
              ),
            ],
            const SizedBox(height: 10),
            if (item.learning != null && item.learning!.learningStyle != null) ...[
              JobDetailTile(
                name: "Learning Style",
                title: item.learning!.learningStyle.toString(),
              ),
              const SizedBox(height: 10),
            ],
            if (item.learning != null && item.learning!.learningChallenge != null) ...[
              JobDetailTile(
                name: "Learning Challenge",
                title: item.learning!.learningChallenge.toString(),
              ),
              const SizedBox(height: 10),
            ],
            if (item.additionalInfo != null) ...[
              JobDetailTile(
                name: "Additional Info",
                title: item.additionalInfo ?? "",
              ),
              const SizedBox(height: 10),
            ],
            if (item.schedule!.isNotEmpty) ...[
              JobScheduleContainer(
                data: item.schedule,
              ),
            ],
            const SizedBox(height: 20),
            applyButton(futureSchoolSupportDetailDashboard!.isApplied == 0)
          ],
        );
      },
    );
  }

  Widget serviceChildCare(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      scrollDirection: Axis.vertical,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.all(20),
      itemCount: futureChildCareDetailDashboard!.jobDetail!.length,
      itemBuilder: (BuildContext context, int index) {
        var item = futureChildCareDetailDashboard!.jobDetail![index];
        return Column(
          children: [
            JobInfoContainer(
              title: item.jobTitle.toString(),
              address: item.address.toString(),
              location: item.location.toString(),
              hourlyRate: "\$${item.hourlyRate.toString()}/hour",
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
            for (var i = 0; i < item.childinfo!.length; i++) ...[
              if (item.childinfo!.length > 1) ...[
                const SizedBox(height: 10),
                Text(
                  "Child ${i + 1}",
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 10),
              ],
              JobDetailTile(
                name: "Child Initials",
                title: item.childinfo![i].name.toString(),
              ),
              const SizedBox(height: 10),
              JobDetailTile(
                name: "Child Age",
                title: item.childinfo![i].age.toString(),
              ),
              const SizedBox(height: 10),
            ],
            if (item.schoolCamp != null) ...[
              JobDetailTile(
                name: "Interest for Child",
                title: item.schoolCamp!.interestForChild.toString(),
              ),
              const SizedBox(height: 10),
              // JobDetailTile(
              //   name: "Cost Range For Camp",
              //   title: item.schoolCamp!.costRange.toString(),
              // ),
              const SizedBox(height: 10),
            ],
            const SizedBox(height: 10),
            if (item.schedule!.isNotEmpty) ...[
              JobScheduleContainer(
                data: item.schedule,
              ),
            ],
            const SizedBox(height: 20),
            applyButton(futureChildCareDetailDashboard!.isApplied == 0)
          ],
        );
      },
    );
  }

  Widget serviceHouseKeeping(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      scrollDirection: Axis.vertical,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.all(20),
      itemCount: futureHouseKeepingDetailDashboard!.jobDetail!.length,
      itemBuilder: (BuildContext context, int index) {
        var item = futureHouseKeepingDetailDashboard!.jobDetail![index];
        return Column(
          children: [
            Container(
              alignment: Alignment.center,
              child: Column(
                children: [
                  JobInfoContainer(
                    title: item.jobTitle.toString(),
                    address: item.address.toString(),
                    location: item.location.toString(),
                    hourlyRate: item.hourlyRate.toString(),
                  ),
                  const SizedBox(height: 10),
                  JobDetailTile(
                    name: "Cleaning Type",
                    title: item.houseKeeping!.cleaningType.toString(),
                  ),
                  const SizedBox(height: 10),
                  JobDetailTile(
                    name: "Number of Bedrooms",
                    title: item.houseKeeping!.numberOfBedrooms.toString(),
                  ),
                  const SizedBox(height: 10),
                  JobDetailTile(
                    name: "Number of Bathrooms",
                    title: item.houseKeeping!.numberOfBathrooms.toString(),
                  ),
                  const SizedBox(height: 10),
                  JobDetailTile(
                    name: "Laundary",
                    title: item.houseKeeping!.laundry.toString() == "1" ? "Yes" : "No",
                  ),
                  const SizedBox(height: 10),
                  JobDetailTile(
                    name: "Ironing",
                    title: item.houseKeeping!.ironing.toString() == "1" ? "Yes" : "No",
                  ),
                  const SizedBox(height: 10),
                  JobDetailTile(
                    name: "Other",
                    title: item.houseKeeping!.other.toString() == "null" ? "" : item.houseKeeping!.other.toString(),
                  ),
                  const SizedBox(height: 10),
                  JobDetailTile(
                    name: "Additional Info",
                    title: item.additionalInfo ?? "",
                  ),
                  const SizedBox(height: 10),
                ],
              ),
            ),
            const SizedBox(height: 10),
            JobScheduleContainer(
              data: item.schedule,
            ),
            const SizedBox(height: 20),
            applyButton(futureHouseKeepingDetailDashboard!.isApplied == 0),
          ],
        );
      },
    );
  }

  Widget servicePetCare(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      scrollDirection: Axis.vertical,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: futurePetCareDetailDashboard!.jobDetail!.length,
      padding: const EdgeInsets.all(20),
      itemBuilder: (BuildContext context, int index) {
        var item = futurePetCareDetailDashboard!.jobDetail![index];
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              children: [
                JobInfoContainer(
                  title: item.jobTitle.toString(),
                  address: item.address.toString(),
                  location: item.location.toString(),
                  hourlyRate: "\$${item.hourlyRate.toString()}/hour",
                ),
                const SizedBox(height: 10),
                JobDetailTile(
                  name: "Pet Type",
                  title: item.petCare!.petType.toString(),
                ),
                const SizedBox(height: 10),
                JobDetailTile(
                  name: "Number of Pet",
                  title: item.petCare!.numberOfPets.toString(),
                ),
                const SizedBox(height: 10),
                JobDetailTile(
                  name: "Pet Breed",
                  title: item.petCare!.petBreed.toString(),
                ),
                const SizedBox(height: 10),
                JobDetailTile(
                  name: "Size Of Pet",
                  title: item.petCare!.sizeOfPet.toString(),
                ),
                const SizedBox(height: 10),
                JobDetailTile(
                  name: "Temperament",
                  title: item.petCare!.temperament.toString(),
                ),
                const SizedBox(height: 10),
                JobDetailTile(
                  name: "Additional Info",
                  title: item.additionalInfo ?? "",
                ),
                const SizedBox(height: 10),
              ],
            ),
            const SizedBox(height: 10),
            AssistanceContainer(
              dd: [
                if (item.petCare!.walking.toString() == "1") ...[
                  item.petCare!.walking.toString() == "1" ? "Walking" : item.petCare!.walking.toString(),
                ],
                if (item.petCare!.daycare.toString() == "1") ...[
                  item.petCare!.daycare.toString() == "1" ? "Day Care" : item.petCare!.daycare.toString(),
                ],
                if (item.petCare!.feeding.toString() == "1") ...[
                  item.petCare!.feeding.toString() == "1" ? "Feeding" : item.petCare!.feeding.toString(),
                ],
                if (item.petCare!.socialization.toString() == "1") ...[
                  item.petCare!.socialization.toString() == "1" ? "Socialization" : item.petCare!.socialization.toString(),
                ],
                if (item.petCare!.grooming.toString() == "1") ...[
                  item.petCare!.grooming.toString() == "1" ? "Grooming" : item.petCare!.grooming.toString(),
                ],
                if (item.petCare!.boarding.toString() == "1") ...[
                  item.petCare!.boarding.toString() == "1" ? "Boarding" : item.petCare!.boarding.toString(),
                ],
              ],
            ),
            const SizedBox(height: 10),
            if (item.schedule!.isNotEmpty) ...[
              JobScheduleContainer(
                data: item.schedule,
              ),
            ],
            const SizedBox(height: 10),
            applyButton(futurePetCareDetailDashboard!.isApplied == 0)
          ],
        );
      },
    );
  }
}
