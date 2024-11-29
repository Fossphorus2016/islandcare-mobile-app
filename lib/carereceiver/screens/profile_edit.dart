// ignore_for_file: unused_local_variable, use_build_context_synchronously, unnecessary_null_comparison, prefer_typing_uninitialized_variables, unused_element, must_be_immutable

import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:island_app/models/service_model.dart';
import 'package:island_app/utils/app_url.dart';
import 'package:island_app/utils/functions.dart';
import 'package:island_app/utils/http_handlers.dart';
import 'package:island_app/utils/storage_service.dart';
import 'package:island_app/carereceiver/utils/colors.dart';
import 'package:island_app/widgets/loading_button.dart';

class ProfileReceiverEdit extends StatefulWidget {
  String name;
  String email;

  String? dob;
  int? male;
  String? phoneNumber;
  Service? service;

  // List<Service>? service;
  String? zipCode;
  String? userInfo;
  String? userAddress;
  String? profileImage;
  ProfileReceiverEdit({
    super.key,
    required this.name,
    required this.email,
    this.male,
    this.dob,
    this.phoneNumber,
    required this.service,
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
      initialEntryMode: DatePickerEntryMode.calendarOnly,
      selectableDayPredicate: _isDateSelectable,
      initialDatePickerMode: DatePickerMode.day,
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

  // Future<String> getSWData() async {
  //   var token = await getToken();
  //   var res = await getRequesthandler(url: serviceurl, token: token);
  //   if (res != null && res.statusCode == 200) {
  //     Map<String, dynamic> resBody = res.data;
  //     List<dynamic> serviceData = resBody["services"];
  //     if (widget.service != null) {
  //       var getServiceByProfile = serviceData
  //           .where(
  //             (element) => element['name'] == widget.service,
  //           )
  //           .first;

  //       setState(() {
  //         selectedService = getServiceByProfile['id'].toString();
  //       });
  //     }
  //     setState(() {
  //       data = serviceData;
  //     });
  //   }
  //   return "Sucess";
  // }

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
      showErrorToast("No file select");
    }
  }

  var userinfo = "fromapp";
  bool isButtonLoading = false;
  Future<void> uploadImage() async {
    var token = await getToken();
    var usersId = await getUserId();
    setState(() {
      isButtonLoading = true;
    });
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
        url: '${CareReceiverURl.serviceReceiverProfileEdit}/$usersId',
        formData: formData,
        token: token,
      );
      if (response != null && response.statusCode == 200) {
        showSuccessToast("Profile Updated Successfully.");
      } else {
        if (response != null && response.data != null && response.data["message"] != null) {
          showErrorToast(response.data['message']);
        } else {
          showErrorToast("something went wrong");
        }
      }
      setState(() {
        isButtonLoading = false;
      });
    } catch (e) {
      showErrorToast("Something went wrong please try agan later.");
      setState(() {
        isButtonLoading = false;
      });
    }
  }

  getUserId() async {
    var userId = await storageService.readSecureStorage('userId');
    return userId.toString();
  }

  @override
  void initState() {
    getUserId();
    super.initState();
    // getSWData();
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
                                      ? CachedNetworkImage(
                                          imageUrl: "${AppUrl.webStorageUrl}/${widget.profileImage}",
                                          fit: BoxFit.cover,
                                          alignment: Alignment.center,
                                          errorWidget: (context, url, error) => const Icon(Icons.error),
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
                      // Name and Email
                      Center(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            if (widget.name != null) ...[
                              Text(
                                widget.name,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(fontSize: 16),
                              ),
                            ],
                            if (widget.email != null) ...[
                              Text(
                                widget.email,
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
                            const Text(
                              "Service Provided",
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 12,
                                fontFamily: "Rubik",
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Text(widget.service!.name.toString())
                            // if (widget.service != null) ...[
                            //   for (var i = 0; i < widget.service!.length; i++) ...[
                            //     Container(
                            //       padding: const EdgeInsets.symmetric(vertical: 10),
                            //       decoration: BoxDecoration(
                            //         borderRadius: BorderRadius.circular(12),
                            //       ),
                            //       child: Text(widget.service![i].name.toString()),
                            //     )
                            //   ],
                            // ],
                          ],
                        ),
                      ),
                      const SizedBox(height: 15),
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

                      const SizedBox(height: 10),
                      const Text(
                        "Bio",
                        style: TextStyle(
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
                      const SizedBox(height: 20),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 0),
                        child: LoadingButton(
                            title: "Save",
                            height: 60,
                            backgroundColor: CustomColors.primaryColor,
                            textStyle: TextStyle(
                              color: CustomColors.white,
                              fontSize: 22,
                              fontWeight: FontWeight.w600,
                              fontFamily: "Rubik",
                            ),
                            onPressed: () async {
                              if (_isSelectedGender == null) {
                                showErrorToast("Please Select Gender");
                              } else if (dobController.text.isEmpty) {
                                showErrorToast("Please Select Date Of Birth");
                              }
                              // else if (selectedService == null) {
                              //   showErrorToast("Please Select Services");
                              // }
                              else if (phoneController.text.isEmpty) {
                                showErrorToast("Please Enter Phone Number");
                              } else if (addressController.text.isEmpty) {
                                showErrorToast("Please Enter User Address");
                              } else if (zipController.text.isEmpty) {
                                showErrorToast("Please Enter Zip Code");
                              } else if (userInfoController.text.isEmpty) {
                                showErrorToast("Please Enter User Info");
                              } else {
                                await uploadImage();
                              }
                              return true;
                            }),
                      ),
                      const SizedBox(height: 20),
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
