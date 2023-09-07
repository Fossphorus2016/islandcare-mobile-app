// ignore_for_file: use_build_context_synchronously, unnecessary_null_comparison, prefer_typing_uninitialized_variables

import 'package:flutter/material.dart';
import 'package:island_app/caregiver/models/bank_details_models.dart';
import 'package:island_app/carereceiver/utils/colors.dart';
// import 'package:http/http.dart' as http;
import 'package:island_app/res/app_url.dart';
// import 'package:island_app/utils/dart';
import 'package:island_app/utils/utils.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:core';

import 'package:dio/dio.dart';

class BankDetails extends StatefulWidget {
  const BankDetails({super.key});

  @override
  State<BankDetails> createState() => _BankDetailsState();
}

class _BankDetailsState extends State<BankDetails> {
  List? allCards = [];
  List showItem = [];

  late Future<BankDetailsModel>? futureBankDetails;
  List bankDetails = [];
  TextEditingController accountTitleController = TextEditingController();
  TextEditingController accountNumberController = TextEditingController();
  final bankKey = GlobalKey<FormState>();
  Future<BankDetailsModel> fetchBankDetailsModel() async {
    var token = await getUserToken();
    final response = await Dio().get(
      CareGiverUrl.serviceProviderBankDetails,
      options: Options(headers: {
        'Authorization': 'Bearer $token',
        'Accept': 'application/json',
      }),
    );
    // print(response.body);
    if (response.statusCode == 200) {
      var json = response.data as Map;
      var bankDetails = json['bank_details'] as List;
      // print("response  == ${jsonDecode(response.body)}");
      setState(() {
        bankDetails = bankDetails;
      });
      // print("bankDetails= $bankDetails");
      return BankDetailsModel.fromJson(response.data);
    } else {
      // print("response  == ${jsonDecode(response.body)}");

      throw Exception(
        'Failed to load Manage Cards',
      );
    }
  }

