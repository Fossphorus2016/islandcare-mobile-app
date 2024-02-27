// ignore_for_file: use_build_context_synchronously, unnecessary_null_comparison, prefer_typing_uninitialized_variables, unused_catch_clause, deprecated_member_use

import 'package:flutter/material.dart';
import 'package:island_app/caregiver/models/bank_details_models.dart';
import 'package:island_app/caregiver/utils/profile_provider.dart';
import 'package:island_app/carereceiver/utils/colors.dart';
import 'package:island_app/res/app_url.dart';
import 'package:island_app/utils/utils.dart';
import 'package:provider/provider.dart';
import 'dart:core';

import 'package:dio/dio.dart';

class BankDetails extends StatefulWidget {
  const BankDetails({super.key});

  @override
  State<BankDetails> createState() => _BankDetailsState();
}

class _BankDetailsState extends State<BankDetails> {
  // List? allCards = [];
  // List showItem = [];

  BankDetailsModel? futureBankDetails;
  List bankDetails = [];
  TextEditingController accountTitleController = TextEditingController();
  TextEditingController accountNumberController = TextEditingController();
  final bankKey = GlobalKey<FormState>();
  fetchBankDetailsModel() async {
    var token = await Provider.of<ServiceGiverProvider>(context, listen: false).getUserToken();
    final response = await Dio().get(
      CareGiverUrl.serviceProviderBankDetails,
      options: Options(headers: {
        'Authorization': 'Bearer $token',
        'Accept': 'application/json',
      }),
    );
    if (response.statusCode == 200) {
      var json = response.data as Map;
      var bankdetails = json['bank_details'] as List;

      futureBankDetails = BankDetailsModel.fromJson(response.data);
      setState(() {
        bankDetails = bankdetails;
        // print(json['bank_details']);
        if (futureBankDetails != null && futureBankDetails!.bankDetails != null) {
          filteredList = futureBankDetails!.bankDetails;
        } else {
          filteredList = null;
        }
      });
    } else {
      throw Exception(
        'Failed to load Manage Cards',
      );
    }
  }

