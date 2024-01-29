// ignore_for_file: unused_local_variable, prefer_typing_uninitialized_variables, non_constant_identifier_names, use_build_context_synchronously, deprecated_member_use

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:island_app/providers/user_provider.dart';
import 'package:island_app/res/app_url.dart';
import 'package:island_app/utils/utils.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:island_app/carereceiver/utils/colors.dart';
import '../../widgets/custom_text_field.dart';

class Schedule extends StatefulWidget {
  final String? serviceId;
  final String? jobId;
  const Schedule({
    Key? key,
    this.serviceId,
    this.jobId,
  }) : super(key: key);

  @override
  State<Schedule> createState() => _ScheduleState();
}

class _ScheduleState extends State<Schedule> {
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
// bool _isDateSelectable(DateTime date) {
//     // Disable dates before today
//     return date.isAfter(DateTime.now());
//   }
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
              // primaryColorDark: CustomColors.primaryColor,
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
              // primaryColorDark: CustomColors.primaryColor,
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
    var token = await getUserToken();
    var formData = FormData.fromMap({
      'job_title': jobTitleController.text.toString(),
      'address': addressController.text.toString(),
      'location': locationValue.toString(),
      'hourly_rate': hourlyController.text.toString(),
      'senior_name': seniorNameController.text.toString(),
      'dob': dobController.text.toString(),
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
    var token = await getUserToken();
    var formData = FormData.fromMap(
      {
        'job_title': jobTitleController.text.toString(),
        'address': addressController.text.toString(),
        'location': locationValue.toString(),
        'hourly_rate': hourlyController.text.toString(),
        'pet_type': petTypeValue.toString(),
        'number_of_pets': numberOfPetValue.toString(),
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
      } catch (e) {
        customErrorSnackBar(context, e.toString());
      }
    } else {
      customErrorSnackBar(context, "Please Subscribe Package First");
    }
  }

  PostHouseKeeping() async {
    var token = await getUserToken();
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
    var token = await getUserToken();
    var formData = FormData.fromMap(
      {
        'job_title': jobTitleController.text.toString(),
        'address': addressController.text.toString(),
        'location': locationValue.toString(),
        'hourly_rate': int.parse(hourlyController.text),
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
    var token = await getUserToken();
    var formData = FormData.fromMap(
      {
        'job_title': jobTitleController.text.toString(),
        'address': addressController.text.toString(),
        'location': locationValue.toString(),
        'hourly_rate': hourlyController.text.toString(),
        'interest_for_child': interestForChildController.text.toString(),
        'cost_range': costRangeOfCampController.text.toString(),
        "date[]": dateMapList,
        "start_time[]": startTimeMapList,
        "duration[]": durationMapList,
        "name[]": childnameMapList,
        "age[]": childageMapList,
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
            (widget.serviceId == "1")
                ? "Senior Care"
                : (widget.serviceId == "2")
                    ? "Pet Care"
                    : (widget.serviceId == "3")
                        ? "House Keeping"
                        : (widget.serviceId == "4")
                            ? "Child Care"
                            : (widget.serviceId == "5")
                                ? "School Support"
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
                const SizedBox(
                  height: 20,
                ),
                // Switch View,
                SizedBox(
                  child: Column(
                    children: [
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
                        ServiceChildCare(context),
                      ] else if (widget.serviceId == "5") ...[
                        // Service Id 5
                        ServiceSchoolSupport(context),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget ServiceChildCare(BuildContext context) {
    return Column(
      children: [
        const SizedBox(
          height: 30,
        ),
        //Job Title
        Container(
          alignment: Alignment.topLeft,
          child: Text(
            "Job Title",
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: CustomColors.primaryColor,
              fontFamily: "Rubik",
              fontSize: 14,
            ),
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        SizedBox(
          height: 45,
          child: TextFormField(
            controller: jobTitleController,
            style: TextStyle(
              fontSize: 12,
              fontFamily: "Rubik",
              fontWeight: FontWeight.w600,
              color: CustomColors.primaryColor,
            ),
            textAlignVertical: TextAlignVertical.center,
            maxLines: 1,
            decoration: InputDecoration(
              hintText: "Name",
              hintStyle: TextStyle(
                fontSize: 12,
                fontFamily: "Rubik",
                fontWeight: FontWeight.w600,
                color: CustomColors.primaryColor,
              ),
              fillColor: CustomColors.white,
              focusColor: CustomColors.white,
              hoverColor: CustomColors.white,
              filled: true,
              contentPadding: const EdgeInsets.fromLTRB(12, 4, 12, 4),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(2),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: CustomColors.borderLight,
                  width: 0.5,
                ),
                borderRadius: BorderRadius.circular(2.0),
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: CustomColors.borderLight,
                  width: 0.5,
                ),
                borderRadius: BorderRadius.circular(2.0),
              ),
            ),
          ),
        ),
        //Parish
        const SizedBox(height: 20),
        Container(
          alignment: Alignment.topLeft,
          child: Text(
            "Job Location",
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: CustomColors.primaryColor,
              fontFamily: "Rubik",
              fontSize: 14,
            ),
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        SizedBox(
          height: 45,
          child: TextFormField(
            controller: addressController,
            style: TextStyle(
              fontSize: 12,
              fontFamily: "Rubik",
              fontWeight: FontWeight.w600,
              color: CustomColors.primaryColor,
            ),
            textAlignVertical: TextAlignVertical.center,
            maxLines: 1,
            decoration: InputDecoration(
              hintText: "Job Location",
              hintStyle: TextStyle(
                fontSize: 12,
                fontFamily: "Rubik",
                fontWeight: FontWeight.w600,
                color: CustomColors.primaryColor,
              ),
              fillColor: CustomColors.white,
              focusColor: CustomColors.white,
              hoverColor: CustomColors.white,
              filled: true,
              contentPadding: const EdgeInsets.fromLTRB(12, 4, 12, 4),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(2),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: CustomColors.borderLight,
                  width: 0.5,
                ),
                borderRadius: BorderRadius.circular(2.0),
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: CustomColors.borderLight,
                  width: 0.5,
                ),
                borderRadius: BorderRadius.circular(2.0),
              ),
            ),
          ),
        ),
        //Location
        const SizedBox(height: 20),
        Container(
          alignment: Alignment.topLeft,
          child: Text(
            "Job Area",
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: CustomColors.primaryColor,
              fontFamily: "Rubik",
              fontSize: 14,
            ),
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        SizedBox(
          height: 45,
          child: Center(
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: Colors.transparent,
                border: Border.all(color: CustomColors.borderLight, width: 0.5),
                borderRadius: BorderRadius.circular(2),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton(
                    hint: Text(
                      "Select Area",
                      style: TextStyle(
                        fontSize: 12,
                        fontFamily: "Rubik",
                        fontWeight: FontWeight.w600,
                        color: CustomColors.primaryColor,
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
          child: Text(
            "Hourly Rate",
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: CustomColors.primaryColor,
              fontFamily: "Rubik",
              fontSize: 14,
            ),
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        SizedBox(
          height: 45,
          child: TextFormField(
            keyboardType: TextInputType.number,
            controller: hourlyController,
            style: TextStyle(
              fontSize: 12,
              fontFamily: "Rubik",
              fontWeight: FontWeight.w600,
              color: CustomColors.primaryColor,
            ),
            textAlignVertical: TextAlignVertical.center,
            maxLines: 1,
            decoration: InputDecoration(
              hintText: "Please enter hourly rate",
              hintStyle: TextStyle(
                fontSize: 12,
                fontFamily: "Rubik",
                fontWeight: FontWeight.w600,
                color: CustomColors.primaryColor,
              ),
              fillColor: CustomColors.white,
              focusColor: CustomColors.white,
              hoverColor: CustomColors.white,
              filled: true,
              contentPadding: const EdgeInsets.fromLTRB(12, 4, 12, 4),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(2),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: CustomColors.borderLight,
                  width: 0.5,
                ),
                borderRadius: BorderRadius.circular(2.0),
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: CustomColors.borderLight,
                  width: 0.5,
                ),
                borderRadius: BorderRadius.circular(2.0),
              ),
            ),
          ),
        ),
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
                offset: Offset(0, 4),
                blurRadius: 3,
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
                  textAlignVertical: TextAlignVertical.bottom,
                  maxLines: 1,
                  decoration: InputDecoration(
                    hintText: "Child Name",
                    fillColor: CustomColors.myJobDetail,
                    focusColor: CustomColors.white,
                    hoverColor: CustomColors.white,
                    filled: true,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(6),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: CustomColors.white,
                        width: 0.0,
                      ),
                      borderRadius: BorderRadius.circular(6.0),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: CustomColors.white,
                        width: 0.0,
                      ),
                      borderRadius: BorderRadius.circular(6.0),
                    ),
                  ),
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
                  controller: childrenAgeController,
                  keyboardType: TextInputType.number,
                  style: const TextStyle(
                    fontSize: 16,
                    fontFamily: "Rubik",
                    fontWeight: FontWeight.w400,
                  ),
                  textAlignVertical: TextAlignVertical.bottom,
                  maxLines: 1,
                  decoration: InputDecoration(
                    hintText: "Child Age",
                    fillColor: CustomColors.myJobDetail,
                    focusColor: CustomColors.white,
                    hoverColor: CustomColors.white,
                    filled: true,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(6),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: CustomColors.white,
                        width: 0.0,
                      ),
                      borderRadius: BorderRadius.circular(6.0),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: CustomColors.white,
                        width: 0.0,
                      ),
                      borderRadius: BorderRadius.circular(6.0),
                    ),
                  ),
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
                  textAlignVertical: TextAlignVertical.bottom,
                  maxLines: 1,
                  decoration: InputDecoration(
                    hintText: "Grade Level",
                    fillColor: CustomColors.myJobDetail,
                    focusColor: CustomColors.white,
                    hoverColor: CustomColors.white,
                    filled: true,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(6),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: CustomColors.white,
                        width: 0.0,
                      ),
                      borderRadius: BorderRadius.circular(6.0),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: CustomColors.white,
                        width: 0.0,
                      ),
                      borderRadius: BorderRadius.circular(6.0),
                    ),
                  ),
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
                        const Color(0xff90EAB4).withOpacity(0.1),
                        const Color(0xff6BD294).withOpacity(0.8),
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
                                          Text("Children Name :"),
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
                                Row(
                                  children: [
                                    Container(
                                      alignment: Alignment.topLeft,
                                      width: 100,
                                      child: const Column(
                                        children: [
                                          Text("Grade Level:"),
                                        ],
                                      ),
                                    ),
                                    Expanded(
                                      child: Text("${children[index]['grade']}"),
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
                offset: Offset(0, 4),
                blurRadius: 3,
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
                decoration: BoxDecoration(
                  color: CustomColors.myJobDetail,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: CustomTextFieldWidget(
                  borderColor: CustomColors.white,
                  obsecure: false,
                  keyboardType: TextInputType.number,
                  controller: startDateController,
                  hintText: "Start Date",
                  onChanged: (value) {
                    setState(() {
                      getfromPickedDate = value;
                    });
                  },
                  onTap: () async {
                    _fromDate(context);
                  },
                ),
              ),
              //Timer

              SizedBox(
                width: MediaQuery.of(context).size.width,
                height: 50,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    alignment: Alignment.centerLeft,
                    primary: CustomColors.myJobDetail,
                    padding: const EdgeInsets.all(7),
                    textStyle: const TextStyle(fontSize: 20),
                  ),
                  child: Text(
                    selectedTime != null ? '$selectedTime' : 'Select Time',
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      fontSize: 16,
                      fontFamily: "Rubik",
                      fontWeight: FontWeight.w400,
                      color: CustomColors.primaryText,
                    ),
                  ),
                  onPressed: () {
                    setState(
                      () {
                        displayTimeDialog();
                      },
                    );
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
                      color: CustomColors.myJobDetail,
                      border: Border.all(color: CustomColors.myJobDetail, width: 0.5),
                      borderRadius: BorderRadius.circular(2),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton(
                          hint: Text(
                            "Duration in hours",
                            style: TextStyle(
                              fontSize: 12,
                              fontFamily: "Rubik",
                              fontWeight: FontWeight.w600,
                              color: CustomColors.primaryText,
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
                        const Color(0xff90EAB4).withOpacity(0.1),
                        const Color(0xff6BD294).withOpacity(0.8),
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
        // Show Days
        ListView.builder(
            shrinkWrap: true,
            scrollDirection: Axis.vertical,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: seniorCareDays.length,
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
                              children: [
                                Row(
                                  children: [
                                    Container(
                                      alignment: Alignment.topLeft,
                                      width: 100,
                                      child: const Column(
                                        children: [
                                          Text("Date"),
                                        ],
                                      ),
                                    ),
                                    Expanded(
                                      child: Text(
                                        seniorCareDays[index]['starting_date'].toString(),
                                        style: TextStyle(
                                          fontSize: 15,
                                          color: CustomColors.primaryText,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
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
                                          Text("Time:"),
                                        ],
                                      ),
                                    ),
                                    Expanded(
                                      child: Text("${seniorCareDays[index]['starting_time']}"),
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
                                          Text("Duration:"),
                                        ],
                                      ),
                                    ),
                                    Expanded(
                                      child: Text("${seniorCareDays[index]['duration']} hours"),
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
                          seniorCareDays.removeAt(index);
                          startTimeMapList.removeAt(index);
                          dateMapList.removeAt(index);
                          durationMapList.removeAt(index);
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
        //Need Assistance
        const SizedBox(height: 20),
        Container(
          alignment: Alignment.topLeft,
          child: Text(
            "Need Assistance",
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: CustomColors.primaryColor,
              fontFamily: "Rubik",
              fontSize: 14,
            ),
          ),
        ),
        const SizedBox(
          height: 10,
        ),
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
        other == "1"
            ? SizedBox(
                height: 45,
                child: TextFormField(
                  onChanged: (value) {
                    other = value;
                  },
                  controller: otherFieldController,
                  style: TextStyle(
                    fontSize: 12,
                    fontFamily: "Rubik",
                    fontWeight: FontWeight.w600,
                    color: CustomColors.primaryColor,
                  ),
                  textAlignVertical: TextAlignVertical.center,
                  maxLines: 1,
                  decoration: InputDecoration(
                    hintText: "Please enter detail here",
                    hintStyle: TextStyle(
                      fontSize: 12,
                      fontFamily: "Rubik",
                      fontWeight: FontWeight.w600,
                      color: CustomColors.primaryColor,
                    ),
                    fillColor: CustomColors.white,
                    focusColor: CustomColors.white,
                    hoverColor: CustomColors.white,
                    filled: true,
                    contentPadding: const EdgeInsets.fromLTRB(12, 4, 12, 4),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(2),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: CustomColors.borderLight,
                        width: 0.5,
                      ),
                      borderRadius: BorderRadius.circular(2.0),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: CustomColors.borderLight,
                        width: 0.5,
                      ),
                      borderRadius: BorderRadius.circular(2.0),
                    ),
                  ),
                ),
              )
            : Container(),

        // Learning Style
        const SizedBox(height: 20),
        Container(
          alignment: Alignment.topLeft,
          child: Text(
            "Learning Style",
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: CustomColors.primaryColor,
              fontFamily: "Rubik",
              fontSize: 14,
            ),
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        SizedBox(
          height: 45,
          child: TextFormField(
            keyboardType: TextInputType.name,
            controller: learningStyleController,
            style: TextStyle(
              fontSize: 12,
              fontFamily: "Rubik",
              fontWeight: FontWeight.w600,
              color: CustomColors.primaryColor,
            ),
            textAlignVertical: TextAlignVertical.bottom,
            decoration: InputDecoration(
              hintText: "Learning Style",
              hintStyle: TextStyle(
                fontSize: 12,
                fontFamily: "Rubik",
                fontWeight: FontWeight.w600,
                color: CustomColors.primaryColor,
              ),
              fillColor: CustomColors.white,
              focusColor: CustomColors.white,
              hoverColor: CustomColors.white,
              filled: true,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(2),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: CustomColors.borderLight,
                  width: 0.5,
                ),
                borderRadius: BorderRadius.circular(2.0),
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: CustomColors.borderLight,
                  width: 0.5,
                ),
                borderRadius: BorderRadius.circular(2.0),
              ),
            ),
          ),
        ),
        // Learning Style
        const SizedBox(height: 20),
        Container(
          alignment: Alignment.topLeft,
          child: Text(
            "Learning Challenge",
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: CustomColors.primaryColor,
              fontFamily: "Rubik",
              fontSize: 14,
            ),
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        SizedBox(
          height: 100,
          child: TextFormField(
            keyboardType: TextInputType.name,
            controller: learningChallengeController,
            style: TextStyle(
              fontSize: 12,
              fontFamily: "Rubik",
              fontWeight: FontWeight.w600,
              color: CustomColors.primaryColor,
            ),
            textAlignVertical: TextAlignVertical.bottom,
            maxLines: 5,
            decoration: InputDecoration(
              hintText: "Learning Challenge",
              hintStyle: TextStyle(
                fontSize: 12,
                fontFamily: "Rubik",
                fontWeight: FontWeight.w600,
                color: CustomColors.primaryColor,
              ),
              fillColor: CustomColors.white,
              focusColor: CustomColors.white,
              hoverColor: CustomColors.white,
              filled: true,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(2),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: CustomColors.borderLight,
                  width: 0.5,
                ),
                borderRadius: BorderRadius.circular(2.0),
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: CustomColors.borderLight,
                  width: 0.5,
                ),
                borderRadius: BorderRadius.circular(2.0),
              ),
            ),
          ),
        ),
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
              } else if (childrenController.text.isEmpty) {
                customErrorSnackBar(context, "Child Name is Required");
              } else if (childrenAgeController.text.isEmpty) {
                customErrorSnackBar(context, "Child Age is Required");
              } else if (gradeLevelController.text.isEmpty) {
                customErrorSnackBar(context, "Grade Level is Required");
              } else if (startDateController.text.isEmpty) {
                customErrorSnackBar(context, "Start Date is Required");
              } else if (selectedTime == null) {
                customErrorSnackBar(context, "Time is Required");
              } else if (selectedHours == null) {
                customErrorSnackBar(context, "Duration is Required");
              } else if (learningStyleController.text.isEmpty) {
                customErrorSnackBar(context, "Learning Style is Required");
              } else if (learningChallengeController.text.isEmpty) {
                customErrorSnackBar(context, "Learning Challenge is Required");
              } else {
                customSuccesSnackBar(context, "Job Created Successfully");
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
                    const Color(0xff90EAB4).withOpacity(0.1),
                    const Color(0xff6BD294).withOpacity(0.8),
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
                  "Save",
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
        const SizedBox(
          height: 30,
        ),
        //Job Title
        Container(
          alignment: Alignment.topLeft,
          child: Text(
            "Job Title",
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: CustomColors.primaryColor,
              fontFamily: "Rubik",
              fontSize: 14,
            ),
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        SizedBox(
          height: 45,
          child: TextFormField(
            controller: jobTitleController,
            style: TextStyle(
              fontSize: 12,
              fontFamily: "Rubik",
              fontWeight: FontWeight.w600,
              color: CustomColors.primaryColor,
            ),
            textAlignVertical: TextAlignVertical.center,
            maxLines: 1,
            decoration: InputDecoration(
              hintText: "Name",
              hintStyle: TextStyle(
                fontSize: 12,
                fontFamily: "Rubik",
                fontWeight: FontWeight.w600,
                color: CustomColors.primaryColor,
              ),
              fillColor: CustomColors.white,
              focusColor: CustomColors.white,
              hoverColor: CustomColors.white,
              filled: true,
              contentPadding: const EdgeInsets.fromLTRB(12, 4, 12, 4),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(2),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: CustomColors.borderLight,
                  width: 0.5,
                ),
                borderRadius: BorderRadius.circular(2.0),
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: CustomColors.borderLight,
                  width: 0.5,
                ),
                borderRadius: BorderRadius.circular(2.0),
              ),
            ),
          ),
        ),
        //Parish
        const SizedBox(height: 20),
        Container(
          alignment: Alignment.topLeft,
          child: Text(
            "Job Location",
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: CustomColors.primaryColor,
              fontFamily: "Rubik",
              fontSize: 14,
            ),
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        SizedBox(
          height: 45,
          child: TextFormField(
            controller: addressController,
            style: TextStyle(
              fontSize: 12,
              fontFamily: "Rubik",
              fontWeight: FontWeight.w600,
              color: CustomColors.primaryColor,
            ),
            textAlignVertical: TextAlignVertical.center,
            maxLines: 1,
            decoration: InputDecoration(
              hintText: "Job Location",
              hintStyle: TextStyle(
                fontSize: 12,
                fontFamily: "Rubik",
                fontWeight: FontWeight.w600,
                color: CustomColors.primaryColor,
              ),
              fillColor: CustomColors.white,
              focusColor: CustomColors.white,
              hoverColor: CustomColors.white,
              filled: true,
              contentPadding: const EdgeInsets.fromLTRB(12, 4, 12, 4),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(2),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: CustomColors.borderLight,
                  width: 0.5,
                ),
                borderRadius: BorderRadius.circular(2.0),
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: CustomColors.borderLight,
                  width: 0.5,
                ),
                borderRadius: BorderRadius.circular(2.0),
              ),
            ),
          ),
        ),
        //Location
        const SizedBox(height: 20),
        Container(
          alignment: Alignment.topLeft,
          child: Text(
            "Job Area",
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: CustomColors.primaryColor,
              fontFamily: "Rubik",
              fontSize: 14,
            ),
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        SizedBox(
          height: 45,
          child: Center(
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: Colors.transparent,
                border: Border.all(color: CustomColors.borderLight, width: 0.5),
                borderRadius: BorderRadius.circular(2),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton(
                    hint: Text(
                      "Select Area",
                      style: TextStyle(
                        fontSize: 12,
                        fontFamily: "Rubik",
                        fontWeight: FontWeight.w600,
                        color: CustomColors.primaryColor,
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
          child: Text(
            "Hourly Rate",
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: CustomColors.primaryColor,
              fontFamily: "Rubik",
              fontSize: 14,
            ),
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        SizedBox(
          height: 45,
          child: TextFormField(
            keyboardType: TextInputType.number,
            controller: hourlyController,
            style: TextStyle(
              fontSize: 12,
              fontFamily: "Rubik",
              fontWeight: FontWeight.w600,
              color: CustomColors.primaryColor,
            ),
            textAlignVertical: TextAlignVertical.center,
            maxLines: 1,
            decoration: InputDecoration(
              hintText: "Please enter hourly rate",
              hintStyle: TextStyle(
                fontSize: 12,
                fontFamily: "Rubik",
                fontWeight: FontWeight.w600,
                color: CustomColors.primaryColor,
              ),
              fillColor: CustomColors.white,
              focusColor: CustomColors.white,
              hoverColor: CustomColors.white,
              filled: true,
              contentPadding: const EdgeInsets.fromLTRB(12, 4, 12, 4),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(2),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: CustomColors.borderLight,
                  width: 0.5,
                ),
                borderRadius: BorderRadius.circular(2.0),
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: CustomColors.borderLight,
                  width: 0.5,
                ),
                borderRadius: BorderRadius.circular(2.0),
              ),
            ),
          ),
        ),

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
                offset: Offset(0, 4),
                blurRadius: 3,
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
                  textAlignVertical: TextAlignVertical.bottom,
                  maxLines: 1,
                  decoration: InputDecoration(
                    hintText: "Child Name",
                    fillColor: CustomColors.myJobDetail,
                    focusColor: CustomColors.white,
                    hoverColor: CustomColors.white,
                    filled: true,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(6),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: CustomColors.white,
                        width: 0.0,
                      ),
                      borderRadius: BorderRadius.circular(6.0),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: CustomColors.white,
                        width: 0.0,
                      ),
                      borderRadius: BorderRadius.circular(6.0),
                    ),
                  ),
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
                  controller: childrenAgeController,
                  keyboardType: TextInputType.number,
                  style: const TextStyle(
                    fontSize: 16,
                    fontFamily: "Rubik",
                    fontWeight: FontWeight.w400,
                  ),
                  textAlignVertical: TextAlignVertical.bottom,
                  maxLines: 1,
                  decoration: InputDecoration(
                    hintText: "Child Age",
                    fillColor: CustomColors.myJobDetail,
                    focusColor: CustomColors.white,
                    hoverColor: CustomColors.white,
                    filled: true,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(6),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: CustomColors.white,
                        width: 0.0,
                      ),
                      borderRadius: BorderRadius.circular(6.0),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: CustomColors.white,
                        width: 0.0,
                      ),
                      borderRadius: BorderRadius.circular(6.0),
                    ),
                  ),
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
                        const Color(0xff90EAB4).withOpacity(0.1),
                        const Color(0xff6BD294).withOpacity(0.8),
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
                                          Text("Children Name :"),
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
                offset: Offset(0, 4),
                blurRadius: 3,
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
                decoration: BoxDecoration(
                  color: CustomColors.myJobDetail,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: CustomTextFieldWidget(
                  borderColor: CustomColors.white,
                  obsecure: false,
                  keyboardType: TextInputType.number,
                  controller: startDateController,
                  hintText: "Start Date",
                  onChanged: (value) {
                    setState(() {
                      getfromPickedDate = value;
                    });
                  },
                  onTap: () async {
                    _fromDate(context);
                  },
                ),
              ),
              //Timer

              SizedBox(
                width: MediaQuery.of(context).size.width,
                height: 50,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    alignment: Alignment.centerLeft,
                    primary: CustomColors.myJobDetail,
                    padding: const EdgeInsets.all(7),
                    textStyle: const TextStyle(fontSize: 20),
                  ),
                  child: Text(
                    selectedTime != null ? '$selectedTime' : 'Select Time',
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      fontSize: 16,
                      fontFamily: "Rubik",
                      fontWeight: FontWeight.w400,
                      color: CustomColors.primaryText,
                    ),
                  ),
                  onPressed: () {
                    setState(
                      () {
                        displayTimeDialog();
                      },
                    );
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
                      color: CustomColors.myJobDetail,
                      border: Border.all(color: CustomColors.myJobDetail, width: 0.5),
                      borderRadius: BorderRadius.circular(2),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton(
                          hint: Text(
                            "Duration in hours",
                            style: TextStyle(
                              fontSize: 12,
                              fontFamily: "Rubik",
                              fontWeight: FontWeight.w600,
                              color: CustomColors.primaryText,
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
                        const Color(0xff90EAB4).withOpacity(0.1),
                        const Color(0xff6BD294).withOpacity(0.8),
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
        // Show Days
        ListView.builder(
            shrinkWrap: true,
            scrollDirection: Axis.vertical,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: seniorCareDays.length,
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
                              children: [
                                Row(
                                  children: [
                                    Container(
                                      alignment: Alignment.topLeft,
                                      width: 100,
                                      child: const Column(
                                        children: [
                                          Text("Date"),
                                        ],
                                      ),
                                    ),
                                    Expanded(
                                      child: Text(
                                        seniorCareDays[index]['starting_date'].toString(),
                                        style: TextStyle(
                                          fontSize: 15,
                                          color: CustomColors.primaryText,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
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
                                          Text("Time:"),
                                        ],
                                      ),
                                    ),
                                    Expanded(
                                      child: Text("${seniorCareDays[index]['starting_time']}"),
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
                                          Text("Duration:"),
                                        ],
                                      ),
                                    ),
                                    Expanded(
                                      child: Text("${seniorCareDays[index]['duration']} hours"),
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
                          seniorCareDays.removeAt(index);
                          startTimeMapList.removeAt(index);
                          dateMapList.removeAt(index);
                          durationMapList.removeAt(index);
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
        // Interest For Child
        const SizedBox(height: 20),
        Container(
          alignment: Alignment.topLeft,
          child: Text(
            "Interest For Child",
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: CustomColors.primaryColor,
              fontFamily: "Rubik",
              fontSize: 14,
            ),
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        SizedBox(
          height: 45,
          child: TextFormField(
            keyboardType: TextInputType.name,
            controller: interestForChildController,
            style: TextStyle(
              fontSize: 12,
              fontFamily: "Rubik",
              fontWeight: FontWeight.w600,
              color: CustomColors.primaryColor,
            ),
            textAlignVertical: TextAlignVertical.bottom,
            decoration: InputDecoration(
              hintText: "Interest For Child",
              hintStyle: TextStyle(
                fontSize: 12,
                fontFamily: "Rubik",
                fontWeight: FontWeight.w600,
                color: CustomColors.primaryColor,
              ),
              fillColor: CustomColors.white,
              focusColor: CustomColors.white,
              hoverColor: CustomColors.white,
              filled: true,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(2),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: CustomColors.borderLight,
                  width: 0.5,
                ),
                borderRadius: BorderRadius.circular(2.0),
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: CustomColors.borderLight,
                  width: 0.5,
                ),
                borderRadius: BorderRadius.circular(2.0),
              ),
            ),
          ),
        ),
        // cost rang
        const SizedBox(height: 20),
        Container(
          alignment: Alignment.topLeft,
          child: Text(
            "Cost Range Of Camp",
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: CustomColors.primaryColor,
              fontFamily: "Rubik",
              fontSize: 14,
            ),
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        SizedBox(
          height: 45,
          child: TextFormField(
            keyboardType: TextInputType.number,
            controller: costRangeOfCampController,
            style: TextStyle(
              fontSize: 12,
              fontFamily: "Rubik",
              fontWeight: FontWeight.w600,
              color: CustomColors.primaryColor,
            ),
            textAlignVertical: TextAlignVertical.bottom,
            decoration: InputDecoration(
              hintText: "Cost Range Of Camp",
              hintStyle: TextStyle(
                fontSize: 12,
                fontFamily: "Rubik",
                fontWeight: FontWeight.w600,
                color: CustomColors.primaryColor,
              ),
              fillColor: CustomColors.white,
              focusColor: CustomColors.white,
              hoverColor: CustomColors.white,
              filled: true,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(2),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: CustomColors.borderLight,
                  width: 0.5,
                ),
                borderRadius: BorderRadius.circular(2.0),
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: CustomColors.borderLight,
                  width: 0.5,
                ),
                borderRadius: BorderRadius.circular(2.0),
              ),
            ),
          ),
        ),
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
              } else if (childrenController.text.isEmpty) {
                customErrorSnackBar(context, "Child Name is Required");
              } else if (childrenAgeController.text.isEmpty) {
                customErrorSnackBar(context, "Child Age is Required");
              } else if (startDateController.text.isEmpty) {
                customErrorSnackBar(context, "Start Date is Required");
              } else if (selectedTime == null) {
                customErrorSnackBar(context, "Time is Required");
              } else if (selectedHours == null) {
                customErrorSnackBar(context, "Duration is Required");
              } else if (interestForChildController.text.isEmpty) {
                customErrorSnackBar(context, "Interest for Child is Required");
              } else if (costRangeOfCampController.text.isEmpty) {
                customErrorSnackBar(context, "Cost Range is Required");
              } else {
                customSuccesSnackBar(context, "Job Created Successfully");
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
                    const Color(0xff90EAB4).withOpacity(0.1),
                    const Color(0xff6BD294).withOpacity(0.8),
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
                  "Save",
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
        const SizedBox(
          height: 30,
        ),
        //Job Title
        Container(
          alignment: Alignment.topLeft,
          child: Text(
            "Job Title",
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: CustomColors.primaryColor,
              fontFamily: "Rubik",
              fontSize: 14,
            ),
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        SizedBox(
          height: 45,
          child: TextFormField(
            controller: jobTitleController,
            style: TextStyle(
              fontSize: 12,
              fontFamily: "Rubik",
              fontWeight: FontWeight.w600,
              color: CustomColors.primaryColor,
            ),
            textAlignVertical: TextAlignVertical.center,
            maxLines: 1,
            decoration: InputDecoration(
              hintText: "Name",
              hintStyle: TextStyle(
                fontSize: 12,
                fontFamily: "Rubik",
                fontWeight: FontWeight.w600,
                color: CustomColors.primaryColor,
              ),
              fillColor: CustomColors.white,
              focusColor: CustomColors.white,
              hoverColor: CustomColors.white,
              filled: true,
              contentPadding: const EdgeInsets.fromLTRB(12, 4, 12, 4),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(2),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: CustomColors.borderLight,
                  width: 0.5,
                ),
                borderRadius: BorderRadius.circular(2.0),
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: CustomColors.borderLight,
                  width: 0.5,
                ),
                borderRadius: BorderRadius.circular(2.0),
              ),
            ),
          ),
        ),
        //Parish
        const SizedBox(height: 20),
        Container(
          alignment: Alignment.topLeft,
          child: Text(
            "Job Location",
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: CustomColors.primaryColor,
              fontFamily: "Rubik",
              fontSize: 14,
            ),
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        SizedBox(
          height: 45,
          child: TextFormField(
            controller: addressController,
            style: TextStyle(
              fontSize: 12,
              fontFamily: "Rubik",
              fontWeight: FontWeight.w600,
              color: CustomColors.primaryColor,
            ),
            textAlignVertical: TextAlignVertical.center,
            maxLines: 1,
            decoration: InputDecoration(
              hintText: "Job Location",
              hintStyle: TextStyle(
                fontSize: 12,
                fontFamily: "Rubik",
                fontWeight: FontWeight.w600,
                color: CustomColors.primaryColor,
              ),
              fillColor: CustomColors.white,
              focusColor: CustomColors.white,
              hoverColor: CustomColors.white,
              filled: true,
              contentPadding: const EdgeInsets.fromLTRB(12, 4, 12, 4),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(2),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: CustomColors.borderLight,
                  width: 0.5,
                ),
                borderRadius: BorderRadius.circular(2.0),
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: CustomColors.borderLight,
                  width: 0.5,
                ),
                borderRadius: BorderRadius.circular(2.0),
              ),
            ),
          ),
        ),
        //Location
        const SizedBox(height: 20),
        Container(
          alignment: Alignment.topLeft,
          child: Text(
            "Job Area",
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: CustomColors.primaryColor,
              fontFamily: "Rubik",
              fontSize: 14,
            ),
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        SizedBox(
          height: 45,
          child: Center(
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: Colors.transparent,
                border: Border.all(color: CustomColors.borderLight, width: 0.5),
                borderRadius: BorderRadius.circular(2),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton(
                    hint: Text(
                      "Select Area",
                      style: TextStyle(
                        fontSize: 12,
                        fontFamily: "Rubik",
                        fontWeight: FontWeight.w600,
                        color: CustomColors.primaryColor,
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
          child: Text(
            "Hourly Rate",
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: CustomColors.primaryColor,
              fontFamily: "Rubik",
              fontSize: 14,
            ),
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        SizedBox(
          height: 45,
          child: TextFormField(
            keyboardType: TextInputType.number,
            controller: hourlyController,
            style: TextStyle(
              fontSize: 12,
              fontFamily: "Rubik",
              fontWeight: FontWeight.w600,
              color: CustomColors.primaryColor,
            ),
            textAlignVertical: TextAlignVertical.bottom,
            decoration: InputDecoration(
              hintText: "\$10",
              hintStyle: TextStyle(
                fontSize: 12,
                fontFamily: "Rubik",
                fontWeight: FontWeight.w600,
                color: CustomColors.primaryColor,
              ),
              fillColor: CustomColors.white,
              focusColor: CustomColors.white,
              hoverColor: CustomColors.white,
              filled: true,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(2),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: CustomColors.borderLight,
                  width: 0.5,
                ),
                borderRadius: BorderRadius.circular(2.0),
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: CustomColors.borderLight,
                  width: 0.5,
                ),
                borderRadius: BorderRadius.circular(2.0),
              ),
            ),
          ),
        ),
        // Cleaning type
        const SizedBox(height: 20),
        Container(
          alignment: Alignment.topLeft,
          child: Text(
            "Cleaning Type",
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: CustomColors.primaryColor,
              fontFamily: "Rubik",
              fontSize: 14,
            ),
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: cleaningType.length,
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
                  selectedCleaning = index;
                });
                if (selectedCleaning == 0) {
                  cleaningTypeValue = "Light Cleaning";
                } else if (selectedCleaning == 1) {
                  cleaningTypeValue = "Deep Cleaning";
                }
              },
              child: Container(
                margin: const EdgeInsets.only(right: 10),
                decoration: BoxDecoration(
                  color: selectedCleaning == index ? CustomColors.primaryColor : const Color.fromRGBO(14, 190, 127, 0.08),
                  border: Border.all(
                    width: .5,
                    color: const Color.fromRGBO(103, 114, 148, 0.1),
                  ),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Center(
                  child: Text(
                    cleaningType[index],
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      fontFamily: "Rubik",
                      color: selectedCleaning == index ? CustomColors.white : CustomColors.primaryColor,
                    ),
                  ),
                ),
              ),
            );
          },
        ),
        // Add Days
        const SizedBox(height: 20),
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
                offset: Offset(0, 4),
                blurRadius: 3,
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
                decoration: BoxDecoration(
                  color: CustomColors.myJobDetail,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: CustomTextFieldWidget(
                  borderColor: CustomColors.white,
                  obsecure: false,
                  keyboardType: TextInputType.number,
                  controller: startDateController,
                  hintText: "Start Date",
                  onChanged: (value) {
                    setState(() {
                      getfromPickedDate = value;
                    });
                  },
                  onTap: () async {
                    _fromDate(context);
                  },
                ),
              ),
              //Timer

              SizedBox(
                width: MediaQuery.of(context).size.width,
                height: 50,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    alignment: Alignment.centerLeft,
                    primary: CustomColors.myJobDetail,
                    padding: const EdgeInsets.all(7),
                    textStyle: const TextStyle(fontSize: 20),
                  ),
                  child: Text(
                    selectedTime != null ? '$selectedTime' : 'Select Time',
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      fontSize: 16,
                      fontFamily: "Rubik",
                      fontWeight: FontWeight.w400,
                      color: CustomColors.primaryText,
                    ),
                  ),
                  onPressed: () {
                    setState(
                      () {
                        displayTimeDialog();
                      },
                    );
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
                      color: CustomColors.myJobDetail,
                      border: Border.all(color: CustomColors.myJobDetail, width: 0.5),
                      borderRadius: BorderRadius.circular(2),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton(
                          hint: Text(
                            "Duration in hours",
                            style: TextStyle(
                              fontSize: 12,
                              fontFamily: "Rubik",
                              fontWeight: FontWeight.w600,
                              color: CustomColors.primaryText,
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
                        const Color(0xff90EAB4).withOpacity(0.1),
                        const Color(0xff6BD294).withOpacity(0.8),
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
        // Show Days
        ListView.builder(
            shrinkWrap: true,
            scrollDirection: Axis.vertical,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: seniorCareDays.length,
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
                              children: [
                                Row(
                                  children: [
                                    Container(
                                      alignment: Alignment.topLeft,
                                      width: 100,
                                      child: const Column(
                                        children: [
                                          Text("Date"),
                                        ],
                                      ),
                                    ),
                                    Expanded(
                                      child: Text(
                                        seniorCareDays[index]['starting_date'].toString(),
                                        style: TextStyle(
                                          fontSize: 15,
                                          color: CustomColors.primaryText,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
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
                                          Text("Time:"),
                                        ],
                                      ),
                                    ),
                                    Expanded(
                                      child: Text("${seniorCareDays[index]['starting_time']}"),
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
                                          Text("Duration:"),
                                        ],
                                      ),
                                    ),
                                    Expanded(
                                      child: Text("${seniorCareDays[index]['duration']} hours"),
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
                          seniorCareDays.removeAt(index);
                          startTimeMapList.removeAt(index);
                          dateMapList.removeAt(index);
                          durationMapList.removeAt(index);
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
        // Size of House/Apartment
        const SizedBox(height: 20),
        Container(
          alignment: Alignment.topLeft,
          child: Text(
            "Size of House/Apartment",
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: CustomColors.primaryColor,
              fontFamily: "Rubik",
              fontSize: 14,
            ),
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: bedroom.length,
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
                  selectedBedroom = index;
                });
                if (selectedBedroom == 0) {
                  bedroomValue = '1';
                } else if (selectedBedroom == 1) {
                  bedroomValue = '2';
                } else if (selectedBedroom == 2) {
                  bedroomValue = '3';
                } else if (selectedBedroom == 3) {
                  bedroomValue = '4';
                }
              },
              child: Container(
                margin: const EdgeInsets.only(right: 10),
                decoration: BoxDecoration(
                  color: selectedBedroom == index ? CustomColors.primaryColor : const Color.fromRGBO(14, 190, 127, 0.08),
                  border: Border.all(
                    width: .5,
                    color: const Color.fromRGBO(103, 114, 148, 0.1),
                  ),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Center(
                  child: Text(
                    bedroom[index],
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      fontFamily: "Rubik",
                      color: selectedBedroom == index ? CustomColors.white : CustomColors.primaryColor,
                    ),
                  ),
                ),
              ),
            );
          },
        ),
        const SizedBox(
          height: 10,
        ),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: bathroom.length,
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
                  selectedBathroom = index;
                });
                if (selectedBathroom == 0) {
                  bathroomValue = '1';
                } else if (selectedBathroom == 1) {
                  bathroomValue = '2';
                } else if (selectedBathroom == 2) {
                  bathroomValue = '3';
                } else if (selectedBathroom == 3) {
                  bathroomValue = '4';
                }
              },
              child: Container(
                margin: const EdgeInsets.only(right: 10),
                decoration: BoxDecoration(
                  color: selectedBathroom == index ? CustomColors.primaryColor : const Color.fromRGBO(14, 190, 127, 0.08),
                  border: Border.all(
                    width: .5,
                    color: const Color.fromRGBO(103, 114, 148, 0.1),
                  ),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Center(
                  child: Text(
                    bathroom[index],
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      fontFamily: "Rubik",
                      color: selectedBathroom == index ? CustomColors.white : CustomColors.primaryColor,
                    ),
                  ),
                ),
              ),
            );
          },
        ), // Need Assistance
        const SizedBox(height: 20),
        Container(
          alignment: Alignment.topLeft,
          child: Text(
            "Other",
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: CustomColors.primaryColor,
              fontFamily: "Rubik",
              fontSize: 14,
            ),
          ),
        ),
        const SizedBox(
          height: 10,
        ),
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
        other == "1"
            ? SizedBox(
                height: 45,
                child: TextFormField(
                  onChanged: (value) {
                    other = value;
                  },
                  controller: otherFieldController,
                  style: TextStyle(
                    fontSize: 12,
                    fontFamily: "Rubik",
                    fontWeight: FontWeight.w600,
                    color: CustomColors.primaryColor,
                  ),
                  textAlignVertical: TextAlignVertical.center,
                  maxLines: 1,
                  decoration: InputDecoration(
                    hintText: "Please enter detail here",
                    hintStyle: TextStyle(
                      fontSize: 12,
                      fontFamily: "Rubik",
                      fontWeight: FontWeight.w600,
                      color: CustomColors.primaryColor,
                    ),
                    fillColor: CustomColors.white,
                    focusColor: CustomColors.white,
                    hoverColor: CustomColors.white,
                    filled: true,
                    contentPadding: const EdgeInsets.fromLTRB(12, 4, 12, 4),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(2),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: CustomColors.borderLight,
                        width: 0.5,
                      ),
                      borderRadius: BorderRadius.circular(2.0),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: CustomColors.borderLight,
                        width: 0.5,
                      ),
                      borderRadius: BorderRadius.circular(2.0),
                    ),
                  ),
                ),
              )
            : Container(),

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
              } else if (startDateController.text.isEmpty) {
                customErrorSnackBar(context, "Start Date is Required");
              } else if (selectedTime == null) {
                customErrorSnackBar(context, "Time is Required");
              } else if (selectedHours == null) {
                customErrorSnackBar(context, "Duration is Required");
              } else if (bedroomValue == null) {
                customErrorSnackBar(context, "Please Select Bedroom");
              } else if (bathroomValue == null) {
                customErrorSnackBar(context, "Please Select Bathroom");
              } else {
                customSuccesSnackBar(context, "Job Created Successfully");
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
                    const Color(0xff90EAB4).withOpacity(0.1),
                    const Color(0xff6BD294).withOpacity(0.8),
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
                  "Save",
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
        const SizedBox(
          height: 30,
        ),
        //Job Title
        Container(
          alignment: Alignment.topLeft,
          child: Text(
            "Job Title",
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: CustomColors.primaryColor,
              fontFamily: "Rubik",
              fontSize: 14,
            ),
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        SizedBox(
          height: 45,
          child: TextFormField(
            controller: jobTitleController,
            style: TextStyle(
              fontSize: 12,
              fontFamily: "Rubik",
              fontWeight: FontWeight.w600,
              color: CustomColors.primaryColor,
            ),
            textAlignVertical: TextAlignVertical.center,
            maxLines: 1,
            decoration: InputDecoration(
              hintText: "Name",
              hintStyle: TextStyle(
                fontSize: 12,
                fontFamily: "Rubik",
                fontWeight: FontWeight.w600,
                color: CustomColors.primaryColor,
              ),
              fillColor: CustomColors.white,
              focusColor: CustomColors.white,
              hoverColor: CustomColors.white,
              filled: true,
              contentPadding: const EdgeInsets.fromLTRB(12, 4, 12, 4),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(2),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: CustomColors.borderLight,
                  width: 0.5,
                ),
                borderRadius: BorderRadius.circular(2.0),
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: CustomColors.borderLight,
                  width: 0.5,
                ),
                borderRadius: BorderRadius.circular(2.0),
              ),
            ),
          ),
        ),
        //Parish
        const SizedBox(height: 20),
        Container(
          alignment: Alignment.topLeft,
          child: Text(
            "Job Location",
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: CustomColors.primaryColor,
              fontFamily: "Rubik",
              fontSize: 14,
            ),
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        SizedBox(
          height: 45,
          child: TextFormField(
            controller: addressController,
            style: TextStyle(
              fontSize: 12,
              fontFamily: "Rubik",
              fontWeight: FontWeight.w600,
              color: CustomColors.primaryColor,
            ),
            textAlignVertical: TextAlignVertical.center,
            maxLines: 1,
            decoration: InputDecoration(
              hintText: "Job Location",
              hintStyle: TextStyle(
                fontSize: 12,
                fontFamily: "Rubik",
                fontWeight: FontWeight.w600,
                color: CustomColors.primaryColor,
              ),
              fillColor: CustomColors.white,
              focusColor: CustomColors.white,
              hoverColor: CustomColors.white,
              filled: true,
              contentPadding: const EdgeInsets.fromLTRB(12, 4, 12, 4),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(2),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: CustomColors.borderLight,
                  width: 0.5,
                ),
                borderRadius: BorderRadius.circular(2.0),
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: CustomColors.borderLight,
                  width: 0.5,
                ),
                borderRadius: BorderRadius.circular(2.0),
              ),
            ),
          ),
        ),
        //Location
        const SizedBox(height: 20),
        Container(
          alignment: Alignment.topLeft,
          child: Text(
            "Job Area",
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: CustomColors.primaryColor,
              fontFamily: "Rubik",
              fontSize: 14,
            ),
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        SizedBox(
          height: 45,
          child: Center(
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: Colors.transparent,
                border: Border.all(color: CustomColors.borderLight, width: 0.5),
                borderRadius: BorderRadius.circular(2),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton(
                    hint: Text(
                      "Select Area",
                      style: TextStyle(
                        fontSize: 12,
                        fontFamily: "Rubik",
                        fontWeight: FontWeight.w600,
                        color: CustomColors.primaryColor,
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
          child: Text(
            "Hourly Rate",
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: CustomColors.primaryColor,
              fontFamily: "Rubik",
              fontSize: 14,
            ),
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        SizedBox(
          height: 45,
          child: TextFormField(
            keyboardType: TextInputType.number,
            controller: hourlyController,
            style: TextStyle(
              fontSize: 12,
              fontFamily: "Rubik",
              fontWeight: FontWeight.w600,
              color: CustomColors.primaryColor,
            ),
            textAlignVertical: TextAlignVertical.bottom,
            decoration: InputDecoration(
              hintText: "\$10",
              hintStyle: TextStyle(
                fontSize: 12,
                fontFamily: "Rubik",
                fontWeight: FontWeight.w600,
                color: CustomColors.primaryColor,
              ),
              fillColor: CustomColors.white,
              focusColor: CustomColors.white,
              hoverColor: CustomColors.white,
              filled: true,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(2),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: CustomColors.borderLight,
                  width: 0.5,
                ),
                borderRadius: BorderRadius.circular(2.0),
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: CustomColors.borderLight,
                  width: 0.5,
                ),
                borderRadius: BorderRadius.circular(2.0),
              ),
            ),
          ),
        ),
        // Add Days
        const SizedBox(height: 20),
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
                offset: Offset(0, 4),
                blurRadius: 3,
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
                decoration: BoxDecoration(
                  color: CustomColors.myJobDetail,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: CustomTextFieldWidget(
                  borderColor: CustomColors.white,
                  obsecure: false,
                  keyboardType: TextInputType.number,
                  controller: startDateController,
                  hintText: "Start Date",
                  onChanged: (value) {
                    setState(() {
                      getfromPickedDate = value;
                    });
                  },
                  onTap: () async {
                    _fromDate(context);
                  },
                ),
              ),
              //Timer

              SizedBox(
                width: MediaQuery.of(context).size.width,
                height: 50,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    alignment: Alignment.centerLeft,
                    primary: CustomColors.myJobDetail,
                    padding: const EdgeInsets.all(7),
                    textStyle: const TextStyle(fontSize: 20),
                  ),
                  child: Text(
                    selectedTime != null ? '$selectedTime' : 'Select Time',
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      fontSize: 16,
                      fontFamily: "Rubik",
                      fontWeight: FontWeight.w400,
                      color: CustomColors.primaryText,
                    ),
                  ),
                  onPressed: () {
                    setState(
                      () {
                        displayTimeDialog();
                      },
                    );
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
                      color: CustomColors.myJobDetail,
                      border: Border.all(color: CustomColors.myJobDetail, width: 0.5),
                      borderRadius: BorderRadius.circular(2),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton(
                          hint: Text(
                            "Duration in hours",
                            style: TextStyle(
                              fontSize: 12,
                              fontFamily: "Rubik",
                              fontWeight: FontWeight.w600,
                              color: CustomColors.primaryText,
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
                        const Color(0xff90EAB4).withOpacity(0.1),
                        const Color(0xff6BD294).withOpacity(0.8),
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
        // Show Days
        ListView.builder(
            shrinkWrap: true,
            scrollDirection: Axis.vertical,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: seniorCareDays.length,
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
                              children: [
                                Row(
                                  children: [
                                    Container(
                                      alignment: Alignment.topLeft,
                                      width: 100,
                                      child: const Column(
                                        children: [
                                          Text("Date"),
                                        ],
                                      ),
                                    ),
                                    Expanded(
                                      child: Text(
                                        seniorCareDays[index]['starting_date'].toString(),
                                        style: TextStyle(
                                          fontSize: 15,
                                          color: CustomColors.primaryText,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
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
                                          Text("Time:"),
                                        ],
                                      ),
                                    ),
                                    Expanded(
                                      child: Text("${seniorCareDays[index]['starting_time']}"),
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
                                          Text("Duration:"),
                                        ],
                                      ),
                                    ),
                                    Expanded(
                                      child: Text("${seniorCareDays[index]['duration']} hours"),
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
                          seniorCareDays.removeAt(index);
                          startTimeMapList.removeAt(index);
                          dateMapList.removeAt(index);
                          durationMapList.removeAt(index);
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
        // Pet type
        const SizedBox(height: 20),
        Container(
          alignment: Alignment.topLeft,
          child: Text(
            "Pet Type",
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: CustomColors.primaryColor,
              fontFamily: "Rubik",
              fontSize: 14,
            ),
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: petType.length,
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
                  color: selectedIndex == index ? CustomColors.primaryColor : const Color.fromRGBO(14, 190, 127, 0.08),
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
                      fontWeight: FontWeight.w600,
                      fontFamily: "Rubik",
                      color: selectedIndex == index ? CustomColors.white : CustomColors.primaryColor,
                    ),
                  ),
                ),
              ),
            );
          },
        ),
        // Other Field
        const SizedBox(height: 20),
        otherField == 1
            ? SizedBox(
                height: 45,
                child: TextFormField(
                  keyboardType: TextInputType.name,
                  controller: otherFieldController,
                  style: TextStyle(
                    fontSize: 12,
                    fontFamily: "Rubik",
                    fontWeight: FontWeight.w600,
                    color: CustomColors.primaryColor,
                  ),
                  onChanged: (value) {
                    petTypeValue = value;
                  },
                  textAlignVertical: TextAlignVertical.bottom,
                  decoration: InputDecoration(
                    hintText: "Abc..",
                    hintStyle: TextStyle(
                      fontSize: 12,
                      fontFamily: "Rubik",
                      fontWeight: FontWeight.w600,
                      color: CustomColors.primaryColor,
                    ),
                    fillColor: CustomColors.white,
                    focusColor: CustomColors.white,
                    hoverColor: CustomColors.white,
                    filled: true,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(2),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: CustomColors.borderLight,
                        width: 0.5,
                      ),
                      borderRadius: BorderRadius.circular(2.0),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: CustomColors.borderLight,
                        width: 0.5,
                      ),
                      borderRadius: BorderRadius.circular(2.0),
                    ),
                  ),
                ),
              )
            : Container(),
        // Number of Pets
        const SizedBox(height: 20),
        Container(
          alignment: Alignment.topLeft,
          child: Text(
            "Number of Pets",
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: CustomColors.primaryColor,
              fontFamily: "Rubik",
              fontSize: 14,
            ),
          ),
        ),
        const SizedBox(
          height: 10,
        ),
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
                  color: selectedNumberIndex == index ? CustomColors.primaryColor : const Color.fromRGBO(14, 190, 127, 0.08),
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
                      fontWeight: FontWeight.w600,
                      fontFamily: "Rubik",
                      color: selectedNumberIndex == index ? CustomColors.white : CustomColors.primaryColor,
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
          child: Text(
            "Pet Breed",
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: CustomColors.primaryColor,
              fontFamily: "Rubik",
              fontSize: 14,
            ),
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        SizedBox(
          height: 45,
          child: TextFormField(
            keyboardType: TextInputType.name,
            controller: petBreedController,
            style: TextStyle(
              fontSize: 12,
              fontFamily: "Rubik",
              fontWeight: FontWeight.w600,
              color: CustomColors.primaryColor,
            ),
            textAlignVertical: TextAlignVertical.bottom,
            decoration: InputDecoration(
              hintText: "Pet Breed",
              hintStyle: TextStyle(
                fontSize: 12,
                fontFamily: "Rubik",
                fontWeight: FontWeight.w600,
                color: CustomColors.primaryColor,
              ),
              fillColor: CustomColors.white,
              focusColor: CustomColors.white,
              hoverColor: CustomColors.white,
              filled: true,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(2),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: CustomColors.borderLight,
                  width: 0.5,
                ),
                borderRadius: BorderRadius.circular(2.0),
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: CustomColors.borderLight,
                  width: 0.5,
                ),
                borderRadius: BorderRadius.circular(2.0),
              ),
            ),
          ),
        ),
        // Size Of Pet
        const SizedBox(height: 20),
        Container(
          alignment: Alignment.topLeft,
          child: Text(
            "Size Of Pet",
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: CustomColors.primaryColor,
              fontFamily: "Rubik",
              fontSize: 14,
            ),
          ),
        ),
        const SizedBox(
          height: 10,
        ),
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
                  color: selectedSize == index ? CustomColors.primaryColor : const Color.fromRGBO(14, 190, 127, 0.08),
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
                      fontWeight: FontWeight.w600,
                      fontFamily: "Rubik",
                      color: selectedSize == index ? CustomColors.white : CustomColors.primaryColor,
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
          child: Text(
            "Temperament",
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: CustomColors.primaryColor,
              fontFamily: "Rubik",
              fontSize: 14,
            ),
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: temperament.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            childAspectRatio: (2.3),
            crossAxisCount: 3,
            crossAxisSpacing: 3,
            mainAxisSpacing: 12,
          ),
          itemBuilder: (BuildContext context, int index) {
            return GestureDetector(
              onTap: () {
                setState(() {
                  selectedTemperament = index;
                });
                if (selectedTemperament == 1) {
                  otherGuarded = 1;
                } else {
                  otherGuarded = 0;
                }
                if (selectedTemperament == 0) {
                  temperamentValue = "Friendly/Socialized";
                } else if (selectedTemperament == 1) {
                  temperamentValue = "Guarded";
                }
              },
              child: Container(
                margin: const EdgeInsets.only(right: 10),
                decoration: BoxDecoration(
                  color: selectedTemperament == index ? CustomColors.primaryColor : const Color.fromRGBO(14, 190, 127, 0.08),
                  border: Border.all(
                    width: .5,
                    color: const Color.fromRGBO(103, 114, 148, 0.1),
                  ),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Center(
                  child: Text(
                    temperament[index],
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      fontFamily: "Rubik",
                      color: selectedTemperament == index ? CustomColors.white : CustomColors.primaryColor,
                    ),
                  ),
                ),
              ),
            );
          },
        ),
        // if Guarded Selected
        const SizedBox(
          height: 10,
        ),
        otherGuarded == 1
            ? GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: guarded.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  childAspectRatio: (2.3),
                  crossAxisCount: 3,
                  crossAxisSpacing: 3,
                  mainAxisSpacing: 12,
                ),
                itemBuilder: (BuildContext context, int index) {
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedGuarded = index;
                      });
                      if (selectedGuarded == 0) {
                        temperamentValue = "With People";
                      } else if (selectedGuarded == 1) {
                        temperamentValue = "With Other Animals";
                      }
                    },
                    child: Container(
                      margin: const EdgeInsets.only(right: 10),
                      decoration: BoxDecoration(
                        color: selectedGuarded == index ? CustomColors.primaryColor : const Color.fromRGBO(14, 190, 127, 0.08),
                        border: Border.all(
                          width: .5,
                          color: const Color.fromRGBO(103, 114, 148, 0.1),
                        ),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Center(
                        child: Text(
                          guarded[index],
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            fontFamily: "Rubik",
                            color: selectedGuarded == index ? CustomColors.white : CustomColors.primaryColor,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              )
            : Container(),
        // Need Assistance
        const SizedBox(height: 20),
        Container(
          alignment: Alignment.topLeft,
          child: Text(
            "Need Assistance",
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: CustomColors.primaryColor,
              fontFamily: "Rubik",
              fontSize: 14,
            ),
          ),
        ),
        const SizedBox(
          height: 10,
        ),
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
                  title: const Text("Walking (frequency & duration)"),
                  value: isChecked,
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
                  title: const Text("Day Care"),
                  value: isChecked2,
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
                  title: const Text("Feeding (frequency & duration)"),
                  value: isChecked3,
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
                  title: const Text("Socialization/ Obedience training"),
                  value: isChecked4,
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
                  title: const Text("Grooming"),
                  value: isChecked5,
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
                  title: const Text("Boarding/Overnight pet sitting"),
                  value: isChecked6,
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
                  controlAffinity: ListTileControlAffinity.leading,
                ),
              ),
            ),
          ],
        ),
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
              } else if (startDateController.text.isEmpty) {
                customErrorSnackBar(context, "Start Date is Required");
              } else if (selectedTime == null) {
                customErrorSnackBar(context, "Time is Required");
              } else if (selectedHours == null) {
                customErrorSnackBar(context, "Duration is Required");
              } else if (petTypeValue == null) {
                customErrorSnackBar(context, "Pet Type is Required");
              } else if (numberOfPetValue == null) {
                customErrorSnackBar(context, "Number of pets is Required");
              } else if (petBreedController.text.isEmpty) {
                customErrorSnackBar(context, "Pet Breed is Required");
              } else if (temperamentValue == null) {
                customErrorSnackBar(context, "Temprament is Required");
              } else {
                customSuccesSnackBar(context, "Job Created Successfully");
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
                    const Color(0xff90EAB4).withOpacity(0.1),
                    const Color(0xff6BD294).withOpacity(0.8),
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
                  "Save",
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
        const SizedBox(
          height: 30,
        ),
        //Job Title
        Container(
          alignment: Alignment.topLeft,
          child: Text(
            "Job Title",
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: CustomColors.primaryColor,
              fontFamily: "Rubik",
              fontSize: 14,
            ),
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        SizedBox(
          height: 45,
          child: TextFormField(
            controller: jobTitleController,
            style: TextStyle(
              fontSize: 12,
              fontFamily: "Rubik",
              fontWeight: FontWeight.w600,
              color: CustomColors.primaryColor,
            ),
            textAlignVertical: TextAlignVertical.center,
            maxLines: 1,
            decoration: InputDecoration(
              hintText: "Name",
              hintStyle: TextStyle(
                fontSize: 12,
                fontFamily: "Rubik",
                fontWeight: FontWeight.w600,
                color: CustomColors.primaryColor,
              ),
              fillColor: CustomColors.white,
              focusColor: CustomColors.white,
              hoverColor: CustomColors.white,
              filled: true,
              contentPadding: const EdgeInsets.fromLTRB(12, 4, 12, 4),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(2),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: CustomColors.borderLight,
                  width: 0.5,
                ),
                borderRadius: BorderRadius.circular(2.0),
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: CustomColors.borderLight,
                  width: 0.5,
                ),
                borderRadius: BorderRadius.circular(2.0),
              ),
            ),
          ),
        ),
        //Parish
        const SizedBox(height: 20),
        Container(
          alignment: Alignment.topLeft,
          child: Text(
            "Job Location",
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: CustomColors.primaryColor,
              fontFamily: "Rubik",
              fontSize: 14,
            ),
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        SizedBox(
          height: 45,
          child: TextFormField(
            controller: addressController,
            style: TextStyle(
              fontSize: 12,
              fontFamily: "Rubik",
              fontWeight: FontWeight.w600,
              color: CustomColors.primaryColor,
            ),
            textAlignVertical: TextAlignVertical.center,
            maxLines: 1,
            decoration: InputDecoration(
              hintText: "Job Location",
              hintStyle: TextStyle(
                fontSize: 12,
                fontFamily: "Rubik",
                fontWeight: FontWeight.w600,
                color: CustomColors.primaryColor,
              ),
              fillColor: CustomColors.white,
              focusColor: CustomColors.white,
              hoverColor: CustomColors.white,
              filled: true,
              contentPadding: const EdgeInsets.fromLTRB(12, 4, 12, 4),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(2),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: CustomColors.borderLight,
                  width: 0.5,
                ),
                borderRadius: BorderRadius.circular(2.0),
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: CustomColors.borderLight,
                  width: 0.5,
                ),
                borderRadius: BorderRadius.circular(2.0),
              ),
            ),
          ),
        ),
        //Location
        const SizedBox(height: 20),
        Container(
          alignment: Alignment.topLeft,
          child: Text(
            "Job Area",
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: CustomColors.primaryColor,
              fontFamily: "Rubik",
              fontSize: 14,
            ),
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        SizedBox(
          height: 45,
          child: Center(
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: Colors.transparent,
                border: Border.all(color: CustomColors.borderLight, width: 0.5),
                borderRadius: BorderRadius.circular(2),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton(
                    hint: Text(
                      "Select Area",
                      style: TextStyle(
                        fontSize: 12,
                        fontFamily: "Rubik",
                        fontWeight: FontWeight.w600,
                        color: CustomColors.primaryColor,
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
          child: Text(
            "Hourly Rate",
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: CustomColors.primaryColor,
              fontFamily: "Rubik",
              fontSize: 14,
            ),
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        SizedBox(
          height: 45,
          child: TextFormField(
            keyboardType: TextInputType.number,
            controller: hourlyController,
            style: TextStyle(
              fontSize: 12,
              fontFamily: "Rubik",
              fontWeight: FontWeight.w600,
              color: CustomColors.primaryColor,
            ),
            textAlignVertical: TextAlignVertical.center,
            maxLines: 1,
            decoration: InputDecoration(
              hintText: "Please enter hourly rate",
              hintStyle: TextStyle(
                fontSize: 12,
                fontFamily: "Rubik",
                fontWeight: FontWeight.w600,
                color: CustomColors.primaryColor,
              ),
              fillColor: CustomColors.white,
              focusColor: CustomColors.white,
              hoverColor: CustomColors.white,
              filled: true,
              contentPadding: const EdgeInsets.fromLTRB(12, 4, 12, 4),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(2),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: CustomColors.borderLight,
                  width: 0.5,
                ),
                borderRadius: BorderRadius.circular(2.0),
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: CustomColors.borderLight,
                  width: 0.5,
                ),
                borderRadius: BorderRadius.circular(2.0),
              ),
            ),
          ),
        ),
        //Senior Name
        const SizedBox(height: 20),
        Container(
          alignment: Alignment.topLeft,
          child: Text(
            "Senior Name",
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: CustomColors.primaryColor,
              fontFamily: "Rubik",
              fontSize: 14,
            ),
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        SizedBox(
          height: 45,
          child: TextFormField(
            controller: seniorNameController,
            style: TextStyle(
              fontSize: 12,
              fontFamily: "Rubik",
              fontWeight: FontWeight.w600,
              color: CustomColors.primaryColor,
            ),
            textAlignVertical: TextAlignVertical.center,
            maxLines: 1,
            decoration: InputDecoration(
              hintText: "Senior Name",
              hintStyle: TextStyle(
                fontSize: 12,
                fontFamily: "Rubik",
                fontWeight: FontWeight.w600,
                color: CustomColors.primaryColor,
              ),
              fillColor: CustomColors.white,
              focusColor: CustomColors.white,
              hoverColor: CustomColors.white,
              filled: true,
              contentPadding: const EdgeInsets.fromLTRB(12, 4, 12, 4),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(2),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: CustomColors.borderLight,
                  width: 0.5,
                ),
                borderRadius: BorderRadius.circular(2.0),
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: CustomColors.borderLight,
                  width: 0.5,
                ),
                borderRadius: BorderRadius.circular(2.0),
              ),
            ),
          ),
        ),
        // Date of birth
        const SizedBox(height: 20),
        Container(
          alignment: Alignment.topLeft,
          child: Text(
            "Date Of Birth",
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: CustomColors.primaryColor,
              fontFamily: "Rubik",
              fontSize: 14,
            ),
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        SizedBox(
          height: 45,
          child: TextFormField(
            controller: dobController,
            onChanged: (value) {
              setState(() {
                getfromPickedDate = value;
              });
            },
            onTap: () async {
              _getDobDate(context);
            },
            style: TextStyle(
              fontSize: 12,
              fontFamily: "Rubik",
              fontWeight: FontWeight.w600,
              color: CustomColors.primaryColor,
            ),
            textAlignVertical: TextAlignVertical.center,
            maxLines: 1,
            decoration: InputDecoration(
              hintText: "Date Of Birth",
              hintStyle: TextStyle(
                fontSize: 12,
                fontFamily: "Rubik",
                fontWeight: FontWeight.w600,
                color: CustomColors.primaryColor,
              ),
              fillColor: CustomColors.white,
              focusColor: CustomColors.white,
              hoverColor: CustomColors.white,
              filled: true,
              contentPadding: const EdgeInsets.fromLTRB(12, 4, 12, 4),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(2),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: CustomColors.borderLight,
                  width: 0.5,
                ),
                borderRadius: BorderRadius.circular(2.0),
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: CustomColors.borderLight,
                  width: 0.5,
                ),
                borderRadius: BorderRadius.circular(2.0),
              ),
            ),
          ),
        ),
        //Medical Condition (optional)
        const SizedBox(height: 20),
        Container(
          alignment: Alignment.topLeft,
          child: Text(
            "Medical Condition (optional)",
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: CustomColors.primaryColor,
              fontFamily: "Rubik",
              fontSize: 14,
            ),
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        SizedBox(
          height: 120,
          child: TextFormField(
            controller: medicalConditionController,
            style: TextStyle(
              fontSize: 12,
              fontFamily: "Rubik",
              fontWeight: FontWeight.w600,
              color: CustomColors.primaryColor,
            ),
            textAlignVertical: TextAlignVertical.center,
            maxLines: 5,
            decoration: InputDecoration(
              hintText: "Medical Condition (optional)",
              hintStyle: TextStyle(
                fontSize: 12,
                fontFamily: "Rubik",
                fontWeight: FontWeight.w600,
                color: CustomColors.primaryColor,
              ),
              fillColor: CustomColors.white,
              focusColor: CustomColors.white,
              hoverColor: CustomColors.white,
              filled: true,
              contentPadding: const EdgeInsets.fromLTRB(6, 4, 12, 4),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(2),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: CustomColors.borderLight,
                  width: 0.5,
                ),
                borderRadius: BorderRadius.circular(2.0),
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: CustomColors.borderLight,
                  width: 0.5,
                ),
                borderRadius: BorderRadius.circular(2.0),
              ),
            ),
          ),
        ),
        // Add Days
        // const SizedBox(height: 20),
        // Row(
        //   mainAxisAlignment: MainAxisAlignment.end,
        //   children: [
        //     GestureDetector(
        //       onTap: () {
        //         showDialog(
        //           context: context,
        //           builder: (BuildContext context) {
        //             return StatefulBuilder(builder: (context, setState) {
        //               return AlertDialog(
        //                 content: SingleChildScrollView(
        //                   scrollDirection: Axis.vertical,
        //                   child: Column(
        //                     mainAxisSize: MainAxisSize.min,
        //                     children: <Widget>[
        //                       Text("Add Days"),
        //                       // Start Date
        //                       Container(
        //                         height: 50,
        //                         margin: const EdgeInsets.only(bottom: 15, top: 15),
        //                         decoration: BoxDecoration(
        //                           color: CustomColors.myJobDetail,
        //                           borderRadius: BorderRadius.circular(6),
        //                         ),
        //                         child: CustomTextFieldWidget(
        //                           borderColor: CustomColors.white,
        //                           obsecure: false,
        //                           keyboardType: TextInputType.number,
        //                           controller: startDateController,
        //                           hintText: "Start Date",
        //                           onChanged: (value) {
        //                             setState(() {
        //                               getfromPickedDate = value;
        //                             });
        //                           },
        //                           onTap: () async {
        //                             _fromDate(context);
        //                           },
        //                         ),
        //                       ),
        //                       //Timer
        //                       // Text(selectedTime != null ? '$selectedTime': 'Click Below Button To Select Time...',
        //                       // style: const TextStyle(fontSize: 24),textAlign:TextAlign.center,),
        //                       Container(
        //                         width: MediaQuery.of(context).size.width,
        //                         height: 50,
        //                         child: ElevatedButton(
        //                           style: ElevatedButton.styleFrom(
        //                             alignment: Alignment.centerLeft,
        //                             // ignore: deprecated_member_use
        //                             primary: CustomColors.myJobDetail,
        //                             padding: const EdgeInsets.all(7),
        //                             textStyle: const TextStyle(fontSize: 20),
        //                           ),
        //                           child: Text(
        //                             selectedTime != null ? '$selectedTime' : 'Select Time',
        //                             textAlign: TextAlign.left,
        //                             style: TextStyle(
        //                               fontSize: 16,
        //                               fontFamily: "Rubik",
        //                               fontWeight: FontWeight.w400,
        //                               color: CustomColors.primaryText,
        //                             ),
        //                           ),
        //                           onPressed: () {
        //                             setState(
        //                               () {
        //                                 displayTimeDialog();
        //                               },
        //                             );
        //                           },
        //                         ),
        //                       ),
        //                       // Duration
        //                       Container(
        //                         height: 50,
        //                         margin: const EdgeInsets.only(bottom: 15, top: 15),
        //                         child: Center(
        //                           child: DecoratedBox(
        //                             decoration: BoxDecoration(
        //                               color: CustomColors.myJobDetail,
        //                               border: Border.all(color: CustomColors.myJobDetail, width: 0.5),
        //                               borderRadius: BorderRadius.circular(2),
        //                             ),
        //                             child: Padding(
        //                               padding: const EdgeInsets.symmetric(
        //                                 horizontal: 10,
        //                                 vertical: 4,
        //                               ),
        //                               child: DropdownButtonHideUnderline(
        //                                 child: DropdownButton(
        //                                   hint: Text(
        //                                     "Duration in hours",
        //                                     style: TextStyle(
        //                                       fontSize: 12,
        //                                       fontFamily: "Rubik",
        //                                       fontWeight: FontWeight.w600,
        //                                       color: CustomColors.primaryText,
        //                                     ),
        //                                   ),
        //                                   isExpanded: true,
        //                                   items: hours!.map((item) {
        //                                     return DropdownMenuItem(
        //                                       child: Text(item['name']),
        //                                       value: item['id'].toString(),
        //                                     );
        //                                   }).toList(),
        //                                   onChanged: (newVal) {
        //                                     setState(() {
        //                                       selectedHours = newVal;
        //                                     });
        //                                   },
        //                                   value: selectedHours,
        //                                 ),
        //                               ),
        //                             ),
        //                           ),
        //                         ),
        //                       ),

        //                       // AddBtn
        //                       GestureDetector(
        //                         onTap: () {
        //                           String startDate = startDateController.text.trim();
        //                           String time = selectedTime.toString();
        //                           String duration = durationController.text.trim();
        //                           // if (startDate.isNotEmpty) {
        //                           setState(() {
        //                             dateMapList.add(startDate);
        //                             startTimeMapList.add(time);
        //                             durationMapList.add(selectedHours);
        //                             // durationMapList.add(selectedHours);
        //                             seniorCareDays.add(
        //                               {
        //                                 "starting_date": startDate,
        //                                 "starting_time": time,
        //                                 "duration": selectedHours,
        //                                 // "duration": selectedHours,
        //                               },
        //                             );
        //                             Navigator.pop(context);
        //                           });
        //                         },
        //                         child: Container(
        //                           width: MediaQuery.of(context).size.width,
        //                           height: 50,
        //                           margin: const EdgeInsets.only(top: 20),
        //                           decoration: BoxDecoration(
        //                             gradient: LinearGradient(
        //                               begin: Alignment.center,
        //                               end: Alignment.center,
        //                               colors: [
        //                                 const Color(0xff90EAB4).withOpacity(0.1),
        //                                 const Color(0xff6BD294).withOpacity(0.8),
        //                               ],
        //                             ),
        //                             color: CustomColors.white,
        //                             boxShadow: const [
        //                               BoxShadow(
        //                                 color: Color.fromARGB(13, 0, 0, 0),
        //                                 blurRadius: 4.0,
        //                                 spreadRadius: 2.0,
        //                                 offset: Offset(2.0, 2.0),
        //                               ),
        //                             ],
        //                             borderRadius: BorderRadius.circular(6),
        //                           ),
        //                           child: Center(
        //                             child: Text(
        //                               "Save",
        //                               style: TextStyle(
        //                                 color: CustomColors.white,
        //                                 fontSize: 16,
        //                                 fontWeight: FontWeight.w600,
        //                                 fontFamily: "Rubik",
        //                               ),
        //                             ),
        //                           ),
        //                         ),
        //                       ),
        //                     ],
        //                   ),
        //                 ),
        //               );
        //             });
        //           },
        //         );
        //       },
        //       child: Container(
        //         padding: EdgeInsets.all(10),
        //         decoration: BoxDecoration(
        //           color: CustomColors.primaryColor,
        //           borderRadius: BorderRadius.circular(6),
        //         ),
        //         child: Text(
        //           "Add More Days",
        //           style: TextStyle(
        //             color: CustomColors.white,
        //             fontSize: 13,
        //             fontFamily: "Poppins",
        //             fontWeight: FontWeight.w600,
        //           ),
        //         ),
        //       ),
        //     ),
        //   ],
        // ),
        // Add Days Op
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
                offset: Offset(0, 4),
                blurRadius: 3,
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
                decoration: BoxDecoration(
                  color: CustomColors.myJobDetail,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: CustomTextFieldWidget(
                  borderColor: CustomColors.white,
                  obsecure: false,
                  keyboardType: TextInputType.number,
                  controller: startDateController,
                  hintText: "Start Date",
                  onChanged: (value) {
                    setState(() {
                      getfromPickedDate = value;
                    });
                  },
                  onTap: () async {
                    _fromDate(context);
                  },
                ),
              ),
              //Timer

              SizedBox(
                width: MediaQuery.of(context).size.width,
                height: 50,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    alignment: Alignment.centerLeft,
                    primary: CustomColors.myJobDetail,
                    padding: const EdgeInsets.all(7),
                    textStyle: const TextStyle(fontSize: 20),
                  ),
                  child: Text(
                    selectedTime != null ? '$selectedTime' : 'Select Time',
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      fontSize: 16,
                      fontFamily: "Rubik",
                      fontWeight: FontWeight.w400,
                      color: CustomColors.primaryText,
                    ),
                  ),
                  onPressed: () {
                    setState(
                      () {
                        displayTimeDialog();
                      },
                    );
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
                      color: CustomColors.myJobDetail,
                      border: Border.all(color: CustomColors.myJobDetail, width: 0.5),
                      borderRadius: BorderRadius.circular(2),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton(
                          hint: Text(
                            "Duration in hours",
                            style: TextStyle(
                              fontSize: 12,
                              fontFamily: "Rubik",
                              fontWeight: FontWeight.w600,
                              color: CustomColors.primaryText,
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
                        const Color(0xff90EAB4).withOpacity(0.1),
                        const Color(0xff6BD294).withOpacity(0.8),
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
        // Show Days
        ListView.builder(
            shrinkWrap: true,
            scrollDirection: Axis.vertical,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: seniorCareDays.length,
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
                              children: [
                                Row(
                                  children: [
                                    Container(
                                      alignment: Alignment.topLeft,
                                      width: 100,
                                      child: const Column(
                                        children: [
                                          Text("Date"),
                                        ],
                                      ),
                                    ),
                                    Expanded(
                                      child: Text(
                                        seniorCareDays[index]['starting_date'].toString(),
                                        style: TextStyle(
                                          fontSize: 15,
                                          color: CustomColors.primaryText,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
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
                                          Text("Time:"),
                                        ],
                                      ),
                                    ),
                                    Expanded(
                                      child: Text("${seniorCareDays[index]['starting_time']}"),
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
                                          Text("Duration:"),
                                        ],
                                      ),
                                    ),
                                    Expanded(
                                      child: Text("${seniorCareDays[index]['duration']} hours"),
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
                          seniorCareDays.removeAt(index);
                          startTimeMapList.removeAt(index);
                          dateMapList.removeAt(index);
                          durationMapList.removeAt(index);
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
        // Require Assistance with
        const SizedBox(height: 20),
        Container(
          alignment: Alignment.topLeft,
          child: Text(
            "Requires Assistance With",
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: CustomColors.primaryColor,
              fontFamily: "Rubik",
              fontSize: 14,
            ),
          ),
        ),
        const SizedBox(
          height: 10,
        ),
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
                  title: const Text("Bathing"),
                  value: isChecked,
                  onChanged: (newValue) {
                    setState(() {
                      isChecked = newValue!;
                      if (newValue == false) {
                        bathing = "0";
                      } else {
                        bathing = "1";
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
                  title: const Text("Dressing"),
                  value: isChecked2,
                  onChanged: (newValue) {
                    setState(() {
                      isChecked2 = newValue!;
                      if (newValue == false) {
                        dressing = "0";
                      } else {
                        dressing = "1";
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
                  title: const Text("Feeding"),
                  value: isChecked3,
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
                  title: const Text("Meal Preparation"),
                  value: isChecked4,
                  onChanged: (newValue) {
                    setState(() {
                      isChecked4 = newValue!;
                      if (newValue == true) {
                        meal_preparation = "1";
                      } else if (newValue == false) {
                        meal_preparation = "0";
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
                  title: const Text("Grocery Shopping"),
                  value: isChecked5,
                  onChanged: (newValue) {
                    setState(() {
                      isChecked5 = newValue!;
                      if (newValue == false) {
                        grocery_shopping = "0";
                      } else {
                        grocery_shopping = "1";
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
                  title: const Text("Walking more than 10 steps"),
                  value: isChecked6,
                  onChanged: (newValue) {
                    setState(() {
                      isChecked6 = newValue!;
                      if (newValue == false) {
                        walking = "0";
                      } else {
                        walking = "1";
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
                  title: const Text("Transferring from Bed to transfer ?"),
                  value: isChecked7,
                  onChanged: (newValue) {
                    setState(() {
                      isChecked7 = newValue!;
                      if (newValue == false) {
                        bed_transfer = "0";
                      } else {
                        bed_transfer = "1";
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
                  title: const Text("Light Cleaning"),
                  value: isChecked8,
                  onChanged: (newValue) {
                    setState(() {
                      isChecked8 = newValue!;
                      if (newValue == false) {
                        light_cleaning = "0";
                      } else {
                        light_cleaning = "1";
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
                  title: const Text("Companionship"),
                  value: isChecked9,
                  onChanged: (newValue) {
                    setState(() {
                      isChecked9 = newValue!;
                      if (newValue == false) {
                        companionship = "0";
                      } else {
                        companionship = "1";
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
                  title: const Text("Medication Administration"),
                  value: isChecked10,
                  onChanged: (newValue) {
                    setState(() {
                      isChecked10 = newValue!;
                      if (newValue == false) {
                        medication_administration = "0";
                      } else {
                        medication_administration = "1";
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
                  title: const Text("Dressing wound care"),
                  value: isChecked11,
                  onChanged: (newValue) {
                    setState(() {
                      isChecked11 = newValue!;
                      if (newValue == false) {
                        dressing_wound_care = "0";
                      } else {
                        dressing_wound_care = "1";
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
                  title: const Text("Blood pressure monitoring"),
                  value: isChecked12,
                  onChanged: (newValue) {
                    setState(() {
                      isChecked12 = newValue!;
                      if (newValue == false) {
                        blood_pressure_monetoring = "0";
                      } else {
                        blood_pressure_monetoring = "1";
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
                  title: const Text("Blood sugar monitoring"),
                  value: isChecked13,
                  onChanged: (newValue) {
                    setState(() {
                      isChecked13 = newValue!;
                      if (newValue == false) {
                        blood_sugar_monetoring = "0";
                      } else {
                        blood_sugar_monetoring = "1";
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
                  title: const Text("Grooming Hair and Nail trimming"),
                  value: isChecked14,
                  onChanged: (newValue) {
                    setState(() {
                      isChecked14 = newValue!;
                      if (newValue == false) {
                        grooming_hair_and_nail_trimming = "0";
                      } else {
                        grooming_hair_and_nail_trimming = "1";
                      }
                    });
                  },
                  controlAffinity: ListTileControlAffinity.leading,
                ),
              ),
            ),
          ],
        ),

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
              } else if (startDateController.text.isEmpty) {
                customErrorSnackBar(context, "Add atlest 1 day");
              } else {
                customSuccesSnackBar(context, "Job Created Successfully");
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
                    const Color(0xff90EAB4).withOpacity(0.1),
                    const Color(0xff6BD294).withOpacity(0.8),
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
                  "Save",
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
}
