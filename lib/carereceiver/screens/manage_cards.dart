// ignore_for_file: use_build_context_synchronously, await_only_futures

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:island_app/carereceiver/models/manage_cards_model.dart';
import 'package:island_app/carereceiver/utils/colors.dart';
// import 'package:http/http.dart' as http;
import 'package:island_app/res/app_url.dart';
import 'package:island_app/utils/utils.dart';
import 'package:island_app/widgets/progress_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ManageCards extends StatefulWidget {
  const ManageCards({super.key});

  @override
  State<ManageCards> createState() => _ManageCardsState();
}

class _ManageCardsState extends State<ManageCards> {
  List? allCards = [];
  List showItem = [];
  late Future<CreditCardModel>? futureManageCards;
  List manageCardsData = [];
  TextEditingController nameOncardController = TextEditingController();
  var cardNumberController = TextEditingController();
  TextEditingController cvvController = TextEditingController();
  final cardKey = GlobalKey<FormState>();
  List? month = [
    {
      "id": 1,
      "name": "January",
    },
    {
      "id": 2,
      "name": "February",
    },
    {
      "id": 3,
      "name": "March",
    },
    {
      "id": 4,
      "name": "April",
    },
    {
      "id": 5,
      "name": "May",
    },
    {
      "id": 6,
      "name": "June",
    },
    {
      "id": 7,
      "name": "July",
    },
    {
      "id": 8,
      "name": "August",
    },
    {
      "id": 9,
      "name": "September",
    },
    {
      "id": 10,
      "name": "October",
    },
    {
      "id": 11,
      "name": "November",
    },
    {
      "id": 12,
      "name": "December",
    },
  ];
  String? selectedMonth;
  List? year = [
    {
      "id": 2023,
      "name": "2023",
    },
    {
      "id": 2024,
      "name": "2024",
    },
    {
      "id": 2025,
      "name": "2025",
    },
    {
      "id": 2026,
      "name": "2026",
    },
    {
      "id": 2027,
      "name": "2027",
    },
    {
      "id": 2028,
      "name": "2028",
    },
    {
      "id": 2029,
      "name": "2029",
    },
    {
      "id": 2030,
      "name": "2030",
    },
    {
      "id": 2031,
      "name": "2031",
    },
    {
      "id": 2032,
      "name": "2032",
    },
    {
      "id": 2033,
      "name": "2033",
    },
    {
      "id": 2034,
      "name": "2034",
    },
    {
      "id": 2035,
      "name": "2035",
    },
    {
      "id": 2036,
      "name": "2036",
    },
    {
      "id": 2037,
      "name": "2037",
    },
    {
      "id": 2038,
      "name": "2038",
    },
  ];
  String? selectedYear;

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

  Future<CreditCardModel> fetchManageCardsModel() async {
    var token = await getUserToken();
    final response = await Dio().get(
      CareReceiverURl.serviceReceiverGetCreditCards,
      options: Options(headers: {
        'Authorization': 'Bearer $token',
        'Accept': 'application/json',
      }),
    );
    if (response.statusCode == 200) {
      var json = response.data as Map;
      var bankDetails = json['credit-cards'] as List;
      // print("response  == ${jsonDecode(response.body)}");
      setState(() {
        manageCardsData = bankDetails;
      });
      // print("manageCardsData= $manageCardsData");
      return CreditCardModel.fromJson(response.data);
    } else {
      throw Exception(
        'Failed to load Manage Cards',
      );
    }
  }

  Future<Response> postAddCard() async {
    var requestBody = {
      'name_on_card': nameOncardController.text.toString(),
      'card_number': cardNumberController.text.toString(),
      'card_expiration_month': selectedMonth.toString(),
      'card_expiration_year': selectedYear.toString(),
      'cvv': cvvController.text.toString(),
    };
    var token = await getUserToken();
    // showProgress(context);
    final response = await Dio().post(
      CareReceiverURl.serviceReceiverAddCreditCards,
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
      if (response.data.contains("Card Already Exist")) {
        customErrorSnackBar(
          context,
          response.data,
        );
      } else if (response.data.contains("The credit card number is invalid.")) {
        customErrorSnackBar(
          context,
          response.data,
        );
      } else {
        customSuccesSnackBar(
          context,
          "Card Added Successfully",
        );
      }

      // print(response.body);
    } else {
      customErrorSnackBar(
        context,
        "something went wrong please try again later",
      );
      // print(response.body);
    }

    // hideProgress();
    return response;
  }

