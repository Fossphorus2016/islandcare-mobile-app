// ignore_for_file: use_build_context_synchronously, prefer_typing_uninitialized_variables, await_only_futures, deprecated_member_use

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:island_app/caregiver/models/bank_details_models.dart';
import 'package:island_app/carereceiver/utils/colors.dart';
import 'package:island_app/providers/user_provider.dart';
import 'package:island_app/res/app_url.dart';
import 'package:island_app/utils/utils.dart';
import 'package:provider/provider.dart';
// import 'package:island_app/widgets/bank_detail_panel.dart';
import 'dart:core';

class ReceiverBankDetails extends StatefulWidget {
  const ReceiverBankDetails({super.key});

  @override
  State<ReceiverBankDetails> createState() => _ReceiverBankDetailsState();
}

class _ReceiverBankDetailsState extends State<ReceiverBankDetails> {
  List? allCards = [];
  List showItem = [];

  BankDetailsModel? futureBankDetails;
  List bankDetails = [];
  FocusNode focus = FocusNode();
  fetchBankDetailsModel() async {
    var token = await Provider.of<RecieverUserProvider>(context, listen: false).getUserToken();
    final response = await Dio().get(
      CareReceiverURl.serviceReceiverBankDetails,
      options: Options(
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      ),
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

  selectBank(bankId) async {
    var token = await Provider.of<RecieverUserProvider>(context, listen: false).getUserToken();
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
        customSuccesSnackBar(
          context,
          "Bank Account Selected",
        );
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

  deleteBank(bankId) async {
    var token = await Provider.of<RecieverUserProvider>(context, listen: false).getUserToken();
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
      // print(response.toString());
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
          "Unable To Delete Unverified Banks",
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
      var token = await Provider.of<RecieverUserProvider>(context, listen: false).getUserToken();
      final response = await Dio().post(
        CareReceiverURl.addServiceReceiverBank,
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
    } on DioError {
      customErrorSnackBar(
        context,
        "Something went wrong please try again later",
      );
    }
  }

  TextEditingController accountTitleController = TextEditingController();
  TextEditingController accountNumberController = TextEditingController();
  final bankKey = GlobalKey<FormState>();
  List dataNames = [
    {"name": "CLARIEN", "value": "CLARIEN"},
    {"name": "BNTB", "value": "BNTB"},
    {"name": "HSBC", "value": "HSBC"},
  ]; //edited line
  var selectedNames;
  // var now = DateTime.now();
  // DateTime today = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);
  // getUserToken() async {
  //   SharedPreferences preferences = await SharedPreferences.getInstance();
  //   var userToken = await preferences.getString(
  //     'userToken',
  //   );

  //   return userToken.toString();
  // }

  TextEditingController textController = TextEditingController();
  @override
  void initState() {
    super.initState();
    fetchBankDetailsModel();

    textController.addListener(() {
      // setState(() {
      //   if (textController.text.isEmpty) {
      //     filteredList = bankDetails;
      //   } else {
      //     filteredList = bankDetails.where((element) => element.toString().toLowerCase().contains(textController.text.toLowerCase())).toList();
      //   }
      // });
    });
  }

  List<BankDetail>? filteredList = [];

  BankDetail? selectedBank;
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
                                                  color: CustomColors.primaryColor,
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
                      color: CustomColors.primaryColor,
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
                // Listing
                // Container(
                //   padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
                //   decoration: BoxDecoration(
                //     color: CustomColors.blackLight,
                //     border: Border(
                //       bottom: BorderSide(
                //         color: CustomColors.borderLight,
                //         width: 0.1,
                //       ),
                //     ),
                //   ),
                //   child: Row(
                //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //     crossAxisAlignment: CrossAxisAlignment.start,
                //     children: [
                //       Text(
                //         "Bank Name",
                //         style: TextStyle(
                //           color: CustomColors.black,
                //           fontSize: 12,
                //           fontFamily: "Poppins",
                //           fontWeight: FontWeight.w600,
                //         ),
                //       ),
                //       Text(
                //         "Account Title",
                //         style: TextStyle(
                //           color: CustomColors.black,
                //           fontSize: 12,
                //           fontFamily: "Poppins",
                //           fontWeight: FontWeight.w600,
                //         ),
                //       ),
                //     ],
                //   ),
                // ),
                if (filteredList != null) ...[
                  SizedBox(
                    width: MediaQuery.of(context).size.width,
                    height: FocusScope.of(context).hasFocus ? 250 : 80,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // Row(
                        //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        //   children: [
                        //     Text(
                        //       widget.title,
                        //       style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                        //     ),
                        //     IconButton(
                        //       icon: const Icon(Icons.close),
                        //       onPressed: () {
                        //         FocusScope.of(context).unfocus();
                        //         Navigator.pop(context);
                        //       },
                        //     ),
                        //     /*Align(
                        //                                 alignment: Alignment.centerRight,
                        //                                 child: TextButton(
                        //                                     onPressed: () {
                        //                                       FocusScope.of(context).unfocus();
                        //                                       Navigator.pop(context);
                        //                                     },
                        //                                     child: Text(
                        //                                       'Close',
                        //                                       style: widget.titleStyle != null
                        //                                           ? widget.titleStyle
                        //                                           : TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                        //                                     )),
                        //                               )*/
                        //   ],
                        // ),
                        // const SizedBox(height: 5),
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
                                    // widget.onSelected(filteredList[index]);
                                    setState(() {
                                      selectedBank = filteredList![index];
                                    });
                                    // print(filteredList![index]);
                                  },
                                  child: Container(
                                    // color: Colors.red,
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
                  //  ListView.builder(
                  //   physics: const NeverScrollableScrollPhysics(),
                  //   shrinkWrap: true,
                  //   itemCount: snapshot.data!.bankDetails!.length,
                  //   itemBuilder: (BuildContext context, int index) {
                  //     return BankDetailPanel(
                  //       bankName: snapshot.data!.bankDetails![index].nameOfBank.toString(),
                  //       accountTitle: snapshot.data!.bankDetails![index].nameOnAccount.toString(),
                  //       accountNumber: snapshot.data!.bankDetails![index].accountNumber.toString(),
                  //       defaulBank: snapshot.data?.bankDetails![index].status == 1 ? true : false,
                  //       status: snapshot.data!.bankDetails![index].status == 0 ? "Pending" : "Approved",
                  //       deleteBank: () => deleteBank(snapshot.data?.bankDetails![index].id),
                  //       setDefaultBank: () => selectBank(snapshot.data!.bankDetails![index].id),
                  //     );
                  //   },
                  // );
                  //     } else {
                  //       return const Center(
                  //         child: CircularProgressIndicator(),
                  //       );
                  //     }
                  //   },
                  // ),
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
