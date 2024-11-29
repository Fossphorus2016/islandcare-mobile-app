// ignore_for_file: use_build_context_synchronously, unused_local_variable, unnecessary_null_comparison, prefer_typing_uninitialized_variables, unrelated_type_equality_checks

// import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:island_app/caregiver/models/profile_model.dart';
import 'package:island_app/caregiver/utils/profile_provider.dart';
import 'package:island_app/utils/app_colors.dart';
import 'package:island_app/utils/app_url.dart';
import 'package:island_app/utils/functions.dart';
import 'package:island_app/utils/http_handlers.dart';
import 'package:island_app/widgets/document_download_list.dart';
import 'package:island_app/widgets/loading_button.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';
import 'package:provider/provider.dart';
import 'package:island_app/carereceiver/utils/colors.dart';
import 'package:island_app/widgets/custom_text_field.dart';

class ProfileGiverPendingEdit extends StatefulWidget {
  final String? name;
  final String? email;
  final String? avatar;
  final String? serviceName;
  final String? gender;
  final String? phoneNumber;
  final String? dob;
  final int? yoe;
  final String? hourlyRate;
  final String? userAddress;
  final List<String>? area;

  final String? zipCode;
  final List? additionalService;
  final List? educations;

  final String? availability;
  final String? userInfo;
  final String? workReference;
  final String? resume;
  final bool? validDriverLicenseVerify;
  final bool? scarsAwarenessCertificationVerify;
  final bool? policeBackgroundCheckVerify;
  final bool? cprFirstAidCertificationVerify;
  final bool? governmentRegisteredCareProviderVerify;
  final bool? animalCareProviderCertificationVerify;
  final bool? animalFirstAidVerify;
  final bool? redCrossBabysittingCertificationVerify;
  final bool? chaildAndFamilyServicesAndAbuseVerify;

  const ProfileGiverPendingEdit({
    super.key,
    this.name,
    this.email,
    this.avatar,
    this.gender,
    this.phoneNumber,
    this.dob,
    this.yoe,
    this.hourlyRate,
    this.userAddress,
    this.area,
    this.zipCode,
    this.additionalService,
    this.userInfo,
    this.availability,
    this.educations,
    this.serviceName,
    this.workReference,
    this.resume,
    this.validDriverLicenseVerify,
    this.scarsAwarenessCertificationVerify,
    this.policeBackgroundCheckVerify,
    this.cprFirstAidCertificationVerify,
    this.governmentRegisteredCareProviderVerify,
    this.animalCareProviderCertificationVerify,
    this.animalFirstAidVerify,
    this.redCrossBabysittingCertificationVerify,
    this.chaildAndFamilyServicesAndAbuseVerify,
  });
  @override
  State<ProfileGiverPendingEdit> createState() => _ProfileGiverPendingEditState();
}

class _ProfileGiverPendingEditState extends State<ProfileGiverPendingEdit> {
  final TextEditingController dobController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController zipController = TextEditingController();
  final TextEditingController userInfoController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController experienceController = TextEditingController();
  final TextEditingController hourlyController = TextEditingController();
  final TextEditingController availabilityController = TextEditingController();
  final TextEditingController instituteController = TextEditingController();
  final TextEditingController majorController = TextEditingController();
  final TextEditingController fromController = TextEditingController();
  final TextEditingController toController = TextEditingController();
  @override
  void initState() {
    super.initState();

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

    if (widget.availability != null) {
      availabilityController.text = widget.availability!;
    }
    if (widget.userInfo != null) {
      userInfoController.text = widget.userInfo!;
    }
    if (widget.gender != "null" && widget.gender != null) {
      isSelectedGender = widget.gender.toString();
    }
    if (widget.area != "null" && widget.area != null) {
      selectedArea = widget.area!;
    }
    if (widget.additionalService != null && widget.additionalService!.isNotEmpty) {
      selectedAdditionalService.addAll(widget.additionalService!);
      selectedAdditionalService = selectedAdditionalService.toSet().toList();
      setRequireDocumentInit();
    }
    if (widget.educations != null && widget.educations!.isNotEmpty) {
      for (var i = 0; i < widget.educations!.length; i++) {
        var item = widget.educations![i];
        instituteMapList.add(widget.educations![i]['name']);
        majorMapList.add(widget.educations![i]['major']);
        startDateMapList.add(widget.educations![i]['from']);
        endDateMapList.add(widget.educations![i]['to']);
        currentMapList.add(widget.educations![i]['current']);
        educationApiList.add(widget.educations![i]);
      }
      instituteMapList = instituteMapList.toSet().toList();
      majorMapList = majorMapList.toSet().toList();
      startDateMapList = startDateMapList.toSet().toList();
      endDateMapList = endDateMapList.toSet().toList();
      currentMapList = currentMapList.toSet().toList();
      educationApiList = educationApiList.toSet().toList();
    }
    validationErrors = {
      "valid_driver_license": {"status": false, "verify": widget.validDriverLicenseVerify == true, "error": "Valid Driver License is Required."},
      "scars_awareness_certification": {"status": false, "verify": widget.scarsAwarenessCertificationVerify == true, "error": "Scars Awareness Certification is Required."},
      "red_cross_babysitting_certification": {"status": false, "verify": widget.redCrossBabysittingCertificationVerify == true, "error": "Red Cross Babysitting Certification is Required."},
      "cpr_first_aid_certification": {"status": false, "verify": widget.cprFirstAidCertificationVerify == true, "error": "CPR First Aid Certification is Required."},
      "animal_care_provider_certification": {"status": false, "verify": widget.animalCareProviderCertificationVerify == true, "error": "Animal Care Provider Certification is Required."},
      "child_and_family_services_and_abuse": {"status": false, "verify": widget.chaildAndFamilyServicesAndAbuseVerify == true, "error": "Child And Family Services and Abuse is Required."},
      "animail_first_aid": {"status": false, "verify": widget.animalFirstAidVerify == true, "error": "Animail First Aid is Required."},
      "government_registered_care_provider": {"status": false, "verify": widget.governmentRegisteredCareProviderVerify == true, "error": "Government Registered Care Provider is Required."},
      "police_background_check": {"status": false, "verify": widget.policeBackgroundCheckVerify == true, "error": "Police Background Check is Required."},
    };
  }

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