  selectBank(var bankId) async {
    var token = await getUserToken();
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
      // print(response.toString());
      if (response.statusCode == 200) {
        customSuccesSnackBar(context, "Bank Account Selected");
        setState(() {
          futureBankDetails = fetchBankDetailsModel();
        });
      } else {
        customErrorSnackBar(
          context,
          "Unable To Select Unverified Banks",
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
    var token = await getUserToken();
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
        setState(() {
          futureBankDetails = fetchBankDetailsModel();
        });
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
  Future<Response> postAddBank() async {
    var requestBody = {
      'name_of_bank': selectedNames.toString(),
      'name_on_account': accountTitleController.text.toString(),
      'account_number': accountNumberController.text.toString(),
      // 'card_number': cardNumberController.text.toString(),
      // 'card_expiration_month': selectedMonth.toString(),
      // 'card_expiration_year': selectedYear.toString(),
      // 'cvv': cvvController.text.toString(),
    };
    var token = await getUserToken();
    // showProgress(context);
    final response = await Dio().post(
      CareGiverUrl.addServiceProviderBank,
      // body: jsonEncode(model.toJson()),
      data: requestBody,
      options: Options(
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      ),
    );
    if (response.statusCode == 200) {
      if (response.data.contains("This Bank Account Already Exist")) {
        customErrorSnackBar(context, "This Bank Account Already Exist");

        // customErrorSnackBar(response.body, context);
      } else {
        // customSuccesSnackBar("Bank Account Added Successfully", context);
        customSuccesSnackBar(context, "Bank Account Added Successfully");
        accountTitleController.clear();
        accountNumberController.clear();

        setState(() {
          futureBankDetails = fetchBankDetailsModel();
        });
      }
      // print(response.body);
    } else {
      customErrorSnackBar(context, response.data['message']);
      // customErrorSnackBar(response.body, context);
      // print(response.body);
    }
    Navigator.pop(context);
    // hideProgress();
    return response;
  }

  List dataNames = [
    {"name": "CLARIEN", "value": "CLARIEN"},
    {"name": "BNTB", "value": "BNTB"},
    {"name": "HSBC", "value": "HSBC"},
  ]; //edited line
  var selectedNames;

  // Future<String> getBankNames() async {
  //   var token = await getUserToken();
  //   var res = await http.get(Uri.parse(AppUrl.bankName), headers: {
  //     'Authorization': 'Bearer $token',
  //     'Accept': 'application/json',
  //   });
  //   Map<String, dynamic> resBody = json.decode(res.body);
  //   // Map<String, dynamic> map = json.decode(response.body);
  //   List<dynamic>? names = resBody["names"];
  //   // print(data![0]["name"]);
  //   // var json = jsonDecode(res.body) as Map;
  //   // var listOfJobs = json['jobs'] as List;

  //   setState(() {
  //     dataNames = names;
  //   });

  //   // print("BankNames== $dataNames");

  //   return "Sucess";
  // }

  getUserToken() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    var userToken = preferences.getString(
      'userToken',
    );
    // if (kDebugMode) {
    // print(userToken);
    // }
    return userToken.toString();
  }

  var now = DateTime.now();
  DateTime today = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);

  @override
  void initState() {
    // print("today ${DateFormat('yyyy-MM-dd').format(today)}");
    getUserToken();
    super.initState();
    futureBankDetails = fetchBankDetailsModel();
    // getBankNames();
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
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 20,
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
                                                        // print(selectedNames);
                                                      });
                                                    },
                                                    items: dataNames.map((itemone) {
                                                      return DropdownMenuItem(value: itemone['value'], child: Text(itemone['name']));
                                                    }).toList(),
                                                  )),
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
                                                keyboardType: TextInputType.name,
                                                textInputAction: TextInputAction.next,
                                                controller: accountTitleController,
                                                style: const TextStyle(
                                                  fontSize: 16,
                                                  fontFamily: "Rubik",
                                                  fontWeight: FontWeight.w400,
                                                ),
                                                textAlignVertical: TextAlignVertical.bottom,
                                                maxLines: 1,
                                                // onChanged: (value) => _runFilter(value),
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
                                                controller: accountNumberController,
                                                style: const TextStyle(
                                                  fontSize: 16,
                                                  fontFamily: "Rubik",
                                                  fontWeight: FontWeight.w400,
                                                ),
                                                textAlignVertical: TextAlignVertical.bottom,
                                                maxLines: 1,
                                                // onChanged: (value) => _runFilter(value),
                                                decoration: InputDecoration(
                                                  // suffixIcon: Icon(
                                                  //   Icons.credit_card,
                                                  //   size: 17,
                                                  //   color: CustomColors.red,
                                                  // ),
                                                  // suffixIcon: Icon(
                                                  //   Icons.close,
                                                  //   size: 17,
                                                  //   color: CustomColors.hintText,
                                                  // ),
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
                const SizedBox(
                  height: 10,
                ),
                // Listing
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
                  decoration: BoxDecoration(
                    color: CustomColors.blackLight,
                    border: Border(
                      bottom: BorderSide(
                        color: CustomColors.borderLight,
                        width: 0.1,
                      ),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Bank Name",
                        style: TextStyle(
                          color: CustomColors.black,
                          fontSize: 12,
                          fontFamily: "Poppins",
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        "Account Title",
                        style: TextStyle(
                          color: CustomColors.black,
                          fontSize: 12,
                          fontFamily: "Poppins",
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
                FutureBuilder<BankDetailsModel>(
                    future: futureBankDetails,
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        return ListView.builder(
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: snapshot.data!.bankDetails!.length,
                          itemBuilder: (BuildContext context, int index) {
                            return Column(
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    if (showItem.contains(index)) {
                                      showItem.remove(index);
                                    } else {
                                      showItem.add(index);
                                    }

                                    setState(() {});
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 0),
                                    decoration: BoxDecoration(
                                      border: Border(
                                        bottom: BorderSide(
                                          color: CustomColors.borderLight,
                                          width: 0.1,
                                        ),
                                      ),
                                    ),
                                    child: Column(
                                      children: [
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Column(
                                              crossAxisAlignment: CrossAxisAlignment.center,
                                              children: [
                                                Container(
                                                  width: MediaQuery.of(context).size.width * .4,
                                                  alignment: Alignment.center,
                                                  child: Text(
                                                    // bankDetails[index]['name_of_bank'].toString(),
                                                    // "Babysitters",
                                                    snapshot.data!.bankDetails![index].nameOfBank.toString(),
                                                    style: TextStyle(
                                                      color: CustomColors.primaryText,
                                                      fontFamily: "Poppins",
                                                      fontWeight: FontWeight.w600,
                                                      fontSize: 13,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            Container(
                                              width: MediaQuery.of(context).size.width * .4,
                                              alignment: Alignment.center,
                                              child: Text(
                                                snapshot.data!.bankDetails![index].nameOnAccount.toString(),
                                                style: TextStyle(
                                                  color: CustomColors.primaryText,
                                                  fontFamily: "Poppins",
                                                  fontWeight: FontWeight.w600,
                                                  fontSize: 13,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                showItem.contains(index)
                                    ? Container(
                                        padding: const EdgeInsets.symmetric(vertical: 5),
                                        decoration: BoxDecoration(
                                          color: CustomColors.loginBg,
                                          border: Border(
                                            top: BorderSide(
                                              color: CustomColors.borderLight,
                                              width: 0.1,
                                            ),
                                          ),
                                        ),
                                        child: Column(
                                          children: [
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Column(
                                                  crossAxisAlignment: CrossAxisAlignment.center,
                                                  children: [
                                                    Container(
                                                      width: MediaQuery.of(context).size.width * .4,
                                                      alignment: Alignment.center,
                                                      child: Text(
                                                        "Account Number",
                                                        // "Babysitters",
                                                        style: TextStyle(
                                                          color: CustomColors.primaryText,
                                                          fontFamily: "Poppins",
                                                          fontWeight: FontWeight.w600,
                                                          fontSize: 13,
                                                        ),
                                                      ),
                                                    ),
                                                    const SizedBox(
                                                      height: 5,
                                                    ),
                                                    Container(
                                                      width: MediaQuery.of(context).size.width * .4,
                                                      alignment: Alignment.center,
                                                      child: Text(
                                                        snapshot.data!.bankDetails![index].accountNumber.toString(),
                                                        // "One-Time",
                                                        style: TextStyle(
                                                          color: CustomColors.hintText,
                                                          fontFamily: "Poppins",
                                                          fontWeight: FontWeight.w500,
                                                          fontSize: 12,
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                Column(
                                                  crossAxisAlignment: CrossAxisAlignment.center,
                                                  children: [
                                                    Container(
                                                      width: MediaQuery.of(context).size.width * .4,
                                                      alignment: Alignment.center,
                                                      child: Text(
                                                        "Selected Default Bank",
                                                        // "Babysitters",
                                                        style: TextStyle(
                                                          color: CustomColors.primaryText,
                                                          fontFamily: "Poppins",
                                                          fontWeight: FontWeight.w600,
                                                          fontSize: 13,
                                                        ),
                                                      ),
                                                    ),
                                                    const SizedBox(
                                                      height: 5,
                                                    ),
                                                    if (snapshot.data?.bankDetails![index].status == 1 && snapshot.data!.bankDetails![index].selected == 1) ...[
                                                      Container(
                                                        width: MediaQuery.of(context).size.width * .4,
                                                        padding: const EdgeInsets.all(6),
                                                        decoration: BoxDecoration(color: snapshot.data!.bankDetails![index].selected.toString() == "1" ? CustomColors.green : CustomColors.loginBg, borderRadius: BorderRadius.circular(6)),
                                                        alignment: Alignment.center,
                                                        child: Text(
                                                          "Default Bank",
                                                          // "One-Time",
                                                          style: TextStyle(
                                                            color: snapshot.data!.bankDetails![index].selected == 1 ? Colors.white : CustomColors.red,
                                                            fontFamily: "Poppins",
                                                            fontWeight: FontWeight.w500,
                                                            fontSize: 12,
                                                          ),
                                                        ),
                                                      ),
                                                    ] else ...[
                                                      GestureDetector(
                                                        onTap: () {
                                                          selectBank(snapshot.data!.bankDetails![index].id);
                                                          // setState(() {
                                                          //   futureBankDetails = fetchBankDetailsModel();
                                                          // });
                                                        },
                                                        child: Container(
                                                          width: MediaQuery.of(context).size.width * .4,
                                                          padding: const EdgeInsets.all(6),
                                                          decoration: BoxDecoration(color: snapshot.data!.bankDetails![index].selected.toString() == "1" ? CustomColors.green : CustomColors.loginBg, borderRadius: BorderRadius.circular(6)),
                                                          alignment: Alignment.center,
                                                          child: Text(
                                                            snapshot.data!.bankDetails![index].status == 0 ? "" : "Select",
                                                            // "One-Time",
                                                            style: TextStyle(
                                                              color: snapshot.data!.bankDetails![index].selected.toString() == "1" ? CustomColors.white : CustomColors.red,
                                                              fontFamily: "Poppins",
                                                              fontWeight: FontWeight.w500,
                                                              fontSize: 12,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ]
                                                  ],
                                                ),
                                              ],
                                            ),
                                            const SizedBox(
                                              height: 10,
                                            ),
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Column(
                                                  crossAxisAlignment: CrossAxisAlignment.center,
                                                  children: [
                                                    Container(
                                                      width: MediaQuery.of(context).size.width * .4,
                                                      alignment: Alignment.center,
                                                      child: Text(
                                                        "Status",
                                                        // "Babysitters",
                                                        style: TextStyle(
                                                          color: CustomColors.primaryText,
                                                          fontFamily: "Poppins",
                                                          fontWeight: FontWeight.w600,
                                                          fontSize: 13,
                                                        ),
                                                      ),
                                                    ),
                                                    const SizedBox(
                                                      height: 5,
                                                    ),
                                                    Container(
                                                      width: MediaQuery.of(context).size.width * .4,
                                                      alignment: Alignment.center,
                                                      child: Text(
                                                        snapshot.data!.bankDetails![index].status == 0 ? "Pending" : "Approved",
                                                        // "One-Time",
                                                        style: TextStyle(
                                                          color: snapshot.data!.bankDetails![index].status == 0 ? CustomColors.red : CustomColors.green,
                                                          fontFamily: "Poppins",
                                                          fontWeight: FontWeight.w500,
                                                          fontSize: 12,
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                Column(
                                                  crossAxisAlignment: CrossAxisAlignment.center,
                                                  children: [
                                                    Container(
                                                      width: MediaQuery.of(context).size.width * .4,
                                                      alignment: Alignment.center,
                                                      child: Text(
                                                        "Action",
                                                        // "Babysitters",
                                                        style: TextStyle(
                                                          color: CustomColors.primaryText,
                                                          fontFamily: "Poppins",
                                                          fontWeight: FontWeight.w600,
                                                          fontSize: 13,
                                                        ),
                                                      ),
                                                    ),
                                                    const SizedBox(
                                                      height: 5,
                                                    ),
                                                    GestureDetector(
                                                      onTap: () {
                                                        deleteBank(snapshot.data?.bankDetails![index].id);
                                                      },
                                                      child: Container(
                                                        width: MediaQuery.of(context).size.width * .4,
                                                        padding: const EdgeInsets.all(6),
                                                        decoration: BoxDecoration(color: CustomColors.red, borderRadius: BorderRadius.circular(6)),
                                                        alignment: Alignment.center,
                                                        child: Text(
                                                          snapshot.data!.bankDetails![index].selected.toString() == "1" ? "Delete" : "Delete",
                                                          // "One-Time",
                                                          style: TextStyle(
                                                            color: CustomColors.white,
                                                            fontFamily: "Poppins",
                                                            fontWeight: FontWeight.w500,
                                                            fontSize: 12,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                            const SizedBox(
                                              height: 10,
                                            ),
                                            // Container(
                                            //   width: MediaQuery.of(context).size.width * .4,
                                            //   padding: const EdgeInsets.symmetric(vertical: 8),
                                            //   margin: const EdgeInsets.symmetric(vertical: 8),
                                            //   decoration: BoxDecoration(
                                            //     color: CustomColors.red,
                                            //     borderRadius: BorderRadius.circular(6),
                                            //   ),
                                            //   child: Center(
                                            //     child: Text(
                                            //       "Delete",
                                            //       style: TextStyle(
                                            //         color: CustomColors.white,
                                            //       ),
                                            //     ),
                                            //   ),
                                            // ),
                                          ],
                                        ),
                                      )
                                    : Container(),
                              ],
                            );
                          },
                        );
                      } else {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                    }),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
