// ignore_for_file: unused_local_variable, prefer_typing_uninitialized_variables, non_constant_identifier_names, use_build_context_synchronously, deprecated_member_use

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:island_app/providers/user_provider.dart';
import 'package:island_app/utils/app_url.dart';
import 'package:island_app/utils/functions.dart';
import 'package:island_app/utils/utils.dart';
import 'package:island_app/widgets/check_tile_container.dart';
import 'package:island_app/widgets/show_day_container.dart';
import 'package:provider/provider.dart';
import 'package:island_app/carereceiver/utils/colors.dart';

class PostSchedule extends StatefulWidget {
  final String? serviceId;
  final String? jobId;
  const PostSchedule({
    super.key,
    this.serviceId,
    this.jobId,
  });

  @override
  State<PostSchedule> createState() => _PostScheduleState();
}

class _PostScheduleState extends State<PostSchedule> {
  final TextEditingController dateController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController descController = TextEditingController();
  final TextEditingController hourlyController = TextEditingController();
  final TextEditingController jobTitleController = TextEditingController();
  final TextEditingController startDateController = TextEditingController();
  final TextEditingController fromController = TextEditingController();
  final TextEditingController durationController = TextEditingController();
  final TextEditingController childrenController = TextEditingController();
  final TextEditingController childrenAgeController = TextEditingController();
  final TextEditingController zipController = TextEditingController();
  final TextEditingController responsibilitiesController = TextEditingController();
  final TextEditingController requirementController = TextEditingController();
  final TextEditingController seniorNameController = TextEditingController();
  final TextEditingController medicalConditionController = TextEditingController();
  final TextEditingController petBreedController = TextEditingController();
  final TextEditingController learningStyleController = TextEditingController();
  final TextEditingController learningChallengeController = TextEditingController();
  final TextEditingController interestForChildController = TextEditingController();
  final TextEditingController costRangeOfCampController = TextEditingController();
  final TextEditingController dobController = TextEditingController();
  final TextEditingController otherFieldController = TextEditingController();
  final TextEditingController gradeLevelController = TextEditingController();
  final TextEditingController additionalInfoController = TextEditingController();

  int? selectedIndex;
  int? otherField = 0;
  int? otherGuarded = 0;
  int? selectedNumberIndex;
  int? selectedSize;
  int? selectedTemperament;
  int? selectedGuarded;
  int? selectedCleaning;
  int? selectedBedroom;
  int? selectedBathroom;
  String? petTypeValue;
  int? numberOfPetValue;
  String? temperamentValue;
  String? sizeOfPetValue;
  String? cleaningTypeValue;
  String? bedroomValue;
  String? bathroomValue;
  String? locationValue;
  final List<String> bedroom = <String>[
    '1 Bedroom',
    '2 Bedroom',
    '3 Bedroom',
    '4 Bedroom or more',
  ];
  final List<String> bathroom = <String>[
    '1 Bathroom',
    '2 Bathroom',
    '3 Bathroom',
    '4 Bathroom or more',
  ];
  final List<String> cleaningType = <String>[
    'Light Cleaning',
    'Deep Cleaning',
  ];
  final List<String> temperament = <String>[
    'Friendly/Socialized',
    'Guarded',
  ];
  final List<String> guarded = <String>[
    'With People',
    'With Other Animals',
  ];
  final List<String> petType = <String>[
    'Dog',
    'Cat',
    'Fish',
    'Small Rodents',
    'Other',
  ];
  final List<String> sizeOfPet = <String>[
    'Small',
    'Medium',
    'Large',
  ];
  final List<String> petNumber = <String>[
    '1',
    '2',
    '3',
  ];
  List days = [];
  List childInfo = [];
  List seniorCareDays = [];

  List children = [];
  // List data send
  List dateMapList = [];
  List startTimeMapList = [];
  List durationMapList = [];
  List childnameMapList = [];
  List childageMapList = [];
  List gradeLevelMapList = [];
  bool isChecked = false;
  bool isChecked2 = false;
  bool isChecked3 = false;
  bool isChecked4 = false;
  bool isChecked5 = false;
  bool isChecked6 = false;
  bool isChecked7 = false;
  bool isChecked8 = false;
  bool isChecked9 = false;
  bool isChecked10 = false;
  bool isChecked11 = false;
  bool isChecked12 = false;
  bool isChecked13 = false;
  bool isChecked14 = false;
  bool isChecked15 = false;
  var math;
  var english;
  var reading;
  var science;
  var bathing;
  var laundry;
  var ironing;
  var other;
  var dressing;
  var feeding;
  var socialization;
  var meal_preparation;
  var grocery_shopping;
  var walking;
  var dayCare;
  var bed_transfer;
  var light_cleaning;
  var companionship;
  var medication_administration;
  var dressing_wound_care;
  var blood_pressure_monetoring;
  var blood_sugar_monetoring;
  var grooming_hair_and_nail_trimming;
  var boarding;

  List? data = [
    {
      "id": 1,
      "name": "East",
    },
    {
      "id": 2,
      "name": "West",
    },
    {
      "id": 3,
      "name": "Central",
    }
  ];
  List? hours = [
    {
      "id": 1,
      "name": "1 hours",
    },
    {
      "id": 2,
      "name": "2 hours",
    },
    {
      "id": 3,
      "name": "3 hours",
    },
    {
      "id": 4,
      "name": "4 hours",
    },
    {
      "id": 5,
      "name": "5 hours",
    },
    {
      "id": 6,
      "name": "6 hours",
    },
    {
      "id": 7,
      "name": "7 hours",
    },
    {
      "id": 8,
      "name": "8 hours",
    },
    {
      "id": 9,
      "name": "9 hours",
    },
    {
      "id": 10,
      "name": "10 hours",
    },
    {
      "id": 11,
      "name": "11 hours",
    },
    {
      "id": 12,
      "name": "12 hours",
    },
    {
      "id": 13,
      "name": "13 hours",
    },
    {
      "id": 14,
      "name": "14 hours",
    },
    {
      "id": 15,
      "name": "15 hours",
    },
  ];
  String? selectedLocation;
  String? selectedHours;

// fromdata
  DateTime? selectedDate = DateTime.now();

  var getfromPickedDate;

  _fromDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate!,
      firstDate: DateTime.now(),
      lastDate: DateTime(2050),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: ColorScheme.fromSwatch(
              primarySwatch: Colors.teal,
              // primaryColorDark: ServiceRecieverColor.primaryColor,
              accentColor: const Color(0xff55CE86),
            ),
            dialogBackgroundColor: Colors.white,
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      startDateController.text = DateFormat('yyyy-MM-dd').format(picked);

      setState(() {
        getfromPickedDate = startDateController.text;
      });
    }
  }

  _getDobDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate!,
      firstDate: DateTime.now(),
      lastDate: DateTime(2050),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: ColorScheme.fromSwatch(
              primarySwatch: Colors.teal,
              // primaryColorDark: ServiceRecieverColor.primaryColor,
              accentColor: const Color(0xff55CE86),
            ),
            dialogBackgroundColor: Colors.white,
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      dobController.text = DateFormat('yyyy-MM-dd').format(picked);

      setState(() {
        getfromPickedDate = dobController.text;
      });
    }
  }

