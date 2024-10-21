// ignore_for_file: unused_local_variable, use_build_context_synchronously, unnecessary_null_comparison, prefer_typing_uninitialized_variables, unused_element, must_be_immutable

import 'dart:io';
import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:island_app/utils/app_url.dart';
import 'package:island_app/utils/functions.dart';
import 'package:island_app/utils/http_handlers.dart';
import 'package:island_app/utils/storage_service.dart';
import 'package:island_app/utils/utils.dart';
import 'package:island_app/carereceiver/utils/colors.dart';
import 'package:island_app/widgets/custom_text_field.dart';
import 'package:island_app/widgets/progress_dialog.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

class ProfileReceiverEdit extends StatefulWidget {
  String? name;
  String? dob;
  int? male;
  String? phoneNumber;
  String? service;
  String? zipCode;
  String? userInfo;
  String? userAddress;
  String? profileImage;
  ProfileReceiverEdit({
    super.key,
    this.name,
    this.male,
    this.dob,
    this.phoneNumber,
    this.service,
    this.zipCode,
    this.userInfo,
    this.userAddress,
    this.profileImage,
  });
  @override
  State<ProfileReceiverEdit> createState() => _ProfileReceiverEditState();
}

class _ProfileReceiverEditState extends State<ProfileReceiverEdit> {
  var _isSelectedGender = "1";
  final TextEditingController dobController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController zipController = TextEditingController();
  final TextEditingController userInfoController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController addressController = TextEditingController();

// DatePicker
  var getPickedDate;
  DateTime? selectedDate = DateTime.now();
  var myFormat = DateFormat('d-MM-yyyy');
  bool _isDateSelectable(DateTime date) {
    // Disable dates before today
    return date.isBefore(DateTime.now());
  }