  getUserToken() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    var userToken = await preferences.getString(
      'userToken',
    );
    // if (kDebugMode) {
    // print(userToken);
    // }
    return userToken.toString();
  }

  @override
  void initState() {
    getUserToken();
    super.initState();
    futureManageCards = fetchManageCardsModel();
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
            "Manage Cards",
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
                                      const SizedBox(
                                        height: 20,
                                      ),
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
                                      const SizedBox(
                                        height: 20,
                                      ),
                                      Center(
                                        child: Text(
                                          "Enter Your Card Detail",
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
                                      const SizedBox(
                                        height: 40,
                                      ),
                                      Form(
                                        key: cardKey,
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
                                              child: TextFormField(
                                                controller: nameOncardController,
                                                style: const TextStyle(
                                                  fontSize: 16,
                                                  fontFamily: "Rubik",
                                                  fontWeight: FontWeight.w400,
                                                ),
                                                textAlignVertical: TextAlignVertical.bottom,
                                                maxLines: 1,
                                                // onChanged: (value) => _runFilter(value),
                                                decoration: InputDecoration(
                                                  suffixIcon: Icon(
                                                    Icons.person,
                                                    size: 17,
                                                    color: CustomColors.primaryColor,
                                                  ),
                                                  // suffixIcon: Icon(
                                                  //   Icons.close,
                                                  //   size: 17,
                                                  //   color: CustomColors.hintText,
                                                  // ),
                                                  hintText: "Enter Name On Card",
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
                                                keyboardType: TextInputType.number,
                                                controller: cardNumberController,
                                                style: const TextStyle(
                                                  fontSize: 16,
                                                  fontFamily: "Rubik",
                                                  fontWeight: FontWeight.w400,
                                                ),
                                                textAlignVertical: TextAlignVertical.bottom,
                                                maxLines: 1,
                                                // onChanged: (value) => _runFilter(value),
                                                decoration: InputDecoration(
                                                  suffixIcon: Icon(
                                                    Icons.credit_card,
                                                    size: 17,
                                                    color: CustomColors.primaryColor,
                                                  ),
                                                  // suffixIcon: Icon(
                                                  //   Icons.close,
                                                  //   size: 17,
                                                  //   color: CustomColors.hintText,
                                                  // ),
                                                  hintText: "16 Digit Card Number",
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
                                            SizedBox(
                                              width: MediaQuery.of(context).size.width,
                                              child: Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: [
                                                  SizedBox(
                                                    height: 50,
                                                    width: MediaQuery.of(context).size.width * .4,
                                                    // margin: const EdgeInsets.only(bottom: 15, top: 15),
                                                    child: Center(
                                                      child: DecoratedBox(
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
                                                        child: Padding(
                                                          padding: const EdgeInsets.symmetric(
                                                            horizontal: 10,
                                                            vertical: 4,
                                                          ),
                                                          child: DropdownButtonHideUnderline(
                                                            child: DropdownButton(
                                                              hint: const Text(
                                                                "Expiration Month",
                                                                style: TextStyle(
                                                                  fontSize: 16,
                                                                  fontFamily: "Rubik",
                                                                  fontWeight: FontWeight.w400,
                                                                ),
                                                              ),
                                                              isExpanded: true,
                                                              items: month!.map((item) {
                                                                return DropdownMenuItem(
                                                                  value: item['id'].toString(),
                                                                  child: Text(item['name']),
                                                                );
                                                              }).toList(),
                                                              onChanged: (newVal) {
                                                                setState(() {
                                                                  selectedMonth = newVal;
                                                                  // print(selectedMonth);
                                                                });
                                                              },
                                                              value: selectedMonth,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  const SizedBox(
                                                    width: 10,
                                                  ),
                                                  SizedBox(
                                                    width: MediaQuery.of(context).size.width * .4,
                                                    height: 50,
                                                    // margin: const EdgeInsets.only(bottom: 15, top: 15),
                                                    child: Center(
                                                      child: DecoratedBox(
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
                                                        child: Padding(
                                                          padding: const EdgeInsets.symmetric(
                                                            horizontal: 10,
                                                            vertical: 4,
                                                          ),
                                                          child: DropdownButtonHideUnderline(
                                                            child: DropdownButton(
                                                              hint: const Text(
                                                                "Expiration Year",
                                                                style: TextStyle(
                                                                  fontSize: 16,
                                                                  fontFamily: "Rubik",
                                                                  fontWeight: FontWeight.w400,
                                                                ),
                                                              ),
                                                              isExpanded: true,
                                                              items: year!.map((item) {
                                                                return DropdownMenuItem(
                                                                  value: item['id'].toString(),
                                                                  child: Text(item['name']),
                                                                );
                                                              }).toList(),
                                                              onChanged: (newVal) {
                                                                setState(() {
                                                                  selectedYear = newVal;

                                                                  // print(selectedYear);
                                                                });

                                                                // print(selectedYear);
                                                              },
                                                              value: selectedYear,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ],
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
                                                keyboardType: TextInputType.number,
                                                controller: cvvController,
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
                                                  hintText: "CVV/CVC",
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
                                                if (nameOncardController.text.isEmpty) {
                                                  customErrorSnackBar(
                                                    context,
                                                    "Please Enter Name",
                                                  );
                                                } else if (cardNumberController.text.isEmpty) {
                                                  customErrorSnackBar(
                                                    context,
                                                    "Please Enter Card Number",
                                                  );
                                                } else if (selectedMonth == null) {
                                                  customErrorSnackBar(
                                                    context,
                                                    "Please Select Month",
                                                  );
                                                } else if (selectedYear == null) {
                                                  customErrorSnackBar(
                                                    context,
                                                    "Please Select Year",
                                                  );
                                                } else if (cvvController.text.isEmpty) {
                                                  customErrorSnackBar(
                                                    context,
                                                    "Please Enter CVV",
                                                  );
                                                } else {
                                                  if (cardKey.currentState!.validate()) {
                                                    // var request = AddCardModel(
                                                    //   nameOnCard: nameOncardController.text.toString(),
                                                    //   cardNumber: cardNumberController.text.toString(),
                                                    //   cardExpirationMonth: selectedMonth.toString(),
                                                    //   cardExpirationYear: selectedYear.toString(),
                                                    //   cvv: cvvController.text.toString(),
                                                    // );
                                                    postAddCard();
                                                    // .then(
                                                    //   (response) async {
                                                    //     print(jsonDecode(response.body));
                                                    //   },
                                                    // );
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
                                                    "Add Card",
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
                        "Add New Card",
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
                        "Name on Card",
                        style: TextStyle(
                          color: CustomColors.black,
                          fontSize: 12,
                          fontFamily: "Poppins",
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        "Card Number",
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

                FutureBuilder<CreditCardModel>(
                  future: futureManageCards,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return ListView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: snapshot.data?.creditCards?.length,
                        itemBuilder: (BuildContext context, int index) {
                          return GestureDetector(
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
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        children: [
                                          Container(
                                            width: MediaQuery.of(context).size.width * .4,
                                            alignment: Alignment.topLeft,
                                            child: Text(
                                              snapshot.data!.creditCards![index].nameOnCard.toString(),
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
                                          snapshot.data!.creditCards![index].cardNumber.toString(),
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
                                                        width: MediaQuery.of(context).size.width * .3,
                                                        alignment: Alignment.center,
                                                        child: Text(
                                                          "Expiry Month",
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
                                                        width: MediaQuery.of(context).size.width * .3,
                                                        alignment: Alignment.center,
                                                        child: Text(
                                                          snapshot.data!.creditCards![index].cardExpirationMonth.toString(),
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
                                                        width: MediaQuery.of(context).size.width * .3,
                                                        alignment: Alignment.center,
                                                        child: Text(
                                                          "Expiry Year",
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
                                                        width: MediaQuery.of(context).size.width * .3,
                                                        alignment: Alignment.center,
                                                        child: Text(
                                                          snapshot.data!.creditCards![index].cardExpirationYear.toString(),
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
                                                        width: MediaQuery.of(context).size.width * .3,
                                                        alignment: Alignment.center,
                                                        child: Text(
                                                          "CVV",
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
                                                        width: MediaQuery.of(context).size.width * .3,
                                                        alignment: Alignment.center,
                                                        child: Text(
                                                          snapshot.data!.creditCards![index].cvv.toString(),
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
                                                ],
                                              ),
                                            ],
                                          ),
                                        )
                                      : Container(),
                                ],
                              ),
                            ),
                          );
                        },
                      );
                    } else {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
