// ignore_for_file: use_build_context_synchronously, unused_local_variable, unnecessary_null_comparison, prefer_typing_uninitialized_variables, unrelated_type_equality_checks

import 'dart:io';
import 'package:dio/dio.dart';
// import 'package:dotted_border/dotted_border.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:island_app/caregiver/models/profile_model.dart';
import 'package:island_app/caregiver/utils/profile_provider.dart';
import 'package:island_app/res/app_url.dart';
import 'package:island_app/utils/utils.dart';
import 'package:island_app/widgets/document_download_list.dart';
import 'package:island_app/widgets/profile_container_field.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:island_app/screens/notification.dart';
import 'package:island_app/carereceiver/utils/colors.dart';
import 'package:island_app/widgets/custom_text_field.dart';
import 'package:island_app/widgets/progress_dialog.dart';

class ProfileGiverPendingEdit extends StatefulWidget {
  final String? name;
  final String? email;
  final String? avatar;
  final String? gender;
  final String? phoneNumber;
  final String? dob;
  final int? yoe;
  final String? hourlyRate;
  final String? userAddress;
  final String? zipCode;
  final String? additionalService;
  final String? availability;
  final String? userInfo;

  const ProfileGiverPendingEdit({
    Key? key,
    this.name,
    this.email,
    this.avatar,
    this.gender,
    this.phoneNumber,
    this.dob,
    this.yoe,
    this.hourlyRate,
    this.userAddress,
    this.zipCode,
    this.additionalService,
    this.availability,
    this.userInfo,
  }) : super(key: key);
  @override
  State<ProfileGiverPendingEdit> createState() => _ProfileGiverPendingEditState();
}

class _ProfileGiverPendingEditState extends State<ProfileGiverPendingEdit> {
  var _isSelectedGender = "1";
  final TextEditingController dobController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController zipController = TextEditingController();
  final TextEditingController userInfoController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController experienceController = TextEditingController();
  final TextEditingController hourlyController = TextEditingController();
  final TextEditingController availabilityController = TextEditingController();
  final TextEditingController keywordController = TextEditingController();
  final TextEditingController instituteController = TextEditingController();
  final TextEditingController majorController = TextEditingController();
  final TextEditingController fromController = TextEditingController();
  final TextEditingController toController = TextEditingController();
  @override
  void initState() {
    super.initState();
    // this.getSWData();
    fetchProfileEdit = fetchProfileGiverModelEdit();
    if (widget.gender != "null" || widget.gender != null) {
      _isSelectedGender = widget.gender!;
    }
    if (widget.phoneNumber != null) {
      phoneController.text = widget.phoneNumber!;
    }
    if (widget.dob != null) {
      dobController.text = widget.dob!;
    }
    if (widget.yoe != null) {
      experienceController.text = widget.yoe!.toString();
    }
    if (widget.hourlyRate != null) {
      hourlyController.text = widget.hourlyRate!;
    }
    if (widget.userAddress != null) {
      addressController.text = widget.userAddress!;
    }
    if (widget.zipCode != null) {
      zipController.text = widget.zipCode!;
    }
    if (widget.additionalService != null) {
      keywordController.text = widget.additionalService!;
    }
    if (widget.availability != null) {
      availabilityController.text = widget.availability!;
    }
    if (widget.userInfo != null) {
      userInfoController.text = widget.userInfo!;
    }
  }

  var isPeriodSeleted = "0";
  void _toggleradio() {
    if (isPeriodSeleted == "0") {
      setState(() {
        isPeriodSeleted = "1";
      });
    } else {
      {
        setState(() {
          isPeriodSeleted = "0";
        });
      }
    }
  }

  List<Map<String, String>> education = [];
  var arr1 = [];
  List instituteMapList = [];
  List majorMapList = [];
  List startDateMapList = [];
  List endDateMapList = [];
  List currentMapList = [];
  var stringListData = [];
  FilePickerResult? enhanceResult;
  // DatePicker
  var getPickedDate;
  var gettoPickedDate;
  var getfromPickedDate;
  bool _isDateSelectable(DateTime date) {
    // Disable dates before today
    return date.isBefore(DateTime.now());
  }