  selectBank(var bankId) async {
    var token = await Provider.of<ServiceGiverProvider>(context, listen: false).getUserToken();
    var formData = FormData.fromMap(
      {
        "id": bankId,
      },
    );
    Dio dio = Dio();
    try {
      var response = await dio.post(
        '${AppUrl.webBaseURL}/api/select-bank',
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
      if (response.statusCode == 200 && !response.data['message'].contains("Unable To Select Unverified Banks")) {
        customSuccesSnackBar(context, "Bank Account Selected");
        fetchBankDetailsModel();
      } else {
        customErrorSnackBar(
          context,
          response.data['message'].toString(),
        );
      }
    } catch (e) {
      customErrorSnackBar(
        context,
        e.toString(),
      );
    }
  }

  deleteBank(var bankId) async {
    var token = await Provider.of<ServiceGiverProvider>(context, listen: false).getUserToken();
    var formData = FormData.fromMap(
      {
        "id": bankId,
      },
    );
    Dio dio = Dio();
    try {
      var response = await dio.post(
        '${AppUrl.webBaseURL}/api/delete-bank',
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
        customSuccesSnackBar(
          context,
          "Bank Account Removed Successfully",
        );
        focus.requestFocus();
        fetchBankDetailsModel();
      } else {
        customErrorSnackBar(
          context,
          response.data['message'].toString(),
        );
      }
    } catch (e) {
      customErrorSnackBar(
        context,
        e.toString(),
      );
    }
  }

  // Add Bank Detail
  postAddBank() async {
    var requestBody = {
      'name_of_bank': selectedNames.toString(),
      'name_on_account': accountTitleController.text.toString(),
      'account_number': accountNumberController.text.toString(),
    };
    try {
      var token = await Provider.of<ServiceGiverProvider>(context, listen: false).getUserToken();
      final response = await Dio().post(
        CareGiverUrl.addServiceProviderBank,
        data: requestBody,
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Accept': 'application/json',
          },
        ),
      );
      if (response.statusCode == 200) {
        if (response.data['success']) {
          customSuccesSnackBar(
            context,
            response.data['message'],
          );
          fetchBankDetailsModel();
          focus.requestFocus();
          accountTitleController.clear();
          accountNumberController.clear();
        } else {
          customErrorSnackBar(
            context,
            response.data['message'],
          );
          accountTitleController.clear();
          accountNumberController.clear();
        }
      } else {
        customErrorSnackBar(
          context,
          response.data['message'],
        );
      }
    } on DioError catch (e) {
      customErrorSnackBar(
        context,
        "Something went wrong please try again later",
      );
    }
  }

  List dataNames = [
    {"name": "CLARIEN", "value": "CLARIEN"},
    {"name": "BNTB", "value": "BNTB"},
    {"name": "HSBC", "value": "HSBC"},
  ]; //edited line
  var selectedNames;

  var now = DateTime.now();
  DateTime today = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);

  @override
  void initState() {
    super.initState();
    fetchBankDetailsModel();
  }

  List<BankDetail>? filteredList = [];
  BankDetail? selectedBank;
  FocusNode focus = FocusNode();
  TextEditingController textController = TextEditingController();
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
            "Bank Details",
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
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),
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
                                  padding: const EdgeInsets.symmetric(horizontal: 25),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      const SizedBox(height: 20),
                                      Center(
                                        child: Container(
                                          width: 130,
                                          height: 5,
                                          decoration: BoxDecoration(
                                            color: const Color(0xffC4C4C4),
                                            borderRadius: BorderRadius.circular(6),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: 20),
                                      Center(
                                        child: Text(
                                          "Enter Your Bank Details",
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            color: CustomColors.black,
                                            fontFamily: "Rubik",
                                            fontStyle: FontStyle.normal,
                                            fontSize: 24,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: 40),
                                      Form(
                                        key: bankKey,
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Container(
                                              decoration: BoxDecoration(
                                                borderRadius: const BorderRadius.only(
                                                  topLeft: Radius.circular(6),
                                                  bottomLeft: Radius.circular(6),
                                                  bottomRight: Radius.circular(6),
                                                  topRight: Radius.circular(6),
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
                                              width: MediaQuery.of(context).size.width,
                                              height: 50,
                                              child: DecoratedBox(
                                                decoration: const BoxDecoration(
                                                  color: Colors.transparent,
                                                ),
                                                child: Padding(
                                                  padding: const EdgeInsets.symmetric(
                                                    horizontal: 10,
                                                    vertical: 4,
                                                  ),
                                                  child: DropdownButtonHideUnderline(
                                                    child: DropdownButton(
                                                      isExpanded: true,
                                                      hint: const Text("Select Banks"),
                                                      value: selectedNames,
                                                      onChanged: (value) {
                                                        setState(() {
                                                          selectedNames = value.toString();
                                                        });
                                                      },
                                                      items: dataNames.map((itemone) {
                                                        return DropdownMenuItem(value: itemone['value'], child: Text(itemone['name']));
                                                      }).toList(),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            const SizedBox(
                                              height: 10,
                                            ),
                                            Container(
                                              decoration: BoxDecoration(
                                                borderRadius: const BorderRadius.only(
                                                  topLeft: Radius.circular(6),
                                                  bottomLeft: Radius.circular(6),
                                                  bottomRight: Radius.circular(6),
                                                  topRight: Radius.circular(6),
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
                                              width: MediaQuery.of(context).size.width,
                                              height: 50,
                                              child: TextFormField(
                                                keyboardType: TextInputType.text,
                                                controller: accountTitleController,
                                                textInputAction: TextInputAction.next,
                                                style: const TextStyle(
                                                  fontSize: 16,
                                                  fontFamily: "Rubik",
                                                  fontWeight: FontWeight.w400,
                                                ),
                                                textAlignVertical: TextAlignVertical.bottom,
                                                maxLines: 1,
                                                decoration: InputDecoration(
                                                  hintText: "Enter Account Title",
                                                  fillColor: CustomColors.white,
                                                  focusColor: CustomColors.white,
                                                  hoverColor: CustomColors.white,
                                                  filled: true,
                                                  border: OutlineInputBorder(
                                                    borderRadius: BorderRadius.circular(4),
                                                  ),
                                                  focusedBorder: OutlineInputBorder(
                                                    borderSide: BorderSide(color: CustomColors.white, width: 2.0),
                                                    borderRadius: BorderRadius.circular(4.0),
                                                  ),
                                                  enabledBorder: OutlineInputBorder(
                                                    borderSide: BorderSide(color: CustomColors.white, width: 2.0),
                                                    borderRadius: BorderRadius.circular(4.0),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            const SizedBox(
                                              height: 10,
                                            ),
                                            Container(
                                              decoration: BoxDecoration(
                                                borderRadius: const BorderRadius.only(
                                                  topLeft: Radius.circular(6),
                                                  bottomLeft: Radius.circular(6),
                                                  bottomRight: Radius.circular(6),
                                                  topRight: Radius.circular(6),
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
                                              width: MediaQuery.of(context).size.width,
                                              height: 50,
                                              child: TextFormField(
                                                keyboardType: TextInputType.text,
                                                textInputAction: TextInputAction.done,
                                                controller: accountNumberController,
                                                style: const TextStyle(fontSize: 16, fontFamily: "Rubik", fontWeight: FontWeight.w400),
                                                textAlignVertical: TextAlignVertical.bottom,
                                                maxLines: 1,
                                                decoration: InputDecoration(
                                                  hintText: "Enter Account Number",
                                                  fillColor: CustomColors.white,
                                                  focusColor: CustomColors.white,
                                                  hoverColor: CustomColors.white,
                                                  filled: true,
                                                  border: OutlineInputBorder(
                                                    borderRadius: BorderRadius.circular(4),
                                                  ),
                                                  focusedBorder: OutlineInputBorder(
                                                    borderSide: BorderSide(color: CustomColors.white, width: 2.0),
                                                    borderRadius: BorderRadius.circular(4.0),
                                                  ),
                                                  enabledBorder: OutlineInputBorder(
                                                    borderSide: BorderSide(color: CustomColors.white, width: 2.0),
                                                    borderRadius: BorderRadius.circular(4.0),
                                                  ),
                                                ),
                                              ),
                                            ),

                                            const SizedBox(
                                              height: 20,
                                            ),
                                            // OTP
                                            GestureDetector(
                                              onTap: () {
                                                if (selectedNames == null) {
                                                  customErrorSnackBar(
                                                    context,
                                                    "Please Select Bank Names",
                                                  );
                                                } else if (accountTitleController.text.isEmpty) {
                                                  customErrorSnackBar(
                                                    context,
                                                    "Please Enter Account Title",
                                                  );
                                                } else if (accountNumberController.text.isEmpty) {
                                                  customErrorSnackBar(
                                                    context,
                                                    "Please Enter Account Number",
                                                  );
                                                } else {
                                                  if (bankKey.currentState!.validate()) {
                                                    postAddBank();
                                                    Navigator.pop(context);
                                                  }
                                                }
                                              },
                                              child: Container(
                                                width: MediaQuery.of(context).size.width,
                                                height: 54,
                                                decoration: BoxDecoration(
                                                  color: ServiceGiverColor.redButton,
                                                  borderRadius: BorderRadius.circular(10),
                                                ),
                                                child: Center(
                                                  child: Text(
                                                    "Add Bank Detail",
                                                    style: TextStyle(
                                                      color: CustomColors.white,
                                                      fontFamily: "Rubik",
                                                      fontStyle: FontStyle.normal,
                                                      fontWeight: FontWeight.w500,
                                                      fontSize: 18,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            const SizedBox(
                                              height: 30,
                                            ),
                                          ],
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
                    width: 140,
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: ServiceGiverColor.black,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Center(
                      child: Text(
                        "Add New Bank",
                        style: TextStyle(color: CustomColors.white),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                if (filteredList != null) ...[
                  SizedBox(
                    width: MediaQuery.of(context).size.width,
                    height: FocusScope.of(context).hasFocus ? 250 : 80,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        TextField(
                          focusNode: focus,
                          autofocus: true,
                          decoration: InputDecoration(
                            isDense: true,
                            prefixIcon: const Icon(Icons.search),
                            hintText: "Search Bank...",
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: const BorderSide(color: Colors.black26),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: const BorderSide(color: Colors.black12),
                            ),
                          ),
                          style: const TextStyle(fontSize: 14),
                          controller: textController,
                          onChanged: (value) {
                            setState(() {
                              if (textController.text.isEmpty) {
                                filteredList = futureBankDetails!.bankDetails;
                              } else {
                                filteredList = futureBankDetails!.bankDetails!.where((element) {
                                  if (element.nameOfBank.toString().toLowerCase().contains(textController.text.toLowerCase())) {
                                    return true;
                                  } else if (element.nameOnAccount.toString().toLowerCase().contains(textController.text.toLowerCase())) {
                                    return true;
                                  } else if (element.accountNumber.toString().toLowerCase().contains(textController.text.toLowerCase())) {
                                    return true;
                                  } else {
                                    return false;
                                  }
                                }).toList();
                              }
                            });
                          },
                        ),
                        const SizedBox(height: 15),
                        if (FocusScope.of(context).hasFocus) ...[
                          Container(
                            padding: const EdgeInsets.only(bottom: 10),
                            decoration: const BoxDecoration(
                              border: Border(
                                bottom: BorderSide(color: Colors.grey),
                              ),
                            ),
                            child: const Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Bank Name",
                                  style: TextStyle(fontWeight: FontWeight.w600),
                                ),
                                Text(
                                  "Account Title",
                                  style: TextStyle(fontWeight: FontWeight.w600),
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            child: ListView.builder(
                              itemCount: filteredList!.length,
                              cacheExtent: 50,
                              itemBuilder: (context, index) {
                                return InkWell(
                                  onTap: () {
                                    FocusScope.of(context).unfocus();

                                    setState(() {
                                      selectedBank = filteredList![index];
                                    });
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(vertical: 10),
                                    decoration: const BoxDecoration(
                                      border: Border(
                                        bottom: BorderSide(color: Colors.grey),
                                      ),
                                    ),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          filteredList![index].nameOfBank.toString(),
                                          style: const TextStyle(fontSize: 14),
                                        ),
                                        Text(
                                          filteredList![index].nameOnAccount.toString(),
                                          style: const TextStyle(fontSize: 14),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                  if (selectedBank != null && !FocusScope.of(context).hasFocus) ...[
                    Row(
                      children: [
                        const Text(
                          "Name Of Bank: ",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(width: 10),
                        Text(selectedBank!.nameOfBank.toString()),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        const Text(
                          "Account Title: ",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(width: 10),
                        Text(selectedBank!.nameOnAccount.toString()),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        const Text(
                          "Account Number: ",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(width: 10),
                        Text(selectedBank!.accountNumber.toString()),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Row(
                      // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "Status: ",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(width: 10),
                        Text(
                          selectedBank!.status == 0 ? "Pending" : "Approved",
                          style: TextStyle(
                            color: selectedBank!.status == 1 ? Colors.green : null,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Row(
                      // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "Selected Default Bank: ",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(width: 10),
                        Text(selectedBank!.status == 1 ? "true" : "false"),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        if (selectedBank!.selected == 0) ...[
                          TextButton(
                            onPressed: () {
                              selectBank(selectedBank!.id);
                            },
                            style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.resolveWith((states) => Colors.green),
                              shape: MaterialStateProperty.resolveWith(
                                (states) => RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                            ),
                            child: const Text(
                              "Set Default Bank",
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                          const SizedBox(width: 20),
                        ],
                        TextButton(
                          onPressed: () {
                            deleteBank(selectedBank!.id);
                          },
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.resolveWith((states) => Colors.red),
                            shape: MaterialStateProperty.resolveWith(
                              (states) => RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          ),
                          child: const Text(
                            "Delete",
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                  ]
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