    instituteController.dispose();
    majorController.dispose();
    fromController.dispose();
    toController.dispose();
  }

  var isSelectedGender = "1";
  setSelectedGender(value) {
    setState(() {
      isSelectedGender = value;
    });
  }

  List<String> listSuggestedType = [
    "Senior Care",
    "Pet Care",
    "House Keeping",
    "School Support",
    "Child Care",
  ];

  List selectedAdditionalService = [];

  setSelectedAdditionalService(value) {
    setState(() {
      selectedAdditionalService.add(value);
    });
    setRequireDocument(value);
  }

  removeSelectedAdditionalService(value) {
    setState(() {
      selectedAdditionalService.remove(value);
    });
    removeRequireDocument(value);
  }

  int selectedIndex = -1;
  bool sendRequest = false;

  bool phoneError = false;
  setPhoneError(value) {
    setState(() {
      phoneError = value;
    });
  }

  bool yearOfExpError = false;
  setYearOfExpError(value) {
    setState(() {
      yearOfExpError = value;
    });
  }

  bool hourlyRateError = false;
  setHourlyRateError(value) {
    setState(() {
      hourlyRateError = value;
    });
  }

  bool userAddressError = false;
  setUserAddressError(value) {
    setState(() {
      userAddressError = value;
    });
  }

  bool zipcodeError = false;
  setZipcodeError(value) {
    setState(() {
      zipcodeError = value;
    });
  }

  bool additionalServiceError = false;
  bool avaibilityError = false;
  setAvaibilityError(value) {
    setState(() {
      avaibilityError = value;
    });
  }

  bool aboutMeError = false;
  setAboutMeError(value) {
    setState(() {
      aboutMeError = value;
    });
  }

  var isPeriodSeleted = "0";
  void toggleradio(value) {
    setState(() {
      if (value == true) {
        isPeriodSeleted = "1";
      } else {
        isPeriodSeleted = "0";
      }
    });
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

  var gettoPickedDate;
  var getfromPickedDate;
  bool _isDateSelectable(DateTime date) {
    // Disable dates before today
    return date.isBefore(DateTime.now());
  }

  DateTime? selectedDate = DateTime.now();
  var myFormat = DateFormat('d-MM-yyyy');
  String getPickedDate = '';
  selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate!,
      firstDate: DateTime(1975),
      lastDate: DateTime.now(),
      initialEntryMode: DatePickerEntryMode.calendarOnly,
      selectableDayPredicate: _isDateSelectable,
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: ColorScheme.fromSwatch(
              primarySwatch: Colors.teal,
              backgroundColor: ServiceGiverColor.black,
              accentColor: const Color(0xff55CE86),
            ),
            dialogBackgroundColor: Colors.white,
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() {
        getPickedDate = DateFormat('yyyy-MM-dd').format(picked);
      });
    }
  }

  eduFromDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      firstDate: DateTime(1990),
      lastDate: DateTime.now(),
      initialEntryMode: DatePickerEntryMode.calendarOnly,
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: ColorScheme.fromSwatch(
              primarySwatch: Colors.teal,
              accentColor: const Color(0xff55CE86),
            ),
            dialogBackgroundColor: Colors.white,
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() {
        fromController.text = DateFormat('yyyy-MM-dd').format(picked);

        picked == fromController;

        getfromPickedDate = fromController.text;
      });
    }
  }

  eduToDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      firstDate: DateTime(1990),
      lastDate: DateTime.now(),
      initialEntryMode: DatePickerEntryMode.calendarOnly,
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: ColorScheme.fromSwatch(
              primarySwatch: Colors.teal,
              accentColor: const Color(0xff55CE86),
            ),
            dialogBackgroundColor: Colors.white,
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() {
        toController.text = DateFormat('yyyy-MM-dd').format(picked);
        picked == toController;

        gettoPickedDate = toController.text;
      });
    }
  }

  List educationApiList = [];
  late Future<ProfileGiverModel> fetchProfileEdit;

  File? image;
  File? imageFileDio;

  bool showSpinner = false;
  var myimg;

  Future getImageDio(BuildContext context) async {
    try {
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
      }
      // else {
      //   showErrorToast("No file select");
      // }
    } catch (e) {
      //
    }
  }

  var lists = {
    'work_reference': "",
    'resume': "",
    "valid_driver_license": "",
    "scars_awareness_certification": "",
    "red_cross_babysitting_certification": "",
    "cpr_first_aid_certification": "",
    "animal_care_provider_certification": "",
    "child_and_family_services_and_abuse": "",
    "animail_first_aid": "",
    "government_registered_care_provider": "",
    "police_background_check": "",
  };

  uploadDocument(BuildContext context, String documentType) async {
    try {
      FilePickerResult? file = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf', 'docx', 'doc'],
      );
      if (file != null) {
        if (file.files[0].extension == "pdf" || file.files[0].extension == "doc" || file.files[0].extension == "docx") {
          setState(() {
            lists[documentType] = file.files.single.path.toString();
          });
        } else {
          showErrorToast("Only DOC and PDF file allowed");
        }
      }
    } catch (error) {
      showErrorToast(error.toString());
    }
  }

  var error;
  Future<void> sendPrfileUpdateRequest() async {
    var usersId = await Provider.of<ServiceGiverProvider>(context, listen: false).getUserId();
    var token = await getToken();
    print(selectedArea.join(','));
    var formData = FormData.fromMap({
      '_method': 'PUT',
      'id': usersId,
      'user_info': userInfoController.text.trim().toString(),
      'phone': phoneController.text.trim().toString(),
      'address': addressController.text.trim().toString(),
      'gender': isSelectedGender,
      'dob': dobController.text.trim().toString(),
      'area': selectedArea.join(','),
      'zip': zipController.text.trim().toString(),
      'experience': experienceController.text.trim().toString(),
      'hourly_rate': hourlyController.text.trim().toString(),
      'availability': availabilityController.text.trim().toString(),
      'additional_service[]': selectedAdditionalService,
      // 'service': jsonEncode(List<dynamic>.from(selectedAdditionalService.map((x) => {"value": x}))),
      "avatar": imageFileDio == null ? '' : await MultipartFile.fromFile(imageFileDio!.path),
      "institute_name[]": instituteMapList,
      "start_date[]": startDateMapList,
      "end_date[]": endDateMapList,
      "current[]": currentMapList,
      "major[]": majorMapList,
      "work_reference": lists['work_reference'].toString().isEmpty ? '' : await MultipartFile.fromFile(lists['work_reference'].toString()),
      "resume": lists['resume'].toString().isEmpty ? '' : await MultipartFile.fromFile(lists['resume'].toString()),
      "valid_driver_license": lists['valid_driver_license'].toString().isEmpty ? '' : await MultipartFile.fromFile(lists['valid_driver_license'].toString()),
      "scars_awareness_certification": lists['scars_awareness_certification'].toString().isEmpty ? '' : await MultipartFile.fromFile(lists['scars_awareness_certification'].toString()),
      "red_cross_babysitting_certification": lists['red_cross_babysitting_certification'].toString().isEmpty ? '' : await MultipartFile.fromFile(lists['red_cross_babysitting_certification'].toString()),
      "cpr_first_aid_certification": lists['cpr_first_aid_certification'].toString().isEmpty ? '' : await MultipartFile.fromFile(lists['cpr_first_aid_certification'].toString()),
      "animal_care_provider_certification": lists['animal_care_provider_certification'].toString().isEmpty ? '' : await MultipartFile.fromFile(lists['animal_care_provider_certification'].toString()),
      "child_and_family_services_and_abuse": lists['child_and_family_services_and_abuse'].toString().isEmpty ? '' : await MultipartFile.fromFile(lists['child_and_family_services_and_abuse'].toString()),
      "animail_first_aid": lists['animail_first_aid'].toString().isEmpty ? '' : await MultipartFile.fromFile(lists['animail_first_aid'].toString()),
      "government_registered_care_provider": lists['government_registered_care_provider'].toString().isEmpty ? '' : await MultipartFile.fromFile(lists['government_registered_care_provider'].toString()),
      "police_background_check": lists['police_background_check'].toString().isEmpty ? '' : await MultipartFile.fromFile(lists['police_background_check'].toString()),
    });
    setState(() {
      sendRequest = true;
    });
    try {
      var response = await postRequesthandler(
        url: CareGiverUrl.serviceProviderProfileUpdate,
        formData: formData,
        token: token,
      );
      setState(() {
        sendRequest = false;
      });
      if (response != null && response.statusCode == 200) {
        Provider.of<ServiceGiverProvider>(context, listen: false).fetchProfileGiverModel();
        Navigator.pop(context);
        showSuccessToast("Profile Updated Successfully.");
      } else {
        if (response != null && response.data != null) {
          setState(() {
            error = response.data;
          });
        }
        showErrorToast("Something went wrong please try agan later.");
      }
    } catch (e) {
      showErrorToast(e.toString());
    }
  }

  final List areaList = [
    {"name": "East", "value": "0"},
    {"name": "Central", "value": "1"},
    {"name": "West", "value": "2"},
  ];

  List<String> selectedArea = [];

  removeSelectedArea(item) {
    setState(() {
      selectedArea.remove(item);
    });
  }

  // setSelectedArea(value) {
  //   setState(() {
  //     selectedArea = value;
  //   });
  // }

  List requireDocument = [];

  List<String>? getExtraDocumentRequire(String serviceName) {
    if (serviceName.contains('Senior Care')) {
      return [
        'valid_driver_license',
        'scars_awareness_certification',
        'police_background_check',
        'cpr_first_aid_certification',
        'government_registered_care_provider',
      ];
    } else if (serviceName.contains('Pet Care')) {
      return [
        'valid_driver_license',
        'scars_awareness_certification',
        'police_background_check',
        'animal_care_provider_certification',
        'animail_first_aid',
      ];
    } else if (serviceName.contains('House Keeping')) {
      return null;
    } else if (serviceName.contains('School Support')) {
      return [
        'valid_driver_license',
        'scars_awareness_certification',
        'police_background_check',
        'red_cross_babysitting_certification',
        'cpr_first_aid_certification',
        'child_and_family_services_and_abuse',
        'government_registered_care_provider',
      ];
    } else if (serviceName.contains('Child Care')) {
      return [
        'valid_driver_license',
        'scars_awareness_certification',
        'police_background_check',
        'red_cross_babysitting_certification',
        'cpr_first_aid_certification',
        'child_and_family_services_and_abuse',
        'government_registered_care_provider',
      ];
    } else {
      return null;
    }
  }

  setRequireDocument(value) {
    var getdocrequire = getExtraDocumentRequire(value);
    if (getdocrequire != null) {
      setState(() {
        requireDocument.addAll(getdocrequire);
      });
    }
  }

  removeRequireDocumentDuplicate() {
    setState(() {
      requireDocument = requireDocument.toSet().toList();
    });
  }

  removeRequireDocument(value) {
    var getdocrequire = getExtraDocumentRequire(value);
    setState(() {
      if (getdocrequire != null) {
        for (var i = 0; i < getdocrequire.length; i++) {
          requireDocument.remove(getdocrequire[i]);
        }
      }
    });
  }

  setRequireDocumentInit() {
    setState(() {
      for (int i = 0; i < selectedAdditionalService.length; i++) {
        var getdocrequire = getExtraDocumentRequire(selectedAdditionalService[i]);
        if (getdocrequire != null) {
          requireDocument.addAll(getdocrequire);
        }
      }
    });
  }

  bool isDocumentAvailable(String documentKey) {
    if (validationErrors[documentKey]!['verify']) {
      return true;
    }
    return lists[documentKey]?.isNotEmpty ?? false;
  }

  List<String> missingDocuments = [];

  var validationErrors = {};

  setValidateErrorToDefault() {
    setState(() {
      validationErrors = {
        "valid_driver_license": {"status": false, "verify": widget.validDriverLicenseVerify == true, "error": "Valid Driver License is Required."},
        "scars_awareness_certification": {"status": false, "verify": widget.scarsAwarenessCertificationVerify == true, "error": "Scars Awareness Certification is Required."},
        "red_cross_babysitting_certification": {"status": false, "verify": widget.redCrossBabysittingCertificationVerify == true, "error": "Red Cross Babysitting Certification is Required."},
        "cpr_first_aid_certification": {"status": false, "verify": widget.cprFirstAidCertificationVerify == true, "error": "CPR First Aid Certification is Required."},
        "animal_care_provider_certification": {"status": false, "verify": widget.animalCareProviderCertificationVerify == true, "error": "Animal Care Provider Certification is Required."},
        "child_and_family_services_and_abuse": {"status": false, "verify": widget.chaildAndFamilyServicesAndAbuseVerify == true, "error": "Child And Family Services and Abuse is Required."},
        "animail_first_aid": {"status": false, "verify": widget.animalFirstAidVerify == true, "error": "Animail First Aid is Required."},
        "government_registered_care_provider": {"status": false, "verify": widget.governmentRegisteredCareProviderVerify == true, "error": "Government Registered Care Provider is Required."},
        "police_background_check": {"status": false, "verify": widget.policeBackgroundCheckVerify == true, "error": "Police Background Check is Required."},
      };
    });
  }

  setValidateError(missingDocument) {
    setState(() {
      if (!validationErrors[missingDocument]!['verify']) {
        validationErrors[missingDocument]!['status'] = true;
      }
    });
  }

  final updateFormKey = GlobalKey<FormState>();

  TextEditingController additionalServiceSearchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CustomColors.loginBg,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: ServiceGiverColor.black,
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
      ),
      body: SafeArea(
        child: Form(
          key: updateFormKey,
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
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
                  Align(
                    alignment: Alignment.center,
                    child: InkWell(
                      onTap: () async {
                        await getImageDio(context);
                      },
                      child: SizedBox(
                        height: 100.45,
                        width: 120.45,
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            Container(
                              alignment: Alignment.center,
                              height: 100.45,
                              width: 100.45,
                              decoration: BoxDecoration(
                                color: ServiceGiverColor.black,
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
                              child: imageFileDio == null
                                  ? Center(
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
                            Positioned(
                              right: 05,
                              bottom: 0,
                              child: Container(
                                padding: const EdgeInsets.all(5.0),
                                decoration: BoxDecoration(
                                  color: Colors.grey.shade200,
                                  borderRadius: BorderRadius.circular(80),
                                ),
                                child: const Icon(
                                  Icons.camera_alt,
                                  color: Colors.grey,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  // GestureDetector(
                  //   onTap: () {
                  //     getImageDio(context);
                  //   },
                  //   child: imageFileDio == null
                  //       ? Center(
                  //           child: Container(
                  //             alignment: Alignment.center,
                  //             height: 100.45,
                  //             width: 100.45,
                  //             decoration: BoxDecoration(
                  //               color: ServiceGiverColor.black,
                  //               borderRadius: BorderRadius.circular(100),
                  //               boxShadow: const [
                  //                 BoxShadow(
                  //                   color: Color.fromARGB(15, 0, 0, 0),
                  //                   blurRadius: 4,
                  //                   spreadRadius: 4,
                  //                   offset: Offset(2, 2), // Shadow position
                  //                 ),
                  //               ],
                  //             ),
                  //             child: Center(
                  //               child: widget.avatar != null
                  //                   ? ClipRRect(
                  //                       borderRadius: BorderRadius.circular(100),
                  //                       child: Image(
                  //                         width: 100,
                  //                         height: 100,
                  //                         fit: BoxFit.fitWidth,
                  //                         image: NetworkImage("${AppUrl.webStorageUrl}/${widget.avatar}"),
                  //                       ),
                  //                     )
                  //                   : const Text("Upload"),
                  //             ),
                  //           ),
                  //         )
                  //       : Center(
                  //           child: ClipRRect(
                  //             borderRadius: BorderRadius.circular(100),
                  //             child: Image.file(
                  //               imageFileDio!,
                  //               width: 100,
                  //               height: 100,
                  //               fit: BoxFit.fitWidth,
                  //             ),
                  //           ),
                  //         ),
                  // ),
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
                  // Service Provided
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 17, vertical: 10),
                    decoration: BoxDecoration(
                      color: CustomColors.white,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    width: double.infinity,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Service Provided",
                          style: TextStyle(
                            color: ServiceGiverColor.black,
                            fontSize: 12,
                            fontFamily: "Rubik",
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(widget.serviceName.toString()),
                        ),
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
                            color: ServiceGiverColor.black,
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
                                  setSelectedGender("1");
                                },
                                child: Container(
                                  height: 50.45,
                                  padding: const EdgeInsets.all(4),
                                  decoration: BoxDecoration(
                                    color: isSelectedGender == "1" ? ServiceGiverColor.black : CustomColors.white,
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
                                      setSelectedGender("1");
                                    },
                                    child: Text(
                                      "Male",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        color: isSelectedGender == "1" ? CustomColors.white : CustomColors.primaryText,
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
                                  setSelectedGender("2");
                                },
                                child: Container(
                                  height: 50.45,
                                  padding: const EdgeInsets.all(4),
                                  decoration: BoxDecoration(
                                    color: isSelectedGender == "2" ? ServiceGiverColor.black : CustomColors.white,
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
                                      setSelectedGender("2");
                                    },
                                    child: Text(
                                      "Female",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        color: isSelectedGender == "2" ? CustomColors.white : CustomColors.primaryText,
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
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 17, vertical: 10),
                    decoration: BoxDecoration(
                      color: CustomColors.white,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    width: double.infinity,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Contact Number",
                          style: TextStyle(
                            color: ServiceGiverColor.black,
                            fontSize: 12,
                            fontFamily: "Rubik",
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        // const SizedBox(height: 05),
                        Container(
                          padding: const EdgeInsets.only(left: 12),
                          decoration: phoneError
                              ? BoxDecoration(
                                  border: Border.all(color: Colors.red),
                                  borderRadius: BorderRadius.circular(12),
                                )
                              : null,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              TextFormField(
                                controller: phoneController,
                                keyboardType: TextInputType.phone,
                                textInputAction: TextInputAction.next,
                                inputFormatters: [
                                  FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                                  LengthLimitingTextInputFormatter(15),
                                ],
                                decoration: const InputDecoration(
                                  contentPadding: EdgeInsets.zero,
                                  constraints: BoxConstraints(maxHeight: 50, minHeight: 50),
                                  hintText: "Phone Number",
                                  border: InputBorder.none,
                                ),
                                validator: (value) {
                                  if (value == null || value.trim().toString().length < 10) {
                                    setPhoneError(true);

                                    return "Please enter a valid phone number";
                                  }

                                  setPhoneError(false);

                                  return null;
                                },
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 15),
                  // DOB
                  InkWell(
                    onTap: () {
                      selectDate();
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
                              color: ServiceGiverColor.black,
                              fontSize: 12,
                              fontFamily: "Rubik",
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            getPickedDate.isEmpty
                                ? dobController.text.isEmpty
                                    ? "Date Of Birth"
                                    : dobController.text
                                : getPickedDate.toString(),
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
                  // Experrience
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 17, vertical: 10),
                    decoration: BoxDecoration(
                      color: CustomColors.white,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    width: double.infinity,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Years Of Experience",
                          style: TextStyle(
                            color: ServiceGiverColor.black,
                            fontSize: 12,
                            fontFamily: "Rubik",
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 05),
                        Container(
                          padding: const EdgeInsets.only(left: 12),
                          decoration: yearOfExpError
                              ? BoxDecoration(
                                  border: Border.all(color: Colors.red),
                                  borderRadius: BorderRadius.circular(12),
                                )
                              : null,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              TextFormField(
                                controller: experienceController,
                                keyboardType: TextInputType.number,
                                textInputAction: TextInputAction.next,
                                inputFormatters: [
                                  FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                                  LengthLimitingTextInputFormatter(02),
                                ],
                                decoration: const InputDecoration(
                                  contentPadding: EdgeInsets.zero,
                                  constraints: BoxConstraints(maxHeight: 50, minHeight: 50),
                                  hintText: "Years Of Experience",
                                  border: InputBorder.none,
                                ),
                                validator: (value) {
                                  if (value == null || value.trim().isEmpty) {
                                    setYearOfExpError(true);

                                    return "Please enter your experience";
                                  }
                                  setYearOfExpError(false);

                                  return null;
                                },
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 15),
                  // Hourly Rate
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 17, vertical: 10),
                    decoration: BoxDecoration(
                      color: CustomColors.white,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    width: double.infinity,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Hourly Rate",
                          style: TextStyle(
                            color: ServiceGiverColor.black,
                            fontSize: 12,
                            fontFamily: "Rubik",
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 05),
                        Container(
                          padding: const EdgeInsets.only(left: 0),
                          decoration: hourlyRateError
                              ? BoxDecoration(
                                  border: Border.all(color: Colors.red),
                                  borderRadius: BorderRadius.circular(12),
                                )
                              : null,
                          alignment: Alignment.centerLeft,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              TextFormField(
                                controller: hourlyController,
                                keyboardType: TextInputType.number,
                                textInputAction: TextInputAction.next,
                                inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[0-9]'))],
                                decoration: const InputDecoration(
                                  contentPadding: EdgeInsets.zero,
                                  constraints: BoxConstraints(maxHeight: 50, minHeight: 50),
                                  hintText: "Hourly Rate",
                                  prefixIconConstraints: BoxConstraints(
                                    maxWidth: 60,
                                    minWidth: 30,
                                  ),
                                  prefixIcon: SvgPicture(
                                    SvgAssetLoader("assets/images/icons/currency-dollar.svg"),
                                  ),
                                  border: InputBorder.none,
                                ),
                                validator: (value) {
                                  if (value == null || value.trim().isEmpty) {
                                    setHourlyRateError(true);
                                    return "Please enter your hourly rate";
                                  }
                                  setHourlyRateError(false);
                                  return null;
                                },
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 15),
                  // Address
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
                          "Address",
                          style: TextStyle(
                            color: ServiceGiverColor.black,
                            fontSize: 12,
                            fontFamily: "Rubik",
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 05),
                        Container(
                          padding: const EdgeInsets.only(left: 12),
                          decoration: userAddressError
                              ? BoxDecoration(
                                  border: Border.all(color: Colors.red),
                                  borderRadius: BorderRadius.circular(12),
                                )
                              : null,
                          child: Column(
                            children: [
                              TextFormField(
                                controller: addressController,
                                keyboardType: TextInputType.multiline,
                                maxLines: 3,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontFamily: "Rubik",
                                  fontWeight: FontWeight.w400,
                                ),
                                decoration: const InputDecoration(
                                  hintText: "Address",
                                  contentPadding: EdgeInsets.zero,
                                  border: InputBorder.none,
                                ),
                                validator: (value) {
                                  if (value == null || value.trim().isEmpty) {
                                    setUserAddressError(true);

                                    return "Please enter your permanent address";
                                  }
                                  setUserAddressError(false);

                                  return null;
                                },
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 15),
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
                                  color: ServiceGiverColor.black,
                                  fontSize: 12,
                                  fontFamily: "Rubik",
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(height: 8),
                              MultiSelectDialogField(
                                items: areaList
                                    .map(
                                      (item) => MultiSelectItem(
                                        item["value"].toString(),
                                        item["name"],
                                      ),
                                    )
                                    .toList(),
                                listType: MultiSelectListType.CHIP,
                                buttonIcon: const Icon(Icons.arrow_drop_down),
                                initialValue: selectedArea,
                                decoration: BoxDecoration(borderRadius: BorderRadius.circular(08)),
                                title: const Text(
                                  "Select Area",
                                  style: TextStyle(fontSize: 18, color: Colors.black),
                                ),
                                buttonText: const Text(
                                  "Select Area",
                                  style: TextStyle(fontSize: 14),
                                ),
                                confirmText: const Text("ok"),
                                cancelText: const Text("cancel"),
                                onConfirm: (values) {
                                  setState(() {
                                    selectedArea = values;
                                  });
                                },
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Zip Code
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 17, vertical: 10),
                    decoration: BoxDecoration(
                      color: CustomColors.white,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    width: double.infinity,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Postal Code",
                          style: TextStyle(
                            color: ServiceGiverColor.black,
                            fontSize: 12,
                            fontFamily: "Rubik",
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 05),
                        Container(
                          padding: const EdgeInsets.only(left: 12),
                          decoration: zipcodeError
                              ? BoxDecoration(
                                  border: Border.all(color: Colors.red),
                                  borderRadius: BorderRadius.circular(12),
                                )
                              : null,
                          child: TextFormField(
                            controller: zipController,
                            keyboardType: TextInputType.text,
                            textInputAction: TextInputAction.next,
                            decoration: const InputDecoration(
                              contentPadding: EdgeInsets.zero,
                              constraints: BoxConstraints(maxHeight: 50, minHeight: 50),
                              hintText: "Postal Code",
                              border: InputBorder.none,
                            ),
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                setZipcodeError(true);
                                return "Please enter postal code";
                              }
                              setZipcodeError(false);
                              return null;
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 15),
                  // AdditionalService Make MultiSelected
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 17, vertical: 10),
                    decoration: BoxDecoration(
                      color: CustomColors.white,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    width: double.infinity,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Additional Services",
                              style: TextStyle(
                                color: ServiceGiverColor.black,
                                fontSize: 12,
                                fontFamily: "Rubik",
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 05),
                            InkWell(
                              onTap: () {
                                showModalBottomSheet(
                                  context: context,
                                  isDismissible: true,
                                  isScrollControlled: true,
                                  builder: (context) => StatefulBuilder(
                                    builder: (BuildContext context, StateSetter setState) {
                                      return Container(
                                        color: Colors.white,
                                        width: MediaQuery.of(context).size.width,
                                        child: Column(
                                          children: [
                                            Center(
                                              child: Container(
                                                height: 05,
                                                width: 100,
                                                decoration: BoxDecoration(
                                                  color: Colors.grey.shade200,
                                                  borderRadius: BorderRadius.circular(20),
                                                ),
                                              ),
                                            ),
                                            const SizedBox(height: 50),
                                            Padding(
                                              padding: const EdgeInsets.symmetric(horizontal: 15),
                                              child: TextField(
                                                controller: additionalServiceSearchController,
                                                textAlignVertical: TextAlignVertical.center,
                                                textInputAction: TextInputAction.send,
                                                onEditingComplete: () {
                                                  if (additionalServiceSearchController.text.isNotEmpty && !selectedAdditionalService.any((element) => element == additionalServiceSearchController.text)) {
                                                    setSelectedAdditionalService(additionalServiceSearchController.text);
                                                    setState(() {});
                                                    additionalServiceSearchController.clear();
                                                  }
                                                },
                                                decoration: InputDecoration(
                                                  contentPadding: const EdgeInsets.symmetric(horizontal: 10),
                                                  border: const OutlineInputBorder(),
                                                  suffixIconConstraints: const BoxConstraints(
                                                    minWidth: 40,
                                                    minHeight: 30,
                                                  ),
                                                  suffixIcon: InkWell(
                                                    onTap: () {
                                                      if (additionalServiceSearchController.text.isNotEmpty && !selectedAdditionalService.any((element) => element == additionalServiceSearchController.text)) {
                                                        setSelectedAdditionalService(additionalServiceSearchController.text);
                                                        setState(() {});
                                                        additionalServiceSearchController.clear();
                                                      }
                                                      Navigator.pop(context);
                                                    },
                                                    child: const Icon(Icons.done, size: 24),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            Wrap(
                                              spacing: 8.0,
                                              runSpacing: 0.0,
                                              children: List.generate(selectedAdditionalService.length, (index) {
                                                var item = selectedAdditionalService[index];
                                                return InputChip(
                                                  backgroundColor: Colors.grey.shade200,
                                                  deleteIconColor: Colors.black,
                                                  side: BorderSide.none,
                                                  label: Text(
                                                    item,
                                                    style: const TextStyle(color: Colors.black),
                                                  ),
                                                  deleteIcon: const Icon(
                                                    Icons.close,
                                                    size: 14,
                                                  ),
                                                  onDeleted: () {
                                                    removeSelectedAdditionalService(item);
                                                    setState(() {});
                                                  },
                                                );
                                              }),
                                            ),
                                            Expanded(
                                              child: ListView(
                                                children: listSuggestedType.map<Widget>((e) {
                                                  if (selectedAdditionalService.any((element) => element.toString().toLowerCase().contains(e.toLowerCase()))) {
                                                    return Container();
                                                  }
                                                  return CheckboxListTile(
                                                    value: false,
                                                    title: Text(e),
                                                    onChanged: (value) {
                                                      if (value == true) {
                                                        var val = e;
                                                        setSelectedAdditionalService(val);
                                                        setState(() {});
                                                      }
                                                    },
                                                  );
                                                }).toList(),
                                              ),
                                            ),
                                          ],
                                        ),
                                      );
                                    },
                                  ),
                                );
                              },
                              child: Container(
                                width: 30,
                                height: 30,
                                decoration: BoxDecoration(color: Colors.grey.shade300, borderRadius: BorderRadius.circular(05)),
                                child: const Icon(
                                  Icons.edit,
                                  size: 16,
                                ),
                              ),
                            ),
                          ],
                        ),
                        Wrap(
                          spacing: 8.0,
                          runSpacing: 0.0,
                          children: List.generate(selectedAdditionalService.length, (index) {
                            var item = selectedAdditionalService[index];
                            return Chip(
                              backgroundColor: Colors.grey.shade200,
                              deleteIconColor: Colors.black,
                              side: BorderSide.none,
                              label: Text(
                                item,
                                style: const TextStyle(color: Colors.black),
                              ),
                              deleteIcon: const Icon(
                                Icons.close,
                                size: 14,
                              ),
                              onDeleted: () {
                                removeSelectedAdditionalService(item);
                              },
                            );
                          }),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 15),
                  // Education
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Education/Qualification",
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
                                            Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  "Institute Name",
                                                  style: TextStyle(
                                                    color: ServiceGiverColor.black,
                                                    fontSize: 16,
                                                    fontFamily: "Rubik",
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                ),
                                                const SizedBox(height: 10),
                                                Container(
                                                  height: 50,
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
                                                      focusColor: CustomColors.white,
                                                      hoverColor: CustomColors.white,
                                                      border: OutlineInputBorder(
                                                        borderRadius: BorderRadius.circular(10),
                                                        borderSide: const BorderSide(color: Colors.grey),
                                                      ),
                                                      // focusedBorder: OutlineInputBorder(
                                                      //   borderSide: const BorderSide(color: Colors.grey, width: 0.0),
                                                      //   borderRadius: BorderRadius.circular(10.0),
                                                      // ),
                                                      enabledBorder: OutlineInputBorder(
                                                        borderSide: const BorderSide(color: Colors.grey, width: 0.0),
                                                        borderRadius: BorderRadius.circular(10.0),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),

                                            // Major
                                            const SizedBox(height: 20),
                                            Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  "Degree/Certification",
                                                  style: TextStyle(
                                                    color: ServiceGiverColor.black,
                                                    fontSize: 16,
                                                    fontFamily: "Rubik",
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                ),
                                                const SizedBox(height: 10),
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
                                                      focusColor: CustomColors.white,
                                                      hoverColor: CustomColors.white,
                                                      border: OutlineInputBorder(
                                                        borderRadius: BorderRadius.circular(10),
                                                        borderSide: const BorderSide(color: Colors.grey),
                                                      ),
                                                      enabledBorder: OutlineInputBorder(
                                                        borderSide: const BorderSide(color: Colors.grey, width: 0.0),
                                                        borderRadius: BorderRadius.circular(10.0),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),

                                            // Time period
                                            const SizedBox(height: 20),
                                            Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  "Time Period",
                                                  style: TextStyle(
                                                    color: ServiceGiverColor.black,
                                                    fontSize: 16,
                                                    fontFamily: "Rubik",
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                ),
                                                const SizedBox(height: 10),
                                                Row(
                                                  children: [
                                                    Checkbox.adaptive(
                                                      value: isPeriodSeleted == "0" ? false : true,
                                                      onChanged: (value) {
                                                        toggleradio(value);
                                                        toController.text = '';
                                                        setState(() {});
                                                      },
                                                    ),
                                                    InkWell(
                                                        onTap: () {
                                                          setState(() {
                                                            if (isPeriodSeleted == "1") {
                                                              isPeriodSeleted = "0";
                                                            } else {
                                                              isPeriodSeleted = "1";
                                                            }
                                                          });
                                                        },
                                                        child: const Text("Currently Studying"))
                                                  ],
                                                ),
                                              ],
                                            ),
                                            // From Date
                                            const SizedBox(height: 20),
                                            Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  "From",
                                                  style: TextStyle(
                                                    color: ServiceGiverColor.black,
                                                    fontSize: 16,
                                                    fontFamily: "Rubik",
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                ),
                                                const SizedBox(height: 10),
                                                Container(
                                                  decoration: BoxDecoration(
                                                    color: Colors.white,
                                                    borderRadius: BorderRadius.circular(12),
                                                  ),
                                                  child: CustomTextFieldWidget(
                                                    borderColor: CustomColors.white,
                                                    obsecure: false,
                                                    keyboardType: TextInputType.number,
                                                    controller: fromController,
                                                    readOnly: true,
                                                    hintText: "Pick a date",
                                                    onTap: () async {
                                                      eduFromDate();
                                                    },
                                                  ),
                                                ),
                                              ],
                                            ),

                                            // To Date
                                            if (isPeriodSeleted == "0") ...[
                                              const SizedBox(height: 20),
                                              Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    "To",
                                                    style: TextStyle(
                                                      color: ServiceGiverColor.black,
                                                      fontSize: 16,
                                                      fontFamily: "Rubik",
                                                      fontWeight: FontWeight.w600,
                                                    ),
                                                  ),
                                                  const SizedBox(height: 10),
                                                  Container(
                                                    decoration: BoxDecoration(
                                                      color: Colors.white,
                                                      borderRadius: BorderRadius.circular(12),
                                                    ),
                                                    child: CustomTextFieldWidget(
                                                      borderColor: CustomColors.white,
                                                      obsecure: false,
                                                      readOnly: true,
                                                      keyboardType: TextInputType.number,
                                                      controller: toController,
                                                      hintText: "Pick a date",
                                                      onTap: () async {
                                                        eduToDate();
                                                      },
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                            // AddBtn
                                            const SizedBox(height: 20),
                                            LoadingButton(
                                              title: "Save",
                                              backgroundColor: ServiceGiverColor.black,
                                              height: 54,
                                              textStyle: TextStyle(
                                                color: CustomColors.white,
                                                fontSize: 20,
                                                fontWeight: FontWeight.w600,
                                                fontFamily: "Rubik",
                                              ),
                                              onPressed: () async {
                                                String institute = instituteController.text.trim();
                                                String major = majorController.text.trim();
                                                String from = fromController.text.toString();
                                                String to = toController.text.toString();

                                                if (institute.isNotEmpty && major.isNotEmpty && from.isNotEmpty) {
                                                  if (isPeriodSeleted == "0" && to.isEmpty) {
                                                    return false;
                                                  }
                                                  instituteController.text = '';
                                                  majorController.text = '';
                                                  fromController.text = '';
                                                  toController.text = '';
                                                  instituteMapList.add(institute);
                                                  majorMapList.add(major);
                                                  startDateMapList.add(from);
                                                  endDateMapList.add(to);
                                                  currentMapList.add(isPeriodSeleted);
                                                  educationApiList.add(
                                                    {
                                                      "name": institute.toString(),
                                                      "major": major.toString(),
                                                      "from": from.toString(),
                                                      "current": isPeriodSeleted.toString(),
                                                      "to": to.toString(),
                                                    },
                                                  );
                                                  toggleradio(false);
                                                  instituteController.text = '';
                                                  majorController.text = '';
                                                  fromController.text = '';
                                                  toController.text = '';
                                                  setState(() {});

                                                  Navigator.pop(context, true);
                                                }
                                                return true;
                                              },
                                            ),
                                            const SizedBox(height: 50)
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
                            color: ServiceGiverColor.black,
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
                            height: 120,
                            width: MediaQuery.of(context).size.width,
                            child: Stack(
                              children: [
                                Positioned(
                                  top: 10,
                                  child: Container(
                                    width: MediaQuery.of(context).size.width - 40,
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
                                        Row(
                                          children: [
                                            const Text("to: "),
                                            Expanded(
                                              child: educationApiList[i]['current'] == "1"
                                                  ? const Text(
                                                      "Currently Studying",
                                                      maxLines: 2,
                                                      overflow: TextOverflow.fade,
                                                    )
                                                  : Text(
                                                      "${educationApiList[i]['to']}",
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
                                // remove icon
                                Positioned(
                                  top: 0,
                                  right: 05,
                                  child: GestureDetector(
                                    onTap: () {
                                      educationApiList.removeAt(i);
                                      instituteMapList.removeAt(i);
                                      majorMapList.removeAt(i);
                                      startDateMapList.removeAt(i);
                                      endDateMapList.removeAt(i);
                                      currentMapList.removeAt(i);
                                      setState(() {});
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
                  const SizedBox(height: 15),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 17, vertical: 10),
                    decoration: BoxDecoration(
                      color: CustomColors.white,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    width: double.infinity,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "About Me",
                          style: TextStyle(
                            color: ServiceGiverColor.black,
                            fontSize: 12,
                            fontFamily: "Rubik",
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 05),
                        Container(
                          padding: const EdgeInsets.only(left: 12),
                          decoration: aboutMeError
                              ? BoxDecoration(
                                  border: Border.all(color: Colors.red),
                                  borderRadius: BorderRadius.circular(12),
                                )
                              : null,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                height: 70,
                                child: TextFormField(
                                  controller: userInfoController,
                                  keyboardType: TextInputType.multiline,
                                  textInputAction: TextInputAction.next,
                                  // maxLines: 2,
                                  expands: true,
                                  maxLines: null,
                                  minLines: null,
                                  decoration: const InputDecoration(
                                    contentPadding: EdgeInsets.zero,
                                    hintText: "About Me",
                                    border: InputBorder.none,
                                  ),
                                  validator: (value) {
                                    if (value == null || value.trim().isEmpty) {
                                      setAboutMeError(true);

                                      return "Please provide information about yourself";
                                    }
                                    setAboutMeError(false);
                                    return null;
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 15),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 17, vertical: 10),
                    decoration: BoxDecoration(
                      color: CustomColors.white,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    width: double.infinity,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Availability",
                          style: TextStyle(
                            color: ServiceGiverColor.black,
                            fontSize: 12,
                            fontFamily: "Rubik",
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 05),
                        Container(
                          padding: const EdgeInsets.only(left: 12),
                          decoration: avaibilityError
                              ? BoxDecoration(
                                  border: Border.all(color: Colors.red),
                                  borderRadius: BorderRadius.circular(12),
                                )
                              : null,
                          child: SizedBox(
                            height: 70,
                            child: TextFormField(
                              controller: availabilityController,
                              keyboardType: TextInputType.multiline,
                              textInputAction: TextInputAction.next,
                              // maxLines: 2,
                              expands: true,
                              maxLines: null,
                              minLines: null,
                              decoration: const InputDecoration(
                                contentPadding: EdgeInsets.zero,
                                hintText: "Availability",
                                border: InputBorder.none,
                              ),
                              validator: (value) {
                                if (value == null || value.trim().isEmpty) {
                                  setAvaibilityError(true);
                                  return "Please provide availability information";
                                }
                                setAvaibilityError(false);
                                return null;
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 15),

                  // Work Reference (1 Area)
                  UploadBasicDocumentList(
                    onTap: () {
                      uploadDocument(context, "work_reference");
                    },
                    title: "Work Reference (1 Area)",
                    fileSelectText: lists['work_reference'].toString().isEmpty ? "Select File" : "Change File",
                  ),
                  if (error != null && error['errors'] != null && error['errors']!['work_reference'] != null) ...[
                    const SizedBox(height: 05),
                    Padding(
                      padding: const EdgeInsets.only(left: 10),
                      child: Text(
                        error['errors']['work_reference'].toString(),
                        style: const TextStyle(
                          color: Colors.red,
                          fontSize: 09,
                        ),
                      ),
                    ),
                  ],
                  const SizedBox(height: 10),
                  // Resume
                  UploadBasicDocumentList(
                    onTap: () {
                      uploadDocument(context, "resume");
                    },
                    title: "Resume",
                    fileSelectText: lists['resume'].toString().isEmpty ? "Select File" : "Change File",
                  ),
                  if (error != null && error['errors'] != null && error['errors']!['resume'] != null) ...[
                    const SizedBox(height: 05),
                    Padding(
                      padding: const EdgeInsets.only(left: 10),
                      child: Text(
                        error['errors']['resume'].toString(),
                        style: const TextStyle(
                          color: Colors.red,
                          fontSize: 09,
                        ),
                      ),
                    ),
                  ],
                  const SizedBox(height: 10),

                  // file type 1
                  UploadBasicDocumentList(
                    onTap: () {
                      uploadDocument(context, "valid_driver_license");
                    },
                    title: "Valid Driver's License",
                    fileSelectText: lists['valid_driver_license'].toString().isEmpty ? "Select File" : "Change File",
                  ),
                  if (validationErrors['valid_driver_license']!['status'] == true) ...[
                    const SizedBox(height: 05),
                    Padding(
                      padding: const EdgeInsets.only(left: 10),
                      child: Text(
                        validationErrors['valid_driver_license']!['error'].toString(),
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
                      uploadDocument(context, "scars_awareness_certification");
                    },
                    title: "Scars Awareness Certification",
                    fileSelectText: lists['scars_awareness_certification'].toString().isEmpty ? "Select File" : "Change File",
                  ),
                  if (validationErrors['scars_awareness_certification']!['status'] == true) ...[
                    const SizedBox(height: 05),
                    Padding(
                      padding: const EdgeInsets.only(left: 10),
                      child: Text(
                        validationErrors['scars_awareness_certification']!['error'].toString(),
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
                      uploadDocument(context, "police_background_check");
                    },
                    title: "Police Background Check",
                    fileSelectText: lists['police_background_check'].toString().isEmpty ? "Select File" : "Change File",
                  ),
                  if (validationErrors['police_background_check']!['status'] == true) ...[
                    const SizedBox(height: 05),
                    Padding(
                      padding: const EdgeInsets.only(left: 10),
                      child: Text(
                        validationErrors['police_background_check']!['error'].toString(),
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
                      uploadDocument(context, "cpr_first_aid_certification");
                    },
                    title: "CPR/First Aid Certificate",
                    fileSelectText: lists['cpr_first_aid_certification'].toString().isEmpty ? "Select File" : "Change File",
                  ),
                  if (validationErrors['cpr_first_aid_certification']!['status'] == true) ...[
                    const SizedBox(height: 05),
                    Padding(
                      padding: const EdgeInsets.only(left: 10),
                      child: Text(
                        validationErrors['cpr_first_aid_certification']!['error'].toString(),
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
                      uploadDocument(context, "government_registered_care_provider");
                    },
                    title: "Government Registered Care Provider",
                    fileSelectText: lists['government_registered_care_provider'].toString().isEmpty ? "Select File" : "Change File",
                  ),
                  if (validationErrors['government_registered_care_provider']!['status'] == true) ...[
                    const SizedBox(height: 05),
                    Padding(
                      padding: const EdgeInsets.only(left: 10),
                      child: Text(
                        validationErrors['government_registered_care_provider']!['error'].toString(),
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
                      uploadDocument(context, "animal_care_provider_certification");
                    },
                    title: "Animal Care Provider Certificate",
                    fileSelectText: lists['animal_care_provider_certification'].toString().isEmpty ? "Select File" : "Change File",
                  ),
                  if (validationErrors['animal_care_provider_certification']!['status'] == true) ...[
                    const SizedBox(height: 05),
                    Padding(
                      padding: const EdgeInsets.only(left: 5.0),
                      child: Text(
                        validationErrors['animal_care_provider_certification']!['error'].toString(),
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
                      uploadDocument(context, "animail_first_aid");
                    },
                    title: "Animal First Aid",
                    fileSelectText: lists['animail_first_aid'].toString().isEmpty ? "Select File" : "Change File",
                  ),
                  if (validationErrors['animail_first_aid']!['status'] == true) ...[
                    const SizedBox(height: 05),
                    Padding(
                      padding: const EdgeInsets.only(left: 10),
                      child: Text(
                        validationErrors['animail_first_aid']!['error'].toString(),
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
                      uploadDocument(context, "red_cross_babysitting_certification");
                    },
                    title: "Red Cross Babysitting Certification",
                    fileSelectText: lists['red_cross_babysitting_certification'].toString().isEmpty ? "Select File" : "Change File",
                  ),
                  if (validationErrors['red_cross_babysitting_certification']!['status'] == true) ...[
                    const SizedBox(height: 05),
                    Padding(
                      padding: const EdgeInsets.only(left: 10),
                      child: Text(
                        validationErrors['red_cross_babysitting_certification']!['error'].toString(),
                        style: const TextStyle(
                          color: Colors.red,
                          fontSize: 09,
                        ),
                      ),
                    ),
                  ],
                  // file type 5
                  const SizedBox(height: 10),
                  UploadBasicDocumentList(
                    onTap: () {
                      uploadDocument(context, "child_and_family_services_and_abuse");
                    },
                    title: "Dept Child and Family Services Child Abuse Check",
                    fileSelectText: lists['child_and_family_services_and_abuse'].toString().isEmpty ? "Select File" : "Change File",
                  ),
                  if (validationErrors['child_and_family_services_and_abuse']!['status'] == true) ...[
                    const SizedBox(height: 05),
                    Padding(
                      padding: const EdgeInsets.only(left: 10),
                      child: Text(
                        validationErrors['child_and_family_services_and_abuse']!['error'].toString(),
                        style: const TextStyle(
                          color: Colors.red,
                          fontSize: 09,
                        ),
                      ),
                    ),
                  ],
                  const SizedBox(height: 20),
                  // file type 7
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 0),
                    child: LoadingButton(
                      title: "Save",
                      height: 60,
                      backgroundColor: ServiceGiverColor.black,
                      textStyle: TextStyle(
                        color: CustomColors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.w600,
                        fontFamily: "Rubik",
                      ),
                      onPressed: () async {
                        updateFormKey.currentState!.validate();
                        if (isSelectedGender == null) {
                          showErrorToast("Please Select Gender");
                        } else if (dobController.text.isEmpty) {
                          showErrorToast("Please Select Date Of Birth");
                        } else if (phoneController.text.isEmpty) {
                          showErrorToast("Please Enter Phone Number");
                        } else if (experienceController.text.isEmpty) {
                          showErrorToast("Please Enter Years of Experience");
                        } else if (hourlyController.text.isEmpty) {
                          showErrorToast("Please Enter Hourly Rate");
                        } else if (addressController.text.isEmpty) {
                          showErrorToast("Please Enter Address");
                        } else if (selectedArea == "select") {
                          showErrorToast("Please Select Area");
                        } else if (zipController.text.isEmpty) {
                          showErrorToast("Please Enter Postal Code");
                        } else if (selectedAdditionalService.isEmpty) {
                          showErrorToast("Please Select Additional Services");
                        } else if (educationApiList.isEmpty) {
                          showErrorToast("Please Enter education");
                        } else if (userInfoController.text.isEmpty) {
                          showErrorToast("Please Enter User Info");
                        } else if (availabilityController.text.isEmpty) {
                          showErrorToast("Please Enter User Availability");
                        } else if (widget.workReference == null && lists['work_reference']!.isEmpty) {
                          showErrorToast("Work Refrence is Required");
                          setState(() {
                            error = {
                              'errors': {'work_reference': "Work Reference (1 Area) is Required"},
                            };
                          });
                        } else if (widget.resume == null && lists['resume']!.isEmpty) {
                          showErrorToast("Resume is Required");
                          setState(() {
                            error = {
                              'errors': {'resume': "Resume is Required"},
                            };
                          });
                        } else {
                          List<String> missingDocuments = [];
                          setValidateErrorToDefault();

                          removeRequireDocumentDuplicate();
                          for (String documentKey in requireDocument) {
                            if (!isDocumentAvailable(documentKey)) {
                              missingDocuments.add(documentKey);
                            }
                          }
                          if (missingDocuments.isNotEmpty) {
                            // Show errors for missing documents
                            for (String missingDocument in missingDocuments) {
                              setValidateError(missingDocument);
                            }
                          } else {
                            // All required documents are available
                            // You can proceed with your logic here

                            if (updateFormKey.currentState!.validate()) {
                              await sendPrfileUpdateRequest();
                            }
                          }
                        }
                        return false;
                      },
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
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
              education.removeAt(index);
              instituteMapList.removeAt(index);
              majorMapList.removeAt(index);
              startDateMapList.removeAt(index);
              endDateMapList.removeAt(index);
              currentMapList.removeAt(index);
              setState(() {});
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
                    education.removeAt(index);
                    instituteMapList.removeAt(index);
                    majorMapList.removeAt(index);
                    startDateMapList.removeAt(index);
                    endDateMapList.removeAt(index);
                    currentMapList.removeAt(index);
                    setState(() {});
                  }),
                  child: const Icon(Icons.delete)),
            ],
          ),
        ),
      ),
    );
  }
}