  _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate!,
      firstDate: DateTime(1975),
      lastDate: DateTime.now(),
      selectableDayPredicate: _isDateSelectable,
      initialDatePickerMode: DatePickerMode.day,
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
        getPickedDate == picked;
      });
    }
  }

  // Services API
  String? selectedService;

  final String serviceurl = AppUrl.services;

  List? data = []; //edited line

  Future<String> getSWData() async {
    var res = await getRequesthandler(url: serviceurl);
    Map<String, dynamic> resBody = res.data;
    List<dynamic> serviceData = resBody["services"];
    if (widget.service != null) {
      var getServiceByProfile = serviceData
          .where(
            (element) => element['name'] == widget.service,
          )
          .first;

      setState(() {
        selectedService = getServiceByProfile['id'].toString();
      });
    }
    setState(() {
      data = serviceData;
    });

    return "Sucess";
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
  bool showSpinner = false;
  var myimg;
  Future getImage() async {
    FilePickerResult? pickedFileDio = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['png', 'jpg', 'jpeg'],
    );

    if (pickedFileDio != null) {
      if (checkImageFileTypes(context, pickedFileDio.files.single.extension)) {
        setState(() {
          image = File(pickedFileDio.files.single.path ?? " ");
        });
      }
    } else {
      customErrorSnackBar(context, "No file select");
    }
  }

  var userinfo = "fromapp";

  Future<void> uploadImage() async {
    var token = await getUserToken();
    var usersId = await getUserId();

    var formData = FormData.fromMap(
      {
        '_method': 'PUT',
        'user_info': userInfoController.text.toString(),
        'phone': phoneController.text.toString(),
        'address': addressController.text.toString(),
        'gender': _isSelectedGender,
        'dob': dobController.text.toString(),
        'zip': zipController.text.toString(),
        "avatar": image == null ? null : await MultipartFile.fromFile(image!.path),
      },
    );

    try {
      var response = await postRequesthandler(
        url: 'https://islandcare.bm/api/service-receiver-profile/$usersId',
        formData: formData,
        token: token,
      );
      if (response.statusCode == 200) {
        customSuccesSnackBar(
          context,
          "Profile Updated Successfully.",
        );
      } else {
        customErrorSnackBar(
          context,
          response.data['message'],
        );
      }
    } catch (e) {
      customErrorSnackBar(context, "Something went wrong please try agan later.");
    }
  }

  getUserToken() async {
    var userToken = await getToken();
    // print(userToken);
    return userToken.toString();
  }

  getUserId() async {
    var userId = await storageService.readSecureStorage('userId');
    return userId.toString();
  }

  @override
  void initState() {
    getUserToken();
    getUserId();
    super.initState();
    getSWData();
    if (widget.dob != null) {
      dobController.text = widget.dob!;
    }
    if (widget.zipCode != null) {
      zipController.text = widget.zipCode!;
    }
    if (widget.userInfo != null) {
      userInfoController.text = widget.userInfo!;
    }
    if (widget.userAddress != null) {
      addressController.text = widget.userAddress!;
    }
    if (widget.phoneNumber != null) {
      phoneController.text = widget.phoneNumber!;
    }
  }

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
        ),
        body: SizedBox(
          height: MediaQuery.of(context).size.height,
          child: SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 18),
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
                          getImage();
                        },
                        child: image == null
                            ? Center(
                                child: Container(
                                  alignment: Alignment.center,
                                  height: 100.45,
                                  width: 100.45,
                                  padding: const EdgeInsets.all(4),
                                  clipBehavior: Clip.antiAlias,
                                  decoration: BoxDecoration(
                                    // color: CustomColors.primaryColor,
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
                                  child: widget.profileImage != null
                                      ? Image(
                                          image: NetworkImage("${AppUrl.webStorageUrl}/${widget.profileImage}"),
                                          fit: BoxFit.cover,
                                        )
                                      : const Center(child: Text("Upload")),
                                ),
                              )
                            : Center(
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(50),
                                  child: Image.file(
                                    File(image!.path).absolute,
                                    width: 100,
                                    height: 100,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                      ),
                      const SizedBox(height: 15),
                      //  Gender
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
                            const SizedBox(
                              height: 5,
                            ),
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
                                const SizedBox(
                                  width: 15,
                                ),
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
                              "Home Address",
                              style: TextStyle(
                                color: CustomColors.primaryColor,
                                fontSize: 12,
                                fontFamily: "Rubik",
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            TextFormField(
                              controller: addressController,
                              keyboardType: TextInputType.name,
                              style: const TextStyle(
                                fontSize: 16,
                                fontFamily: "Rubik",
                                fontWeight: FontWeight.w400,
                              ),
                              textAlignVertical: TextAlignVertical.bottom,
                              maxLines: 1,
                              validator: (value) {
                                if (value != null || value!.isEmpty) {
                                  return "please add Address";
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
                      //  Phone Number
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
                              "Contact Number",
                              style: TextStyle(
                                color: CustomColors.primaryColor,
                                fontSize: 12,
                                fontFamily: "Rubik",
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 05),
                            TextFormField(
                              controller: phoneController,
                              keyboardType: TextInputType.number,
                              style: const TextStyle(
                                fontSize: 16,
                                fontFamily: "Rubik",
                                fontWeight: FontWeight.w400,
                              ),
                              textAlignVertical: TextAlignVertical.bottom,
                              inputFormatters: [
                                FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                                LengthLimitingTextInputFormatter(10),
                              ],
                              validator: (val) {
                                if (val == null || val.isEmpty) {
                                  return 'Enter your Phone Number';
                                }
                                return null;
                              },
                              decoration: InputDecoration(
                                hintText: "Phone Number",
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
                              "Postal Code",
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
                              style: const TextStyle(fontSize: 16, fontFamily: "Rubik", fontWeight: FontWeight.w400),
                              decoration: InputDecoration(
                                hintText: "Zip Code",
                                fillColor: CustomColors.white,
                                focusColor: CustomColors.white,
                                hoverColor: CustomColors.white,
                                filled: true,
                                border: OutlineInputBorder(borderRadius: BorderRadius.circular(0)),
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
                      // Date Of Birth
                      InkWell(
                        onTap: () {
                          _selectDate(context);
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 17, vertical: 10),
                          margin: const EdgeInsets.only(bottom: 15),
                          width: MediaQuery.of(context).size.width,
                          alignment: Alignment.centerLeft,
                          decoration: BoxDecoration(
                            color: CustomColors.white,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
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
                              const SizedBox(height: 10),
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
                      // Services
                      // Container(
                      //   padding: const EdgeInsets.symmetric(horizontal: 17, vertical: 10),
                      //   margin: const EdgeInsets.only(bottom: 15),
                      //   decoration: BoxDecoration(
                      //     color: CustomColors.white,
                      //     borderRadius: BorderRadius.circular(12),
                      //   ),
                      //   child: Column(
                      //     crossAxisAlignment: CrossAxisAlignment.start,
                      //     mainAxisAlignment: MainAxisAlignment.center,
                      //     children: [
                      //       Text(
                      //         "Services",
                      //         style: TextStyle(
                      //           color: CustomColors.primaryColor,
                      //           fontSize: 12,
                      //           fontFamily: "Rubik",
                      //           fontWeight: FontWeight.w600,
                      //         ),
                      //       ),
                      //       Center(
                      //         child: DecoratedBox(
                      //           decoration: BoxDecoration(
                      //             color: Colors.transparent,
                      //             border: Border.all(color: const Color.fromARGB(255, 255, 255, 255), width: 0.5),
                      //             borderRadius: BorderRadius.circular(12),
                      //           ),
                      //           child: Padding(
                      //             padding: const EdgeInsets.symmetric(
                      //               horizontal: 10,
                      //               vertical: 4,
                      //             ),
                      //             child: DropdownButtonHideUnderline(
                      //               child: DropdownButton(
                      //                 hint: const Text("Services You Provide"),
                      //                 isExpanded: true,
                      //                 items: data!.map((item) {
                      //                   return DropdownMenuItem(
                      //                     value: item['id'].toString(),
                      //                     child: Text(item['name']),
                      //                   );
                      //                 }).toList(),
                      //                 onChanged: (newVal) {
                      //                   setState(() {
                      //                     selectedService = newVal;
                      //                   });
                      //                 },
                      //                 value: selectedService,
                      //               ),
                      //             ),
                      //           ),
                      //         ),
                      //       ),
                      //     ],
                      //   ),
                      // ),

                      const SizedBox(height: 10),
                      const Text(
                        "Bio",
                        style: TextStyle(
                          // color: CustomColors.primaryColor,
                          fontSize: 16,
                          fontFamily: "Rubik",
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 10),
                      // User Information
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
                              "User Information",
                              style: TextStyle(
                                color: CustomColors.primaryColor,
                                fontSize: 12,
                                fontFamily: "Rubik",
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            TextFormField(
                              controller: userInfoController,
                              keyboardType: TextInputType.name,
                              textAlignVertical: TextAlignVertical.bottom,
                              maxLines: 1,
                              style: const TextStyle(
                                fontSize: 16,
                                fontFamily: "Rubik",
                                fontWeight: FontWeight.w400,
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return "Please add User Info";
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

                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 0),
                        child: GestureDetector(
                          onTap: () {
                            if (_isSelectedGender == null) {
                              customErrorSnackBar(context, "Please Select Gender");
                            } else if (dobController.text.isEmpty) {
                              customErrorSnackBar(context, "Please Select Date Of Birth");
                            } else if (selectedService == null) {
                              customErrorSnackBar(context, "Please Select Services");
                            } else if (phoneController.text.isEmpty) {
                              customErrorSnackBar(context, "Please Enter Phone Number");
                            } else if (addressController.text.isEmpty) {
                              customErrorSnackBar(context, "Please Enter User Address");
                            } else if (zipController.text.isEmpty) {
                              customErrorSnackBar(context, "Please Enter Zip Code");
                            } else if (userInfoController.text.isEmpty) {
                              customErrorSnackBar(context, "Please Enter User Info");
                            } else {
                              uploadImage();
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
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class ProfileReceiverPendingEdit extends StatefulWidget {
  const ProfileReceiverPendingEdit({
    super.key,
  });
  @override
  State<ProfileReceiverPendingEdit> createState() => _ProfileReceiverPendingEditState();
}

class _ProfileReceiverPendingEditState extends State<ProfileReceiverPendingEdit> {
  var _isSelectedGender = "1";
  final TextEditingController dobController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController zipController = TextEditingController();
  final TextEditingController userInfoController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController addressController = TextEditingController();

// DatePicker
  var getPickedDate;
  DateTime? selectedDate = DateTime.now();
  var myFormat = DateFormat('d-MM-yyyy');
  void _onSelectionChanged(DateRangePickerSelectionChangedArgs args) {
    setState(() {
      if (args.value is PickerDateRange) {
        // startDate = DateFormat('dd-MM-yyyy').format(args.value.startDate);
        // if (args.value.endDate != null) {
        //   endDate = DateFormat('dd-MM-yyyy').format(args.value.endDate);
        // } else {
        //   endDate = DateFormat('dd-MM-yyyy').format(args.value.startDate);
        // }
      }
    });
  }

  bool _isDateSelectable(DateTime date) {
    // Disable dates before today
    return date.isBefore(DateTime.now());
  }

  _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate!,
      firstDate: DateTime(1975),
      lastDate: DateTime.now(),
      selectableDayPredicate: _isDateSelectable,
      initialDatePickerMode: DatePickerMode.day,
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
        getPickedDate == picked;
      });
    }
  }

  // Services API
  String? selectedService;

  final String serviceurl = AppUrl.services;

  List? data = []; //edited line

  Future<String> getSWData() async {
    var res = await getRequesthandler(url: serviceurl);
    Map<String, dynamic> resBody = res.data;
    List<dynamic> serviceData = resBody["services"];

    setState(() {
      data = serviceData;
    });

    return "Sucess";
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
  bool showSpinner = false;
  var myimg;
  Future getImage() async {
    FilePickerResult? pickedFileDio = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['png', 'jpg', 'jpeg'],
    );

    if (pickedFileDio != null) {
      if (checkImageFileTypes(context, pickedFileDio.files.single.extension)) {
        setState(() {
          image = File(pickedFileDio.files.single.path ?? " ");
        });
      }
    } else {
      customErrorSnackBar(context, "No file select");
    }
  }

  var userinfo = "fromapp";

  Future<void> uploadImage(filename) async {
    var token = await getUserToken();
    var usersId = await getUserId();
    var formData = FormData.fromMap(
      {
        '_method': 'PUT',
        'user_info': userInfoController.text.toString(),
        'phone': phoneController.text.toString(),
        'address': addressController.text.toString(),
        'gender': _isSelectedGender,
        'dob': dobController.text.toString(),
        'zip': zipController.text.toString(),
        "avatar": image == null ? null : await MultipartFile.fromFile(image!.path),
      },
    );

    try {
      var response = await postRequesthandler(
        url: 'https://islandcare.bm/api/service-receiver-profile/$usersId',
        formData: formData,
        token: token,
      );
      if (response.statusCode == 200) {
        customSuccesSnackBar(
          context,
          "Profile Updated Successfully.",
        );
      } else {
        customErrorSnackBar(
          context,
          "Something went wrong please try agan later.",
        );
      }
    } catch (e) {
      customErrorSnackBar(context, e.toString());
    }
  }

  getUserToken() async {
    var userToken = await getToken();
    return userToken.toString();
  }

  getUserId() async {
    var userId = await storageService.readSecureStorage('userId');
    return userId.toString();
  }

  @override
  void initState() {
    getUserToken();
    getUserId();
    super.initState();
    getSWData();
  }

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
          actions: const [],
        ),
        body: SizedBox(
          height: MediaQuery.of(context).size.height,
          child: SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 18),
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
                          getImage();
                        },
                        child: image == null
                            ? Center(
                                child: Container(
                                  alignment: Alignment.center,
                                  height: 100.45,
                                  width: 100.45,
                                  padding: const EdgeInsets.all(4),
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
                                  child: const Center(child: Text("Upload")),
                                ),
                              )
                            : Center(
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(50),
                                  child: Image.file(
                                    File(image!.path).absolute,
                                    width: 100,
                                    height: 100,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                      ),
                      const SizedBox(height: 15),
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
                              "GenderGenderGenderGenderGenderGender",
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
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 17, vertical: 10),
                        margin: const EdgeInsets.only(bottom: 15),
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
                            CustomTextFieldWidget(
                              borderColor: CustomColors.white,
                              obsecure: false,
                              keyboardType: TextInputType.number,
                              controller: dobController,
                              onChanged: (value) {
                                setState(() {
                                  getPickedDate = value;
                                });
                              },
                              hintText: "DOB",
                              onTap: () async {
                                showDialog(
                                    context: context,
                                    builder: (context) {
                                      return AlertDialog(
                                        content: Container(
                                          width: MediaQuery.of(context).size.width,
                                          height: 300,
                                          decoration: const BoxDecoration(
                                            color: Colors.white,
                                          ),
                                          child: SfDateRangePicker(
                                            headerHeight: 50,
                                            initialDisplayDate: DateTime.now(),
                                            initialSelectedDate: DateTime.now(),
                                            enablePastDates: false,
                                            backgroundColor: Colors.white,
                                            selectionMode: DateRangePickerSelectionMode.range,
                                            showActionButtons: true,
                                            confirmText: "CONFIRM",
                                            initialSelectedRange: PickerDateRange(
                                              DateTime.now(),
                                              DateTime.now().add(
                                                const Duration(
                                                  days: 3,
                                                ),
                                              ),
                                            ),
                                            onSubmit: (args) {
                                              if (args != null) {
                                                var value = args as PickerDateRange;

                                                //  setState(() {
                                                //   startDate = DateFormat('dd-MM-yyyy').format(
                                                //     DateTime.parse(
                                                //       value.startDate.toString(),
                                                //     ),
                                                //   );
                                                //   if (value.endDate != null) {
                                                //     endDate = DateFormat('dd-MM-yyyy').format(
                                                //       DateTime.parse(
                                                //         value.endDate.toString(),
                                                //       ),
                                                //     );
                                                //   } else {
                                                //     endDate = DateFormat('dd-MM-yyyy').format(
                                                //       DateTime.parse(
                                                //         value.startDate.toString(),
                                                //       ),
                                                //     );
                                                //   }
                                                // });
                                                // NavigationService().pop();
                                              } else {
                                                // setState(() {
                                                //   startDate = DateFormat('dd-MM-yyyy').format(
                                                //     DateTime.now(),
                                                //   );
                                                //   endDate = DateFormat('dd-MM-yyyy').format(
                                                //     DateTime.now(),
                                                //   );
                                                // });
                                                // NavigationService().pop();
                                              }
                                            },
                                            onCancel: () {
                                              setState(() {
                                                // startDate = DateFormat('dd-MM-yyyy').format(
                                                //   DateTime.now(),
                                                // );
                                                // endDate = DateFormat('dd-MM-yyyy').format(
                                                //   DateTime.now(),
                                                // );
                                              });
                                              // NavigationService().pop();
                                            },
                                            onSelectionChanged: (dateRangePickerSelectionChangedArgs) => _onSelectionChanged(dateRangePickerSelectionChangedArgs),
                                          ),
                                        ),
                                      );
                                    });
                              },
                            ),
                          ],
                        ),
                      ),
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
                              "Services ",
                              style: TextStyle(
                                color: CustomColors.primaryColor,
                                fontSize: 12,
                                fontFamily: "Rubik",
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Center(
                              child: DecoratedBox(
                                decoration: BoxDecoration(
                                  color: Colors.transparent,
                                  border: Border.all(color: const Color.fromARGB(255, 255, 255, 255), width: 0.5),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 10,
                                    vertical: 4,
                                  ),
                                  child: DropdownButtonHideUnderline(
                                    child: DropdownButton(
                                      hint: const Text("Services You Provide"),
                                      isExpanded: true,
                                      items: data!.map((item) {
                                        return DropdownMenuItem(
                                          value: item['id'].toString(),
                                          child: Text(item['name']),
                                        );
                                      }).toList(),
                                      onChanged: (newVal) {
                                        setState(() {
                                          selectedService = newVal;
                                        });
                                      },
                                      value: selectedService,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
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
                              "Phone Number",
                              style: TextStyle(
                                color: CustomColors.primaryColor,
                                fontSize: 12,
                                fontFamily: "Rubik",
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            TextFormField(
                              controller: phoneController,
                              keyboardType: TextInputType.number,
                              style: const TextStyle(
                                fontSize: 16,
                                fontFamily: "Rubik",
                                fontWeight: FontWeight.w400,
                              ),
                              textAlignVertical: TextAlignVertical.bottom,
                              maxLines: 1,
                              decoration: InputDecoration(
                                hintText: "Phone Number",
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
                              ),
                            ),
                          ],
                        ),
                      ),
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
                              ),
                            ),
                          ],
                        ),
                      ),
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
                              "User Info",
                              style: TextStyle(
                                color: CustomColors.primaryColor,
                                fontSize: 12,
                                fontFamily: "Rubik",
                                fontWeight: FontWeight.w600,
                              ),
                            ),
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
                              decoration: InputDecoration(
                                hintText: "User Info",
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
                              ),
                            ),
                          ],
                        ),
                      ),
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
                            TextFormField(
                              controller: addressController,
                              keyboardType: TextInputType.name,
                              style: const TextStyle(
                                fontSize: 16,
                                fontFamily: "Rubik",
                                fontWeight: FontWeight.w400,
                              ),
                              textAlignVertical: TextAlignVertical.bottom,
                              maxLines: 1,
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
                              ),
                            ),
                          ],
                        ),
                      ),

                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 0),
                        child: GestureDetector(
                          onTap: () {
                            if (_isSelectedGender == null) {
                              customErrorSnackBar(context, "Please Select Gender");
                            } else if (dobController.text.isEmpty) {
                              customErrorSnackBar(context, "Please Select Date Of Birth");
                            } else if (selectedService == null) {
                              customErrorSnackBar(context, "Please Select Services");
                            } else if (phoneController.text.isEmpty) {
                              customErrorSnackBar(context, "Please Enter Phone Number");
                            } else if (zipController.text.isEmpty) {
                              customErrorSnackBar(context, "Please Enter Zip Code");
                            } else if (addressController.text.isEmpty) {
                              customErrorSnackBar(context, "Please Enter User Address");
                            } else {
                              uploadImage(image!.path);
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
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