  DateTime? selectedDate = DateTime.now();
  var myFormat = DateFormat('d-MM-yyyy');
  _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate!,
      firstDate: DateTime(1975),
      lastDate: DateTime.now(),
      selectableDayPredicate: _isDateSelectable,
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: ColorScheme.fromSwatch(
              primarySwatch: Colors.teal,
              // : ,
              backgroundColor: CustomColors.primaryColor,
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
      picked == dobController;
      setState(() {
        getPickedDate = dobController.text;
      });
    }
  }

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
      fromController.text = DateFormat('yyyy-MM-dd').format(picked);

      picked == fromController;
      setState(() {
        getfromPickedDate = fromController.text;
      });
    }
  }

  _toDate(BuildContext context) async {
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
      toController.text = DateFormat('yyyy-MM-dd').format(picked);
      picked == toController;
      setState(() {
        gettoPickedDate = toController.text;
      });
    }
  }

  List educationApiList = [];
  late Future<ProfileGiverModel> fetchProfileEdit;
  Future<ProfileGiverModel> fetchProfileGiverModelEdit() async {
    var token = await Provider.of<ServiceGiverProvider>(context, listen: false).getUserToken();
    final response = await Dio().get(
      CareGiverUrl.serviceProviderProfile,
      options: Options(
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      ),
    );
    if (response.statusCode == 200) {
      setState(() {
        educationApiList = response.data['data']["educations"];
        selectedArea = response.data['data']["userdetail"]['area'] != null ? response.data['data']["userdetail"]['area'].toString() : 'select';
      });
      for (int i = 0; i < educationApiList.length; i++) {
        instituteMapList.add(educationApiList[i]['name']);
        majorMapList.add(educationApiList[i]['major']);
        startDateMapList.add(educationApiList[i]['from']);
        endDateMapList.add(educationApiList[i]['to']);
        currentMapList.add(educationApiList[i]['current']);
      }
      return ProfileGiverModel.fromJson(response.data);
    } else {
      throw Exception(
        customErrorSnackBar(
          context,
          'Failed to load Profile Model',
        ),
      );
    }
  }

  // Image Picking
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

  File? image;
  File? imageFileDio;

  bool showSpinner = false;
  var myimg;

  Future getImageDio() async {
    FilePickerResult? pickedFileDio = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['png', 'jpg', 'jpeg'],
    );

    if (pickedFileDio != null) {
      if (checkImageFileTypes(context, pickedFileDio.files.single.extension)) {
        setState(() {
          imageFileDio = File(pickedFileDio.files.single.path ?? "");
        });
      }
    } else {
      customErrorSnackBar(context, "No file select");
    }
  }

  var lists = {
    "valid_driver_license": "",
    "scars_awareness_certification": "",
    "red_cross_babysitting_certification": "",
    "cpr_first_aid_certification": "",
    "animal_care_provider_certification": "",
    "chaild_and_family_services_and_abuse": "",
    "animail_first_aid": "",
    "government_registered_care_provider": "",
    "police_background_check": "",
  };

  uploadDocument(String documentType) async {
    FilePickerResult? file = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf', 'docx', 'doc'],
      allowMultiple: false,
    );
    if (file != null) {
      setState(() {
        lists[documentType] = file.files.single.path.toString();
      });
      // print(lists);
    }
  }

  var error;
  uploadImageDio() async {
    // var usersId = await Provider.of<ServiceGiverProvider>(context, listen: false).getUserId();
    // var token = await Provider.of<ServiceGiverProvider>(context, listen: false).getUserToken();

    // var formData = FormData.fromMap(
    //   {
    //     '_method': 'PUT',
    //     'id': usersId,
    //     'user_info': userInfoController.text.toString(),
    //     'phone': phoneController.text.toString(),
    //     'address': addressController.text.toString(),
    //     'gender': _isSelectedGender,
    //     'dob': dobController.text.toString(),
    //     'area': selectedArea,
    //     'zip': zipController.text.toString(),
    //     'experience': experienceController.text.toString(),
    //     'hourly_rate': hourlyController.text.toString(),
    //     'availability': availabilityController.text.toString(),
    //     'service': keywordController.text.toString(),
    //     "avatar": imageFileDio == null ? null : await MultipartFile.fromFile(imageFileDio!.path),
    //     "institute_name[]": instituteMapList,
    //     "start_date[]": startDateMapList,
    //     "end_date[]": endDateMapList,
    //     "current[]": currentMapList,
    //     "major[]": majorMapList,
    //     "valid_driver_license": lists['valid_driver_license'].toString().isEmpty ? null : await MultipartFile.fromFile(lists['valid_driver_license'].toString()),
    //     "scars_awareness_certification": lists['scars_awareness_certification'].toString().isEmpty ? null : await MultipartFile.fromFile(lists['scars_awareness_certification'].toString()),
    //     "red_cross_babysitting_certification": lists['red_cross_babysitting_certification'].toString().isEmpty ? null : await MultipartFile.fromFile(lists['red_cross_babysitting_certification'].toString()),
    //     "cpr_first_aid_certification": lists['cpr_first_aid_certification'].toString().isEmpty ? null : await MultipartFile.fromFile(lists['cpr_first_aid_certification'].toString()),
    //     "animal_care_provider_certification": lists['animal_care_provider_certification'].toString().isEmpty ? null : await MultipartFile.fromFile(lists['animal_care_provider_certification'].toString()),
    //     "chaild_and_family_services_and_abuse": lists['chaild_and_family_services_and_abuse'].toString().isEmpty ? null : await MultipartFile.fromFile(lists['chaild_and_family_services_and_abuse'].toString()),
    //     "animail_first_aid": lists['animail_first_aid'].toString().isEmpty ? null : await MultipartFile.fromFile(lists['animail_first_aid'].toString()),
    //     "government_registered_care_provider": lists['government_registered_care_provider'].toString().isEmpty ? null : await MultipartFile.fromFile(lists['government_registered_care_provider'].toString()),
    //     "police_background_check": lists['police_background_check'].toString().isEmpty ? null : await MultipartFile.fromFile(lists['police_background_check'].toString()),
    //   },
    // );

    // Dio dio = Dio();
    // try {
    //   var response = await dio.post('https://islandcare.bm/api/service-provider-profile/update', data: formData, options: Options(contentType: 'application/json', followRedirects: false, validateStatus: (status) => true, headers: {"Accept": "application/json", "Authorization": "Bearer $token"}));
    //   setState(() {
    //     sendRequest = false;
    //   });
    //   // print(response.data);
    //   if (response.statusCode == 200) {
    //     Provider.of<ServiceGiverProvider>(context, listen: false).fetchProfileGiverModel();
    //     customSuccesSnackBar(
    //       context,
    //       "Profile Updated Successfully.",
    //     );
    //   } else {
    //     // print(response.data);
    //     setState(() {
    //       error = response.data;
    //     });
    //     customErrorSnackBar(
    //       context,
    //       "Something went wrong please try agan later.",
    //     );
    //   }
    // } catch (e) {
    //   // print(e);
    //   customErrorSnackBar(context, e.toString());
    // }
  }

  var areaList = [
    {"name": "Select Area", "value": "select"},
    {"name": "East", "value": "0"},
    {"name": "Central", "value": "1"},
    {"name": "West", "value": "2"},
  ];

  var selectedArea = "select";

  @override
  void dispose() {
    super.dispose();
    dobController.dispose();
    nameController.dispose();
    zipController.dispose();
    userInfoController.dispose();
    phoneController.dispose();
    addressController.dispose();
    experienceController.dispose();
    hourlyController.dispose();
    availabilityController.dispose();
    keywordController.dispose();
    instituteController.dispose();
    majorController.dispose();
    fromController.dispose();
    toController.dispose();
  }

  int selectedIndex = -1;
  bool sendRequest = false;
  final updateFormKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: CustomColors.loginBg,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: CustomColors.primaryColor,
          centerTitle: true,
          title: Text(
            "Profile Edit",
            style: TextStyle(
              fontSize: 20,
              color: CustomColors.white,
              fontWeight: FontWeight.w600,
              fontFamily: "Rubik",
            ),
          ),
          actions: [
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const NotificationScreen(),
                  ),
                );
              },
              child: const Padding(
                padding: EdgeInsets.all(12.0),
              ),
            )
          ],
        ),
        body: SizedBox(
          height: MediaQuery.of(context).size.height,
          child: SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 18),
                  child: Form(
                    key: updateFormKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 15),
                        Text(
                          "Personal Information",
                          style: TextStyle(
                            color: CustomColors.primaryText,
                            fontFamily: "Rubik",
                            fontWeight: FontWeight.w600,
                            fontSize: 18,
                          ),
                        ),
                        const SizedBox(height: 15),
                        // Upload Image
                        GestureDetector(
                          onTap: () {
                            getImageDio();
                          },
                          child: imageFileDio == null
                              ? Center(
                                  child: Container(
                                    alignment: Alignment.center,
                                    height: 100.45,
                                    width: 100.45,
                                    decoration: BoxDecoration(
                                      color: CustomColors.primaryColor,
                                      borderRadius: BorderRadius.circular(100),
                                      boxShadow: const [
                                        BoxShadow(
                                          color: Color.fromARGB(15, 0, 0, 0),
                                          blurRadius: 4,
                                          spreadRadius: 4,
                                          offset: Offset(2, 2), // Shadow position
                                        ),
                                      ],
                                    ),
                                    child: Center(
                                      child: widget.avatar != null
                                          ? ClipRRect(
                                              borderRadius: BorderRadius.circular(100),
                                              child: Image(
                                                width: 100,
                                                height: 100,
                                                fit: BoxFit.fitWidth,
                                                image: NetworkImage("${AppUrl.webStorageUrl}/${widget.avatar}"),
                                              ),
                                            )
                                          : const Text("Upload"),
                                    ),
                                  ),
                                )
                              : Center(
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(100),
                                    child: Image.file(
                                      imageFileDio!,
                                      width: 100,
                                      height: 100,
                                      fit: BoxFit.fitWidth,
                                    ),
                                  ),
                                ),
                        ),
                        const SizedBox(height: 15),
                        // Name and Email
                        Center(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              if (widget.name != null) ...[
                                Text(
                                  "${widget.name}",
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(fontSize: 16),
                                ),
                              ],
                              if (widget.email != null) ...[
                                Text(
                                  "${widget.email}",
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(fontSize: 16),
                                ),
                              ],
                            ],
                          ),
                        ),
                        const SizedBox(height: 15),
                        // Gender
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 17, vertical: 10),
                          margin: const EdgeInsets.only(bottom: 15),
                          decoration: BoxDecoration(
                            color: CustomColors.white,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Gender",
                                style: TextStyle(
                                  color: CustomColors.primaryColor,
                                  fontSize: 12,
                                  fontFamily: "Rubik",
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(height: 5),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          _isSelectedGender = "1";
                                        });
                                      },
                                      child: Container(
                                        height: 50.45,
                                        padding: const EdgeInsets.all(4),
                                        decoration: BoxDecoration(
                                          color: _isSelectedGender == "1" ? CustomColors.primaryColor : CustomColors.white,
                                          borderRadius: BorderRadius.circular(8),
                                          boxShadow: const [
                                            BoxShadow(
                                              color: Color.fromARGB(15, 0, 0, 0),
                                              blurRadius: 4,
                                              spreadRadius: 4,
                                              offset: Offset(2, 2), // Shadow position
                                            ),
                                          ],
                                        ),
                                        child: TextButton(
                                          style: TextButton.styleFrom(splashFactory: NoSplash.splashFactory),
                                          onPressed: () {
                                            setState(() {
                                              _isSelectedGender = "1";
                                            });
                                          },
                                          child: Text(
                                            "Male",
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              color: _isSelectedGender == "1" ? CustomColors.white : CustomColors.primaryText,
                                              fontFamily: "Rubik",
                                              fontSize: 12,
                                              fontWeight: FontWeight.w300,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 15),
                                  Expanded(
                                    child: GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          _isSelectedGender = "2";
                                        });
                                      },
                                      child: Container(
                                        height: 50.45,
                                        padding: const EdgeInsets.all(4),
                                        decoration: BoxDecoration(
                                          color: _isSelectedGender == "2" ? CustomColors.primaryColor : CustomColors.white,
                                          borderRadius: BorderRadius.circular(8),
                                          boxShadow: const [
                                            BoxShadow(
                                              color: Color.fromARGB(15, 0, 0, 0),
                                              blurRadius: 4,
                                              spreadRadius: 4,
                                              offset: Offset(2, 2),
                                            ),
                                          ],
                                        ),
                                        child: TextButton(
                                          style: TextButton.styleFrom(splashFactory: NoSplash.splashFactory),
                                          onPressed: () {
                                            setState(() {
                                              _isSelectedGender = "2";
                                            });
                                          },
                                          child: Text(
                                            "Female",
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              color: _isSelectedGender == "2" ? CustomColors.white : CustomColors.primaryText,
                                              fontFamily: "Rubik",
                                              fontSize: 12,
                                              fontWeight: FontWeight.w300,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        // Phone Number
                        ProfileContainerField(
                          title: "Phone Number",
                          controller: phoneController,
                          hintText: "Phone Number",
                          keyboardType: TextInputType.phone,
                          textInputAction: TextInputAction.next,
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                            LengthLimitingTextInputFormatter(15),
                            // CustomTextInputFormatter(),
                          ],
                          validator: (value) {
                            if (value == null) {
                              return "error in validator";
                            } else if (value.toString().length < 10) {
                              return "error in validator";
                            }
                            return null;
                          },
                        ),

                        // Container(
                        //   padding: const EdgeInsets.symmetric(horizontal: 17, vertical: 10),
                        //   decoration: BoxDecoration(
                        //     color: CustomColors.white,
                        //     borderRadius: BorderRadius.circular(12),
                        //   ),
                        //   child: Column(
                        //     crossAxisAlignment: CrossAxisAlignment.start,
                        //     mainAxisAlignment: MainAxisAlignment.center,
                        //     children: [
                        //       Text(
                        //         "Phone Number",
                        //         style: TextStyle(
                        //           color: CustomColors.primaryColor,
                        //           fontSize: 12,
                        //           fontFamily: "Rubik",
                        //           fontWeight: FontWeight.w600,
                        //         ),
                        //       ),
                        //       // const SizedBox(height: 05),
                        //       TextFormField(
                        //         controller: phoneController,
                        //         keyboardType: TextInputType.number,
                        //         style: const TextStyle(
                        //           fontSize: 16,
                        //           fontFamily: "Rubik",
                        //           fontWeight: FontWeight.w400,
                        //         ),
                        //         textAlignVertical: TextAlignVertical.bottom,
                        //         maxLines: 1,
                        //         inputFormatters: [
                        //           FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                        //           LengthLimitingTextInputFormatter(15),
                        //           // CustomTextInputFormatter(),
                        //         ],
                        //         validator: (value) {
                        //           if (value == null) {
                        //             return "error in validator";
                        //           } else if (value.toString().length < 10) {
                        //             return "error in validator";
                        //           }
                        //           return null;
                        //         },
                        //         decoration: InputDecoration(
                        //           // constraints: const BoxConstraints(maxHeight: 40, minHeight: 40),
                        //           // contentPadding: EdgeInsets.zero,
                        //           hintText: "Phone Number",
                        //           fillColor: CustomColors.white,
                        //           focusColor: CustomColors.white,
                        //           hoverColor: CustomColors.white,
                        //           filled: true,
                        //           border: OutlineInputBorder(borderRadius: BorderRadius.circular(0)),
                        //           focusedBorder: OutlineInputBorder(
                        //             borderSide: BorderSide(color: CustomColors.white, width: 0.0),
                        //             borderRadius: BorderRadius.circular(0.0),
                        //           ),
                        //           enabledBorder: OutlineInputBorder(
                        //             borderSide: BorderSide(color: CustomColors.white, width: 0.0),
                        //             borderRadius: BorderRadius.circular(0.0),
                        //           ),
                        //           errorBorder: OutlineInputBorder(
                        //             borderSide: BorderSide(color: CustomColors.red, width: 0.5),
                        //             borderRadius: BorderRadius.circular(12),
                        //           ),
                        //           focusedErrorBorder: OutlineInputBorder(
                        //             borderSide: BorderSide(color: CustomColors.red, width: 0.5),
                        //             borderRadius: BorderRadius.circular(12),
                        //           ),
                        //         ),
                        //       ),
                        //     ],
                        //   ),
                        // ),
                        const SizedBox(height: 15),
                        // DOB
                        InkWell(
                          onTap: () {
                            _selectDate(context);
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 17, vertical: 10),
                            margin: const EdgeInsets.only(bottom: 15),
                            width: MediaQuery.of(context).size.width,
                            alignment: Alignment.centerLeft,
                            decoration: BoxDecoration(color: CustomColors.white, borderRadius: BorderRadius.circular(12)),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "Date Of Birth",
                                  style: TextStyle(
                                    color: CustomColors.primaryColor,
                                    fontSize: 12,
                                    fontFamily: "Rubik",
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  dobController.text.isEmpty ? "Date Of Birth" : dobController.text.toString(),
                                  style: const TextStyle(
                                    color: Colors.black,
                                    fontSize: 15,
                                    fontFamily: "Rubik",
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        // Area
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 17, vertical: 10),
                          margin: const EdgeInsets.only(bottom: 15),
                          decoration: BoxDecoration(color: CustomColors.white, borderRadius: BorderRadius.circular(12)),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      "Area",
                                      style: TextStyle(
                                        color: CustomColors.primaryColor,
                                        fontSize: 12,
                                        fontFamily: "Rubik",
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    DropdownButton(
                                      value: selectedArea,
                                      underline: Container(),
                                      isExpanded: true,
                                      items: areaList
                                          .map(
                                            (e) => DropdownMenuItem(
                                              value: e["value"],
                                              child: Text(e["name"].toString()),
                                            ),
                                          )
                                          .toList(),
                                      onChanged: (value) {
                                        // print(value.runtimeType);
                                        setState(() {
                                          selectedArea = value!;
                                        });
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        // Experrience
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 17, vertical: 10),
                          margin: const EdgeInsets.only(bottom: 15),
                          decoration: BoxDecoration(
                            color: CustomColors.white,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Years Of Experience",
                                style: TextStyle(
                                  color: CustomColors.primaryColor,
                                  fontSize: 12,
                                  fontFamily: "Rubik",
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(height: 05),
                              TextFormField(
                                controller: experienceController,
                                keyboardType: TextInputType.number,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontFamily: "Rubik",
                                  fontWeight: FontWeight.w400,
                                ),
                                textAlignVertical: TextAlignVertical.bottom,
                                maxLines: 1,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return "Please add Years Of Experience";
                                  }
                                  return null;
                                },
                                inputFormatters: [
                                  FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                                  LengthLimitingTextInputFormatter(02),
                                  // CustomTextInputFormatter(),
                                ],
                                decoration: InputDecoration(
                                  hintText: "Experience",
                                  fillColor: CustomColors.white,
                                  focusColor: CustomColors.white,
                                  hoverColor: CustomColors.white,
                                  filled: true,
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(0),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: CustomColors.white, width: 0.0),
                                    borderRadius: BorderRadius.circular(0.0),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: CustomColors.white, width: 0.0),
                                    borderRadius: BorderRadius.circular(0.0),
                                  ),
                                  errorBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: CustomColors.red, width: 0.5),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  focusedErrorBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: CustomColors.red, width: 0.5),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        // Hourly
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 17, vertical: 10),
                          margin: const EdgeInsets.only(bottom: 15),
                          decoration: BoxDecoration(
                            color: CustomColors.white,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Hourly Rate",
                                style: TextStyle(
                                  color: CustomColors.primaryColor,
                                  fontSize: 12,
                                  fontFamily: "Rubik",
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              // const SizedBox(height: 05),
                              TextFormField(
                                controller: hourlyController,
                                keyboardType: TextInputType.number,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontFamily: "Rubik",
                                  fontWeight: FontWeight.w400,
                                ),
                                textAlignVertical: TextAlignVertical.bottom,
                                maxLines: 1,
                                inputFormatters: [
                                  FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                                ],
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return "Please add Hourly Rate";
                                  }
                                  return null;
                                },
                                decoration: InputDecoration(
                                  hintText: "Hourly",
                                  fillColor: CustomColors.white,
                                  focusColor: CustomColors.white,
                                  hoverColor: CustomColors.white,
                                  filled: true,
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(0),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: CustomColors.white, width: 0.0),
                                    borderRadius: BorderRadius.circular(0.0),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: CustomColors.white, width: 0.0),
                                    borderRadius: BorderRadius.circular(0.0),
                                  ),
                                  errorBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: CustomColors.red, width: 0.5),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  focusedErrorBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: CustomColors.red, width: 0.5),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        // User Address
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 17, vertical: 10),
                          margin: const EdgeInsets.only(bottom: 15),
                          decoration: BoxDecoration(
                            color: CustomColors.white,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "User Address",
                                style: TextStyle(
                                  color: CustomColors.primaryColor,
                                  fontSize: 12,
                                  fontFamily: "Rubik",
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(height: 05),
                              TextFormField(
                                controller: addressController,
                                keyboardType: TextInputType.multiline,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontFamily: "Rubik",
                                  fontWeight: FontWeight.w400,
                                ),
                                textAlignVertical: TextAlignVertical.bottom,
                                maxLines: 4,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return "Please enter User Address";
                                  }
                                  return null;
                                },
                                decoration: InputDecoration(
                                  hintText: "User Address",
                                  fillColor: CustomColors.white,
                                  focusColor: CustomColors.white,
                                  hoverColor: CustomColors.white,
                                  filled: true,
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(0),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: CustomColors.white, width: 0.0),
                                    borderRadius: BorderRadius.circular(0.0),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: CustomColors.white, width: 0.0),
                                    borderRadius: BorderRadius.circular(0.0),
                                  ),
                                  errorBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: CustomColors.red, width: 0.5),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  focusedErrorBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: CustomColors.red, width: 0.5),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        // Zip Code
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 17, vertical: 10),
                          margin: const EdgeInsets.only(bottom: 15),
                          decoration: BoxDecoration(
                            color: CustomColors.white,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Zip Code",
                                style: TextStyle(
                                  color: CustomColors.primaryColor,
                                  fontSize: 12,
                                  fontFamily: "Rubik",
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(height: 05),
                              TextFormField(
                                controller: zipController,
                                keyboardType: TextInputType.number,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontFamily: "Rubik",
                                  fontWeight: FontWeight.w400,
                                ),
                                textAlignVertical: TextAlignVertical.bottom,
                                maxLines: 1,
                                inputFormatters: [
                                  FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                                  LengthLimitingTextInputFormatter(06),
                                ],
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return "Please enter Zip Code";
                                  }
                                  return null;
                                },
                                decoration: InputDecoration(
                                  hintText: "Zip Code",
                                  fillColor: CustomColors.white,
                                  focusColor: CustomColors.white,
                                  hoverColor: CustomColors.white,
                                  filled: true,
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(0),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: CustomColors.white, width: 0.0),
                                    borderRadius: BorderRadius.circular(0.0),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: CustomColors.white, width: 0.0),
                                    borderRadius: BorderRadius.circular(0.0),
                                  ),
                                  errorBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: CustomColors.red, width: 0.5),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  focusedErrorBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: CustomColors.red, width: 0.5),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        // AdditionalService
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 17, vertical: 10),
                          margin: const EdgeInsets.only(bottom: 15),
                          decoration: BoxDecoration(
                            color: CustomColors.white,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Additional Services",
                                style: TextStyle(
                                  color: CustomColors.primaryColor,
                                  fontSize: 12,
                                  fontFamily: "Rubik",
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(height: 05),
                              TextFormField(
                                controller: keywordController,
                                keyboardType: TextInputType.multiline,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontFamily: "Rubik",
                                  fontWeight: FontWeight.w400,
                                ),
                                textAlignVertical: TextAlignVertical.bottom,
                                maxLines: 3,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return "Please fill this field";
                                  }
                                  return null;
                                },
                                decoration: InputDecoration(
                                  hintText: "abc, abc, abc",
                                  fillColor: CustomColors.white,
                                  focusColor: CustomColors.white,
                                  hoverColor: CustomColors.white,
                                  filled: true,
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(0),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: CustomColors.white, width: 0.0),
                                    borderRadius: BorderRadius.circular(0.0),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: CustomColors.white, width: 0.0),
                                    borderRadius: BorderRadius.circular(0.0),
                                  ),
                                  errorBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: CustomColors.red, width: 0.5),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  focusedErrorBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: CustomColors.red, width: 0.5),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        // Education
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Education",
                              style: TextStyle(
                                color: CustomColors.primaryText,
                                fontSize: 16,
                                fontFamily: "Poppins",
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                showModalBottomSheet(
                                  isScrollControlled: true,
                                  context: context,
                                  backgroundColor: Colors.white,
                                  shape: const RoundedRectangleBorder(
                                    borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(30.0),
                                      topRight: Radius.circular(30.0),
                                    ),
                                  ),
                                  builder: (BuildContext context) {
                                    return StatefulBuilder(
                                      builder: (BuildContext context, StateSetter setState) {
                                        return SingleChildScrollView(
                                          child: Padding(
                                            padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
                                            child: Container(
                                              padding: const EdgeInsets.only(
                                                left: 15,
                                                right: 15,
                                                top: 15,
                                              ),
                                              child: Column(
                                                mainAxisSize: MainAxisSize.min,
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: <Widget>[
                                                  const Align(
                                                    alignment: Alignment.center,
                                                    child: Text(
                                                      "Add Education",
                                                      style: TextStyle(
                                                        fontSize: 16,
                                                        fontWeight: FontWeight.w600,
                                                      ),
                                                    ),
                                                  ),
                                                  // Institute Name
                                                  Container(
                                                    height: 50,
                                                    margin: const EdgeInsets.only(bottom: 15, top: 15),
                                                    decoration: BoxDecoration(
                                                      color: CustomColors.white,
                                                      borderRadius: BorderRadius.circular(12),
                                                    ),
                                                    child: TextFormField(
                                                      controller: instituteController,
                                                      keyboardType: TextInputType.name,
                                                      textInputAction: TextInputAction.next,
                                                      style: const TextStyle(
                                                        fontSize: 16,
                                                        fontFamily: "Rubik",
                                                        fontWeight: FontWeight.w400,
                                                      ),
                                                      textAlignVertical: TextAlignVertical.bottom,
                                                      maxLines: 1,
                                                      decoration: InputDecoration(
                                                        hintText: "Institute Name",
                                                        fillColor: CustomColors.myJobDetail,
                                                        focusColor: CustomColors.white,
                                                        hoverColor: CustomColors.white,
                                                        filled: true,
                                                        border: OutlineInputBorder(
                                                          borderRadius: BorderRadius.circular(10),
                                                        ),
                                                        focusedBorder: OutlineInputBorder(
                                                          borderSide: BorderSide(color: CustomColors.white, width: 0.0),
                                                          borderRadius: BorderRadius.circular(10.0),
                                                        ),
                                                        enabledBorder: OutlineInputBorder(
                                                          borderSide: BorderSide(color: CustomColors.white, width: 0.0),
                                                          borderRadius: BorderRadius.circular(10.0),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  // Major
                                                  Container(
                                                    height: 50,
                                                    decoration: BoxDecoration(
                                                      color: CustomColors.white,
                                                      borderRadius: BorderRadius.circular(12),
                                                    ),
                                                    child: TextFormField(
                                                      controller: majorController,
                                                      keyboardType: TextInputType.name,
                                                      textInputAction: TextInputAction.next,
                                                      style: const TextStyle(
                                                        fontSize: 16,
                                                        fontFamily: "Rubik",
                                                        fontWeight: FontWeight.w400,
                                                      ),
                                                      textAlignVertical: TextAlignVertical.bottom,
                                                      maxLines: 1,
                                                      decoration: InputDecoration(
                                                        hintText: "Major",
                                                        fillColor: CustomColors.myJobDetail,
                                                        focusColor: CustomColors.white,
                                                        hoverColor: CustomColors.white,
                                                        filled: true,
                                                        border: OutlineInputBorder(
                                                          borderRadius: BorderRadius.circular(10),
                                                        ),
                                                        focusedBorder: OutlineInputBorder(
                                                          borderSide: BorderSide(color: CustomColors.white, width: 0.0),
                                                          borderRadius: BorderRadius.circular(10.0),
                                                        ),
                                                        enabledBorder: OutlineInputBorder(
                                                          borderSide: BorderSide(color: CustomColors.white, width: 0.0),
                                                          borderRadius: BorderRadius.circular(10.0),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  // Time period
                                                  const SizedBox(
                                                    height: 15,
                                                  ),
                                                  TextButton.icon(
                                                    style: TextButton.styleFrom(splashFactory: NoSplash.splashFactory),
                                                    onPressed: () {
                                                      _toggleradio();
                                                      setState(() {});
                                                    },
                                                    icon: CircleAvatar(
                                                      backgroundColor: const Color.fromARGB(181, 171, 171, 171),
                                                      radius: 8,
                                                      child: CircleAvatar(
                                                        radius: 4,
                                                        backgroundColor: isPeriodSeleted == "1" ? CustomColors.primaryText : const Color.fromARGB(181, 171, 171, 171),
                                                      ),
                                                    ),
                                                    label: Text(
                                                      "Currently Studying?",
                                                      textAlign: TextAlign.center,
                                                      style: TextStyle(
                                                        color: CustomColors.primaryText,
                                                        fontFamily: "Rubik",
                                                        fontStyle: FontStyle.normal,
                                                        fontSize: 12,
                                                        fontWeight: FontWeight.w400,
                                                      ),
                                                    ),
                                                  ),
                                                  // From Date
                                                  Container(
                                                    height: 50,
                                                    decoration: BoxDecoration(
                                                      color: CustomColors.myJobDetail,
                                                      borderRadius: BorderRadius.circular(12),
                                                    ),
                                                    child: CustomTextFieldWidget(
                                                      borderColor: CustomColors.white,
                                                      obsecure: false,
                                                      keyboardType: TextInputType.number,
                                                      controller: fromController,
                                                      hintText: "From",
                                                      onTap: () async {
                                                        _fromDate(context);
                                                      },
                                                    ),
                                                  ),
                                                  // To Date
                                                  const SizedBox(
                                                    height: 15,
                                                  ),
                                                  Container(
                                                    height: 50,
                                                    decoration: BoxDecoration(
                                                      color: CustomColors.myJobDetail,
                                                      borderRadius: BorderRadius.circular(12),
                                                    ),
                                                    child: CustomTextFieldWidget(
                                                      borderColor: CustomColors.white,
                                                      obsecure: false,
                                                      keyboardType: TextInputType.number,
                                                      controller: toController,
                                                      hintText: "To",
                                                      onTap: () async {
                                                        _toDate(context);
                                                      },
                                                    ),
                                                  ),
                                                  // AddBtn
                                                  GestureDetector(
                                                    onTap: () async {
                                                      {
                                                        String institute = instituteController.text.trim();
                                                        String major = majorController.text.trim();
                                                        String from = fromController.text.toString();
                                                        String to = toController.text.toString();

                                                        if (institute.isNotEmpty && major.isNotEmpty) {
                                                          instituteController.text = '';
                                                          majorController.text = '';
                                                          fromController.text = '';
                                                          toController.text = '';
                                                          instituteMapList.add(institute);
                                                          majorMapList.add(major);
                                                          startDateMapList.add(from);
                                                          endDateMapList.add(to);
                                                          currentMapList.add(isPeriodSeleted);
                                                          setState(() {
                                                            educationApiList.add(
                                                              {
                                                                "name": institute.toString(),
                                                                "major": major.toString(),
                                                                "from": from.toString(),
                                                                "current": isPeriodSeleted.toString(),
                                                                "to": to.toString(),
                                                              },
                                                            );
                                                          });

                                                          setState(() {
                                                            instituteController.text = '';
                                                            majorController.text = '';
                                                            fromController.text = '';
                                                            toController.text = '';
                                                          });
                                                          SharedPreferences pref = await SharedPreferences.getInstance();
                                                          var data = await pref.setString('ListData', education.toString());

                                                          Navigator.pop(context, true);
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
                                          ),
                                        );
                                      },
                                    );
                                  },
                                );
                              },
                              child: Container(
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: CustomColors.primaryColor,
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Text(
                                  "Add Education",
                                  style: TextStyle(
                                    color: CustomColors.white,
                                    fontSize: 13,
                                    fontFamily: "Poppins",
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        if (educationApiList.isNotEmpty) ...[
                          Column(
                            children: [
                              for (var i = 0; i < educationApiList.length; i++) ...[
                                SizedBox(
                                  height: 100,
                                  width: MediaQuery.of(context).size.width,
                                  child: Stack(
                                    children: [
                                      Positioned(
                                        top: 10,
                                        child: Container(
                                          width: MediaQuery.of(context).size.width - 40,
                                          height: 90,
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 10,
                                            vertical: 10,
                                          ),
                                          decoration: BoxDecoration(
                                            color: CustomColors.white,
                                            borderRadius: BorderRadius.circular(10),
                                          ),
                                          child: Column(
                                            children: [
                                              Row(
                                                children: [
                                                  const Text("Institute Name: "),
                                                  Expanded(
                                                    child: Text(
                                                      "${educationApiList[i]['name']}",
                                                      maxLines: 2,
                                                      overflow: TextOverflow.fade,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              Row(
                                                children: [
                                                  const Text("Major: "),
                                                  Expanded(
                                                    child: Text(
                                                      "${educationApiList[i]['major']}",
                                                      maxLines: 2,
                                                      overflow: TextOverflow.fade,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              Row(
                                                children: [
                                                  const Text("From: "),
                                                  Expanded(
                                                    child: Text(
                                                      "${educationApiList[i]['from']}",
                                                      maxLines: 2,
                                                      overflow: TextOverflow.fade,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      Positioned(
                                        top: 0,
                                        right: 05,
                                        child: GestureDetector(
                                          onTap: () {
                                            //
                                            setState(() {
                                              educationApiList.removeAt(i);
                                              instituteMapList.removeAt(i);
                                              majorMapList.removeAt(i);
                                              startDateMapList.removeAt(i);
                                              endDateMapList.removeAt(i);
                                              currentMapList.removeAt(i);
                                            });
                                          },
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
                                ),
                              ],
                            ],
                          ),
                        ],
                        const SizedBox(height: 10),
                        Text(
                          "Bio",
                          style: TextStyle(
                            color: CustomColors.primaryText,
                            fontSize: 16,
                            fontFamily: "Poppins",
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        // Availability
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 17, vertical: 10),
                          margin: const EdgeInsets.only(bottom: 15, top: 15),
                          decoration: BoxDecoration(
                            color: CustomColors.white,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Availability",
                                style: TextStyle(
                                  color: CustomColors.primaryColor,
                                  fontSize: 12,
                                  fontFamily: "Rubik",
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(height: 05),
                              TextFormField(
                                controller: availabilityController,
                                keyboardType: TextInputType.multiline,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontFamily: "Rubik",
                                  fontWeight: FontWeight.w400,
                                ),
                                textAlignVertical: TextAlignVertical.bottom,
                                maxLines: 4,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return "Please fill this field";
                                  }
                                  return null;
                                },
                                decoration: InputDecoration(
                                  hintText: "Availability",
                                  fillColor: CustomColors.white,
                                  focusColor: CustomColors.white,
                                  hoverColor: CustomColors.white,
                                  filled: true,
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(0),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: CustomColors.white, width: 0.0),
                                    borderRadius: BorderRadius.circular(0.0),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: CustomColors.white, width: 0.0),
                                    borderRadius: BorderRadius.circular(0.0),
                                  ),
                                  errorBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: CustomColors.red, width: 0.5),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  focusedErrorBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: CustomColors.red, width: 0.5),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        // User Info
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 17, vertical: 10),
                          margin: const EdgeInsets.only(bottom: 15),
                          decoration: BoxDecoration(
                            color: CustomColors.white,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "About Me",
                                style: TextStyle(
                                  color: CustomColors.primaryColor,
                                  fontSize: 12,
                                  fontFamily: "Rubik",
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(height: 05),
                              TextFormField(
                                controller: userInfoController,
                                keyboardType: TextInputType.name,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontFamily: "Rubik",
                                  fontWeight: FontWeight.w400,
                                ),
                                textAlignVertical: TextAlignVertical.bottom,
                                maxLines: 1,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return "Please fill this field";
                                  }
                                  return null;
                                },
                                decoration: InputDecoration(
                                  hintText: "User Info",
                                  fillColor: CustomColors.white,
                                  focusColor: CustomColors.white,
                                  hoverColor: CustomColors.white,
                                  filled: true,
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: CustomColors.white, width: 0.0),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  errorBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: CustomColors.red, width: 0.5),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  focusedErrorBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: CustomColors.red, width: 0.5),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: CustomColors.white, width: 0.0),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        // Background Verified
                        // DottedBorder(
                        //   radius: const Radius.circular(10),
                        //   borderType: BorderType.RRect,
                        //   color: CustomColors.primaryColor,
                        //   child: Container(
                        //     padding: const EdgeInsets.symmetric(vertical: 5),
                        //     decoration: BoxDecoration(
                        //       color: CustomColors.primaryLight,
                        //       borderRadius: BorderRadius.circular(10),
                        //     ),
                        //     child: ListTile(
                        //       leading: Icon(
                        //         Icons.workspace_premium,
                        //         color: CustomColors.primaryColor,
                        //       ),
                        //       title: Text(
                        //         "Background Verified",
                        //         style: TextStyle(
                        //           color: CustomColors.primaryText,
                        //           fontSize: 12,
                        //           fontFamily: "Poppins",
                        //           fontWeight: FontWeight.w600,
                        //         ),
                        //       ),
                        //       subtitle: Text(
                        //         "We encourage parents to conduct their own screenings using the background check tools. See what each of the badges covered, or learn more about keeping your family safe by visiting the Trust & Safety Center.",
                        //         style: TextStyle(
                        //           color: CustomColors.primaryText,
                        //           fontSize: 10,
                        //           fontFamily: "Poppins",
                        //           fontWeight: FontWeight.w300,
                        //         ),
                        //       ),
                        //     ),
                        //   ),
                        // ),
                        // const SizedBox(height: 20),
                        // file type 1
                        UploadBasicDocumentList(
                          onTap: () {
                            uploadDocument("valid_driver_license");
                          },
                          title: "Valid Driver's License",
                          fileSelectText: lists['valid_driver_license'].toString().isEmpty ? "Select File" : "Change File",
                        ),
                        if (error != null && error['errors'] != null && error['errors']!['valid_driver_license'] != null) ...[
                          const SizedBox(height: 05),
                          Padding(
                            padding: const EdgeInsets.only(left: 10),
                            child: Text(
                              error['errors']['valid_driver_license'].toString(),
                              style: const TextStyle(
                                color: Colors.red,
                                fontSize: 09,
                              ),
                            ),
                          ),
                        ],
                        const SizedBox(height: 10),
                        // file type 2
                        UploadBasicDocumentList(
                          onTap: () {
                            uploadDocument("scars_awareness_certification");
                          },
                          title: "Scars Awareness Certification",
                          fileSelectText: lists['scars_awareness_certification'].toString().isEmpty ? "Select File" : "Change File",
                        ),
                        if (error != null && error['errors'] != null && error['errors']!['scars_awareness_certification'] != null) ...[
                          const SizedBox(height: 05),
                          Padding(
                            padding: const EdgeInsets.only(left: 10),
                            child: Text(
                              error['errors']['scars_awareness_certification'].toString(),
                              style: const TextStyle(
                                color: Colors.red,
                                fontSize: 09,
                              ),
                            ),
                          ),
                        ],
                        const SizedBox(height: 10),
                        // file type 8
                        UploadBasicDocumentList(
                          onTap: () {
                            uploadDocument("police_background_check");
                          },
                          title: "Police Background Check",
                          fileSelectText: lists['police_background_check'].toString().isEmpty ? "Select File" : "Change File",
                        ),
                        if (error != null && error['errors'] != null && error['errors']!['police_background_check'] != null) ...[
                          const SizedBox(height: 05),
                          Padding(
                            padding: const EdgeInsets.only(left: 10),
                            child: Text(
                              error['errors']['police_background_check'].toString(),
                              style: const TextStyle(
                                color: Colors.red,
                                fontSize: 09,
                              ),
                            ),
                          ),
                        ],
                        const SizedBox(height: 10),
                        // file type 3a
                        UploadBasicDocumentList(
                          onTap: () {
                            uploadDocument("cpr_first_aid_certification");
                          },
                          title: "CPR/First Aid Certificate",
                          fileSelectText: lists['cpr_first_aid_certification'].toString().isEmpty ? "Select File" : "Change File",
                        ),
                        if (error != null && error['errors'] != null && error['errors']!['cpr_first_aid_certification'] != null) ...[
                          const SizedBox(height: 05),
                          Padding(
                            padding: const EdgeInsets.only(left: 10),
                            child: Text(
                              error['errors']['cpr_first_aid_certification'].toString(),
                              style: const TextStyle(
                                color: Colors.red,
                                fontSize: 09,
                              ),
                            ),
                          ),
                        ],
                        const SizedBox(height: 10),
                        // file type 7
                        UploadBasicDocumentList(
                          onTap: () {
                            uploadDocument("government_registered_care_provider");
                          },
                          title: "Government Registered Care Provider",
                          fileSelectText: lists['government_registered_care_provider'].toString().isEmpty ? "Select File" : "Change File",
                        ),
                        if (error != null && error['errors'] != null && error['errors']!['government_registered_care_provider'] != null) ...[
                          const SizedBox(height: 05),
                          Padding(
                            padding: const EdgeInsets.only(left: 10),
                            child: Text(
                              error['errors']['government_registered_care_provider'].toString(),
                              style: const TextStyle(
                                color: Colors.red,
                                fontSize: 09,
                              ),
                            ),
                          ),
                        ],
                        // file type 4
                        const SizedBox(height: 10),
                        UploadBasicDocumentList(
                          onTap: () {
                            uploadDocument("animal_care_provider_certification");
                          },
                          title: "Animal Care Provider Certificate",
                          fileSelectText: lists['animal_care_provider_certification'].toString().isEmpty ? "Select File" : "Change File",
                        ),
                        if (error != null && error['errors'] != null && error['errors']!['animal_care_provider_certification'] != null) ...[
                          const SizedBox(height: 05),
                          Padding(
                            padding: const EdgeInsets.only(left: 5.0),
                            child: Text(
                              error['errors']['animal_care_provider_certification'].toString(),
                              style: const TextStyle(
                                color: Colors.red,
                                fontSize: 09,
                              ),
                            ),
                          ),
                        ],
                        // file type 6
                        const SizedBox(height: 10),
                        UploadBasicDocumentList(
                          onTap: () {
                            uploadDocument("animail_first_aid");
                          },
                          title: "Animal First Aid",
                          fileSelectText: lists['animail_first_aid'].toString().isEmpty ? "Select File" : "Change File",
                        ),
                        if (error != null && error['errors'] != null && error['errors']!['animail_first_aid'] != null) ...[
                          const SizedBox(height: 05),
                          Padding(
                            padding: const EdgeInsets.only(left: 10),
                            child: Text(
                              error['errors']['animail_first_aid'][0].toString(),
                              style: const TextStyle(
                                color: Colors.red,
                                fontSize: 09,
                              ),
                            ),
                          ),
                        ],
                        // file type 3a
                        const SizedBox(height: 10),
                        UploadBasicDocumentList(
                          onTap: () {
                            uploadDocument("red_cross_babysitting_certification");
                          },
                          title: "Red Cross Babysitting Certification",
                          fileSelectText: lists['red_cross_babysitting_certification'].toString().isEmpty ? "Select File" : "Change File",
                        ),
                        if (error != null && error['errors'] != null && error['errors']!['red_cross_babysitting_certification'] != null) ...[
                          const SizedBox(height: 05),
                          Padding(
                            padding: const EdgeInsets.only(left: 10),
                            child: Text(
                              error['errors']['red_cross_babysitting_certification'][0].toString(),
                              style: const TextStyle(
                                color: Colors.red,
                                fontSize: 09,
                              ),
                            ),
                          ),
                        ],
                        // file type 3b

                        // file type 5
                        const SizedBox(height: 10),
                        UploadBasicDocumentList(
                          onTap: () {
                            uploadDocument("chaild_and_family_services_and_abuse");
                          },
                          title: "Dept Child and Family Services Child Abuse Check",
                          fileSelectText: lists['chaild_and_family_services_and_abuse'].toString().isEmpty ? "Select File" : "Change File",
                        ),
                        if (error != null && error['errors'] != null && error['errors']!['chaild_and_family_services_and_abuse'] != null) ...[
                          const SizedBox(height: 05),
                          Padding(
                            padding: const EdgeInsets.only(left: 10),
                            child: Text(
                              error['errors']['chaild_and_family_services_and_abuse'][0].toString(),
                              style: const TextStyle(
                                color: Colors.red,
                                fontSize: 09,
                              ),
                            ),
                          ),
                        ],
                        // file type 7

                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 0),
                          child: GestureDetector(
                            onTap: () async {
                              updateFormKey.currentState!.validate();
                              if (_isSelectedGender == null) {
                                customErrorSnackBar(context, "Please Select Gender");
                              } else if (phoneController.text.isEmpty) {
                                customErrorSnackBar(context, "Please Enter Phone Number");
                              } else if (dobController.text.isEmpty) {
                                customErrorSnackBar(context, "Please Select Date Of Birth");
                              } else if (selectedArea == "select") {
                                customErrorSnackBar(context, "Please Select Area");
                              } else if (experienceController.text.isEmpty) {
                                customErrorSnackBar(context, "Please Enter Years of Experience");
                              } else if (hourlyController.text.isEmpty) {
                                customErrorSnackBar(context, "Please Enter User Hourly Rate");
                              } else if (addressController.text.isEmpty) {
                                customErrorSnackBar(context, "Please Enter User Address");
                              } else if (zipController.text.isEmpty) {
                                customErrorSnackBar(context, "Please Enter Zip Code");
                              } else if (keywordController.text.isEmpty) {
                                customErrorSnackBar(context, "Please Enter User Keyword");
                              } else if (availabilityController.text.isEmpty) {
                                customErrorSnackBar(context, "Please Enter User Availability");
                              } else if (userInfoController.text.isEmpty) {
                                customErrorSnackBar(context, "Please Enter User Info");
                              } else if (instituteMapList.isEmpty) {
                                customErrorSnackBar(context, "Please Enter education");
                              } else {
                                if (updateFormKey.currentState!.validate()) {
                                  setState(() {
                                    sendRequest = true;
                                  });
                                  uploadImageDio();
                                }
                              }
                            },
                            child: Container(
                              width: MediaQuery.of(context).size.width,
                              height: 60,
                              margin: const EdgeInsets.symmetric(vertical: 10),
                              decoration: BoxDecoration(
                                color: const Color(0xff6BD294).withOpacity(0.8),
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
                                child: sendRequest
                                    ? const CircularProgressIndicator(
                                        color: Colors.white,
                                      )
                                    : Text(
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
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget getEducation(int index) {
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
              style: TextStyle(fontSize: 18.0, color: Colors.white),
            ),
          ),
        ),
        Positioned(
          top: 25,
          right: 10,
          left: 3,
          bottom: 5,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 5),
            decoration: BoxDecoration(color: CustomColors.white, borderRadius: BorderRadius.circular(10)),
            alignment: Alignment.centerLeft,
            width: MediaQuery.of(context).size.width,
            height: 100,
          ),
        ),
        Positioned(
          top: 10,
          right: -2,
          child: GestureDetector(
            onTap: (() {
              setState(() {
                education.removeAt(index);
                instituteMapList.removeAt(index);
                majorMapList.removeAt(index);
                startDateMapList.removeAt(index);
                endDateMapList.removeAt(index);
                currentMapList.removeAt(index);
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
  }

  Widget getRow(int index) {
    return Card(
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: index % 2 == 0 ? Colors.deepPurpleAccent : Colors.purple,
          foregroundColor: Colors.white,
          child: Text(
            education[index]["institute_name[]"].toString(),
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              education[index]["institute_name[]"].toString(),
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            Text(education[index]["major[]"].toString()),
          ],
        ),
        trailing: SizedBox(
          width: 70,
          child: Row(
            children: [
              InkWell(
                  onTap: (() {
                    //
                    setState(() {
                      education.removeAt(index);
                      instituteMapList.removeAt(index);
                      majorMapList.removeAt(index);
                      startDateMapList.removeAt(index);
                      endDateMapList.removeAt(index);
                      currentMapList.removeAt(index);
                    });
                  }),
                  child: const Icon(Icons.delete)),
            ],
          ),
        ),
      ),
    );
  }
}
