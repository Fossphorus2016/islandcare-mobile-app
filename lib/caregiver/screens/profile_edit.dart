// ignore_for_file: use_build_context_synchronously, unused_local_variable, unnecessary_null_comparison, prefer_typing_uninitialized_variables, unrelated_type_equality_checks

import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:island_app/caregiver/models/profile_model.dart';
import 'package:island_app/caregiver/utils/profile_provider.dart';
import 'package:island_app/utils/app_url.dart';
import 'package:island_app/utils/utils.dart';
import 'package:island_app/widgets/document_download_list.dart';
import 'package:provider/provider.dart';
import 'package:island_app/carereceiver/utils/colors.dart';
import 'package:island_app/widgets/custom_text_field.dart';
import 'package:island_app/widgets/progress_dialog.dart';

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
  final String? area;

  final String? zipCode;
  final List? additionalService;
  final List? educations;

  final String? availability;
  final String? userInfo;
  final String? workReference;
  final String? resume;

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
    this.area,
    this.zipCode,
    this.additionalService,
    this.userInfo,
    this.availability,
    this.educations,
    this.serviceName,
    this.workReference,
    this.resume,
  }) : super(key: key);
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
    Provider.of<GiverProfileEidtProvider>(context, listen: false).initValueSet(widget.gender, widget.area, widget.additionalService, widget.educations);
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
    // keywordController.dispose();
    instituteController.dispose();
    majorController.dispose();
    fromController.dispose();
    toController.dispose();
  }

  final updateFormKey = GlobalKey<FormState>();

  TextEditingController additionalServiceSearchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Consumer<GiverProfileEidtProvider>(
      builder: (context, giverProfileEditProvider, child) => Scaffold(
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
                            giverProfileEditProvider.getImageDio(context);
                          },
                          child: giverProfileEditProvider.imageFileDio == null
                              ? Center(
                                  child: Container(
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
                                      giverProfileEditProvider.imageFileDio!,
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
                                        giverProfileEditProvider.setSelectedGender("1");
                                      },
                                      child: Container(
                                        height: 50.45,
                                        padding: const EdgeInsets.all(4),
                                        decoration: BoxDecoration(
                                          color: giverProfileEditProvider.isSelectedGender == "1" ? ServiceGiverColor.black : CustomColors.white,
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
                                            giverProfileEditProvider.setSelectedGender("1");
                                          },
                                          child: Text(
                                            "Male",
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              color: giverProfileEditProvider.isSelectedGender == "1" ? CustomColors.white : CustomColors.primaryText,
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
                                        giverProfileEditProvider.setSelectedGender("2");
                                      },
                                      child: Container(
                                        height: 50.45,
                                        padding: const EdgeInsets.all(4),
                                        decoration: BoxDecoration(
                                          color: giverProfileEditProvider.isSelectedGender == "2" ? ServiceGiverColor.black : CustomColors.white,
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
                                            giverProfileEditProvider.setSelectedGender("2");
                                          },
                                          child: Text(
                                            "Female",
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              color: giverProfileEditProvider.isSelectedGender == "2" ? CustomColors.white : CustomColors.primaryText,
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
                                "Phone Number",
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
                                decoration: giverProfileEditProvider.phoneError
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
                                        if (value == null || value.toString().length < 10) {
                                          giverProfileEditProvider.setPhoneError(true);

                                          return "Please enter a valid phone number";
                                        }

                                        giverProfileEditProvider.setPhoneError(false);

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
                            giverProfileEditProvider.selectDate(context);
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
                                  giverProfileEditProvider.getPickedDate.isEmpty
                                      ? dobController.text.isEmpty
                                          ? "Date Of Birth"
                                          : dobController.text
                                      : giverProfileEditProvider.getPickedDate.toString(),
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
                              Container(
                                padding: const EdgeInsets.only(left: 12),
                                decoration: giverProfileEditProvider.yearOfExpError
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
                                        if (value == null || value.isEmpty) {
                                          giverProfileEditProvider.setYearOfExpError(true);

                                          return "Please enter your experience";
                                        }
                                        giverProfileEditProvider.setYearOfExpError(false);

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
                              Container(
                                padding: const EdgeInsets.only(left: 12),
                                decoration: giverProfileEditProvider.hourlyRateError
                                    ? BoxDecoration(
                                        border: Border.all(color: Colors.red),
                                        borderRadius: BorderRadius.circular(12),
                                      )
                                    : null,
                                child: TextFormField(
                                  controller: hourlyController,
                                  keyboardType: TextInputType.number,
                                  textInputAction: TextInputAction.next,
                                  inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[0-9]'))],
                                  decoration: const InputDecoration(
                                    contentPadding: EdgeInsets.zero,
                                    constraints: BoxConstraints(maxHeight: 50, minHeight: 50),
                                    hintText: "Hourly Rate",
                                    prefix: Text("\$ "),
                                    // prefixStyle: TextStyle(color: Colors.black),
                                    border: InputBorder.none,
                                  ),
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      giverProfileEditProvider.setHourlyRateError(true);
                                      return "Please enter your hourly rate";
                                    }
                                    giverProfileEditProvider.setHourlyRateError(false);
                                    return null;
                                  },
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
                                decoration: giverProfileEditProvider.userAddressError
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
                                        if (value == null || value.isEmpty) {
                                          giverProfileEditProvider.setUserAddressError(true);

                                          return "Please enter your permanent address";
                                        }
                                        giverProfileEditProvider.setUserAddressError(false);

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
                                    DropdownButton(
                                      value: giverProfileEditProvider.selectedArea,
                                      underline: Container(),
                                      isExpanded: true,
                                      items: giverProfileEditProvider.areaList
                                          .map(
                                            (e) => DropdownMenuItem(
                                              value: e["value"],
                                              child: Text(e["name"].toString()),
                                            ),
                                          )
                                          .toList(),
                                      onChanged: (value) {
                                        // print(value.runtimeType);
                                        giverProfileEditProvider.setSelectedArea(value.toString());
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
                              Container(
                                padding: const EdgeInsets.only(left: 12),
                                decoration: giverProfileEditProvider.zipcodeError
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
                                    if (value == null || value.isEmpty) {
                                      giverProfileEditProvider.setZipcodeError(true);
                                      return "Please enter postal code";
                                    }
                                    giverProfileEditProvider.setZipcodeError(false);
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
                                                        if (additionalServiceSearchController.text.isNotEmpty && !giverProfileEditProvider.selectedAdditionalService.any((element) => element == additionalServiceSearchController.text)) {
                                                          giverProfileEditProvider.setSelectedAdditionalService(additionalServiceSearchController.text);
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
                                                            if (additionalServiceSearchController.text.isNotEmpty && !giverProfileEditProvider.selectedAdditionalService.any((element) => element == additionalServiceSearchController.text)) {
                                                              giverProfileEditProvider.setSelectedAdditionalService(additionalServiceSearchController.text);
                                                              setState(() {});
                                                              additionalServiceSearchController.clear();
                                                            }
                                                          },
                                                          child: const Icon(Icons.done, size: 24),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  Wrap(
                                                    spacing: 8.0,
                                                    runSpacing: 0.0,
                                                    children: List.generate(giverProfileEditProvider.selectedAdditionalService.length, (index) {
                                                      var item = giverProfileEditProvider.selectedAdditionalService[index];
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
                                                          giverProfileEditProvider.removeSelectedAdditionalService(item);
                                                          setState(() {});
                                                        },
                                                      );
                                                    }),
                                                  ),
                                                  Expanded(
                                                    child: ListView(
                                                      children: giverProfileEditProvider.listSuggestedType.map<Widget>((e) {
                                                        if (giverProfileEditProvider.selectedAdditionalService.any((element) => element.toString().toLowerCase().contains(e.toLowerCase()))) {
                                                          return Container();
                                                        }
                                                        return CheckboxListTile(
                                                          value: false,
                                                          title: Text(e),
                                                          onChanged: (value) {
                                                            if (value == true) {
                                                              var val = e;
                                                              giverProfileEditProvider.setSelectedAdditionalService(val);
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
                                children: List.generate(giverProfileEditProvider.selectedAdditionalService.length, (index) {
                                  var item = giverProfileEditProvider.selectedAdditionalService[index];
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
                                      // print("on delete call");
                                      giverProfileEditProvider.removeSelectedAdditionalService(item);
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
                                                          fontSize: 12,
                                                          fontFamily: "Rubik",
                                                          fontWeight: FontWeight.w600,
                                                        ),
                                                      ),
                                                      const SizedBox(height: 10),
                                                      Container(
                                                        height: 50,
                                                        // margin: const EdgeInsets.only(bottom: 15, top: 15),
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
                                                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
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
                                                          fontSize: 12,
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
                                                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
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
                                                          fontSize: 12,
                                                          fontFamily: "Rubik",
                                                          fontWeight: FontWeight.w600,
                                                        ),
                                                      ),
                                                      const SizedBox(height: 10),
                                                      Row(
                                                        children: [
                                                          Checkbox.adaptive(
                                                            value: giverProfileEditProvider.isPeriodSeleted == "0" ? false : true,
                                                            onChanged: (value) {
                                                              // if (value == true) {
                                                              giverProfileEditProvider.toggleradio(value);
                                                              toController.text = '';
                                                              setState(() {});
                                                              // }
                                                            },
                                                          ),
                                                          // const SizedBox(width: 10),
                                                          const Text("Currently Studying")
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
                                                          fontSize: 12,
                                                          fontFamily: "Rubik",
                                                          fontWeight: FontWeight.w600,
                                                        ),
                                                      ),
                                                      const SizedBox(height: 10),
                                                      Container(
                                                        // height: 50,
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
                                                            giverProfileEditProvider.eduFromDate(context, fromController);
                                                          },
                                                        ),
                                                      ),
                                                    ],
                                                  ),

                                                  // To Date
                                                  if (giverProfileEditProvider.isPeriodSeleted == "0") ...[
                                                    const SizedBox(height: 20),
                                                    Column(
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: [
                                                        Text(
                                                          "To",
                                                          style: TextStyle(
                                                            color: ServiceGiverColor.black,
                                                            fontSize: 12,
                                                            fontFamily: "Rubik",
                                                            fontWeight: FontWeight.w600,
                                                          ),
                                                        ),
                                                        const SizedBox(height: 10),
                                                        Container(
                                                          // height: 50,
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
                                                              giverProfileEditProvider.eduToDate(context, toController);
                                                            },
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                  // AddBtn
                                                  GestureDetector(
                                                    onTap: () async {
                                                      {
                                                        String institute = instituteController.text.trim();
                                                        String major = majorController.text.trim();
                                                        String from = fromController.text.toString();
                                                        String to = toController.text.toString();

                                                        if (institute.isNotEmpty && major.isNotEmpty && from.isNotEmpty) {
                                                          if (giverProfileEditProvider.isPeriodSeleted == "0" && to.isEmpty) {
                                                            return;
                                                          }
                                                          instituteController.text = '';
                                                          majorController.text = '';
                                                          fromController.text = '';
                                                          toController.text = '';
                                                          giverProfileEditProvider.instituteMapList.add(institute);
                                                          giverProfileEditProvider.majorMapList.add(major);
                                                          giverProfileEditProvider.startDateMapList.add(from);
                                                          giverProfileEditProvider.endDateMapList.add(to);
                                                          giverProfileEditProvider.currentMapList.add(giverProfileEditProvider.isPeriodSeleted);
                                                          giverProfileEditProvider.educationApiList.add(
                                                            {
                                                              "name": institute.toString(),
                                                              "major": major.toString(),
                                                              "from": from.toString(),
                                                              "current": giverProfileEditProvider.isPeriodSeleted.toString(),
                                                              "to": to.toString(),
                                                            },
                                                          );
                                                          giverProfileEditProvider.toggleradio(false);
                                                          instituteController.text = '';
                                                          majorController.text = '';
                                                          fromController.text = '';
                                                          toController.text = '';

                                                          // SharedPreferences pref = await SharedPreferences.getInstance();
                                                          // var data = await pref.setString('ListData', giverProfileEditProvider.education.toString());

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
                                                            ServiceGiverColor.black,
                                                            ServiceGiverColor.black,
                                                          ],
                                                        ),
                                                        color: CustomColors.white,
                                                        boxShadow: const [
                                                          BoxShadow(
                                                            color: Color.fromARGB(13, 0, 0, 0),
                                                            blurRadius: 4.0,
                                                            spreadRadius: 2.0,
                                                            offset: Offset(
                                                              2.0,
                                                              2.0,
                                                            ),
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
                        if (giverProfileEditProvider.educationApiList.isNotEmpty) ...[
                          Column(
                            children: [
                              for (var i = 0; i < giverProfileEditProvider.educationApiList.length; i++) ...[
                                SizedBox(
                                  height: 120,
                                  width: MediaQuery.of(context).size.width,
                                  child: Stack(
                                    children: [
                                      Positioned(
                                        top: 10,
                                        child: Container(
                                          width: MediaQuery.of(context).size.width - 40,
                                          // height: 100,
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
                                                      "${giverProfileEditProvider.educationApiList[i]['name']}",
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
                                                      "${giverProfileEditProvider.educationApiList[i]['major']}",
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
                                                      "${giverProfileEditProvider.educationApiList[i]['from']}",
                                                      maxLines: 2,
                                                      overflow: TextOverflow.fade,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              // if (giverProfileEditProvider.educationApiList[i]['to'] != null && giverProfileEditProvider.educationApiList[i]['current'].isNotEmpty) ...[
                                              Row(
                                                children: [
                                                  const Text("to: "),
                                                  Expanded(
                                                    child: giverProfileEditProvider.educationApiList[i]['current'] == "1"
                                                        ? const Text(
                                                            "Currently Studying",
                                                            maxLines: 2,
                                                            overflow: TextOverflow.fade,
                                                          )
                                                        : Text(
                                                            "${giverProfileEditProvider.educationApiList[i]['to']}",
                                                            maxLines: 2,
                                                            overflow: TextOverflow.fade,
                                                          ),
                                                  ),
                                                ],
                                              ),
                                              // ]
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
                                            giverProfileEditProvider.educationApiList.removeAt(i);
                                            giverProfileEditProvider.instituteMapList.removeAt(i);
                                            giverProfileEditProvider.majorMapList.removeAt(i);
                                            giverProfileEditProvider.startDateMapList.removeAt(i);
                                            giverProfileEditProvider.endDateMapList.removeAt(i);
                                            giverProfileEditProvider.currentMapList.removeAt(i);
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
                              Container(
                                padding: const EdgeInsets.only(left: 12),
                                decoration: giverProfileEditProvider.aboutMeError
                                    ? BoxDecoration(
                                        border: Border.all(color: Colors.red),
                                        borderRadius: BorderRadius.circular(12),
                                      )
                                    : null,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    TextFormField(
                                      controller: userInfoController,
                                      keyboardType: TextInputType.multiline,
                                      textInputAction: TextInputAction.next,
                                      maxLines: 2,
                                      decoration: const InputDecoration(
                                        contentPadding: EdgeInsets.zero,
                                        hintText: "About Me",
                                        border: InputBorder.none,
                                      ),
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          giverProfileEditProvider.setAboutMeError(true);

                                          return "Please provide information about yourself";
                                        }
                                        giverProfileEditProvider.setAboutMeError(false);
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
                        // Availability
                        // Container(
                        //   padding: const EdgeInsets.symmetric(horizontal: 17, vertical: 10),
                        //   margin: const EdgeInsets.only(bottom: 15, top: 15),
                        //   decoration: BoxDecoration(
                        //     color: CustomColors.white,
                        //     borderRadius: BorderRadius.circular(12),
                        //   ),
                        //   child: Column(
                        //     crossAxisAlignment: CrossAxisAlignment.start,
                        //     mainAxisAlignment: MainAxisAlignment.center,
                        //     children: [
                        //       Text(
                        //         "Availability",
                        //         style: TextStyle(
                        //           color: ServiceGiverColor.black,
                        //           fontSize: 12,
                        //           fontFamily: "Rubik",
                        //           fontWeight: FontWeight.w600,
                        //         ),
                        //       ),
                        //       const SizedBox(height: 05),
                        //       TextFormField(
                        //         controller: availabilityController,
                        //         keyboardType: TextInputType.multiline,
                        //         style: const TextStyle(
                        //           fontSize: 16,
                        //           fontFamily: "Rubik",
                        //           fontWeight: FontWeight.w400,
                        //         ),
                        //         textAlignVertical: TextAlignVertical.bottom,
                        //         maxLines: 4,
                        //         validator: (value) {
                        //           if (value == null || value.isEmpty) {
                        //             return "Please fill this field";
                        //           }
                        //           return null;
                        //         },
                        //         decoration: InputDecoration(
                        //           hintText: "Availability",
                        //           fillColor: CustomColors.white,
                        //           focusColor: CustomColors.white,
                        //           hoverColor: CustomColors.white,
                        //           filled: true,
                        //           border: OutlineInputBorder(
                        //             borderRadius: BorderRadius.circular(0),
                        //           ),
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
                              Container(
                                padding: const EdgeInsets.only(left: 12),
                                decoration: giverProfileEditProvider.avaibilityError
                                    ? BoxDecoration(
                                        border: Border.all(color: Colors.red),
                                        borderRadius: BorderRadius.circular(12),
                                      )
                                    : null,
                                child: TextFormField(
                                  controller: availabilityController,
                                  keyboardType: TextInputType.multiline,
                                  textInputAction: TextInputAction.next,
                                  maxLines: 2,
                                  decoration: const InputDecoration(
                                    contentPadding: EdgeInsets.zero,
                                    hintText: "Availability",
                                    border: InputBorder.none,
                                  ),
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      giverProfileEditProvider.setAvaibilityError(true);
                                      return "Please provide availability information";
                                    }
                                    giverProfileEditProvider.setAvaibilityError(false);
                                    return null;
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 15),
                        // User Info
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
                        //         "About Me",
                        //         style: TextStyle(
                        //           color: ServiceGiverColor.black,
                        //           fontSize: 12,
                        //           fontFamily: "Rubik",
                        //           fontWeight: FontWeight.w600,
                        //         ),
                        //       ),
                        //       const SizedBox(height: 05),
                        //       TextFormField(
                        //         controller: userInfoController,
                        //         keyboardType: TextInputType.name,
                        //         style: const TextStyle(
                        //           fontSize: 16,
                        //           fontFamily: "Rubik",
                        //           fontWeight: FontWeight.w400,
                        //         ),
                        //         textAlignVertical: TextAlignVertical.bottom,
                        //         maxLines: 1,
                        //         validator: (value) {
                        //           if (value == null || value.isEmpty) {
                        //             return "Please fill this field";
                        //           }
                        //           return null;
                        //         },
                        //         decoration: InputDecoration(
                        //           hintText: "User Info",
                        //           fillColor: CustomColors.white,
                        //           focusColor: CustomColors.white,
                        //           hoverColor: CustomColors.white,
                        //           filled: true,
                        //           border: OutlineInputBorder(
                        //             borderRadius: BorderRadius.circular(12),
                        //           ),
                        //           focusedBorder: OutlineInputBorder(
                        //             borderSide: BorderSide(color: CustomColors.white, width: 0.0),
                        //             borderRadius: BorderRadius.circular(12),
                        //           ),
                        //           errorBorder: OutlineInputBorder(
                        //             borderSide: BorderSide(color: CustomColors.red, width: 0.5),
                        //             borderRadius: BorderRadius.circular(12),
                        //           ),
                        //           focusedErrorBorder: OutlineInputBorder(
                        //             borderSide: BorderSide(color: CustomColors.red, width: 0.5),
                        //             borderRadius: BorderRadius.circular(12),
                        //           ),
                        //           enabledBorder: OutlineInputBorder(
                        //             borderSide: BorderSide(color: CustomColors.white, width: 0.0),
                        //             borderRadius: BorderRadius.circular(12),
                        //           ),
                        //         ),
                        //       ),
                        //     ],
                        //   ),
                        // ),

                        // Work Reference (1 Area)
                        UploadBasicDocumentList(
                          onTap: () {
                            giverProfileEditProvider.uploadDocument(context, "work_reference");
                          },
                          title: "Work Reference (1 Area)",
                          fileSelectText: giverProfileEditProvider.lists['work_reference'].toString().isEmpty ? "Select File" : "Change File",
                        ),
                        if (giverProfileEditProvider.error != null && giverProfileEditProvider.error['errors'] != null && giverProfileEditProvider.error['errors']!['work_reference'] != null) ...[
                          const SizedBox(height: 05),
                          Padding(
                            padding: const EdgeInsets.only(left: 10),
                            child: Text(
                              giverProfileEditProvider.error['errors']['work_reference'].toString(),
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
                            giverProfileEditProvider.uploadDocument(context, "resume");
                          },
                          title: "Resume",
                          fileSelectText: giverProfileEditProvider.lists['resume'].toString().isEmpty ? "Select File" : "Change File",
                        ),
                        if (giverProfileEditProvider.error != null && giverProfileEditProvider.error['errors'] != null && giverProfileEditProvider.error['errors']!['resume'] != null) ...[
                          const SizedBox(height: 05),
                          Padding(
                            padding: const EdgeInsets.only(left: 10),
                            child: Text(
                              giverProfileEditProvider.error['errors']['resume'].toString(),
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
                            giverProfileEditProvider.uploadDocument(context, "valid_driver_license");
                          },
                          title: "Valid Driver's License",
                          fileSelectText: giverProfileEditProvider.lists['valid_driver_license'].toString().isEmpty ? "Select File" : "Change File",
                        ),
                        if (giverProfileEditProvider.validationErrors['valid_driver_license']!['status'] == true) ...[
                          const SizedBox(height: 05),
                          Padding(
                            padding: const EdgeInsets.only(left: 10),
                            child: Text(
                              giverProfileEditProvider.validationErrors['valid_driver_license']!['error'].toString(),
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
                            giverProfileEditProvider.uploadDocument(context, "scars_awareness_certification");
                          },
                          title: "Scars Awareness Certification",
                          fileSelectText: giverProfileEditProvider.lists['scars_awareness_certification'].toString().isEmpty ? "Select File" : "Change File",
                        ),
                        if (giverProfileEditProvider.validationErrors['scars_awareness_certification']!['status'] == true) ...[
                          const SizedBox(height: 05),
                          Padding(
                            padding: const EdgeInsets.only(left: 10),
                            child: Text(
                              giverProfileEditProvider.validationErrors['scars_awareness_certification']!['error'].toString(),
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
                            giverProfileEditProvider.uploadDocument(context, "police_background_check");
                          },
                          title: "Police Background Check",
                          fileSelectText: giverProfileEditProvider.lists['police_background_check'].toString().isEmpty ? "Select File" : "Change File",
                        ),
                        if (giverProfileEditProvider.validationErrors['police_background_check']!['status'] == true) ...[
                          const SizedBox(height: 05),
                          Padding(
                            padding: const EdgeInsets.only(left: 10),
                            child: Text(
                              giverProfileEditProvider.validationErrors['police_background_check']!['error'].toString(),
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
                            giverProfileEditProvider.uploadDocument(context, "cpr_first_aid_certification");
                          },
                          title: "CPR/First Aid Certificate",
                          fileSelectText: giverProfileEditProvider.lists['cpr_first_aid_certification'].toString().isEmpty ? "Select File" : "Change File",
                        ),
                        if (giverProfileEditProvider.validationErrors['cpr_first_aid_certification']!['status'] == true) ...[
                          const SizedBox(height: 05),
                          Padding(
                            padding: const EdgeInsets.only(left: 10),
                            child: Text(
                              giverProfileEditProvider.validationErrors['cpr_first_aid_certification']!['error'].toString(),
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
                            giverProfileEditProvider.uploadDocument(context, "government_registered_care_provider");
                          },
                          title: "Government Registered Care Provider",
                          fileSelectText: giverProfileEditProvider.lists['government_registered_care_provider'].toString().isEmpty ? "Select File" : "Change File",
                        ),
                        if (giverProfileEditProvider.validationErrors['government_registered_care_provider']!['status'] == true) ...[
                          const SizedBox(height: 05),
                          Padding(
                            padding: const EdgeInsets.only(left: 10),
                            child: Text(
                              giverProfileEditProvider.validationErrors['government_registered_care_provider']!['error'].toString(),
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
                            giverProfileEditProvider.uploadDocument(context, "animal_care_provider_certification");
                          },
                          title: "Animal Care Provider Certificate",
                          fileSelectText: giverProfileEditProvider.lists['animal_care_provider_certification'].toString().isEmpty ? "Select File" : "Change File",
                        ),
                        if (giverProfileEditProvider.validationErrors['animal_care_provider_certification']!['status'] == true) ...[
                          const SizedBox(height: 05),
                          Padding(
                            padding: const EdgeInsets.only(left: 5.0),
                            child: Text(
                              giverProfileEditProvider.validationErrors['animal_care_provider_certification']!['error'].toString(),
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
                            giverProfileEditProvider.uploadDocument(context, "animail_first_aid");
                          },
                          title: "Animal First Aid",
                          fileSelectText: giverProfileEditProvider.lists['animail_first_aid'].toString().isEmpty ? "Select File" : "Change File",
                        ),
                        if (giverProfileEditProvider.validationErrors['animail_first_aid']!['status'] == true) ...[
                          const SizedBox(height: 05),
                          Padding(
                            padding: const EdgeInsets.only(left: 10),
                            child: Text(
                              giverProfileEditProvider.validationErrors['animail_first_aid']!['error'].toString(),
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
                            giverProfileEditProvider.uploadDocument(context, "red_cross_babysitting_certification");
                          },
                          title: "Red Cross Babysitting Certification",
                          fileSelectText: giverProfileEditProvider.lists['red_cross_babysitting_certification'].toString().isEmpty ? "Select File" : "Change File",
                        ),
                        if (giverProfileEditProvider.validationErrors['red_cross_babysitting_certification']!['status'] == true) ...[
                          const SizedBox(height: 05),
                          Padding(
                            padding: const EdgeInsets.only(left: 10),
                            child: Text(
                              giverProfileEditProvider.validationErrors['red_cross_babysitting_certification']!['error'].toString(),
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
                            giverProfileEditProvider.uploadDocument(context, "chaild_and_family_services_and_abuse");
                          },
                          title: "Dept Child and Family Services Child Abuse Check",
                          fileSelectText: giverProfileEditProvider.lists['chaild_and_family_services_and_abuse'].toString().isEmpty ? "Select File" : "Change File",
                        ),
                        if (giverProfileEditProvider.validationErrors['chaild_and_family_services_and_abuse']!['status'] == true) ...[
                          const SizedBox(height: 05),
                          Padding(
                            padding: const EdgeInsets.only(left: 10),
                            child: Text(
                              giverProfileEditProvider.validationErrors['chaild_and_family_services_and_abuse']!['error'].toString(),
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
                              if (giverProfileEditProvider.isSelectedGender == null) {
                                customErrorSnackBar(context, "Please Select Gender");
                              } else if (dobController.text.isEmpty) {
                                customErrorSnackBar(context, "Please Select Date Of Birth");
                              } else if (phoneController.text.isEmpty) {
                                customErrorSnackBar(context, "Please Enter Phone Number");
                              } else if (experienceController.text.isEmpty) {
                                customErrorSnackBar(context, "Please Enter Years of Experience");
                              } else if (hourlyController.text.isEmpty) {
                                customErrorSnackBar(context, "Please Enter Hourly Rate");
                              } else if (addressController.text.isEmpty) {
                                customErrorSnackBar(context, "Please Enter Address");
                              } else if (giverProfileEditProvider.selectedArea == "select") {
                                customErrorSnackBar(context, "Please Select Area");
                              } else if (zipController.text.isEmpty) {
                                customErrorSnackBar(context, "Please Enter Postal Code");
                              } else if (giverProfileEditProvider.selectedAdditionalService.isEmpty) {
                                customErrorSnackBar(context, "Please Select Additional Services");
                              } else if (giverProfileEditProvider.educationApiList.isEmpty) {
                                customErrorSnackBar(context, "Please Enter education");
                              } else if (userInfoController.text.isEmpty) {
                                customErrorSnackBar(context, "Please Enter User Info");
                              } else if (availabilityController.text.isEmpty) {
                                customErrorSnackBar(context, "Please Enter User Availability");
                              } else if (widget.workReference == null && giverProfileEditProvider.lists['work_reference']!.isEmpty) {
                                customErrorSnackBar(context, "Work Refrence is Required");
                              } else if (widget.resume == null && giverProfileEditProvider.lists['resume']!.isEmpty) {
                                customErrorSnackBar(context, "Resume is Required");
                              } else {
                                List<String> missingDocuments = [];
                                giverProfileEditProvider.setValidateErrorToDefault();
                                // print(giverProfileEditProvider.validationErrorsObj);
                                giverProfileEditProvider.removeRequireDocumentDuplicate();
                                for (String documentKey in giverProfileEditProvider.requireDocument) {
                                  if (!giverProfileEditProvider.isDocumentAvailable(documentKey)) {
                                    missingDocuments.add(documentKey);
                                  }
                                }
                                if (missingDocuments.isNotEmpty) {
                                  // Show errors for missing documents
                                  for (String missingDocument in missingDocuments) {
                                    print("missing doc $missingDocument");
                                    giverProfileEditProvider.setValidateError(missingDocument);
                                  }
                                  print(giverProfileEditProvider.validationErrors);
                                } else {
                                  // All required documents are available
                                  // You can proceed with your logic here
                                  // print("All required documents are available");
                                  if (updateFormKey.currentState!.validate()) {
                                    giverProfileEditProvider.setSendRequest(true);

                                    giverProfileEditProvider.uploadImageDio(context, userInfoController.text, phoneController.text, addressController.text, dobController.text, zipController.text, experienceController.text, hourlyController.text, availabilityController.text);
                                  }
                                }
                              }
                            },
                            child: Container(
                              width: MediaQuery.of(context).size.width,
                              height: 60,
                              margin: const EdgeInsets.symmetric(vertical: 10),
                              decoration: BoxDecoration(
                                color: ServiceGiverColor.black,
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
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget getEducation(int index) {
    return Consumer<GiverProfileEidtProvider>(
      builder: (context, giverProfileEditProvider, child) => Stack(
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
                giverProfileEditProvider.education.removeAt(index);
                giverProfileEditProvider.instituteMapList.removeAt(index);
                giverProfileEditProvider.majorMapList.removeAt(index);
                giverProfileEditProvider.startDateMapList.removeAt(index);
                giverProfileEditProvider.endDateMapList.removeAt(index);
                giverProfileEditProvider.currentMapList.removeAt(index);
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
  }

  Widget getRow(int index) {
    return Consumer<GiverProfileEidtProvider>(
      builder: (context, giverProfileEditProvider, child) => Card(
        child: ListTile(
          leading: CircleAvatar(
            backgroundColor: index % 2 == 0 ? Colors.deepPurpleAccent : Colors.purple,
            foregroundColor: Colors.white,
            child: Text(
              giverProfileEditProvider.education[index]["institute_name[]"].toString(),
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                giverProfileEditProvider.education[index]["institute_name[]"].toString(),
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              Text(giverProfileEditProvider.education[index]["major[]"].toString()),
            ],
          ),
          trailing: SizedBox(
            width: 70,
            child: Row(
              children: [
                InkWell(
                    onTap: (() {
                      giverProfileEditProvider.education.removeAt(index);
                      giverProfileEditProvider.instituteMapList.removeAt(index);
                      giverProfileEditProvider.majorMapList.removeAt(index);
                      giverProfileEditProvider.startDateMapList.removeAt(index);
                      giverProfileEditProvider.endDateMapList.removeAt(index);
                      giverProfileEditProvider.currentMapList.removeAt(index);
                    }),
                    child: const Icon(Icons.delete)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class GiverProfileEidtProvider extends ChangeNotifier {
  initValueSet(genderValue, areaValue, additionalServiceValue, educationValue) {
    if (genderValue != "null" && genderValue != null) {
      isSelectedGender = genderValue;
    }
    if (areaValue != "null" && areaValue != null) {
      selectedArea = areaValue;
    }
    if (additionalServiceValue != null && additionalServiceValue.isNotEmpty) {
      selectedAdditionalService.addAll(additionalServiceValue);
      selectedAdditionalService = selectedAdditionalService.toSet().toList();
      setRequireDocumentInit();
    }
    if (educationValue != null && educationValue.isNotEmpty) {
      for (var i = 0; i < educationValue.length; i++) {
        var item = educationValue[i];
        instituteMapList.add(educationValue[i]['name']);
        majorMapList.add(educationValue[i]['major']);
        startDateMapList.add(educationValue[i]['from']);
        endDateMapList.add(educationValue[i]['to']);
        currentMapList.add(educationValue[i]['current']);
        educationApiList.add(educationValue[i]);
      }
      instituteMapList = instituteMapList.toSet().toList();
      majorMapList = majorMapList.toSet().toList();
      startDateMapList = startDateMapList.toSet().toList();
      endDateMapList = endDateMapList.toSet().toList();
      currentMapList = currentMapList.toSet().toList();
      educationApiList = educationApiList.toSet().toList();
    }
  }

  var isSelectedGender = "1";
  setSelectedGender(value) {
    isSelectedGender = value;
    notifyListeners();
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
    selectedAdditionalService.add(value);
    setRequireDocument(value);
    notifyListeners();
  }

  removeSelectedAdditionalService(value) {
    selectedAdditionalService.remove(value);
    removeRequireDocument(value);
    notifyListeners();
  }

  int selectedIndex = -1;
  bool sendRequest = false;
  setSendRequest(value) {
    sendRequest = value;
    notifyListeners();
  }

  bool phoneError = false;
  setPhoneError(value) {
    phoneError = value;
    notifyListeners();
  }

  bool yearOfExpError = false;
  setYearOfExpError(value) {
    yearOfExpError = value;
    notifyListeners();
  }

  bool hourlyRateError = false;
  setHourlyRateError(value) {
    hourlyRateError = value;
    notifyListeners();
  }

  bool userAddressError = false;
  setUserAddressError(value) {
    userAddressError = value;
    notifyListeners();
  }

  bool zipcodeError = false;
  setZipcodeError(value) {
    zipcodeError = value;
    notifyListeners();
  }

  bool additionalServiceError = false;
  bool avaibilityError = false;
  setAvaibilityError(value) {
    avaibilityError = value;
    notifyListeners();
  }

  bool aboutMeError = false;
  setAboutMeError(value) {
    aboutMeError = value;
    notifyListeners();
  }

  var isPeriodSeleted = "0";
  void toggleradio(value) {
    if (value == true) {
      isPeriodSeleted = "1";
    } else {
      isPeriodSeleted = "0";
    }
    notifyListeners();
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
  selectDate(BuildContext context) async {
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
      // text = DateFormat('yyyy-MM-dd').format(picked);

      // picked == dobController;

      getPickedDate = DateFormat('yyyy-MM-dd').format(picked);
      notifyListeners();
    }
  }

  eduFromDate(BuildContext context, fromController) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      firstDate: DateTime(1990),
      lastDate: DateTime.now(),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: ColorScheme.fromSwatch(
              primarySwatch: Colors.teal,
              // primaryColorDark: ServiceGiverColor.black,
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

      getfromPickedDate = fromController.text;
      notifyListeners();
    }
  }

  eduToDate(BuildContext context, controller) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      firstDate: DateTime(1990),
      lastDate: DateTime.now(),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: ColorScheme.fromSwatch(
              primarySwatch: Colors.teal,
              // primaryColorDark: ServiceGiverColor.black,
              accentColor: const Color(0xff55CE86),
            ),
            dialogBackgroundColor: Colors.white,
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      controller.text = DateFormat('yyyy-MM-dd').format(picked);
      picked == controller;

      gettoPickedDate = controller.text;
      notifyListeners();
    }
  }

  List educationApiList = [];
  late Future<ProfileGiverModel> fetchProfileEdit;
  Future<ProfileGiverModel> fetchProfileGiverModelEdit(BuildContext context) async {
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
      educationApiList = response.data['data']["educations"];
      selectedArea = response.data['data']["userdetail"]['area'] != null ? response.data['data']["userdetail"]['area'].toString() : 'select';

      for (int i = 0; i < educationApiList.length; i++) {
        instituteMapList.add(educationApiList[i]['name']);
        majorMapList.add(educationApiList[i]['major']);
        startDateMapList.add(educationApiList[i]['from']);
        endDateMapList.add(educationApiList[i]['to']);
        currentMapList.add(educationApiList[i]['current']);
      }
      notifyListeners();
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
    notifyListeners();
  }

  void hideProgress() async {
    if (pr != null && pr!.isShowing()) {
      await pr!.hide();
      notifyListeners();
    }
  }

  File? image;
  File? imageFileDio;

  bool showSpinner = false;
  var myimg;

  Future getImageDio(BuildContext context) async {
    FilePickerResult? pickedFileDio = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['png', 'jpg', 'jpeg'],
    );

    if (pickedFileDio != null) {
      if (checkImageFileTypes(context, pickedFileDio.files.single.extension)) {
        imageFileDio = File(pickedFileDio.files.single.path ?? "");
        notifyListeners();
      }
    } else {
      customErrorSnackBar(context, "No file select");
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
    "chaild_and_family_services_and_abuse": "",
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
      if (file != null && file.files[0].extension == "pdf" || file!.files[0].extension == "doc" || file.files[0].extension == "docx") {
        lists[documentType] = file.files.single.path.toString();
        // print(lists[documentType]);
        notifyListeners();
      } else {
        customErrorSnackBar(context, "Only DOC and PDF file allowed");
      }
    } catch (error) {
      customErrorSnackBar(context, error.toString());
    }
  }

  var error;
  uploadImageDio(
    BuildContext context,
    userInfoText,
    phoneText,
    addressText,
    dobText,
    zipText,
    experienceText,
    hourlyText,
    availabilityText,
  ) async {
    var usersId = await Provider.of<ServiceGiverProvider>(context, listen: false).getUserId();
    var token = await Provider.of<ServiceGiverProvider>(context, listen: false).getUserToken();
    // print(jsonEncode(List<dynamic>.from(selectedAdditionalService.map((x) => {"value": x}))));
    var formData = FormData.fromMap({
      '_method': 'PUT',
      'id': usersId,
      'user_info': userInfoText.toString(),
      'phone': phoneText.toString(),
      'address': addressText.toString(),
      'gender': isSelectedGender,
      'dob': dobText.toString(),
      'area': selectedArea,
      'zip': zipText.toString(),
      'experience': experienceText.toString(),
      'hourly_rate': hourlyText.toString(),
      'availability': availabilityText.toString(),
      'additional_service': selectedAdditionalService.toString(),
      'service': jsonEncode(List<dynamic>.from(selectedAdditionalService.map((x) => {"value": x}))),
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
      "chaild_and_family_services_and_abuse": lists['chaild_and_family_services_and_abuse'].toString().isEmpty ? '' : await MultipartFile.fromFile(lists['chaild_and_family_services_and_abuse'].toString()),
      "animail_first_aid": lists['animail_first_aid'].toString().isEmpty ? '' : await MultipartFile.fromFile(lists['animail_first_aid'].toString()),
      "government_registered_care_provider": lists['government_registered_care_provider'].toString().isEmpty ? '' : await MultipartFile.fromFile(lists['government_registered_care_provider'].toString()),
      "police_background_check": lists['police_background_check'].toString().isEmpty ? '' : await MultipartFile.fromFile(lists['police_background_check'].toString()),
    });
    // print(formData.fields);
    Dio dio = Dio();
    try {
      var response = await dio.post('https://islandcare.bm/api/service-provider-profile/update', data: formData, options: Options(contentType: 'application/json', followRedirects: false, validateStatus: (status) => true, headers: {"Accept": "application/json", "Authorization": "Bearer $token"}));
      sendRequest = false;
      notifyListeners();
      if (response.statusCode == 200) {
        Provider.of<ServiceGiverProvider>(context, listen: false).fetchProfileGiverModel();
        customSuccesSnackBar(
          context,
          "Profile Updated Successfully.",
        );
      } else {
        error = response.data;
        notifyListeners();
        customErrorSnackBar(
          context,
          "Something went wrong please try agan later.",
        );
      }
    } catch (e) {
      // print(e);
      customErrorSnackBar(context, e.toString());
    }
  }

  final List areaList = [
    {"name": "Select Area", "value": "select"},
    {"name": "East", "value": "0"},
    {"name": "Central", "value": "1"},
    {"name": "West", "value": "2"},
  ];

  var selectedArea = "select";
  setSelectedArea(value) {
    selectedArea = value;
    notifyListeners();
  }

  List requireDocument = [];

  List<String>? getExtraDocumentRequire(String serviceName) {
    if (serviceName.contains('Senior Care')) {
      return [
        'cpr_first_aid_certification',
        'government_registered_care_provider',
      ];
    } else if (serviceName.contains('Pet Care')) {
      return [
        'animal_care_provider_certification',
        'animail_first_aid',
      ];
    } else if (serviceName.contains('House Keeping')) {
      return null;
    } else if (serviceName.contains('School Support')) {
      return [
        'red_cross_babysitting_certification',
        'cpr_first_aid_certification',
        'chaild_and_family_services_and_abuse',
        'government_registered_care_provider',
      ];
    } else if (serviceName.contains('Child Care')) {
      return [
        'red_cross_babysitting_certification',
        'cpr_first_aid_certification',
        'chaild_and_family_services_and_abuse',
        'government_registered_care_provider',
      ];
    } else {
      return null;
    }
  }

  setRequireDocument(value) {
    var getdocrequire = getExtraDocumentRequire(value);
    if (getdocrequire != null) {
      requireDocument.addAll(getdocrequire);
    }
    notifyListeners();
  }

  removeRequireDocumentDuplicate() {
    requireDocument = requireDocument.toSet().toList();

    notifyListeners();
  }

  removeRequireDocument(value) {
    var getdocrequire = getExtraDocumentRequire(value);
    if (getdocrequire != null) {
      for (var i = 0; i < getdocrequire.length; i++) {
        requireDocument.remove(getdocrequire[i]);
      }
    }
    notifyListeners();
  }

  setRequireDocumentInit() {
    for (int i = 0; i < selectedAdditionalService.length; i++) {
      var getdocrequire = getExtraDocumentRequire(selectedAdditionalService[i]);
      if (getdocrequire != null) {
        requireDocument.addAll(getdocrequire);
      }
    }
  }

  bool isDocumentAvailable(String documentKey) {
    print(documentKey);
    return lists[documentKey]?.isNotEmpty ?? false;
  }

  List<String> missingDocuments = [];

  // var validationErrorsObj = {
  //   "valid_driver_license": {"status": false, "error": "Valid Driver License is Required."},
  //   "scars_awareness_certification": {"status": false, "error": "Scars Awareness Certification is Required."},
  //   "red_cross_babysitting_certification": {"status": false, "error": "Red Cross Babysitting Certification is Required."},
  //   "cpr_first_aid_certification": {"status": false, "error": "CPR First Aid Certification is Required."},
  //   "animal_care_provider_certification": {"status": false, "error": "Animal Care Provider Certification is Required."},
  //   "chaild_and_family_services_and_abuse": {"status": false, "error": "Chaild And Family Services and Abuse is Required."},
  //   "animail_first_aid": {"status": false, "error": "Animail First Aid is Required."},
  //   "government_registered_care_provider": {"status": false, "error": "Government Registered Care Provider is Required."},
  //   "police_background_check": {"status": false, "error": "Police Background Check is Required."},
  // };

  var validationErrors = {
    "valid_driver_license": {"status": false, "error": "Valid Driver License is Required."},
    "scars_awareness_certification": {"status": false, "error": "Scars Awareness Certification is Required."},
    "red_cross_babysitting_certification": {"status": false, "error": "Red Cross Babysitting Certification is Required."},
    "cpr_first_aid_certification": {"status": false, "error": "CPR First Aid Certification is Required."},
    "animal_care_provider_certification": {"status": false, "error": "Animal Care Provider Certification is Required."},
    "chaild_and_family_services_and_abuse": {"status": false, "error": "Chaild And Family Services and Abuse is Required."},
    "animail_first_aid": {"status": false, "error": "Animail First Aid is Required."},
    "government_registered_care_provider": {"status": false, "error": "Government Registered Care Provider is Required."},
    "police_background_check": {"status": false, "error": "Police Background Check is Required."},
  };

  setValidateErrorToDefault() {
    validationErrors = {
      "valid_driver_license": {"status": false, "error": "Valid Driver License is Required."},
      "scars_awareness_certification": {"status": false, "error": "Scars Awareness Certification is Required."},
      "red_cross_babysitting_certification": {"status": false, "error": "Red Cross Babysitting Certification is Required."},
      "cpr_first_aid_certification": {"status": false, "error": "CPR First Aid Certification is Required."},
      "animal_care_provider_certification": {"status": false, "error": "Animal Care Provider Certification is Required."},
      "chaild_and_family_services_and_abuse": {"status": false, "error": "Chaild And Family Services and Abuse is Required."},
      "animail_first_aid": {"status": false, "error": "Animail First Aid is Required."},
      "government_registered_care_provider": {"status": false, "error": "Government Registered Care Provider is Required."},
      "police_background_check": {"status": false, "error": "Police Background Check is Required."},
    };
    notifyListeners();
  }

  setValidateError(missingDocument) {
    validationErrors[missingDocument]!['status'] = true;
    notifyListeners();
  }
}