// time
  String? selectedTime;

  var timeValue;

  Future<void> displayTimeDialog() async {
    final TimeOfDay? time = await showTimePicker(context: context, initialTime: TimeOfDay.now());
    if (time != null) {
      setState(() {
        selectedTime = time.format(context);
      });
    }
  }

  // Post JOB API
  PostSeniorCare() async {
    var token = await getToken();
    var formData = FormData.fromMap({
      'job_title': jobTitleController.text.toString(),
      'address': addressController.text.toString(),
      'location': locationValue.toString(),
      'hourly_rate': hourlyController.text.toString(),
      'senior_name': seniorNameController.text.toString(),
      'dob': dobController.text.toString(),
      'additional_info': additionalInfoController.text.toString(),
      'date[]': dateMapList,
      'medical_condition': medicalConditionController.text.toString(),
      'bathing': bathing,
      'dressing': dressing,
      'feeding': feeding,
      'meal_preparation': meal_preparation,
      'grocery_shopping': grocery_shopping,
      'walking': walking,
      'bed_transfer': bed_transfer,
      'light_cleaning': light_cleaning,
      'companionship': companionship,
      ' medication_administration': medication_administration,
      'dressing_wound_care': dressing_wound_care,
      'blood_pressure_monetoring': blood_pressure_monetoring,
      'blood_sugar_monetoring': blood_sugar_monetoring,
      'grooming_hair_and_nail_trimming': grooming_hair_and_nail_trimming,
      'start_time[]': startTimeMapList,
      'duration[]': durationMapList,
    });
    Dio dio = Dio();
    var userSubs = await Provider.of<RecieverUserProvider>(context).userProfile;
    if (userSubs!.data!.userSubscriptionDetail != null) {
      try {
        var response = await dio.post(
          CareReceiverURl.serviceReceiverSeniorCareJobCreater,
          data: formData,
          options: Options(
            followRedirects: false,
            validateStatus: (status) => true,
            headers: {
              "Accept": "application/json",
              "Authorization": "Bearer $token",
            },
          ),
        );
        if (response.statusCode == 200) {
          customSuccesSnackBar(context, "Job Created Successfully");
        }
      } on DioError catch (e) {
        customErrorSnackBar(
          context,
          e.toString(),
        );
      }
    } else {
      customErrorSnackBar(context, "Please Subscribe Package First");
    }
  }

  PostPetCare() async {
    var token = await getToken();
    var formData = FormData.fromMap(
      {
        'job_title': jobTitleController.text.toString(),
        'address': addressController.text.toString(),
        'location': locationValue.toString(),
        'hourly_rate': hourlyController.text.toString(),
        'pet_type': petTypeValue.toString(),
        'number_of_pets': numberOfPetValue.toString(),
        'additional_info': additionalInfoController.text.toString(),
        'pet_breed': petBreedController.text.toString(),
        'size_of_pet': sizeOfPetValue.toString(),
        'temperament': temperamentValue.toString(),
        'walking': walking,
        'boarding': boarding,
        'grooming': grooming_hair_and_nail_trimming,
        'daycare': dayCare,
        'feeding': feeding,
        'socialization': socialization,
        "date[]": dateMapList,
        "start_time[]": startTimeMapList,
        "duration[]": durationMapList,
      },
    );

    Dio dio = Dio();
    var userSubs = await Provider.of<RecieverUserProvider>(context).userProfile;
    if (userSubs!.data!.userSubscriptionDetail != null) {
      try {
        var response = await dio.post(
          CareReceiverURl.serviceReceiverPetCareJobCreater,
          data: formData,
          options: Options(
            followRedirects: false,
            validateStatus: (status) => true,
            headers: {
              "Accept": "application/json",
              "Authorization": "Bearer $token",
            },
          ),
        );
        if (response.statusCode == 200) {
          customSuccesSnackBar(context, "Job Created Successfully");
        }
      } catch (e) {
        customErrorSnackBar(context, e.toString());
      }
    } else {
      customErrorSnackBar(context, "Please Subscribe Package First");
    }
  }

  PostHouseKeeping() async {
    var token = await getToken();
    var formData = FormData.fromMap(
      {
        'job_title': jobTitleController.text.toString(),
        'address': addressController.text.toString(),
        'location': locationValue.toString(),
        'hourly_rate': hourlyController.text.toString(),
        'cleaning_type': cleaningTypeValue.toString(),
        'number_of_bedrooms': bedroomValue.toString(),
        'number_of_bathrooms': bathroomValue.toString(),
        'laundry': laundry.toString(),
        'ironing': ironing.toString(),
        'other': otherFieldController.text.toString(),
        "date[]": dateMapList,
        "start_time[]": startTimeMapList,
        "duration[]": durationMapList,
        'additional_info': additionalInfoController.text.toString(),
      },
    );

    Dio dio = Dio();
    var userSubs = await Provider.of<RecieverUserProvider>(context).userProfile;
    if (userSubs!.data!.userSubscriptionDetail != null) {
      try {
        var response = await dio.post(
          CareReceiverURl.serviceReceiverHouseKeepingJobCreater,
          data: formData,
          options: Options(
            followRedirects: false,
            validateStatus: (status) => true,
            headers: {
              "Accept": "application/json",
              "Authorization": "Bearer $token",
            },
          ),
        );
        if (response.statusCode == 200) {
          customSuccesSnackBar(context, "Job Created Successfully");
        }
      } catch (e) {
        customErrorSnackBar(
          context,
          e.toString(),
        );
      }
    } else {
      customErrorSnackBar(context, "Please Subscribe Package First");
    }
  }

  PostChildCare() async {
    var token = await getToken();
    var formData = FormData.fromMap(
      {
        'job_title': jobTitleController.text.toString(),
        'address': addressController.text.toString(),
        'location': locationValue.toString(),
        'hourly_rate': int.parse(hourlyController.text),
        'interest_for_child': interestForChildController.text.toString(),
        'cost_range': costRangeOfCampController.text.toString(),
        "date[]": dateMapList,
        "start_time[]": startTimeMapList,
        "duration[]": durationMapList,
        "name[]": childnameMapList,
        "age[]": childageMapList,
        // "grade[]": gradeLevelMapList,
      },
    );

    Dio dio = Dio();
    var userSubs = await Provider.of<RecieverUserProvider>(context).userProfile;
    if (userSubs!.data!.userSubscriptionDetail != null) {
      try {
        var response = await dio.post(
          CareReceiverURl.serviceReceiverLearningJobCreater,
          data: formData,
          options: Options(
            followRedirects: false,
            validateStatus: (status) => true,
            headers: {
              "Accept": "application/json",
              "Authorization": "Bearer $token",
            },
          ),
        );
        if (response.statusCode == 200) {
          customSuccesSnackBar(context, "Job Created Successfully");
        }
      } catch (e) {
        customErrorSnackBar(
          context,
          e.toString(),
        );
      }
    } else {
      customErrorSnackBar(context, "Please Subscribe Package First");
    }
  }

  PostSchoolSupport() async {
    var token = await getToken();
    var formData = FormData.fromMap(
      {
        'job_title': jobTitleController.text.toString(),
        'address': addressController.text.toString(),
        'location': locationValue.toString(),
        'hourly_rate': hourlyController.text.toString(),
        'learning_style': learningStyleController.text.toString(),
        'learning_challenge': learningChallengeController.text.toString(),
        'assistance_in_math': math == "0" ? 0 : 1,
        'assistance_in_english': english == "0" ? 0 : 1,
        'assistance_in_reading': reading == "0" ? 0 : 1,
        'assistance_in_science': science == "0" ? 0 : 1,
        'assistance_in_other': otherFieldController.text.isNotEmpty ? otherFieldController.text.toString() : 0,
        "date[]": dateMapList,
        "start_time[]": startTimeMapList,
        "duration[]": durationMapList,
        "name[]": childnameMapList,
        "age[]": childageMapList,
        "grade[]": gradeLevelMapList,
        "child_name[]": childnameMapList,
        "child_age[]": childageMapList,
        "grade_level[]": gradeLevelMapList,
        'additional_info': additionalInfoController.text.toString(),
      },
    );

    Dio dio = Dio();
    var userSubs = await Provider.of<RecieverUserProvider>(context).userProfile;
    if (userSubs!.data!.userSubscriptionDetail != null) {
      try {
        var response = await dio.post(
          CareReceiverURl.serviceReceiverSchoolCampJobCreater,
          data: formData,
          options: Options(
            followRedirects: false,
            validateStatus: (status) => true,
            headers: {
              "Accept": "application/json",
              "Authorization": "Bearer $token",
            },
          ),
        );
        if (response.statusCode == 200) {
          customSuccesSnackBar(context, "Job Created Successfully");
        }
      } catch (e) {
        customErrorSnackBar(
          context,
          e.toString(),
        );
      }
    } else {
      customErrorSnackBar(context, "Please Subscribe Package First");
    }
  }

  // getToken() async {
  //   var userToken = await getToken();
  //   return userToken.toString();
  // }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    dateController.dispose();
    addressController.dispose();
    descController.dispose();
    hourlyController.dispose();
    jobTitleController.dispose();
    startDateController.dispose();
    durationController.dispose();
    childrenController.dispose();
    childrenAgeController.dispose();
    zipController.dispose();
    requirementController.dispose();
    responsibilitiesController.dispose();
    seniorNameController.dispose();
    medicalConditionController.dispose();
    petBreedController.dispose();
    learningStyleController.dispose();
    learningChallengeController.dispose();
    interestForChildController.dispose();
    costRangeOfCampController.dispose();
    dobController.dispose();
    otherFieldController.dispose();
    gradeLevelController.dispose();
    additionalInfoController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
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
                    color: ServiceRecieverColor.primaryColor,
                    size: 18,
                  ),
                ),
              ),
            ),
          ),
          title: Text(
            (widget.serviceId == "1")
                ? "Senior Care Job Post"
                : (widget.serviceId == "2")
                    ? "Pet Care Job Post"
                    : (widget.serviceId == "3")
                        ? "House Keeping Job Post"
                        : (widget.serviceId == "4")
                            ? "School Support Job Post"
                            : (widget.serviceId == "5")
                                ? "Child Care Job Post"
                                : "Screen Not Found",
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
                const SizedBox(height: 20),
                //Job Title
                Container(
                  alignment: Alignment.topLeft,
                  child: const Text(
                    "Job Title",
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      // color: ServiceRecieverColor.primaryColor,
                      fontFamily: "Rubik",
                      fontSize: 14,
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                SizedBox(
                  height: 45,
                  child: TextFormField(
                    controller: jobTitleController,
                    style: const TextStyle(
                      fontSize: 12,
                      fontFamily: "Rubik",
                      fontWeight: FontWeight.w600,
                    ),
                    textAlignVertical: TextAlignVertical.center,
                    maxLines: 1,
                    decoration: inputdecoration("Job Title"),
                  ),
                ),
                //Parish
                const SizedBox(height: 20),
                Container(
                  alignment: Alignment.topLeft,
                  child: const Text(
                    "Job Location",
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      // color: ServiceRecieverColor.primaryColor,
                      fontFamily: "Rubik",
                      fontSize: 14,
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                SizedBox(
                  height: 45,
                  child: TextFormField(
                    controller: addressController,
                    style: const TextStyle(
                      fontSize: 12,
                      fontFamily: "Rubik",
                      fontWeight: FontWeight.w600,
                      // color: ServiceRecieverColor.primaryColor,
                    ),
                    textAlignVertical: TextAlignVertical.center,
                    maxLines: 1,
                    decoration: inputdecoration("Job Location"),
                  ),
                ),
                //Location
                const SizedBox(height: 20),
                Container(
                  alignment: Alignment.topLeft,
                  child: const Text(
                    "Job Area",
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      // color: ServiceRecieverColor.primaryColor,
                      fontFamily: "Rubik",
                      fontSize: 14,
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                SizedBox(
                  height: 45,
                  child: Center(
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        color: Colors.transparent,
                        border: Border.all(color: Colors.grey, width: 0.5),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 4,
                        ),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton(
                            hint: const Text(
                              "Select Area",
                              style: TextStyle(
                                fontSize: 12,
                                fontFamily: "Rubik",
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            isExpanded: true,
                            items: data!.map((item) {
                              return DropdownMenuItem(
                                value: item['id'].toString(),
                                child: Text(item['name']),
                              );
                            }).toList(),
                            onChanged: (newVal) {
                              setState(() {
                                selectedLocation = newVal;
                              });
                              if (selectedLocation == "1") {
                                locationValue = "east";
                              } else if (selectedLocation == "2") {
                                locationValue = "west";
                              } else if (selectedLocation == "3") {
                                locationValue = "central";
                              }
                            },
                            value: selectedLocation,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                // Hourly Rate
                const SizedBox(height: 20),
                Container(
                  alignment: Alignment.topLeft,
                  child: const Text(
                    "Hourly Rate",
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      // color: ServiceRecieverColor.primaryColor,
                      fontFamily: "Rubik",
                      fontSize: 14,
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Container(
                  height: 45,
                  width: MediaQuery.of(context).size.width,
                  padding: const EdgeInsets.only(left: 10),
                  clipBehavior: Clip.hardEdge,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: Colors.grey, width: 0.5),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Flex(
                    direction: Axis.horizontal,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    verticalDirection: VerticalDirection.up,
                    children: [
                      const Text(
                        "\$ ",
                        style: TextStyle(
                          // color: Colors.grey,
                          fontSize: 16,
                        ),
                      ),
                      Flexible(
                        child: TextFormField(
                          keyboardType: TextInputType.number,
                          controller: hourlyController,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                          ],
                          style: const TextStyle(
                            fontSize: 12,
                            fontFamily: "Rubik",
                            fontWeight: FontWeight.w600,
                          ),
                          textAlignVertical: TextAlignVertical.center,
                          maxLines: 1,
                          decoration: const InputDecoration(
                            hintText: "Please add Hourly Rate",
                            hintStyle: TextStyle(
                              fontSize: 14,
                              fontFamily: "Rubik",
                              fontWeight: FontWeight.w600,
                              // color: Colors.grey,
                            ),
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // Switch View,
                if (widget.serviceId == "1") ...[
                  // service id 1
                  ServiceSeniorCare(context),
                ] else if (widget.serviceId == "2") ...[
                  // service id 2
                  ServicePetCare(context),
                ] else if (widget.serviceId == "3") ...[
                  // service id 3
                  ServiceHouseKeeping(context),
                ] else if (widget.serviceId == "4") ...[
                  // Service Id 4
                  ServiceSchoolSupport(context),
                ] else if (widget.serviceId == "5") ...[
                  // Service Id 5
                  ServiceChildCare(context),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget addDaysColumn(context) {
    return Column(
      children: [
        // Add Days
        Container(
          padding: const EdgeInsets.all(12),
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
              bottomLeft: Radius.circular(20),
              bottomRight: Radius.circular(20),
            ),
            boxShadow: [
              BoxShadow(
                color: Color.fromRGBO(26, 41, 96, 0.05999999865889549),
                blurRadius: 3,
                spreadRadius: 5,
              )
            ],
            color: Color.fromRGBO(255, 255, 255, 1),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text(
                "Add Days",
                style: TextStyle(
                  fontFamily: "Rubik",
                  fontSize: 18,
                  color: CustomColors.primaryText,
                  fontWeight: FontWeight.w600,
                ),
              ),
              // Start Date
              Container(
                height: 50,
                margin: const EdgeInsets.only(bottom: 15, top: 15),
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: TextButton(
                  style: ButtonStyle(
                    alignment: Alignment.centerLeft,
                    padding: MaterialStateProperty.resolveWith(
                      (states) => const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    ),
                    shape: MaterialStateProperty.resolveWith(
                      (states) => RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                        side: const BorderSide(color: Colors.grey, width: 0.5),
                      ),
                    ),
                  ),
                  child: Text(
                    getfromPickedDate != null ? '$getfromPickedDate' : 'Date',
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      fontSize: 16,
                      fontFamily: "Rubik",
                      fontWeight: FontWeight.w400,
                      color: CustomColors.primaryText,
                    ),
                  ),
                  onPressed: () {
                    _fromDate(context);
                  },
                ),
                //  CustomTextFieldWidget(
                //   borderColor: CustomColors.white,
                //   obsecure: false,
                //   keyboardType: TextInputType.number,
                //   controller: startDateController,
                //   hintText: "Date",
                //   onChanged: (value) {
                //     setState(() {
                //       getfromPickedDate = value;
                //     });
                //   },
                //   onTap: () async {
                //     _fromDate(context);
                //   },
                // ),
              ),
              //Timer
              SizedBox(
                width: MediaQuery.of(context).size.width,
                height: 50,
                child: TextButton(
                  style: ButtonStyle(
                    alignment: Alignment.centerLeft,
                    padding: MaterialStateProperty.resolveWith(
                      (states) => const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    ),
                    shape: MaterialStateProperty.resolveWith(
                      (states) => RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                        side: const BorderSide(color: Colors.grey, width: 0.5),
                      ),
                    ),
                  ),
                  child: Text(
                    selectedTime != null ? '$selectedTime' : 'Start Time',
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      fontSize: 16,
                      fontFamily: "Rubik",
                      fontWeight: FontWeight.w400,
                      color: CustomColors.primaryText,
                    ),
                  ),
                  onPressed: () {
                    setState(() {
                      displayTimeDialog();
                    });
                  },
                ),
              ),
              // Duration
              Container(
                height: 50,
                margin: const EdgeInsets.only(bottom: 15, top: 15),
                child: Center(
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey, width: 0.5),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton(
                          hint: const Text(
                            "Duration",
                            style: TextStyle(
                              fontSize: 12,
                              fontFamily: "Rubik",
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          isExpanded: true,
                          items: hours!.map((item) {
                            return DropdownMenuItem(
                              value: item['id'].toString(),
                              child: Text(item['name']),
                            );
                          }).toList(),
                          onChanged: (newVal) {
                            setState(() {
                              selectedHours = newVal;
                            });
                          },
                          value: selectedHours,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              // AddBtn
              GestureDetector(
                onTap: () {
                  if (startDateController.text.isNotEmpty && selectedHours != null && selectedTime != null) {
                    String startDate = startDateController.text.trim();
                    String time = selectedTime.toString();
                    setState(() {
                      dateMapList.add(startDate);
                      startTimeMapList.add(time);
                      durationMapList.add(selectedHours);
                      seniorCareDays.add(
                        {
                          "starting_date": startDate,
                          "starting_time": time,
                          "duration": selectedHours,
                        },
                      );
                    });
                  } else {
                    if (startDateController.text.isEmpty) {
                      customErrorSnackBar(context, "please select date");
                    } else if (selectedHours == null) {
                      customErrorSnackBar(context, "please select start time");
                    } else if (selectedTime == null) {
                      customErrorSnackBar(context, "please select Duration");
                    }
                  }
                },
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: 50,
                  margin: const EdgeInsets.only(top: 20),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.center,
                      end: Alignment.center,
                      colors: [
                        ServiceRecieverColor.redButton.withOpacity(0.1),
                        ServiceRecieverColor.redButton.withOpacity(0.8),
                      ],
                    ),
                    color: ServiceRecieverColor.redButton,
                    boxShadow: const [
                      BoxShadow(
                        color: Color.fromARGB(13, 0, 0, 0),
                        blurRadius: 4.0,
                        spreadRadius: 2.0,
                      ),
                    ],
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Center(
                    child: Text(
                      "Add More Days",
                      style: TextStyle(
                        color: CustomColors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        fontFamily: "Rubik",
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 10),
        // Show Days
        const SizedBox(height: 10),
        ListView.builder(
            shrinkWrap: true,
            scrollDirection: Axis.vertical,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: seniorCareDays.length,
            itemBuilder: (context, index) {
              return ShowDaysContainer(
                date: seniorCareDays[index]['starting_date'].toString(),
                time: seniorCareDays[index]['starting_time'],
                duration: seniorCareDays[index]['duration'],
                removeIconTap: (() {
                  setState(() {
                    seniorCareDays.removeAt(index);
                    startTimeMapList.removeAt(index);
                    dateMapList.removeAt(index);
                    durationMapList.removeAt(index);
                  });
                }),
              );
              // SizedBox(
              //   width: MediaQuery.of(context).size.width,
              //   height: 100,
              //   child: Stack(
              //     children: [
              //       Padding(
              //         padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              //         child: Container(
              //           padding: const EdgeInsets.symmetric(
              //             horizontal: 10,
              //             vertical: 10,
              //           ),
              //           decoration: BoxDecoration(
              //             color: Colors.white,
              //             borderRadius: BorderRadius.circular(12),
              //             boxShadow: [
              //               BoxShadow(
              //                 color: Colors.grey.shade300,
              //                 spreadRadius: 01,
              //                 blurRadius: 05,
              //                 blurStyle: BlurStyle.outer,
              //               ),
              //             ],
              //           ),
              //           height: 85,
              //           width: MediaQuery.of(context).size.width,
              //           child: Column(
              //             children: [
              //               Row(
              //                 children: [
              //                   const Text("Date: "),
              //                   Expanded(
              //                     child: Text(
              //                       seniorCareDays[index]['starting_date'].toString(),
              //                     ),
              //                   ),
              //                 ],
              //               ),
              //               Row(
              //                 children: [
              //                   const Text("Time: "),
              //                   Expanded(
              //                     child: Text("${seniorCareDays[index]['starting_time']}"),
              //                   ),
              //                 ],
              //               ),
              //               Row(
              //                 children: [
              //                   const Text("Duration: "),
              //                   Expanded(
              //                     child: Text("${seniorCareDays[index]['duration']} hours"),
              //                   ),
              //                 ],
              //               ),
              //             ],
              //           ),
              //         ),
              //       ),
              //       Positioned(
              //         top: -10,
              //         right: 0,
              //         child: GestureDetector(
              //           onTap: (() {
              //             setState(() {
              //               seniorCareDays.removeAt(index);
              //               startTimeMapList.removeAt(index);
              //               dateMapList.removeAt(index);
              //               durationMapList.removeAt(index);
              //             });
              //           }),
              //           child: Container(
              //             decoration: BoxDecoration(
              //               borderRadius: const BorderRadius.only(
              //                 topLeft: Radius.circular(100),
              //                 bottomLeft: Radius.circular(100),
              //                 bottomRight: Radius.circular(100),
              //                 topRight: Radius.circular(100),
              //               ),
              //               color: CustomColors.white,
              //               boxShadow: const [
              //                 BoxShadow(
              //                   color: Color.fromARGB(13, 0, 0, 0),
              //                   blurRadius: 4.0,
              //                   spreadRadius: 2.0,
              //                   offset: Offset(2.0, 2.0),
              //                 ),
              //               ],
              //             ),
              //             // alignment: Alignment.center,
              //             width: 30,
              //             height: 30,
              //             child: const Icon(
              //               Icons.close,
              //               size: 16,
              //             ),
              //           ),
              //         ),
              //       ),
              //     ],
              //   ),
              // );
            }),
        const SizedBox(height: 10),
      ],
    );
  }

  Widget ServiceChildCare(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 20),
        // Add Children
        Container(
          padding: const EdgeInsets.all(12),
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
              bottomLeft: Radius.circular(20),
              bottomRight: Radius.circular(20),
            ),
            boxShadow: [
              BoxShadow(
                color: Color.fromRGBO(26, 41, 96, 0.05999999865889549),
                blurRadius: 3,
                spreadRadius: 5,
              )
            ],
            color: Color.fromRGBO(255, 255, 255, 1),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text(
                "Add Children",
                style: TextStyle(
                  fontFamily: "Rubik",
                  fontSize: 18,
                  color: CustomColors.primaryText,
                  fontWeight: FontWeight.w600,
                ),
              ),
              // Children Name
              Container(
                height: 50,
                margin: const EdgeInsets.only(bottom: 15, top: 15),
                decoration: BoxDecoration(
                  color: CustomColors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: TextFormField(
                    controller: childrenController,
                    keyboardType: TextInputType.name,
                    style: const TextStyle(
                      fontSize: 16,
                      fontFamily: "Rubik",
                      fontWeight: FontWeight.w400,
                    ),
                    textAlignVertical: TextAlignVertical.center,
                    maxLines: 1,
                    decoration: inputdecoration("Child Initials")),
              ),
              // Children Name
              Container(
                height: 50,
                margin: const EdgeInsets.only(bottom: 15, top: 15),
                decoration: BoxDecoration(
                  color: CustomColors.white,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: TextFormField(
                  controller: childrenAgeController,
                  keyboardType: TextInputType.number,
                  style: const TextStyle(
                    fontSize: 16,
                    fontFamily: "Rubik",
                    fontWeight: FontWeight.w400,
                  ),
                  textAlignVertical: TextAlignVertical.center,
                  maxLines: 1,
                  decoration: inputdecoration("Child Age"),
                ),
              ),
              // AddBtn
              GestureDetector(
                onTap: () {
                  setState(() {
                    childnameMapList.add(childrenController.text.toString());
                    childageMapList.add(childrenAgeController.text.toString());

                    children.add(
                      {
                        "name": childrenController.text.toString(),
                        "age": childrenAgeController.text.toString(),
                      },
                    );
                  });
                },
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: 50,
                  margin: const EdgeInsets.only(top: 20),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.center,
                      end: Alignment.center,
                      colors: [
                        ServiceRecieverColor.redButton.withOpacity(0.1),
                        ServiceRecieverColor.redButton.withOpacity(0.8),
                      ],
                    ),
                    color: ServiceRecieverColor.redButton,
                    boxShadow: const [
                      BoxShadow(
                        color: Color.fromARGB(13, 0, 0, 0),
                        blurRadius: 4.0,
                        spreadRadius: 2.0,
                      ),
                    ],
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Center(
                    child: Text(
                      "Add More Children",
                      style: TextStyle(
                        color: CustomColors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        fontFamily: "Rubik",
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        // Show Children
        ListView.builder(
            shrinkWrap: true,
            scrollDirection: Axis.vertical,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: children.length,
            itemBuilder: (context, index) {
              return Stack(
                children: [
                  Container(
                    decoration: const BoxDecoration(
                      color: Colors.transparent,
                    ),
                    alignment: Alignment.centerRight,
                    width: MediaQuery.of(context).size.width,
                    height: 100,
                    child: const RotatedBox(
                      quarterTurns: 1,
                      child: Text(
                        'Container 1',
                        style: TextStyle(
                          fontSize: 18.0,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 25,
                    right: 10,
                    left: 3,
                    bottom: 5,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                      decoration: BoxDecoration(
                        color: CustomColors.white,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      alignment: Alignment.centerLeft,
                      width: MediaQuery.of(context).size.width,
                      child: Row(
                        children: [
                          SizedBox(
                            width: MediaQuery.of(context).size.width * .80,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Container(
                                      alignment: Alignment.topLeft,
                                      width: 100,
                                      child: const Column(
                                        children: [
                                          Text("Child Initials :"),
                                        ],
                                      ),
                                    ),
                                    Expanded(
                                      child: Text("${children[index]['name']}"),
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Container(
                                      alignment: Alignment.topLeft,
                                      width: 100,
                                      child: const Column(
                                        children: [
                                          Text("Age:"),
                                        ],
                                      ),
                                    ),
                                    Expanded(
                                      child: Text("${children[index]['age']}"),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    top: 10,
                    right: -2,
                    child: GestureDetector(
                      onTap: (() {
                        setState(() {
                          children.removeAt(index);
                          childnameMapList.removeAt(index);
                          childageMapList.removeAt(index);
                        });
                      }),
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(100),
                            bottomLeft: Radius.circular(100),
                            bottomRight: Radius.circular(100),
                            topRight: Radius.circular(100),
                          ),
                          color: CustomColors.white,
                          boxShadow: const [
                            BoxShadow(
                              color: Color.fromARGB(13, 0, 0, 0),
                              blurRadius: 4.0,
                              spreadRadius: 2.0,
                              offset: Offset(2.0, 2.0),
                            ),
                          ],
                        ),
                        alignment: Alignment.center,
                        width: 30,
                        height: 30,
                        child: const Icon(
                          Icons.close,
                          size: 16,
                        ),
                      ),
                    ),
                  ),
                ],
              );
            }),
        const SizedBox(height: 20),
        addDaysColumn(context),
        // Interest For Child
        const SizedBox(height: 20),
        Container(
          alignment: Alignment.topLeft,
          child: const Text(
            "Interest For Child",
            style: TextStyle(
              fontWeight: FontWeight.w600,
              // color: ServiceRecieverColor.primaryColor,
              fontFamily: "Rubik",
              fontSize: 14,
            ),
          ),
        ),
        const SizedBox(height: 10),
        SizedBox(
          height: 45,
          child: TextFormField(
            keyboardType: TextInputType.name,
            controller: interestForChildController,
            style: const TextStyle(
              fontSize: 12,
              fontFamily: "Rubik",
              fontWeight: FontWeight.w600,
            ),
            textAlignVertical: TextAlignVertical.center,
            decoration: inputdecoration("Interest For Child"),
          ),
        ),
        // cost rang
        const SizedBox(height: 20),
        Container(
          alignment: Alignment.topLeft,
          child: const Text(
            "Cost Range Of Camp",
            style: TextStyle(
              fontWeight: FontWeight.w600,
              // color: ServiceRecieverColor.primaryColor,
              fontFamily: "Rubik",
              fontSize: 14,
            ),
          ),
        ),
        const SizedBox(height: 10),
        SizedBox(
          height: 45,
          child: TextFormField(
            keyboardType: TextInputType.number,
            controller: costRangeOfCampController,
            style: const TextStyle(
              fontSize: 12,
              fontFamily: "Rubik",
              fontWeight: FontWeight.w600,
              // color: ServiceRecieverColor.primaryColor,
            ),
            textAlignVertical: TextAlignVertical.center,
            decoration: inputdecoration("Cost Range Of Camp"),
          ),
        ),
        // btn
        const SizedBox(height: 20),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 0),
          child: GestureDetector(
            onTap: () async {
              if (jobTitleController.text.isEmpty) {
                customErrorSnackBar(context, "Job Title is Required");
              } else if (addressController.text.isEmpty) {
                customErrorSnackBar(context, "Job Location is Required");
              } else if (selectedLocation == null) {
                customErrorSnackBar(context, "Job Area is Required");
              } else if (hourlyController.text.isEmpty) {
                customErrorSnackBar(context, "Hourly Rate is Required");
              } else if (children.isEmpty) {
                customErrorSnackBar(context, "Child Initials is Required");
              } else if (seniorCareDays.isEmpty) {
                customErrorSnackBar(context, "Please Enter Add Days");
              } else if (interestForChildController.text.isEmpty) {
                customErrorSnackBar(context, "Interest for Child is Required");
              } else if (costRangeOfCampController.text.isEmpty) {
                customErrorSnackBar(context, "Cost Range of Camp is Required");
              } else {
                PostChildCare();
              }
            },
            child: Container(
              width: MediaQuery.of(context).size.width,
              height: 60,
              margin: const EdgeInsets.symmetric(vertical: 10),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.center,
                  end: Alignment.center,
                  colors: [
                    ServiceRecieverColor.redButton.withOpacity(0.1),
                    ServiceRecieverColor.redButton.withOpacity(0.8),
                  ],
                ),
                color: ServiceRecieverColor.redButton,
                boxShadow: const [
                  BoxShadow(
                    color: Color.fromARGB(13, 0, 0, 0),
                    blurRadius: 4.0,
                    spreadRadius: 2.0,
                    offset: Offset(2.0, 2.0),
                  ),
                ],
                borderRadius: BorderRadius.circular(6),
              ),
              child: Center(
                child: Text(
                  "Submit",
                  style: TextStyle(
                    color: CustomColors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.w600,
                    fontFamily: "Rubik",
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget ServiceSchoolSupport(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 20),
        // Add Children
        Container(
          padding: const EdgeInsets.all(12),
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
              bottomLeft: Radius.circular(20),
              bottomRight: Radius.circular(20),
            ),
            boxShadow: [
              BoxShadow(
                color: Color.fromRGBO(26, 41, 96, 0.05999999865889549),
                blurRadius: 10,
                spreadRadius: 5,
              )
            ],
            color: Color.fromRGBO(255, 255, 255, 1),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text(
                "Add Children",
                style: TextStyle(
                  fontFamily: "Rubik",
                  fontSize: 18,
                  color: CustomColors.primaryText,
                  fontWeight: FontWeight.w600,
                ),
              ),
              // Children Name
              Container(
                height: 50,
                margin: const EdgeInsets.only(bottom: 15, top: 15),
                decoration: BoxDecoration(
                  color: CustomColors.white,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: TextFormField(
                  controller: childrenController,
                  keyboardType: TextInputType.name,
                  style: const TextStyle(
                    fontSize: 16,
                    fontFamily: "Rubik",
                    fontWeight: FontWeight.w400,
                  ),
                  maxLines: 1,
                  decoration: inputdecoration("Child Initials"),
                ),
              ),
              // Children age
              Container(
                height: 50,
                margin: const EdgeInsets.only(bottom: 15, top: 15),
                decoration: BoxDecoration(
                  color: CustomColors.white,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: TextFormField(
                  controller: childrenAgeController,
                  keyboardType: TextInputType.number,
                  style: const TextStyle(
                    fontSize: 16,
                    fontFamily: "Rubik",
                    fontWeight: FontWeight.w400,
                  ),
                  maxLines: 1,
                  decoration: inputdecoration("Child Age"),
                ),
              ),
              Container(
                height: 50,
                margin: const EdgeInsets.only(bottom: 15, top: 15),
                decoration: BoxDecoration(
                  color: CustomColors.white,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: TextFormField(
                  controller: gradeLevelController,
                  keyboardType: TextInputType.number,
                  style: const TextStyle(
                    fontSize: 16,
                    fontFamily: "Rubik",
                    fontWeight: FontWeight.w400,
                  ),
                  maxLines: 1,
                  decoration: inputdecoration("Grade Level"),
                ),
              ),
              // AddBtn
              GestureDetector(
                onTap: () {
                  setState(() {
                    childnameMapList.add(childrenController.text.toString());
                    childageMapList.add(childrenAgeController.text.toString());
                    gradeLevelMapList.add(gradeLevelController.text.toString());

                    children.add(
                      {
                        "name": childrenController.text.toString(),
                        "age": childrenAgeController.text.toString(),
                        "grade": gradeLevelController.text.toString(),
                      },
                    );
                  });
                },
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: 50,
                  margin: const EdgeInsets.only(top: 20),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.center,
                      end: Alignment.center,
                      colors: [
                        ServiceRecieverColor.redButton.withOpacity(0.1),
                        ServiceRecieverColor.redButton.withOpacity(0.8),
                      ],
                    ),
                    color: CustomColors.white,
                    boxShadow: const [
                      BoxShadow(
                        color: Color.fromARGB(13, 0, 0, 0),
                        blurRadius: 4.0,
                        spreadRadius: 2.0,
                        offset: Offset(2.0, 2.0),
                      ),
                    ],
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Center(
                    child: Text(
                      "Add More Children",
                      style: TextStyle(
                        color: CustomColors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        fontFamily: "Rubik",
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        // Show Children
        const SizedBox(height: 20),
        ListView.builder(
            shrinkWrap: true,
            scrollDirection: Axis.vertical,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: children.length,
            itemBuilder: (context, index) {
              return SizedBox(
                width: MediaQuery.of(context).size.width,
                height: 95,
                child: Stack(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 10,
                      ),
                      decoration: BoxDecoration(
                        color: CustomColors.white,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.shade300,
                            spreadRadius: 01,
                            blurRadius: 05,
                          ),
                        ],
                      ),
                      height: 85,
                      width: MediaQuery.of(context).size.width,
                      child: Column(
                        // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              const Text("Child Initials: "),
                              Expanded(
                                child: Text("${children[index]['name']}"),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              const Text("Age:"),
                              Expanded(
                                child: Text("${children[index]['age']}"),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              const Text("Grade Level:"),
                              Expanded(
                                child: Text("${children[index]['grade']}"),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Positioned(
                      top: 00,
                      right: 00,
                      child: GestureDetector(
                        onTap: (() {
                          setState(() {
                            children.removeAt(index);
                            childnameMapList.removeAt(index);
                            childageMapList.removeAt(index);
                          });
                        }),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(100),
                              bottomLeft: Radius.circular(100),
                              bottomRight: Radius.circular(100),
                              topRight: Radius.circular(100),
                            ),
                            color: CustomColors.white,
                            boxShadow: const [
                              BoxShadow(
                                color: Color.fromARGB(13, 0, 0, 0),
                                blurRadius: 4.0,
                                spreadRadius: 2.0,
                                offset: Offset(2.0, 2.0),
                              ),
                            ],
                          ),
                          alignment: Alignment.center,
                          width: 30,
                          height: 30,
                          child: const Icon(
                            Icons.close,
                            size: 16,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }),
        const SizedBox(height: 20),
        // Add Days
        addDaysColumn(context),
        // Container(
        //   padding: const EdgeInsets.all(12),
        //   decoration: const BoxDecoration(
        //     borderRadius: BorderRadius.only(
        //       topLeft: Radius.circular(20),
        //       topRight: Radius.circular(20),
        //       bottomLeft: Radius.circular(20),
        //       bottomRight: Radius.circular(20),
        //     ),
        //     boxShadow: [
        //       BoxShadow(
        //         color: Color.fromRGBO(26, 41, 96, 0.05999999865889549),
        //         spreadRadius: 5,
        //         blurRadius: 3,
        //       )
        //     ],
        //     color: Color.fromRGBO(255, 255, 255, 1),
        //   ),
        //   child: Column(
        //     mainAxisSize: MainAxisSize.min,
        //     children: <Widget>[
        //       Text(
        //         "Add Days",
        //         style: TextStyle(
        //           fontFamily: "Rubik",
        //           fontSize: 18,
        //           color: CustomColors.primaryText,
        //           fontWeight: FontWeight.w600,
        //         ),
        //       ),
        //       // Start Date
        //       Container(
        //         height: 50,
        //         margin: const EdgeInsets.only(bottom: 15, top: 15),
        //         decoration: BoxDecoration(
        //           color: Colors.white,
        //           borderRadius: BorderRadius.circular(12),
        //         ),
        //         child: CustomTextFieldWidget(
        //           borderColor: CustomColors.white,
        //           obsecure: false,
        //           keyboardType: TextInputType.number,
        //           controller: startDateController,
        //           hintText: "Start Date",
        //           onChanged: (value) {
        //             setState(() {
        //               getfromPickedDate = value;
        //             });
        //           },
        //           onTap: () async {
        //             _fromDate(context);
        //           },
        //         ),
        //       ),
        //       //Timer
        //       SizedBox(
        //         width: MediaQuery.of(context).size.width,
        //         height: 50,
        //         child: TextButton(
        //           style: ButtonStyle(
        //             alignment: Alignment.centerLeft,
        //             padding: MaterialStateProperty.resolveWith((states) => const EdgeInsets.symmetric(horizontal: 20, vertical: 10)),
        //             shape: MaterialStateProperty.resolveWith(
        //               (states) => RoundedRectangleBorder(
        //                 borderRadius: BorderRadius.circular(12),
        //                 side: BorderSide(color: ServiceRecieverColor.primaryColor, width: 0.5),
        //               ),
        //             ),
        //           ),
        //           child: Text(
        //             selectedTime != null ? '$selectedTime' : 'Select Time',
        //             textAlign: TextAlign.left,
        //             style: TextStyle(
        //               fontSize: 16,
        //               fontFamily: "Rubik",
        //               fontWeight: FontWeight.w400,
        //               color: CustomColors.primaryText,
        //             ),
        //           ),
        //           onPressed: () {
        //             setState(
        //               () {
        //                 displayTimeDialog();
        //               },
        //             );
        //           },
        //         ),
        //       ),
        //       // Duration
        //       Container(
        //         height: 50,
        //         margin: const EdgeInsets.only(bottom: 15, top: 15),
        //         child: Center(
        //           child: DecoratedBox(
        //             decoration: BoxDecoration(
        //               border: Border.all(color: ServiceRecieverColor.primaryColor, width: 0.5),
        //               borderRadius: BorderRadius.circular(12),
        //             ),
        //             child: Padding(
        //               padding: const EdgeInsets.symmetric(
        //                 horizontal: 10,
        //                 vertical: 4,
        //               ),
        //               child: DropdownButtonHideUnderline(
        //                 child: DropdownButton(
        //                   hint: Text(
        //                     "Duration in hours",
        //                     style: TextStyle(
        //                       fontSize: 12,
        //                       fontFamily: "Rubik",
        //                       fontWeight: FontWeight.w600,
        //                       color: CustomColors.primaryText,
        //                     ),
        //                   ),
        //                   isExpanded: true,
        //                   items: hours!.map((item) {
        //                     return DropdownMenuItem(
        //                       value: item['id'].toString(),
        //                       child: Text(item['name']),
        //                     );
        //                   }).toList(),
        //                   onChanged: (newVal) {
        //                     setState(() {
        //                       selectedHours = newVal;
        //                     });
        //                   },
        //                   value: selectedHours,
        //                 ),
        //               ),
        //             ),
        //           ),
        //         ),
        //       ),
        //       // AddBtn
        //       GestureDetector(
        //         onTap: () {
        //           String startDate = startDateController.text.trim();
        //           String time = selectedTime.toString();
        //           setState(() {
        //             dateMapList.add(startDate);
        //             startTimeMapList.add(time);
        //             durationMapList.add(selectedHours);
        //             seniorCareDays.add(
        //               {
        //                 "starting_date": startDate,
        //                 "starting_time": time,
        //                 "duration": selectedHours,
        //               },
        //             );
        //           });
        //         },
        //         child: Container(
        //           width: MediaQuery.of(context).size.width,
        //           height: 50,
        //           margin: const EdgeInsets.only(top: 20),
        //           decoration: BoxDecoration(
        //             gradient: LinearGradient(
        //               begin: Alignment.center,
        //               end: Alignment.center,
        //               colors: [
        //                 ServiceRecieverColor.redButton.withOpacity(0.1),
        //                 ServiceRecieverColor.redButton.withOpacity(0.8),
        //               ],
        //             ),
        //             color: ServiceRecieverColor.redButton,
        //             boxShadow: const [
        //               BoxShadow(
        //                 color: Color.fromARGB(13, 0, 0, 0),
        //                 blurRadius: 4.0,
        //                 spreadRadius: 2.0,
        //                 offset: Offset(2.0, 2.0),
        //               ),
        //             ],
        //             borderRadius: BorderRadius.circular(6),
        //           ),
        //           child: Center(
        //             child: Text(
        //               "Add More Days",
        //               style: TextStyle(
        //                 color: CustomColors.white,
        //                 fontSize: 16,
        //                 fontWeight: FontWeight.w600,
        //                 fontFamily: "Rubik",
        //               ),
        //             ),
        //           ),
        //         ),
        //       ),
        //     ],
        //   ),
        // ),
        // // Show Days
        // const SizedBox(height: 20),
        // ListView.builder(
        //     shrinkWrap: true,
        //     scrollDirection: Axis.vertical,
        //     physics: const NeverScrollableScrollPhysics(),
        //     itemCount: seniorCareDays.length,
        //     itemBuilder: (context, index) {
        //       return SizedBox(
        //         width: MediaQuery.of(context).size.width,
        //         height: 95,
        //         child: Stack(
        //           children: [
        //             Container(
        //               padding: const EdgeInsets.symmetric(
        //                 horizontal: 10,
        //                 vertical: 10,
        //               ),
        //               decoration: BoxDecoration(
        //                 color: Colors.white,
        //                 borderRadius: BorderRadius.circular(12),
        //                 boxShadow: [
        //                   BoxShadow(
        //                     color: Colors.grey.shade300,
        //                     spreadRadius: 01,
        //                     blurRadius: 05,
        //                   ),
        //                 ],
        //               ),
        //               height: 85,
        //               width: MediaQuery.of(context).size.width,
        //               child: Column(
        //                 children: [
        //                   Row(
        //                     children: [
        //                       const Text("Date: "),
        //                       Expanded(
        //                         child: Text(
        //                           seniorCareDays[index]['starting_date'].toString(),
        //                         ),
        //                       ),
        //                     ],
        //                   ),
        //                   Row(
        //                     children: [
        //                       const Text("Time: "),
        //                       Expanded(
        //                         child: Text("${seniorCareDays[index]['starting_time']}"),
        //                       ),
        //                     ],
        //                   ),
        //                   Row(
        //                     children: [
        //                       const Text("Duration: "),
        //                       Expanded(
        //                         child: Text("${seniorCareDays[index]['duration']} hours"),
        //                       ),
        //                     ],
        //                   ),
        //                 ],
        //               ),
        //             ),
        //             Positioned(
        //               top: 00,
        //               right: 0,
        //               child: GestureDetector(
        //                 onTap: (() {
        //                   setState(() {
        //                     seniorCareDays.removeAt(index);
        //                     startTimeMapList.removeAt(index);
        //                     dateMapList.removeAt(index);
        //                     durationMapList.removeAt(index);
        //                   });
        //                 }),
        //                 child: Container(
        //                   decoration: BoxDecoration(
        //                     borderRadius: const BorderRadius.only(
        //                       topLeft: Radius.circular(100),
        //                       bottomLeft: Radius.circular(100),
        //                       bottomRight: Radius.circular(100),
        //                       topRight: Radius.circular(100),
        //                     ),
        //                     color: CustomColors.white,
        //                     boxShadow: const [
        //                       BoxShadow(
        //                         color: Color.fromARGB(13, 0, 0, 0),
        //                         blurRadius: 4.0,
        //                         spreadRadius: 2.0,
        //                         offset: Offset(2.0, 2.0),
        //                       ),
        //                     ],
        //                   ),
        //                   // alignment: Alignment.center,
        //                   width: 30,
        //                   height: 30,
        //                   child: const Icon(
        //                     Icons.close,
        //                     size: 16,
        //                   ),
        //                 ),
        //               ),
        //             ),
        //           ],
        //         ),
        //       );
        //     }),
        //Need Assistance
        const SizedBox(height: 20),
        Container(
          alignment: Alignment.topLeft,
          child: const Text(
            "Need Assistance",
            style: TextStyle(
              fontWeight: FontWeight.w600,
              // color: ServiceRecieverColor.primaryColor,
              fontFamily: "Rubik",
              fontSize: 14,
            ),
          ),
        ),
        const SizedBox(height: 10),
        Wrap(
          runSpacing: 5.0,
          spacing: 5.0,
          children: [
            Container(
              alignment: Alignment.topLeft,
              width: 150,
              child: ListTileTheme(
                horizontalTitleGap: 0,
                child: CheckboxListTile(
                  contentPadding: EdgeInsets.zero,
                  title: const Text("Math"),
                  value: isChecked,
                  onChanged: (newValue) {
                    setState(() {
                      isChecked = newValue!;
                      if (newValue == false) {
                        math = "0";
                      } else {
                        math = "1";
                      }
                    });
                  },
                  controlAffinity: ListTileControlAffinity.leading,
                ),
              ),
            ),
            Container(
              alignment: Alignment.topLeft,
              width: 150,
              child: ListTileTheme(
                horizontalTitleGap: 0,
                child: CheckboxListTile(
                  contentPadding: EdgeInsets.zero,
                  title: const Text("English"),
                  value: isChecked2,
                  onChanged: (newValue) {
                    setState(() {
                      isChecked2 = newValue!;
                      if (newValue == false) {
                        english = "0";
                      } else {
                        english = "1";
                      }
                    });
                  },
                  controlAffinity: ListTileControlAffinity.leading,
                ),
              ),
            ),
            Container(
              alignment: Alignment.topLeft,
              width: 150,
              child: ListTileTheme(
                horizontalTitleGap: 0,
                child: CheckboxListTile(
                  contentPadding: EdgeInsets.zero,
                  title: const Text("Reading"),
                  value: isChecked3,
                  onChanged: (newValue) {
                    setState(() {
                      isChecked3 = newValue!;
                      if (newValue == false) {
                        reading = "0";
                      } else {
                        reading = "1";
                      }
                    });
                  },
                  controlAffinity: ListTileControlAffinity.leading,
                ),
              ),
            ),
            Container(
              alignment: Alignment.topLeft,
              width: 150,
              child: ListTileTheme(
                horizontalTitleGap: 0,
                child: CheckboxListTile(
                  contentPadding: EdgeInsets.zero,
                  title: const Text("Science"),
                  value: isChecked4,
                  onChanged: (newValue) {
                    setState(() {
                      isChecked4 = newValue!;
                      if (newValue == false) {
                        science = "0";
                      } else {
                        science = "1";
                      }
                    });
                  },
                  controlAffinity: ListTileControlAffinity.leading,
                ),
              ),
            ),
            Container(
              alignment: Alignment.topLeft,
              width: 150,
              child: ListTileTheme(
                horizontalTitleGap: 0,
                child: CheckboxListTile(
                  contentPadding: EdgeInsets.zero,
                  title: const Text("Other"),
                  value: isChecked5,
                  onChanged: (newValue) {
                    setState(() {
                      isChecked5 = newValue!;
                      if (newValue == false) {
                        other = "0";
                      } else {
                        other = "1";
                      }
                    });
                  },
                  controlAffinity: ListTileControlAffinity.leading,
                ),
              ),
            ),
          ],
        ),
        if (other == "1") ...[
          SizedBox(
            height: 45,
            child: TextFormField(
              controller: otherFieldController,
              onChanged: (value) {
                other = value;
              },
              style: const TextStyle(
                fontSize: 12,
                fontFamily: "Rubik",
                fontWeight: FontWeight.w600,
                // color: ServiceRecieverColor.primaryColor,
              ),
              textAlignVertical: TextAlignVertical.center,
              maxLines: 1,
              decoration: inputdecoration("Please enter details here"),
            ),
          ),
        ],
        const SizedBox(height: 20),
        // Learning Style
        Container(
          alignment: Alignment.topLeft,
          child: const Text(
            "Learning Style",
            style: TextStyle(
              fontWeight: FontWeight.w600,
              // color: ServiceRecieverColor.primaryColor,
              fontFamily: "Rubik",
              fontSize: 14,
            ),
          ),
        ),
        const SizedBox(height: 10),
        SizedBox(
          height: 45,
          child: TextFormField(
            keyboardType: TextInputType.name,
            controller: learningStyleController,
            style: const TextStyle(
              fontSize: 12,
              fontFamily: "Rubik",
              fontWeight: FontWeight.w600,
            ),
            decoration: inputdecoration("Learning Style"),
          ),
        ),
        // Child challenge
        const SizedBox(height: 20),
        Container(
          alignment: Alignment.topLeft,
          child: const Text(
            "Learning Challenge",
            style: TextStyle(
              fontWeight: FontWeight.w600,
              // color: ServiceRecieverColor.primaryColor,
              fontFamily: "Rubik",
              fontSize: 14,
            ),
          ),
        ),
        const SizedBox(height: 10),
        SizedBox(
          height: 100,
          child: TextFormField(
            keyboardType: TextInputType.name,
            controller: learningChallengeController,
            style: const TextStyle(
              fontSize: 12,
              fontFamily: "Rubik",
              fontWeight: FontWeight.w600,
            ),
            maxLines: 5,
            decoration: inputdecoration("Learning Challenge"),
          ),
        ),
        const SizedBox(height: 20),
        //Additional Info (optional)
        Container(
          alignment: Alignment.topLeft,
          child: const Text(
            "Additional Info (optional)",
            style: TextStyle(
              fontWeight: FontWeight.w600,
              // color: ServiceRecieverColor.primaryColor,
              fontFamily: "Rubik",
              fontSize: 14,
            ),
          ),
        ),
        const SizedBox(height: 10),
        SizedBox(
          height: 120,
          child: TextFormField(
            controller: additionalInfoController,
            style: const TextStyle(
              fontSize: 12,
              fontFamily: "Rubik",
              fontWeight: FontWeight.w600,
            ),
            textAlignVertical: TextAlignVertical.center,
            maxLines: 5,
            decoration: inputdecoration("Additional Info (optional)"),
          ),
        ),
        // btn
        const SizedBox(height: 20),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 0),
          child: GestureDetector(
            onTap: () async {
              if (jobTitleController.text.isEmpty) {
                customErrorSnackBar(context, "Job Title is Required");
              } else if (addressController.text.isEmpty) {
                customErrorSnackBar(context, "Job Location is Required");
              } else if (selectedLocation == null) {
                customErrorSnackBar(context, "Job Area is Required");
              } else if (hourlyController.text.isEmpty) {
                customErrorSnackBar(context, "Hourly Rate is Required");
              } else if (seniorCareDays.isEmpty) {
                customErrorSnackBar(context, "Please Enter Add Days");
              } else if (children.isEmpty) {
                customErrorSnackBar(context, "Child Initials is Required");
              } else if (other == "1" && otherFieldController.text.isEmpty) {
                customErrorSnackBar(context, "Other is Required");
              } else if (learningStyleController.text.isEmpty) {
                customErrorSnackBar(context, "Learning Style is Required");
              } else if (learningChallengeController.text.isEmpty) {
                customErrorSnackBar(context, "Learning Challenge is Required");
              } else {
                PostSchoolSupport();
              }
            },
            child: Container(
              width: MediaQuery.of(context).size.width,
              height: 60,
              margin: const EdgeInsets.symmetric(vertical: 10),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.center,
                  end: Alignment.center,
                  colors: [
                    ServiceRecieverColor.redButton.withOpacity(0.1),
                    ServiceRecieverColor.redButton.withOpacity(0.8),
                  ],
                ),
                color: ServiceRecieverColor.redButton,
                boxShadow: const [
                  BoxShadow(
                    color: Color.fromARGB(13, 0, 0, 0),
                    blurRadius: 4.0,
                    spreadRadius: 2.0,
                    offset: Offset(2.0, 2.0),
                  ),
                ],
                borderRadius: BorderRadius.circular(6),
              ),
              child: Center(
                child: Text(
                  "Submit",
                  style: TextStyle(
                    color: CustomColors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.w600,
                    fontFamily: "Rubik",
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Column ServiceHouseKeeping(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 10),
        // Cleaning type
        const SizedBox(height: 20),
        Container(
          alignment: Alignment.topLeft,
          child: const Text(
            "Cleaning Type",
            style: TextStyle(
              fontWeight: FontWeight.w600,
              // color: ServiceRecieverColor.primaryColor,
              fontFamily: "Rubik",
              fontSize: 14,
            ),
          ),
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            Expanded(
              flex: 5,
              child: TextButton(
                onPressed: () {
                  setState(() {
                    selectedCleaning = 0;
                    cleaningTypeValue = "Light Cleaning";
                  });
                },
                style: ButtonStyle(
                  shape: MaterialStateProperty.resolveWith((states) => RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
                  backgroundColor: MaterialStateProperty.resolveWith(
                    (states) => selectedCleaning == 0 ? ServiceRecieverColor.primaryColor : Colors.grey.shade200,
                  ),
                ),
                child: Text(
                  cleaningType[0],
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: selectedCleaning == 0 ? FontWeight.w600 : FontWeight.w400,
                    fontFamily: "Rubik",
                    color: selectedCleaning == 0 ? Colors.white : Colors.black,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              flex: 5,
              child: TextButton(
                onPressed: () {
                  setState(() {
                    selectedCleaning = 1;
                    cleaningTypeValue = "Deep Cleaning";
                  });
                },
                style: ButtonStyle(
                  shape: MaterialStateProperty.resolveWith((states) => RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
                  backgroundColor: MaterialStateProperty.resolveWith(
                    (states) => selectedCleaning == 1 ? ServiceRecieverColor.primaryColor : Colors.grey.shade200,
                  ),
                ),
                child: Text(
                  cleaningType[1],
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: selectedCleaning == 1 ? FontWeight.w600 : FontWeight.w400,
                    fontFamily: "Rubik",
                    color: selectedCleaning == 1 ? Colors.white : Colors.black,
                  ),
                ),
              ),
            ),
          ],
        ),
        // Add Days
        const SizedBox(height: 20),
        addDaysColumn(context),
        // Container(
        //   padding: const EdgeInsets.all(12),
        //   decoration: const BoxDecoration(
        //     borderRadius: BorderRadius.only(
        //       topLeft: Radius.circular(20),
        //       topRight: Radius.circular(20),
        //       bottomLeft: Radius.circular(20),
        //       bottomRight: Radius.circular(20),
        //     ),
        //     boxShadow: [
        //       BoxShadow(
        //         color: Color.fromRGBO(26, 41, 96, 0.05999999865889549),
        //         blurRadius: 3,
        //         spreadRadius: 5,
        //       )
        //     ],
        //     color: Color.fromRGBO(255, 255, 255, 1),
        //   ),
        //   child: Column(
        //     mainAxisSize: MainAxisSize.min,
        //     children: <Widget>[
        //       const Text(
        //         "Add Days",
        //         style: TextStyle(
        //           fontFamily: "Rubik",
        //           fontSize: 18,
        //           // color: CustomColors.primaryText,
        //           fontWeight: FontWeight.w600,
        //         ),
        //       ),
        //       // Start Date
        //       Container(
        //         height: 50,
        //         margin: const EdgeInsets.only(bottom: 15, top: 15),
        //         decoration: BoxDecoration(
        //           color: Colors.white,
        //           borderRadius: BorderRadius.circular(12),
        //         ),
        //         child: CustomTextFieldWidget(
        //           borderColor: CustomColors.white,
        //           obsecure: false,
        //           keyboardType: TextInputType.number,
        //           controller: startDateController,
        //           hintText: "Date",
        //           onChanged: (value) {
        //             setState(() {
        //               getfromPickedDate = value;
        //             });
        //           },
        //           onTap: () async {
        //             _fromDate(context);
        //           },
        //         ),
        //       ),
        //       //Timer
        //       SizedBox(
        //         width: MediaQuery.of(context).size.width,
        //         height: 50,
        //         child: TextButton(
        //           style: ButtonStyle(
        //             alignment: Alignment.centerLeft,
        //             padding: MaterialStateProperty.resolveWith((states) => const EdgeInsets.symmetric(horizontal: 20, vertical: 10)),
        //             shape: MaterialStateProperty.resolveWith(
        //               (states) => RoundedRectangleBorder(
        //                 borderRadius: BorderRadius.circular(12),
        //                 side: BorderSide(color: ServiceRecieverColor.primaryColor, width: 0.5),
        //               ),
        //             ),
        //           ),
        //           child: Text(
        //             selectedTime != null ? '$selectedTime' : 'Start Time',
        //             textAlign: TextAlign.left,
        //             style: TextStyle(
        //               fontSize: 16,
        //               fontFamily: "Rubik",
        //               fontWeight: FontWeight.w400,
        //               color: CustomColors.primaryText,
        //             ),
        //           ),
        //           onPressed: () {
        //             setState(
        //               () {
        //                 displayTimeDialog();
        //               },
        //             );
        //           },
        //         ),
        //       ),
        //       // Duration
        //       Container(
        //         height: 50,
        //         margin: const EdgeInsets.only(bottom: 15, top: 15),
        //         child: Center(
        //           child: DecoratedBox(
        //             decoration: BoxDecoration(
        //               border: Border.all(color: ServiceRecieverColor.primaryColor, width: 0.5),
        //               borderRadius: BorderRadius.circular(12),
        //             ),
        //             child: Padding(
        //               padding: const EdgeInsets.symmetric(
        //                 horizontal: 10,
        //                 vertical: 4,
        //               ),
        //               child: DropdownButtonHideUnderline(
        //                 child: DropdownButton(
        //                   hint: Text(
        //                     "Duration",
        //                     style: TextStyle(
        //                       fontSize: 12,
        //                       fontFamily: "Rubik",
        //                       fontWeight: FontWeight.w600,
        //                       color: CustomColors.primaryText,
        //                     ),
        //                   ),
        //                   isExpanded: true,
        //                   items: hours!.map((item) {
        //                     return DropdownMenuItem(
        //                       value: item['id'].toString(),
        //                       child: Text(item['name']),
        //                     );
        //                   }).toList(),
        //                   onChanged: (newVal) {
        //                     setState(() {
        //                       selectedHours = newVal;
        //                     });
        //                   },
        //                   value: selectedHours,
        //                 ),
        //               ),
        //             ),
        //           ),
        //         ),
        //       ),
        //       // AddBtn
        //       GestureDetector(
        //         onTap: () {
        //           String startDate = startDateController.text.trim();
        //           String time = selectedTime.toString();
        //           setState(() {
        //             dateMapList.add(startDate);
        //             startTimeMapList.add(time);
        //             durationMapList.add(selectedHours);
        //             seniorCareDays.add(
        //               {
        //                 "starting_date": startDate,
        //                 "starting_time": time,
        //                 "duration": selectedHours,
        //               },
        //             );
        //           });
        //         },
        //         child: Container(
        //           width: MediaQuery.of(context).size.width,
        //           height: 50,
        //           margin: const EdgeInsets.only(top: 20),
        //           decoration: BoxDecoration(
        //             gradient: LinearGradient(
        //               begin: Alignment.center,
        //               end: Alignment.center,
        //               colors: [
        //                 ServiceRecieverColor.redButton.withOpacity(0.1),
        //                 ServiceRecieverColor.redButton.withOpacity(0.8),
        //               ],
        //             ),
        //             color: ServiceRecieverColor.redButton,
        //             boxShadow: const [
        //               BoxShadow(
        //                 color: Color.fromARGB(13, 0, 0, 0),
        //                 blurRadius: 4.0,
        //                 spreadRadius: 2.0,
        //                 offset: Offset(2.0, 2.0),
        //               ),
        //             ],
        //             borderRadius: BorderRadius.circular(6),
        //           ),
        //           child: Center(
        //             child: Text(
        //               "Add More Days",
        //               style: TextStyle(
        //                 color: CustomColors.white,
        //                 fontSize: 16,
        //                 fontWeight: FontWeight.w600,
        //                 fontFamily: "Rubik",
        //               ),
        //             ),
        //           ),
        //         ),
        //       ),
        //     ],
        //   ),
        // ),
        // // Show Days
        // const SizedBox(height: 20),
        // ListView.builder(
        //     shrinkWrap: true,
        //     scrollDirection: Axis.vertical,
        //     physics: const NeverScrollableScrollPhysics(),
        //     itemCount: seniorCareDays.length,
        //     itemBuilder: (context, index) {
        //       return SizedBox(
        //         width: MediaQuery.of(context).size.width,
        //         height: 95,
        //         child: Stack(
        //           children: [
        //             Container(
        //               padding: const EdgeInsets.symmetric(
        //                 horizontal: 10,
        //                 vertical: 10,
        //               ),
        //               decoration: BoxDecoration(
        //                 color: Colors.white,
        //                 borderRadius: BorderRadius.circular(12),
        //                 boxShadow: [
        //                   BoxShadow(
        //                     color: Colors.grey.shade300,
        //                     spreadRadius: 01,
        //                     blurRadius: 05,
        //                   ),
        //                 ],
        //               ),
        //               height: 85,
        //               width: MediaQuery.of(context).size.width,
        //               child: Column(
        //                 children: [
        //                   Row(
        //                     children: [
        //                       const Text("Date: "),
        //                       Expanded(
        //                         child: Text(
        //                           seniorCareDays[index]['starting_date'].toString(),
        //                         ),
        //                       ),
        //                     ],
        //                   ),
        //                   Row(
        //                     children: [
        //                       const Text("Time: "),
        //                       Expanded(
        //                         child: Text("${seniorCareDays[index]['starting_time']}"),
        //                       ),
        //                     ],
        //                   ),
        //                   Row(
        //                     children: [
        //                       const Text("Duration: "),
        //                       Expanded(
        //                         child: Text("${seniorCareDays[index]['duration']} hours"),
        //                       ),
        //                     ],
        //                   ),
        //                 ],
        //               ),
        //             ),
        //             Positioned(
        //               top: 00,
        //               right: 0,
        //               child: GestureDetector(
        //                 onTap: (() {
        //                   setState(() {
        //                     seniorCareDays.removeAt(index);
        //                     startTimeMapList.removeAt(index);
        //                     dateMapList.removeAt(index);
        //                     durationMapList.removeAt(index);
        //                   });
        //                 }),
        //                 child: Container(
        //                   decoration: BoxDecoration(
        //                     borderRadius: const BorderRadius.only(
        //                       topLeft: Radius.circular(100),
        //                       bottomLeft: Radius.circular(100),
        //                       bottomRight: Radius.circular(100),
        //                       topRight: Radius.circular(100),
        //                     ),
        //                     color: CustomColors.white,
        //                     boxShadow: const [
        //                       BoxShadow(
        //                         color: Color.fromARGB(13, 0, 0, 0),
        //                         blurRadius: 4.0,
        //                         spreadRadius: 2.0,
        //                         offset: Offset(2.0, 2.0),
        //                       ),
        //                     ],
        //                   ),
        //                   // alignment: Alignment.center,
        //                   width: 30,
        //                   height: 30,
        //                   child: const Icon(
        //                     Icons.close,
        //                     size: 16,
        //                   ),
        //                 ),
        //               ),
        //             ),
        //           ],
        //         ),
        //       );
        //     }),
        // Size of House/Apartment
        const SizedBox(height: 20),
        Container(
          alignment: Alignment.topLeft,
          child: const Text(
            "Size of House/Apartment",
            style: TextStyle(
              fontWeight: FontWeight.w600,
              // color: ServiceRecieverColor.primaryColor,
              fontFamily: "Rubik",
              fontSize: 14,
            ),
          ),
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            Expanded(
              flex: 5,
              child: TextButton(
                onPressed: () {
                  setState(() {
                    selectedBedroom = 0;
                    bedroomValue = '1';
                  });
                },
                style: ButtonStyle(
                  shape: MaterialStateProperty.resolveWith((states) => RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
                  backgroundColor: MaterialStateProperty.resolveWith(
                    (states) => selectedBedroom == 0 ? ServiceRecieverColor.primaryColor : Colors.grey.shade200,
                  ),
                ),
                child: Text(
                  "1 Bedroom",
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: selectedBedroom == 0 ? FontWeight.w600 : FontWeight.w400,
                    fontFamily: "Rubik",
                    color: selectedBedroom == 0 ? Colors.white : Colors.black,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              flex: 5,
              child: TextButton(
                onPressed: () {
                  setState(() {
                    selectedBedroom = 1;
                    bedroomValue = '2';
                  });
                },
                style: ButtonStyle(
                  shape: MaterialStateProperty.resolveWith((states) => RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
                  backgroundColor: MaterialStateProperty.resolveWith(
                    (states) => selectedBedroom == 1 ? ServiceRecieverColor.primaryColor : Colors.grey.shade200,
                  ),
                ),
                child: Text(
                  "2 Bedrooms",
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: selectedBedroom == 1 ? FontWeight.w600 : FontWeight.w400,
                    fontFamily: "Rubik",
                    color: selectedBedroom == 1 ? CustomColors.white : Colors.black,
                  ),
                ),
              ),
            ),
          ],
        ),
        Row(
          children: [
            Expanded(
              flex: 5,
              child: TextButton(
                onPressed: () {
                  setState(() {
                    selectedBedroom = 2;
                    bedroomValue = '3';
                  });
                },
                style: ButtonStyle(
                  shape: MaterialStateProperty.resolveWith((states) => RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
                  backgroundColor: MaterialStateProperty.resolveWith(
                    (states) => selectedBedroom == 2 ? ServiceRecieverColor.primaryColor : Colors.grey.shade200,
                  ),
                ),
                child: Text(
                  "3 Bedrooms",
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: selectedBedroom == 2 ? FontWeight.w600 : FontWeight.w400,
                    fontFamily: "Rubik",
                    color: selectedBedroom == 2 ? CustomColors.white : Colors.black,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              flex: 5,
              child: TextButton(
                onPressed: () {
                  setState(() {
                    selectedBedroom = 3;
                    bedroomValue = '4';
                  });
                },
                style: ButtonStyle(
                  shape: MaterialStateProperty.resolveWith((states) => RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
                  backgroundColor: MaterialStateProperty.resolveWith(
                    (states) => selectedBedroom == 3 ? ServiceRecieverColor.primaryColor : Colors.grey.shade200,
                  ),
                ),
                child: Text(
                  "4 Bedrooms and more",
                  maxLines: 2,
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: selectedBedroom == 3 ? FontWeight.w600 : FontWeight.w400,
                    fontFamily: "Rubik",
                    color: selectedBedroom == 3 ? CustomColors.white : Colors.black,
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            Expanded(
              flex: 5,
              child: TextButton(
                onPressed: () {
                  setState(() {
                    selectedBathroom = 0;
                    bathroomValue = '1';
                  });
                },
                style: ButtonStyle(
                  shape: MaterialStateProperty.resolveWith((states) => RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
                  backgroundColor: MaterialStateProperty.resolveWith(
                    (states) => selectedBathroom == 0 ? ServiceRecieverColor.primaryColor : Colors.grey.shade200,
                  ),
                ),
                child: Text(
                  "1 Bathroom",
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: selectedBathroom == 0 ? FontWeight.w600 : FontWeight.w400,
                    fontFamily: "Rubik",
                    color: selectedBathroom == 0 ? CustomColors.white : Colors.black,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              flex: 5,
              child: TextButton(
                onPressed: () {
                  setState(() {
                    selectedBathroom = 1;
                    bathroomValue = '2';
                  });
                },
                style: ButtonStyle(
                  shape: MaterialStateProperty.resolveWith((states) => RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
                  backgroundColor: MaterialStateProperty.resolveWith(
                    (states) => selectedBathroom == 1 ? ServiceRecieverColor.primaryColor : Colors.grey.shade200,
                  ),
                ),
                child: Text(
                  "2 Bathrooms",
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: selectedBathroom == 1 ? FontWeight.w600 : FontWeight.w400,
                    fontFamily: "Rubik",
                    color: selectedBathroom == 1 ? CustomColors.white : Colors.black,
                  ),
                ),
              ),
            ),
          ],
        ),
        Row(
          children: [
            Expanded(
              flex: 5,
              child: TextButton(
                onPressed: () {
                  setState(() {
                    selectedBathroom = 2;
                    bathroomValue = '3';
                  });
                },
                style: ButtonStyle(
                  shape: MaterialStateProperty.resolveWith((states) => RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
                  backgroundColor: MaterialStateProperty.resolveWith(
                    (states) => selectedBathroom == 2 ? ServiceRecieverColor.primaryColor : Colors.grey.shade200,
                  ),
                ),
                child: Text(
                  "3 Bathrooms",
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: selectedBathroom == 2 ? FontWeight.w600 : FontWeight.w400,
                    fontFamily: "Rubik",
                    color: selectedBathroom == 2 ? CustomColors.white : Colors.black,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              flex: 5,
              child: TextButton(
                onPressed: () {
                  setState(() {
                    selectedBathroom = 3;
                    bathroomValue = '4';
                  });
                },
                style: ButtonStyle(
                  shape: MaterialStateProperty.resolveWith((states) => RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
                  backgroundColor: MaterialStateProperty.resolveWith(
                    (states) => selectedBathroom == 3 ? ServiceRecieverColor.primaryColor : Colors.grey.shade200,
                  ),
                ),
                child: Text(
                  "4 Bathrooms and more",
                  maxLines: 2,
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: selectedBathroom == 3 ? FontWeight.w600 : FontWeight.w400,
                    fontFamily: "Rubik",
                    color: selectedBathroom == 3 ? CustomColors.white : Colors.black,
                  ),
                ),
              ),
            ),
          ],
        ),
        // Need Assistance
        const SizedBox(height: 20),
        Container(
          alignment: Alignment.topLeft,
          child: const Text(
            "Other",
            style: TextStyle(
              fontWeight: FontWeight.w600,
              // color: ServiceRecieverColor.primaryColor,
              fontFamily: "Rubik",
              fontSize: 14,
            ),
          ),
        ),
        const SizedBox(height: 10),
        Wrap(
          runSpacing: 5.0,
          spacing: 5.0,
          children: [
            Container(
              alignment: Alignment.topLeft,
              width: 150,
              child: ListTileTheme(
                horizontalTitleGap: 0,
                child: CheckboxListTile(
                  contentPadding: EdgeInsets.zero,
                  title: const Text("Laundry"),
                  value: isChecked,
                  onChanged: (newValue) {
                    setState(() {
                      isChecked = newValue!;
                      if (newValue == false) {
                        laundry = "0";
                      } else {
                        laundry = "1";
                      }
                    });
                  },
                  controlAffinity: ListTileControlAffinity.leading,
                ),
              ),
            ),
            Container(
              alignment: Alignment.topLeft,
              width: 150,
              child: ListTileTheme(
                horizontalTitleGap: 0,
                child: CheckboxListTile(
                  contentPadding: EdgeInsets.zero,
                  title: const Text("Ironing"),
                  value: isChecked2,
                  onChanged: (newValue) {
                    setState(() {
                      isChecked2 = newValue!;
                      if (newValue == false) {
                        ironing = "0";
                      } else {
                        ironing = "1";
                      }
                    });
                  },
                  controlAffinity: ListTileControlAffinity.leading,
                ),
              ),
            ),
            Container(
              alignment: Alignment.topLeft,
              width: 150,
              child: ListTileTheme(
                horizontalTitleGap: 0,
                child: CheckboxListTile(
                  contentPadding: EdgeInsets.zero,
                  title: const Text("Other"),
                  value: isChecked3,
                  onChanged: (newValue) {
                    setState(() {
                      isChecked3 = newValue!;
                      if (newValue == false) {
                        other = "0";
                      } else {
                        other = "1";
                      }
                    });
                  },
                  controlAffinity: ListTileControlAffinity.leading,
                ),
              ),
            ),
          ],
        ),
        if (other == "1") ...[
          SizedBox(
            height: 45,
            child: TextFormField(
              onChanged: (value) {
                other = value;
              },
              controller: otherFieldController,
              style: const TextStyle(
                fontSize: 12,
                fontFamily: "Rubik",
                fontWeight: FontWeight.w600,
                // color: ServiceRecieverColor.primaryColor,
              ),
              textAlignVertical: TextAlignVertical.center,
              maxLines: 1,
              decoration: inputdecoration("Please enter detail here"),
            ),
          ),
        ],

        //Additional Info (optional)
        const SizedBox(height: 20),
        Container(
          alignment: Alignment.topLeft,
          child: const Text(
            "Additional Info (optional)",
            style: TextStyle(
              fontWeight: FontWeight.w600,
              // color: ServiceRecieverColor.primaryColor,
              fontFamily: "Rubik",
              fontSize: 14,
            ),
          ),
        ),
        const SizedBox(height: 10),
        SizedBox(
          height: 120,
          child: TextFormField(
            controller: additionalInfoController,
            style: const TextStyle(
              fontSize: 12,
              fontFamily: "Rubik",
              fontWeight: FontWeight.w600,
            ),
            textAlignVertical: TextAlignVertical.center,
            maxLines: 5,
            decoration: inputdecoration("Additional Info (optional)"),
          ),
        ),
        const SizedBox(height: 20),
        // btn
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 0),
          child: GestureDetector(
            onTap: () async {
              if (jobTitleController.text.isEmpty) {
                customErrorSnackBar(context, "Job Title is Required");
              } else if (addressController.text.isEmpty) {
                customErrorSnackBar(context, "Job Location is Required");
              } else if (selectedLocation == null) {
                customErrorSnackBar(context, "Job Area is Required");
              } else if (hourlyController.text.isEmpty) {
                customErrorSnackBar(context, "Hourly Rate is Required");
              } else if (cleaningTypeValue == null) {
                customErrorSnackBar(context, "Cleaning Type is Required");
              } else if (bedroomValue == null) {
                customErrorSnackBar(context, "Please Select Bedroom");
              } else if (bathroomValue == null) {
                customErrorSnackBar(context, "Please Select Bathroom");
              } else if (other == "1" && otherFieldController.text.isEmpty) {
                customErrorSnackBar(context, "Other is Required");
              } else if (seniorCareDays.isEmpty) {
                customErrorSnackBar(context, "Please Enter Add Days");
              } else {
                PostHouseKeeping();
              }
            },
            child: Container(
              width: MediaQuery.of(context).size.width,
              height: 60,
              margin: const EdgeInsets.symmetric(vertical: 10),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.center,
                  end: Alignment.center,
                  colors: [
                    ServiceRecieverColor.redButton.withOpacity(0.1),
                    ServiceRecieverColor.redButton.withOpacity(0.8),
                  ],
                ),
                color: ServiceRecieverColor.redButton,
                boxShadow: const [
                  BoxShadow(
                    color: Color.fromARGB(13, 0, 0, 0),
                    blurRadius: 4.0,
                    spreadRadius: 2.0,
                    offset: Offset(2.0, 2.0),
                  ),
                ],
                borderRadius: BorderRadius.circular(6),
              ),
              child: Center(
                child: Text(
                  "Submit",
                  style: TextStyle(
                    color: CustomColors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.w600,
                    fontFamily: "Rubik",
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget ServicePetCare(BuildContext context) {
    return Column(
      children: [
        // Add Days
        const SizedBox(height: 20),
        addDaysColumn(context),
        // Container(
        //   padding: const EdgeInsets.all(12),
        //   decoration: const BoxDecoration(
        //     borderRadius: BorderRadius.only(
        //       topLeft: Radius.circular(20),
        //       topRight: Radius.circular(20),
        //       bottomLeft: Radius.circular(20),
        //       bottomRight: Radius.circular(20),
        //     ),
        //     boxShadow: [
        //       BoxShadow(
        //         color: Color.fromRGBO(26, 41, 96, 0.05999999865889549),
        //         spreadRadius: 5,
        //         blurRadius: 3,
        //       )
        //     ],
        //     color: Color.fromRGBO(255, 255, 255, 1),
        //   ),
        //   child: Column(
        //     mainAxisSize: MainAxisSize.min,
        //     children: <Widget>[
        //       Text(
        //         "Add Days",
        //         style: TextStyle(
        //           fontFamily: "Rubik",
        //           fontSize: 18,
        //           color: CustomColors.primaryText,
        //           fontWeight: FontWeight.w600,
        //         ),
        //       ),
        //       const SizedBox(height: 10),
        //       // Start Date
        //       Container(
        //         height: 50,
        //         // margin: const EdgeInsets.only(bottom: 15, top: 15),
        //         decoration: BoxDecoration(
        //           color: Colors.white,
        //           borderRadius: BorderRadius.circular(12),
        //         ),
        //         child: CustomTextFieldWidget(
        //           borderColor: CustomColors.white,
        //           obsecure: false,
        //           keyboardType: TextInputType.number,
        //           controller: startDateController,
        //           hintText: "Date",
        //           onChanged: (value) {
        //             setState(() {
        //               getfromPickedDate = value;
        //             });
        //           },
        //           onTap: () async {
        //             _fromDate(context);
        //           },
        //         ),
        //       ),
        //       //Timer
        //       const SizedBox(height: 10),
        //       SizedBox(
        //         width: MediaQuery.of(context).size.width,
        //         height: 50,
        //         child: TextButton(
        //           style: ButtonStyle(
        //             alignment: Alignment.centerLeft,
        //             padding: MaterialStateProperty.resolveWith((states) => const EdgeInsets.symmetric(horizontal: 20, vertical: 10)),
        //             shape: MaterialStateProperty.resolveWith(
        //               (states) => RoundedRectangleBorder(
        //                 borderRadius: BorderRadius.circular(12),
        //                 side: BorderSide(color: ServiceRecieverColor.primaryColor, width: 0.5),
        //               ),
        //             ),
        //           ),
        //           child: Text(
        //             selectedTime != null ? '$selectedTime' : 'Start Time',
        //             textAlign: TextAlign.left,
        //             style: TextStyle(
        //               fontSize: 16,
        //               fontFamily: "Rubik",
        //               fontWeight: FontWeight.w400,
        //               color: CustomColors.primaryText,
        //             ),
        //           ),
        //           onPressed: () {
        //             setState(
        //               () {
        //                 displayTimeDialog();
        //               },
        //             );
        //           },
        //         ),
        //       ),
        //       // Duration
        //       Container(
        //         height: 50,
        //         margin: const EdgeInsets.only(bottom: 0, top: 15),
        //         child: Center(
        //           child: DecoratedBox(
        //             decoration: BoxDecoration(
        //               // color: CustomColors.myJobDetail,
        //               border: Border.all(color: ServiceRecieverColor.primaryColor, width: 0.5),
        //               borderRadius: BorderRadius.circular(12),
        //             ),
        //             child: Padding(
        //               padding: const EdgeInsets.symmetric(
        //                 horizontal: 10,
        //                 vertical: 4,
        //               ),
        //               child: DropdownButtonHideUnderline(
        //                 child: DropdownButton(
        //                   hint: Text(
        //                     "Duration",
        //                     style: TextStyle(
        //                       fontSize: 12,
        //                       fontFamily: "Rubik",
        //                       fontWeight: FontWeight.w600,
        //                       color: CustomColors.primaryText,
        //                     ),
        //                   ),
        //                   isExpanded: true,
        //                   items: hours!.map((item) {
        //                     return DropdownMenuItem(
        //                       value: item['id'].toString(),
        //                       child: Text(item['name']),
        //                     );
        //                   }).toList(),
        //                   onChanged: (newVal) {
        //                     setState(() {
        //                       selectedHours = newVal;
        //                     });
        //                   },
        //                   value: selectedHours,
        //                 ),
        //               ),
        //             ),
        //           ),
        //         ),
        //       ),
        //       // AddBtn
        //       GestureDetector(
        //         onTap: () {
        //           String startDate = startDateController.text.trim();
        //           String time = selectedTime.toString();
        //           setState(() {
        //             dateMapList.add(startDate);
        //             startTimeMapList.add(time);
        //             durationMapList.add(selectedHours);
        //             seniorCareDays.add(
        //               {
        //                 "starting_date": startDate,
        //                 "starting_time": time,
        //                 "duration": selectedHours,
        //               },
        //             );
        //           });
        //         },
        //         child: Container(
        //           width: MediaQuery.of(context).size.width,
        //           height: 50,
        //           margin: const EdgeInsets.only(top: 20),
        //           decoration: BoxDecoration(
        //             gradient: LinearGradient(
        //               begin: Alignment.center,
        //               end: Alignment.center,
        //               colors: [
        //                 ServiceRecieverColor.redButton.withOpacity(0.1),
        //                 ServiceRecieverColor.redButton.withOpacity(0.8),
        //               ],
        //             ),
        //             color: ServiceRecieverColor.redButton,
        //             boxShadow: const [
        //               BoxShadow(
        //                 color: Color.fromARGB(13, 0, 0, 0),
        //                 blurRadius: 4.0,
        //                 spreadRadius: 2.0,
        //                 offset: Offset(2.0, 2.0),
        //               ),
        //             ],
        //             borderRadius: BorderRadius.circular(6),
        //           ),
        //           child: Center(
        //             child: Text(
        //               "Add More Days",
        //               style: TextStyle(
        //                 color: CustomColors.white,
        //                 fontSize: 16,
        //                 fontWeight: FontWeight.w600,
        //                 fontFamily: "Rubik",
        //               ),
        //             ),
        //           ),
        //         ),
        //       ),
        //     ],
        //   ),
        // ),
        // const SizedBox(height: 20),
        // // Show Days
        // ListView.builder(
        //     shrinkWrap: true,
        //     scrollDirection: Axis.vertical,
        //     physics: const NeverScrollableScrollPhysics(),
        //     itemCount: seniorCareDays.length,
        //     itemBuilder: (context, index) {
        //       return SizedBox(
        //         width: MediaQuery.of(context).size.width,
        //         height: 95,
        //         child: Stack(
        //           children: [
        //             Container(
        //               padding: const EdgeInsets.symmetric(
        //                 horizontal: 10,
        //                 vertical: 10,
        //               ),
        //               decoration: BoxDecoration(
        //                 color: Colors.white,
        //                 borderRadius: BorderRadius.circular(12),
        //                 boxShadow: [
        //                   BoxShadow(
        //                     color: Colors.grey.shade300,
        //                     spreadRadius: 01,
        //                     blurRadius: 05,
        //                   ),
        //                 ],
        //               ),
        //               height: 85,
        //               width: MediaQuery.of(context).size.width,
        //               child: Column(
        //                 children: [
        //                   Row(
        //                     children: [
        //                       const Text("Date: "),
        //                       Expanded(
        //                         child: Text(
        //                           seniorCareDays[index]['starting_date'].toString(),
        //                         ),
        //                       ),
        //                     ],
        //                   ),
        //                   Row(
        //                     children: [
        //                       const Text("Time: "),
        //                       Expanded(
        //                         child: Text("${seniorCareDays[index]['starting_time']}"),
        //                       ),
        //                     ],
        //                   ),
        //                   Row(
        //                     children: [
        //                       const Text("Duration: "),
        //                       Expanded(
        //                         child: Text("${seniorCareDays[index]['duration']} hours"),
        //                       ),
        //                     ],
        //                   ),
        //                 ],
        //               ),
        //             ),
        //             Positioned(
        //               top: 00,
        //               right: 0,
        //               child: GestureDetector(
        //                 onTap: (() {
        //                   setState(() {
        //                     seniorCareDays.removeAt(index);
        //                     startTimeMapList.removeAt(index);
        //                     dateMapList.removeAt(index);
        //                     durationMapList.removeAt(index);
        //                   });
        //                 }),
        //                 child: Container(
        //                   decoration: BoxDecoration(
        //                     borderRadius: const BorderRadius.only(
        //                       topLeft: Radius.circular(100),
        //                       bottomLeft: Radius.circular(100),
        //                       bottomRight: Radius.circular(100),
        //                       topRight: Radius.circular(100),
        //                     ),
        //                     color: CustomColors.white,
        //                     boxShadow: const [
        //                       BoxShadow(
        //                         color: Color.fromARGB(13, 0, 0, 0),
        //                         blurRadius: 4.0,
        //                         spreadRadius: 2.0,
        //                         offset: Offset(2.0, 2.0),
        //                       ),
        //                     ],
        //                   ),
        //                   // alignment: Alignment.center,
        //                   width: 30,
        //                   height: 30,
        //                   child: const Icon(
        //                     Icons.close,
        //                     size: 16,
        //                   ),
        //                 ),
        //               ),
        //             ),
        //           ],
        //         ),
        //       );
        //     }),
        // Pet type
        const SizedBox(height: 20),
        Container(
          alignment: Alignment.topLeft,
          child: const Text(
            "Pet Type",
            style: TextStyle(
              fontWeight: FontWeight.w600,
              // color: ServiceRecieverColor.primaryColor,
              fontFamily: "Rubik",
              fontSize: 14,
            ),
          ),
        ),
        const SizedBox(height: 10),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: petType.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            childAspectRatio: (1.8),
            crossAxisCount: 3,
            crossAxisSpacing: 3,
            mainAxisSpacing: 12,
          ),
          itemBuilder: (BuildContext context, int index) {
            return GestureDetector(
              onTap: () {
                setState(() {
                  selectedIndex = index;
                });
                if (selectedIndex == 4) {
                  otherField = 1;
                } else {
                  otherField = 0;
                }
                if (selectedIndex == 0) {
                  petTypeValue = "Dog";
                } else if (selectedIndex == 1) {
                  petTypeValue = "Cat";
                } else if (selectedIndex == 2) {
                  petTypeValue = "Fish";
                } else if (selectedIndex == 3) {
                  petTypeValue = "Small Rodents";
                } else if (selectedIndex == 4) {
                  petTypeValue = otherFieldController.text.toString();
                }
              },
              child: Container(
                margin: const EdgeInsets.only(right: 10),
                decoration: BoxDecoration(
                  color: selectedIndex == index ? ServiceRecieverColor.primaryColor : Colors.grey.shade200,
                  border: Border.all(
                    width: .5,
                    color: const Color.fromRGBO(103, 114, 148, 0.1),
                  ),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Center(
                  child: Text(
                    petType[index],
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: selectedIndex == index ? FontWeight.w600 : FontWeight.w400,
                      fontFamily: "Rubik",
                      color: selectedIndex == index ? CustomColors.white : Colors.black,
                    ),
                  ),
                ),
              ),
            );
          },
        ),
        // Other Field
        const SizedBox(height: 20),
        if (otherField == 1) ...[
          SizedBox(
            height: 45,
            child: TextFormField(
              keyboardType: TextInputType.name,
              controller: otherFieldController,
              style: const TextStyle(
                fontSize: 12,
                fontFamily: "Rubik",
                fontWeight: FontWeight.w600,
              ),
              onChanged: (value) {
                petTypeValue = value;
              },
              textAlignVertical: TextAlignVertical.center,
              decoration: inputdecoration("Please enter details here"),
            ),
          ),
        ],
        // Number of Pets
        const SizedBox(height: 20),
        Container(
          alignment: Alignment.topLeft,
          child: const Text(
            "Number of Pets",
            style: TextStyle(
              fontWeight: FontWeight.w600,
              // color: ServiceRecieverColor.primaryColor,
              fontFamily: "Rubik",
              fontSize: 14,
            ),
          ),
        ),
        const SizedBox(height: 10),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: petNumber.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            childAspectRatio: (1.8),
            crossAxisCount: 4,
            crossAxisSpacing: 3,
            mainAxisSpacing: 12,
          ),
          itemBuilder: (BuildContext context, int index) {
            return GestureDetector(
              onTap: () {
                setState(() {
                  selectedNumberIndex = index;
                });
                if (selectedNumberIndex == 0) {
                  numberOfPetValue = 1;
                } else if (selectedNumberIndex == 1) {
                  numberOfPetValue = 2;
                } else if (selectedNumberIndex == 2) {
                  numberOfPetValue = 3;
                }
              },
              child: Container(
                margin: const EdgeInsets.only(right: 10),
                decoration: BoxDecoration(
                  color: selectedNumberIndex == index ? ServiceRecieverColor.primaryColor : Colors.grey.shade200,
                  border: Border.all(
                    width: .5,
                    color: const Color.fromRGBO(103, 114, 148, 0.1),
                  ),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Center(
                  child: Text(
                    petNumber[index],
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: selectedNumberIndex == index ? FontWeight.w600 : FontWeight.w400,
                      fontFamily: "Rubik",
                      color: selectedNumberIndex == index ? CustomColors.white : Colors.black,
                    ),
                  ),
                ),
              ),
            );
          },
        ),
        // Pet Breed
        const SizedBox(height: 20),
        Container(
          alignment: Alignment.topLeft,
          child: const Text(
            "Pet Breed",
            style: TextStyle(
              fontWeight: FontWeight.w600,
              // color: ServiceRecieverColor.primaryColor,
              fontFamily: "Rubik",
              fontSize: 14,
            ),
          ),
        ),
        const SizedBox(height: 10),
        SizedBox(
          height: 45,
          child: TextFormField(
            keyboardType: TextInputType.name,
            controller: petBreedController,
            style: const TextStyle(
              fontSize: 12,
              fontFamily: "Rubik",
              fontWeight: FontWeight.w600,
            ),
            textAlignVertical: TextAlignVertical.center,
            decoration: inputdecoration("Pet Breed"),
          ),
        ),
        // Size Of Pet
        const SizedBox(height: 20),
        Container(
          alignment: Alignment.topLeft,
          child: const Text(
            "Size Of Pet",
            style: TextStyle(
              fontWeight: FontWeight.w600,
              // color: ServiceRecieverColor.primaryColor,
              fontFamily: "Rubik",
              fontSize: 14,
            ),
          ),
        ),
        const SizedBox(height: 10),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: sizeOfPet.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            childAspectRatio: (1.8),
            crossAxisCount: 4,
            crossAxisSpacing: 3,
            mainAxisSpacing: 12,
          ),
          itemBuilder: (BuildContext context, int index) {
            return GestureDetector(
              onTap: () {
                setState(() {
                  selectedSize = index;
                });
                if (selectedSize == 0) {
                  sizeOfPetValue = "Small";
                } else if (selectedSize == 1) {
                  sizeOfPetValue = "Medium";
                } else if (selectedSize == 2) {
                  sizeOfPetValue = "Large";
                }
              },
              child: Container(
                margin: const EdgeInsets.only(right: 10),
                decoration: BoxDecoration(
                  color: selectedSize == index ? ServiceRecieverColor.primaryColor : Colors.grey.shade200,
                  border: Border.all(
                    width: .5,
                    color: const Color.fromRGBO(103, 114, 148, 0.1),
                  ),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Center(
                  child: Text(
                    sizeOfPet[index],
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: selectedSize == index ? FontWeight.w600 : FontWeight.w400,
                      fontFamily: "Rubik",
                      color: selectedSize == index ? CustomColors.white : Colors.black,
                    ),
                  ),
                ),
              ),
            );
          },
        ),
        // Temperament
        const SizedBox(height: 20),
        Container(
          alignment: Alignment.topLeft,
          child: const Text(
            "Temperament",
            style: TextStyle(
              fontWeight: FontWeight.w600,
              // color: ServiceRecieverColor.primaryColor,
              fontFamily: "Rubik",
              fontSize: 14,
            ),
          ),
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            Expanded(
              flex: 5,
              child: TextButton(
                onPressed: () {
                  setState(() {
                    selectedTemperament = 0;
                    temperamentValue = "Friendly/Socialized";
                    otherGuarded = 0;
                  });
                },
                style: ButtonStyle(
                  shape: MaterialStateProperty.resolveWith((states) => RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
                  backgroundColor: MaterialStateProperty.resolveWith(
                    (states) => selectedTemperament == 0 ? ServiceRecieverColor.primaryColor : Colors.grey.shade200,
                  ),
                ),
                child: Text(
                  temperament[0],
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: selectedTemperament == 0 ? FontWeight.w600 : FontWeight.w400,
                    fontFamily: "Rubik",
                    color: selectedTemperament == 0 ? CustomColors.white : Colors.black,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              flex: 5,
              child: TextButton(
                onPressed: () {
                  setState(() {
                    otherGuarded = 1;
                    selectedTemperament = 1;
                    temperamentValue = "Guarded";
                  });
                },
                style: ButtonStyle(
                  shape: MaterialStateProperty.resolveWith((states) => RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
                  backgroundColor: MaterialStateProperty.resolveWith(
                    (states) => selectedTemperament == 1 ? ServiceRecieverColor.primaryColor : Colors.grey.shade200,
                  ),
                ),
                child: Text(
                  temperament[1],
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: selectedTemperament == 1 ? FontWeight.w600 : FontWeight.w400,
                    fontFamily: "Rubik",
                    color: selectedTemperament == 1 ? CustomColors.white : Colors.black,
                  ),
                ),
              ),
            ),
          ],
        ),
        // if Guarded Selected
        const SizedBox(height: 10),
        if (otherGuarded == 1) ...[
          Row(
            children: [
              Expanded(
                flex: 5,
                child: TextButton(
                  onPressed: () {
                    setState(() {
                      selectedGuarded = 0;
                      temperamentValue = "With People";
                    });
                  },
                  style: ButtonStyle(
                    shape: MaterialStateProperty.resolveWith((states) => RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
                    backgroundColor: MaterialStateProperty.resolveWith(
                      (states) => selectedGuarded == 0 ? ServiceRecieverColor.primaryColor : Colors.grey.shade200,
                    ),
                  ),
                  child: Text(
                    guarded[0],
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: selectedGuarded == 0 ? FontWeight.w600 : FontWeight.w400,
                      fontFamily: "Rubik",
                      color: selectedGuarded == 0 ? CustomColors.white : Colors.black,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                flex: 5,
                child: TextButton(
                  onPressed: () {
                    setState(() {
                      selectedGuarded = 1;
                      temperamentValue = "With Other Animals";
                    });
                  },
                  style: ButtonStyle(
                    shape: MaterialStateProperty.resolveWith((states) => RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
                    backgroundColor: MaterialStateProperty.resolveWith(
                      (states) => selectedGuarded == 1 ? ServiceRecieverColor.primaryColor : Colors.grey.shade200,
                    ),
                  ),
                  child: Text(
                    guarded[1],
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: selectedGuarded == 1 ? FontWeight.w600 : FontWeight.w400,
                      fontFamily: "Rubik",
                      color: selectedGuarded == 1 ? CustomColors.white : Colors.black,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
        // Need Assistance
        const SizedBox(height: 20),
        Container(
          alignment: Alignment.topLeft,
          child: const Text(
            "Need Assistance",
            style: TextStyle(
              fontWeight: FontWeight.w600,
              // color: ServiceRecieverColor.primaryColor,
              fontFamily: "Rubik",
              fontSize: 14,
            ),
          ),
        ),
        const SizedBox(height: 10),
        CheckTileContainer(
          title: "Walking (frequency & duration)",
          checked: isChecked,
          onChanged: (newValue) {
            setState(() {
              isChecked = newValue!;
              if (newValue == false) {
                walking = "0";
              } else {
                walking = "1";
              }
            });
          },
          onTap: () {
            setState(() {
              isChecked = !isChecked;
              if (isChecked == false) {
                walking = "0";
              } else {
                walking = "1";
              }
            });
          },
        ),
        CheckTileContainer(
          title: "Day Care",
          checked: isChecked2,
          onChanged: (newValue) {
            setState(() {
              isChecked2 = newValue!;
              if (newValue == false) {
                dayCare = "0";
              } else {
                dayCare = "1";
              }
            });
          },
          onTap: () {
            setState(() {
              isChecked2 = !isChecked2;
              if (isChecked2 == false) {
                dayCare = "0";
              } else {
                dayCare = "1";
              }
            });
          },
        ),
        CheckTileContainer(
          title: "Feeding (frequency & duration)",
          checked: isChecked3,
          onChanged: (newValue) {
            setState(() {
              isChecked3 = newValue!;
              if (newValue == false) {
                feeding = "0";
              } else {
                feeding = "1";
              }
            });
          },
          onTap: () {
            setState(() {
              isChecked3 = !isChecked3;
              if (isChecked3 == false) {
                feeding = "0";
              } else {
                feeding = "1";
              }
            });
          },
        ),
        CheckTileContainer(
          title: "Socialization/ Obedience training",
          checked: isChecked4,
          onChanged: (newValue) {
            setState(() {
              isChecked4 = newValue!;
              if (newValue == false) {
                socialization = "0";
              } else {
                socialization = "1";
              }
            });
          },
          onTap: () {
            setState(() {
              isChecked4 = !isChecked4;
              if (isChecked4 == false) {
                socialization = "0";
              } else {
                socialization = "1";
              }
            });
          },
        ),
        CheckTileContainer(
          title: "Grooming",
          checked: isChecked5,
          onChanged: (newValue) {
            setState(() {
              isChecked5 = newValue!;
              if (newValue == false) {
                grooming_hair_and_nail_trimming = "0";
              } else {
                grooming_hair_and_nail_trimming = "1";
              }
            });
          },
          onTap: () {
            setState(() {
              isChecked5 = !isChecked5;
              if (isChecked5 == false) {
                grooming_hair_and_nail_trimming = "0";
              } else {
                grooming_hair_and_nail_trimming = "1";
              }
            });
          },
        ),
        CheckTileContainer(
          title: "Boarding/Overnight pet sitting",
          checked: isChecked6,
          onChanged: (newValue) {
            setState(() {
              isChecked6 = newValue!;
              if (newValue == false) {
                boarding = "0";
              } else {
                boarding = "1";
              }
            });
          },
          onTap: () {
            setState(() {
              isChecked6 = !isChecked6;
              if (isChecked6 == false) {
                boarding = "0";
              } else {
                boarding = "1";
              }
            });
          },
        ),
        //Additional Info (optional)
        const SizedBox(height: 20),
        Container(
          alignment: Alignment.topLeft,
          child: const Text(
            "Additional Info (optional)",
            style: TextStyle(
              fontWeight: FontWeight.w600,
              // color: ServiceRecieverColor.primaryColor,
              fontFamily: "Rubik",
              fontSize: 14,
            ),
          ),
        ),
        const SizedBox(height: 10),
        SizedBox(
          height: 120,
          child: TextFormField(
            controller: additionalInfoController,
            style: const TextStyle(
              fontSize: 12,
              fontFamily: "Rubik",
              fontWeight: FontWeight.w600,
            ),
            textAlignVertical: TextAlignVertical.center,
            maxLines: 5,
            decoration: inputdecoration("Additional Info (optional)"),
          ),
        ),
        // btn
        const SizedBox(height: 20),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 0),
          child: GestureDetector(
            onTap: () async {
              if (jobTitleController.text.isEmpty) {
                customErrorSnackBar(context, "Job Title is Required");
              } else if (addressController.text.isEmpty) {
                customErrorSnackBar(context, "Job Location is Required");
              } else if (selectedLocation == null) {
                customErrorSnackBar(context, "Job Area is Required");
              } else if (hourlyController.text.isEmpty) {
                customErrorSnackBar(context, "Hourly Rate is Required");
              } else if (seniorCareDays.isEmpty) {
                customErrorSnackBar(context, "Please Enter Add Days");
              } else if (other == "1" && otherFieldController.text.isEmpty) {
                customErrorSnackBar(context, "Other is Required");
              } else if (petTypeValue == null) {
                customErrorSnackBar(context, "Pet Type is Required");
              } else if (numberOfPetValue == null) {
                customErrorSnackBar(context, "Number of pets is Required");
              } else if (petBreedController.text.isEmpty) {
                customErrorSnackBar(context, "Pet Breed is Required");
              } else if (temperamentValue == null) {
                customErrorSnackBar(context, "Temprament is Required");
              } else {
                PostPetCare();
              }
            },
            child: Container(
              width: MediaQuery.of(context).size.width,
              height: 60,
              margin: const EdgeInsets.symmetric(vertical: 10),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.center,
                  end: Alignment.center,
                  colors: [
                    ServiceRecieverColor.redButton.withOpacity(0.1),
                    ServiceRecieverColor.redButton.withOpacity(0.8),
                  ],
                ),
                color: ServiceRecieverColor.redButton,
                boxShadow: const [
                  BoxShadow(
                    color: Color.fromARGB(13, 0, 0, 0),
                    blurRadius: 4.0,
                    spreadRadius: 2.0,
                    offset: Offset(2.0, 2.0),
                  ),
                ],
                borderRadius: BorderRadius.circular(6),
              ),
              child: Center(
                child: Text(
                  "Submit",
                  style: TextStyle(
                    color: CustomColors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.w600,
                    fontFamily: "Rubik",
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget ServiceSeniorCare(BuildContext context) {
    return Column(
      children: [
        //Senior Name
        const SizedBox(height: 20),
        Container(
          alignment: Alignment.topLeft,
          child: const Text(
            "Senior Initials",
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontFamily: "Rubik",
              fontSize: 14,
            ),
          ),
        ),
        const SizedBox(height: 10),
        SizedBox(
          height: 45,
          child: TextFormField(
            controller: seniorNameController,
            style: const TextStyle(
              fontSize: 12,
              fontFamily: "Rubik",
              fontWeight: FontWeight.w600,
              // color: ServiceRecieverColor.primaryColor,
            ),
            textAlignVertical: TextAlignVertical.center,
            maxLines: 1,
            decoration: inputdecoration("Senior Initials"),
          ),
        ),
        // Date of birth
        const SizedBox(height: 20),
        Container(
          alignment: Alignment.topLeft,
          child: const Text(
            "Date Of Birth",
            style: TextStyle(
              fontWeight: FontWeight.w600,
              // color: ServiceRecieverColor.primaryColor,
              fontFamily: "Rubik",
              fontSize: 14,
            ),
          ),
        ),
        const SizedBox(height: 10),
        SizedBox(
          height: 45,
          child: TextFormField(
            controller: dobController,
            readOnly: true,
            onChanged: (value) {
              setState(() {
                getfromPickedDate = value;
              });
            },
            onTap: () async {
              _getDobDate(context);
            },
            style: const TextStyle(
              fontSize: 12,
              fontFamily: "Rubik",
              fontWeight: FontWeight.w600,
              // color: ServiceRecieverColor.primaryColor,
            ),
            textAlignVertical: TextAlignVertical.center,
            maxLines: 1,
            decoration: inputdecoration("Date Of Birth"),
          ),
        ),
        //Medical Condition (optional)
        const SizedBox(height: 20),
        Container(
          alignment: Alignment.topLeft,
          child: const Text(
            "Medical Condition (optional)",
            style: TextStyle(
              fontWeight: FontWeight.w600,
              // color: ServiceRecieverColor.primaryColor,
              fontFamily: "Rubik",
              fontSize: 14,
            ),
          ),
        ),
        const SizedBox(height: 10),
        SizedBox(
          height: 120,
          child: TextFormField(
            controller: medicalConditionController,
            style: const TextStyle(
              fontSize: 12,
              fontFamily: "Rubik",
              fontWeight: FontWeight.w600,
            ),
            textAlignVertical: TextAlignVertical.center,
            maxLines: 5,
            decoration: inputdecoration("Medical Condition (optional)"),
          ),
        ),
        // Add Days
        const SizedBox(height: 10), addDaysColumn(context), const SizedBox(height: 10),
        // Require Assistance with
        const SizedBox(height: 30),
        Container(
          alignment: Alignment.topLeft,
          child: const Text(
            "Requires Assistance With",
            style: TextStyle(
              fontWeight: FontWeight.w600,
              // color: ServiceRecieverColor.primaryColor,
              fontFamily: "Rubik",
              fontSize: 14,
            ),
          ),
        ),
        const SizedBox(height: 10),
        // Bathing
        CheckTileContainer(
          title: "Bathing",
          checked: isChecked,
          onTap: () {
            setState(() {
              isChecked = !isChecked;
              if (isChecked == false) {
                bathing = "0";
              } else {
                bathing = "1";
              }
            });
          },
          onChanged: (value) {
            setState(() {
              isChecked = value!;
            });
          },
        ),
        //  Dressing
        CheckTileContainer(
          title: "Dressing",
          checked: isChecked2,
          onTap: () {
            setState(() {
              isChecked2 = !isChecked2;
              if (isChecked2 == false) {
                dressing = "0";
              } else {
                dressing = "1";
              }
            });
          },
          onChanged: (value) {
            setState(() {
              isChecked2 = value!;
            });
          },
        ),
        // Feeding
        CheckTileContainer(
          title: "Feeding",
          checked: isChecked3,
          onChanged: (value) {
            setState(() {
              isChecked3 = value!;
            });
          },
          onTap: () {
            setState(() {
              isChecked3 = !isChecked3;
              if (isChecked3 == false) {
                feeding = "0";
              } else {
                feeding = "1";
              }
            });
          },
        ),
        // Meal Preparation
        CheckTileContainer(
          title: "Meal Preparation",
          checked: isChecked4,
          onTap: () {
            setState(() {
              isChecked4 = !isChecked4;
              if (isChecked4 == false) {
                meal_preparation = "0";
              } else {
                meal_preparation = "1";
              }
            });
          },
          onChanged: (value) {
            setState(() {
              isChecked4 = value!;
            });
          },
        ),
        // Grocery Shopping
        CheckTileContainer(
          title: "Grocery Shopping",
          checked: isChecked5,
          onTap: () {
            setState(() {
              isChecked5 = !isChecked5;
              if (isChecked5 == false) {
                grocery_shopping = "0";
              } else {
                grocery_shopping = "1";
              }
            });
          },
          onChanged: (value) {
            setState(() {
              isChecked5 = value!;
            });
          },
        ),
        // Walking more than 10 steps
        CheckTileContainer(
          title: "Walking more than 10 steps",
          checked: isChecked6,
          onChanged: (value) {
            setState(() {
              isChecked6 = value!;
            });
          },
          onTap: () {
            setState(() {
              isChecked6 = !isChecked6;
              if (isChecked6 == false) {
                walking = "0";
              } else {
                walking = "1";
              }
            });
          },
        ),
        // Transferring from Bed to transfer
        CheckTileContainer(
          title: "Transferring from Bed to transfer ?",
          checked: isChecked7,
          onChanged: (value) {
            setState(() {
              isChecked7 = value!;
            });
          },
          onTap: () {
            setState(() {
              isChecked7 = !isChecked7;
              if (isChecked7 == false) {
                bed_transfer = "0";
              } else {
                bed_transfer = "1";
              }
            });
          },
        ),
        // Light Cleaning
        CheckTileContainer(
          title: "Light Cleaning",
          checked: isChecked8,
          onChanged: (value) {
            setState(() {
              isChecked8 = value!;
            });
          },
          onTap: () {
            setState(() {
              isChecked8 = !isChecked8;
              if (isChecked8 == false) {
                light_cleaning = "0";
              } else {
                light_cleaning = "1";
              }
            });
          },
        ),
        // Companionship
        CheckTileContainer(
          title: "Companionship",
          checked: isChecked9,
          onChanged: (value) {
            setState(() {
              isChecked9 = value!;
            });
          },
          onTap: () {
            setState(() {
              isChecked9 = !isChecked9;
              if (isChecked9 == false) {
                companionship = "0";
              } else {
                companionship = "1";
              }
            });
          },
        ),
        // Medication Administration
        CheckTileContainer(
          title: "Medication Administration",
          checked: isChecked10,
          onTap: () {
            setState(() {
              isChecked10 = !isChecked10;
              if (isChecked10 == false) {
                medication_administration = "0";
              } else {
                medication_administration = "1";
              }
            });
          },
          onChanged: (value) {
            setState(() {
              isChecked10 = value!;
            });
          },
        ),
        // Dressing wound care
        CheckTileContainer(
          title: "Dressing wound care",
          checked: isChecked11,
          onChanged: (value) {
            setState(() {
              isChecked11 = value!;
            });
          },
          onTap: () {
            setState(() {
              isChecked11 = !isChecked11;
              if (isChecked11 == false) {
                dressing_wound_care = "0";
              } else {
                dressing_wound_care = "1";
              }
            });
          },
        ),
        // Blood pressure monitoring
        CheckTileContainer(
          title: "Blood pressure monitoring",
          checked: isChecked12,
          onChanged: (value) {
            setState(() {
              isChecked12 = value!;
            });
          },
          onTap: () {
            setState(() {
              isChecked12 = !isChecked12;
              if (isChecked12 == false) {
                blood_pressure_monetoring = "0";
              } else {
                blood_pressure_monetoring = "1";
              }
            });
          },
        ),
        // Blood sugar monitoring
        CheckTileContainer(
          title: "Blood sugar monitoring",
          checked: isChecked13,
          onChanged: (value) {
            setState(() {
              isChecked13 = value!;
            });
          },
          onTap: () {
            setState(() {
              isChecked13 = !isChecked13;
              if (isChecked13 == false) {
                blood_sugar_monetoring = "0";
              } else {
                blood_sugar_monetoring = "1";
              }
            });
          },
        ),
        // Grooming Hair and Nail trimming
        CheckTileContainer(
          title: "Grooming Hair and Nail trimming",
          checked: isChecked14,
          onTap: () {
            setState(() {
              isChecked14 = !isChecked14;
              if (isChecked14 == false) {
                grooming_hair_and_nail_trimming = "0";
              } else {
                grooming_hair_and_nail_trimming = "1";
              }
            });
          },
          onChanged: (value) {
            setState(() {
              isChecked14 = value!;
            });
          },
        ),
        //Additional Info (optional)
        const SizedBox(height: 20),
        Container(
          alignment: Alignment.topLeft,
          child: const Text(
            "Additional Info (optional)",
            style: TextStyle(
              fontWeight: FontWeight.w600,
              // color: ServiceRecieverColor.primaryColor,
              fontFamily: "Rubik",
              fontSize: 14,
            ),
          ),
        ),
        const SizedBox(height: 10),
        SizedBox(
          height: 120,
          child: TextFormField(
            controller: additionalInfoController,
            style: const TextStyle(
              fontSize: 12,
              fontFamily: "Rubik",
              fontWeight: FontWeight.w600,
            ),
            textAlignVertical: TextAlignVertical.center,
            maxLines: 5,
            decoration: inputdecoration("Additional Info (optional)"),
          ),
        ),
        const SizedBox(height: 20),
        // btn
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 0),
          child: GestureDetector(
            onTap: () async {
              if (jobTitleController.text.isEmpty) {
                customErrorSnackBar(context, "Job Title is Required");
              } else if (addressController.text.isEmpty) {
                customErrorSnackBar(context, "Job Location is Required");
              } else if (selectedLocation == null) {
                customErrorSnackBar(context, "Job Area is Required");
              } else if (hourlyController.text.isEmpty) {
                customErrorSnackBar(context, "Hourly Rate is Required");
              } else if (seniorNameController.text.isEmpty) {
                customErrorSnackBar(context, "Senior Name is Required");
              } else if (dobController.text.isEmpty) {
                customErrorSnackBar(context, "DOB is Required");
              } else if (seniorCareDays.isEmpty) {
                customErrorSnackBar(context, "Please Enter Add Days");
              } else {
                PostSeniorCare();
              }
            },
            child: Container(
              width: MediaQuery.of(context).size.width,
              height: 60,
              margin: const EdgeInsets.symmetric(vertical: 10),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.center,
                  end: Alignment.center,
                  colors: [
                    ServiceRecieverColor.redButton.withOpacity(0.1),
                    ServiceRecieverColor.redButton.withOpacity(0.8),
                  ],
                ),
                color: CustomColors.white,
                boxShadow: const [
                  BoxShadow(
                    color: Color.fromARGB(13, 0, 0, 0),
                    blurRadius: 4.0,
                    spreadRadius: 2.0,
                    // offset: Offset(2.0, 2.0),
                  ),
                ],
                borderRadius: BorderRadius.circular(6),
              ),
              child: Center(
                child: Text(
                  "Submit",
                  style: TextStyle(
                    color: CustomColors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.w600,
                    fontFamily: "Rubik",
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  InputDecoration inputdecoration(hint) {
    return InputDecoration(
      hintText: hint,
      hintStyle: const TextStyle(
        fontSize: 12,
        fontFamily: "Rubik",
        fontWeight: FontWeight.w600,
        // color: ServiceRecieverColor.primaryColor,
      ),
      fillColor: CustomColors.white,
      focusColor: CustomColors.white,
      hoverColor: CustomColors.white,
      filled: true,
      contentPadding: const EdgeInsets.fromLTRB(12, 4, 12, 4),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(
          color: Colors.grey,
          width: 0.5,
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: const BorderSide(
          color: Colors.grey,
          width: 0.5,
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      enabledBorder: OutlineInputBorder(
        borderSide: const BorderSide(
          color: Colors.grey,
          width: 0.5,
        ),
        borderRadius: BorderRadius.circular(12),
      ),
    );
  }
}
