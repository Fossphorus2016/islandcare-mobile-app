// ignore_for_file: use_build_context_synchronously, unnecessary_null_comparison, prefer_typing_uninitialized_variables, unused_catch_clause, deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:island_app/caregiver/models/bank_details_models.dart';
import 'package:island_app/carereceiver/utils/colors.dart';
import 'package:island_app/utils/app_colors.dart';
import 'package:island_app/utils/app_url.dart';
import 'package:island_app/utils/functions.dart';
import 'package:island_app/utils/http_handlers.dart';
import 'package:island_app/widgets/loading_button.dart';
import 'dart:core';

import 'package:dio/dio.dart';

class GiverBankDetails extends StatefulWidget {
  const GiverBankDetails({super.key});

  @override
  State<GiverBankDetails> createState() => _GiverBankDetailsState();
}

class _GiverBankDetailsState extends State<GiverBankDetails> {
  BankDetailsModel? futureBankDetails;
  List bankDetails = [];
  TextEditingController accountTitleController = TextEditingController();
  TextEditingController accountNumberController = TextEditingController();
  final bankKey = GlobalKey<FormState>();
  fetchBankDetailsModel() async {
    var token = await getToken();
    final response = await getRequesthandler(url: CareGiverUrl.serviceProviderBankDetails, token: token, data: null);
    if (response != null && response.statusCode == 200) {
      var json = response.data as Map;
      var bankdetails = json['bank_details'] as List;

      futureBankDetails = BankDetailsModel.fromJson(response.data);
      setState(() {
        bankDetails = bankdetails;
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

  Future<void> selectBank(var bankId) async {
    var token = await getToken();
    var formData = FormData.fromMap(
      {
        "id": bankId,
      },
    );

    try {
      var response = await postRequesthandler(
        url: BankUrl.selectBank,
        token: token,
        formData: formData,
      );
      if (response != null && response.statusCode == 200 && !response.data['message'].contains("Unable To Select Unverified Banks")) {
        showSuccessToast("Bank Account Selected");
        fetchBankDetailsModel();
      } else if (response != null && response.statusCode == 200 && response.data['message'].contains("Unable To Select Unverified Banks")) {
        showErrorToast("Unable To Select Unverified Banks");
        // fetchBankDetailsModel();
      } else {
        showErrorToast("unable to fetch bank data");
      }
    } catch (e) {
      showErrorToast(
        e.toString(),
      );
    }
  }

  Future<void> deleteBank(var bankId) async {
    var token = await getToken();
    var formData = FormData.fromMap(
      {
        "id": bankId,
      },
    );

    try {
      var response = await postRequesthandler(
        url: BankUrl.deleteBank,
        token: token,
        formData: formData,
      );
      if (response != null && response.statusCode == 200) {
        showSuccessToast("Bank Account Removed Successfully");
        // focus.requestFocus();
        fetchBankDetailsModel();
      } else {
        showErrorToast("unable to fetch data");
      }
    } catch (e) {
      showErrorToast(
        e.toString(),
      );
    }
  }

  // Add Bank Detail
  Future<void> postAddBank() async {
    var requestBody = FormData.fromMap({
      'name_of_bank': selectedNames.toString(),
      'name_on_account': accountTitleController.text.trim().toString(),
      'account_number': accountNumberController.text.trim().toString(),
    });
    try {
      var token = await getToken();
      final response = await postRequesthandler(
        url: CareGiverUrl.addServiceProviderBank,
        token: token,
        formData: requestBody,
      );
      if (response != null && response.statusCode == 200) {
        if (response.data['success']) {
          showSuccessToast(response.data['message']);
          fetchBankDetailsModel();
          // focus.requestFocus();
          accountTitleController.clear();
          accountNumberController.clear();
        } else {
          showErrorToast(response.data['message']);
          accountTitleController.clear();
          accountNumberController.clear();
        }
      } else {
        if (response != null && response.data != null && response.data["message"] != null) {
          showErrorToast(response.data['message']);
        } else {
          showErrorToast("unable to add bank");
        }
      }
    } on DioError catch (e) {
      showErrorToast("Something went wrong please try again later");
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
  // FocusNode focus = FocusNode();
  TextEditingController textController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        backgroundColor: ServiceGiverColor.black,
        // automaticallyImplyLeading: false,
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
            color: CustomColors.white,
          ),
        ),
      ),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async {
            await fetchBankDetailsModel();
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            child: CustomScrollView(
              slivers: [
                SliverToBoxAdapter(
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: SizedBox(
                      width: 140,
                      height: 50,
                      child: TextButton(
                        style: ButtonStyle(
                          backgroundColor: WidgetStatePropertyAll(ServiceGiverColor.black),
                          shape: WidgetStatePropertyAll(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                        onPressed: () {
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
                                                      inputFormatters: [
                                                        LengthLimitingTextInputFormatter(20),
                                                      ],
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
                                                  LoadingButton(
                                                    title: "Add Bank Detail",
                                                    height: 54,
                                                    backgroundColor: ServiceGiverColor.redButton,
                                                    textStyle: TextStyle(
                                                      color: CustomColors.white,
                                                      fontFamily: "Rubik",
                                                      fontStyle: FontStyle.normal,
                                                      fontWeight: FontWeight.w500,
                                                      fontSize: 18,
                                                    ),
                                                    onPressed: () async {
                                                      if (selectedNames == null) {
                                                        showErrorToast("Please Select Bank Names");
                                                        return false;
                                                      } else if (accountTitleController.text.isEmpty) {
                                                        showErrorToast("Please Enter Account Title");
                                                        return false;
                                                      } else if (accountNumberController.text.isEmpty) {
                                                        showErrorToast("Please Enter Account Number");
                                                        return false;
                                                      } else {
                                                        if (bankKey.currentState!.validate()) {
                                                          await postAddBank();
                                                          Navigator.pop(context);
                                                          return true;
                                                        }
                                                        return false;
                                                      }
                                                    },
                                                  ),
                                                  const SizedBox(height: 30),
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
                        child: const Text(
                          "Add New Bank",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                ),
                const SliverToBoxAdapter(child: SizedBox(height: 20)),
                SliverToBoxAdapter(
                  child: SizedBox(
                    height: 60,
                    child: TextField(
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
                  ),
                ),
                const SliverToBoxAdapter(child: SizedBox(height: 20)),
                SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (BuildContext context, int index) {
                      BankDetail bank = filteredList![index];
                      return Container(
                        width: MediaQuery.of(context).size.width,
                        height: bank.selected == 1 ? 220 : 200,
                        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                        margin: const EdgeInsets.symmetric(vertical: 05),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(08),
                          boxShadow: [
                            BoxShadow(
                              blurRadius: 05,
                              spreadRadius: 01,
                              color: Colors.grey.shade200,
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                const Text(
                                  "Name Of Bank: ",
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(width: 10),
                                Text(bank.nameOfBank.toString()),
                              ],
                            ),
                            const SizedBox(height: 05),
                            Row(
                              children: [
                                const Text(
                                  "Account Title: ",
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(width: 10),
                                Text(bank.nameOnAccount.toString()),
                              ],
                            ),
                            const SizedBox(height: 05),
                            Row(
                              children: [
                                const Text(
                                  "Account Number: ",
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(width: 10),
                                Text(bank.accountNumber.toString()),
                              ],
                            ),
                            const SizedBox(height: 05),
                            Row(
                              children: [
                                const Text(
                                  "Status: ",
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(width: 10),
                                Text(
                                  bank.status == 0 ? "Pending Approval" : "Approved",
                                  style: TextStyle(
                                    color: bank.status == 1 ? Colors.green : null,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 05),
                            Row(
                              children: [
                                const Text(
                                  "Selected Default Bank: ",
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(width: 10),
                                if (bank.selected == 1) ...[
                                  Container(
                                    decoration: BoxDecoration(
                                      color: ServiceGiverColor.green,
                                      borderRadius: BorderRadius.circular(08),
                                    ),
                                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                                    child: const Text(
                                      "Default Bank",
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                                ],
                              ],
                            ),
                            const SizedBox(height: 05),
                            Row(
                              children: [
                                if (bank.selected == 0 && bank.status == 1) ...[
                                  LoadingButton(
                                    title: "Set as Default",
                                    backgroundColor: Colors.green,
                                    width: 150,
                                    height: 50,
                                    onPressed: () async {
                                      await selectBank(bank.id);
                                      return true;
                                    },
                                  ),
                                  const SizedBox(width: 20),
                                ],
                                if (filteredList!.length > 1) ...[
                                  LoadingButton(
                                    title: "Delete",
                                    width: 120,
                                    height: 50,
                                    backgroundColor: Colors.red,
                                    onPressed: () async {
                                      await deleteBank(bank.id);
                                      return true;
                                    },
                                  ),
                                ],
                              ],
                            ),
                          ],
                        ),
                      );
                    },
                    childCount: filteredList!.length,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget addNewBankDailog() {
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
                            inputFormatters: [
                              LengthLimitingTextInputFormatter(20),
                            ],
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
                        LoadingButton(
                          title: "Add Bank Detail",
                          height: 54,
                          backgroundColor: ServiceGiverColor.redButton,
                          textStyle: TextStyle(
                            color: CustomColors.white,
                            fontFamily: "Rubik",
                            fontStyle: FontStyle.normal,
                            fontWeight: FontWeight.w500,
                            fontSize: 18,
                          ),
                          onPressed: () async {
                            if (selectedNames == null) {
                              showErrorToast("Please Select Bank Names");
                              return false;
                            } else if (accountTitleController.text.isEmpty) {
                              showErrorToast("Please Enter Account Title");
                              return false;
                            } else if (accountNumberController.text.isEmpty) {
                              showErrorToast("Please Enter Account Number");
                              return false;
                            } else {
                              if (bankKey.currentState!.validate()) {
                                await postAddBank();
                                Navigator.pop(context);
                                return true;
                              }
                              return false;
                            }
                          },
                        ),
                        const SizedBox(height: 30),
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
  }
}
