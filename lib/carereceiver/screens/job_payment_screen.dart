// ignore_for_file: use_build_context_synchronously

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:island_app/carereceiver/models/manage_cards_model.dart';
import 'package:island_app/carereceiver/screens/job_applicant_detail.dart';
import 'package:island_app/carereceiver/screens/manage_cards.dart';
import 'package:island_app/carereceiver/utils/colors.dart';
import 'package:island_app/providers/user_provider.dart';
import 'package:island_app/res/app_url.dart';
import 'package:island_app/utils/utils.dart';
import 'package:provider/provider.dart';

class JobPaymentsScreen extends StatefulWidget {
  final String jobId;
  final String jobName;
  final String amount;
  const JobPaymentsScreen({super.key, required this.jobId, required this.jobName, required this.amount});

  @override
  State<JobPaymentsScreen> createState() => _JobPaymentsScreenState();
}

class _JobPaymentsScreenState extends State<JobPaymentsScreen> {
  final paymentForm = GlobalKey<FormState>();

  CreditCard? selectedCard;

  final newPaymentForm = GlobalKey<FormState>();
  bool newCard = false;

  TextEditingController cardHolderNameController = TextEditingController();
  TextEditingController cardNumberController = TextEditingController();
  TextEditingController cardExpiryDateController = TextEditingController();
  TextEditingController cardCvvController = TextEditingController();
  TextEditingController zipCodeController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    // print(RecieverUserProvider.userToken);
    // print(widget.jobId);
    List<CreditCard>? allCards = context.watch<CardProvider>().allCards;
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
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
                color: CustomColors.white,
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
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            width: MediaQuery.of(context).size.width,
            color: Colors.white,
            padding: const EdgeInsets.only(top: 20),
            child: Column(
              children: [
                if (allCards != null) ...[
                  for (int j = 0; j < allCards.length; j++) ...[
                    InkWell(
                      onTap: () {
                        setState(() {
                          newCard = false;
                          selectedCard = allCards[j];
                        });
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(left: 12, right: 12, bottom: 12),
                        child: Container(
                          width: MediaQuery.of(context).size.width,
                          height: 60,
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: selectedCard != null && selectedCard!.id == allCards[j].id ? ServiceRecieverColor.primaryColor : ServiceRecieverColor.redButton,
                              width: 0.5,
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Card Name: ${allCards[j].nameOnCard}",
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                                style: const TextStyle(color: Colors.black),
                              ),
                              Text(
                                "Card Number: ${allCards[j].cardNumber}",
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                                style: const TextStyle(color: Colors.black),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                  if (selectedCard != null) ...[
                    cardFormWidget(context),
                  ],
                ],
                InkWell(
                  onTap: () {
                    setState(() {
                      newCard = true;
                      selectedCard = null;
                    });
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(left: 12, right: 12, bottom: 12),
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      height: 60,
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: ServiceRecieverColor.redButton,
                          width: 0.5,
                        ),
                      ),
                      child: const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Add New Card",
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                            style: TextStyle(color: Colors.black),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                if (newCard) ...[
                  newCardForm(),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  bool sendReq = false;
  dynamic cardFormWidget(BuildContext context) {
    return selectedCard != null
        ? Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(23.0),
                child: Column(
                  children: [
                    // Card Holder Name
                    Container(
                      alignment: Alignment.topLeft,
                      child: Text(
                        "Card Holder Name",
                        style: TextStyle(
                          color: CustomColors.primaryColor,
                          fontFamily: "Rubik",
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                    const SizedBox(height: 5),
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
                      alignment: Alignment.centerLeft,
                      padding: const EdgeInsets.only(left: 10),
                      width: MediaQuery.of(context).size.width,
                      height: 40,
                      child: Text(
                        selectedCard!.nameOnCard.toString(),
                      ),
                    ),
                    const SizedBox(height: 15),
                    // Card Number
                    Container(
                      alignment: Alignment.topLeft,
                      child: Text(
                        "Card Number",
                        style: TextStyle(
                          color: CustomColors.primaryColor,
                          fontFamily: "Rubik",
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                    const SizedBox(height: 5),
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
                      alignment: Alignment.centerLeft,
                      padding: const EdgeInsets.only(left: 10),
                      width: MediaQuery.of(context).size.width,
                      height: 40,
                      child: Text(
                        selectedCard!.cardNumber.toString(),
                      ),
                    ),
                    const SizedBox(height: 15),
                    // Card Expiry Date
                    Container(
                      alignment: Alignment.topLeft,
                      child: Text(
                        "Expiry Date",
                        style: TextStyle(
                          color: CustomColors.primaryColor,
                          fontFamily: "Rubik",
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                    const SizedBox(height: 5),
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
                      alignment: Alignment.centerLeft,
                      padding: const EdgeInsets.only(left: 10),
                      width: MediaQuery.of(context).size.width,
                      height: 40,
                      child: Text("${selectedCard!.cardExpirationMonth}-${selectedCard!.cardExpirationYear}"),
                    ),
                    const SizedBox(height: 15),
                    // Card CVV
                    Container(
                      alignment: Alignment.topLeft,
                      child: Text(
                        "CVV",
                        style: TextStyle(
                          color: CustomColors.primaryColor,
                          fontFamily: "Rubik",
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                    const SizedBox(height: 5),
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
                      alignment: Alignment.centerLeft,
                      padding: const EdgeInsets.only(left: 10),
                      width: MediaQuery.of(context).size.width,
                      height: 40,
                      child: Text("${selectedCard!.cvv}"),
                    ),
                    const SizedBox(height: 15),
                    // Total Amount Row
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Total Amount:",
                          style: TextStyle(
                            color: CustomColors.amount,
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            fontFamily: "Rubik",
                          ),
                        ),
                        Text(
                          "${widget.amount}\$",
                          style: TextStyle(
                            color: CustomColors.primaryText,
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            fontFamily: "Rubik",
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 25),
                    // Submit Button
                    GestureDetector(
                      onTap: !sendReq
                          ? () async {
                              setState(() {
                                sendReq = true;
                              });
                              try {
                                var token = RecieverUserProvider.userToken;
                                var response = await Dio().post(
                                  "${AppUrl.webBaseURL}/charge-card",
                                  data: {
                                    "job_id": widget.jobId,
                                    "card_data": selectedCard!.id.toString(),
                                    "save_card": false,
                                    "name_on_card": selectedCard!.nameOnCard.toString(),
                                    "card_number": selectedCard!.cardNumber.toString(),
                                    "card_expiration_month": selectedCard!.cardExpirationMonth.toString(),
                                    "card_expiration_year": selectedCard!.cardExpirationYear.toString(),
                                    "cvv": selectedCard!.cvv.toString(),
                                    "save": false,
                                  },
                                  options: Options(
                                    headers: {
                                      'Authorization': 'Bearer $token',
                                      'Accept': 'application/json',
                                    },
                                  ),
                                );
                                print(response.data);
                                if (response.statusCode == 200 && response.data['message'].toString().contains("Amount Funded Successfully")) {
                                  customSuccesSnackBar(context, response.data['message']);

                                  Navigator.pop(context);
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => JobApplicantsDetail(jobId: widget.jobId, name: widget.jobName),
                                    ),
                                  );
                                } else {
                                  throw response.data['message'];
                                }
                              } catch (e) {
                                customErrorSnackBar(context, e.toString());
                              }
                              setState(() {
                                sendReq = false;
                              });
                            }
                          : null,
                      child: !sendReq
                          ? Container(
                              height: 60,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: ServiceRecieverColor.redButton,
                              ),
                              child: Center(
                                child: Text(
                                  "Pay Now",
                                  style: TextStyle(
                                    color: CustomColors.white,
                                    fontFamily: "Poppins",
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            )
                          : const Center(
                              child: CircularProgressIndicator(color: Colors.green),
                            ),
                    ),
                  ],
                ),
              ),
            ],
          )
        : Container();
  }

  final RegExp _dateRegex = RegExp(r'^(0[1-9]|1[0-2])-\d{4}$');
  bool saveFrom = false;
  Form newCardForm() {
    return Form(
      key: newPaymentForm,
      child: Padding(
        padding: const EdgeInsets.all(23.0),
        child: Column(
          children: [
            // Card Holder Name
            Container(
              alignment: Alignment.topLeft,
              child: Text(
                "Card Holder Name",
                style: TextStyle(
                  color: CustomColors.primaryColor,
                  fontFamily: "Rubik",
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
            const SizedBox(height: 5),
            Container(
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(6),
                  bottomLeft: Radius.circular(6),
                  bottomRight: Radius.circular(6),
                  topRight: Radius.circular(6),
                ),
                color: CustomColors.white,
              ),
              alignment: Alignment.center,
              width: MediaQuery.of(context).size.width,
              // height: 40,
              child: TextFormField(
                controller: cardHolderNameController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Please Enter Card Holder Name";
                  }
                  return null;
                },
                textInputAction: TextInputAction.next,
                style: const TextStyle(
                  fontSize: 14,
                  fontFamily: "Rubik",
                  fontWeight: FontWeight.w400,
                ),
                textAlignVertical: TextAlignVertical.bottom,
                maxLines: 1,
                decoration: InputDecoration(
                  hintText: "Name",
                  fillColor: CustomColors.white,
                  focusColor: CustomColors.white,
                  hoverColor: CustomColors.white,
                  hintStyle: TextStyle(
                    color: CustomColors.paymentHint,
                    fontFamily: "Poppins",
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                  ),
                  filled: true,
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: ServiceRecieverColor.primaryColor, width: 0.7),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: ServiceRecieverColor.primaryColor, width: 0.7),
                    borderRadius: BorderRadius.circular(4.0),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: ServiceRecieverColor.primaryColor, width: 0.7),
                    borderRadius: BorderRadius.circular(4.0),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10),
            // Card Number
            Container(
              alignment: Alignment.topLeft,
              child: Text(
                "Card Number",
                style: TextStyle(
                  color: ServiceRecieverColor.primaryColor,
                  fontFamily: "Rubik",
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
            const SizedBox(height: 5),
            Container(
              padding: EdgeInsets.zero,
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(6),
                  bottomLeft: Radius.circular(6),
                  bottomRight: Radius.circular(6),
                  topRight: Radius.circular(6),
                ),
                color: CustomColors.white,
              ),
              alignment: Alignment.center,
              width: MediaQuery.of(context).size.width,
              child: TextFormField(
                controller: cardNumberController,
                textInputAction: TextInputAction.next,
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter(RegExp('[0-9]'), allow: true),
                  LengthLimitingTextInputFormatter(16),
                ],
                validator: (value) {
                  if (value == null) {
                    return "Please Enter Card Number";
                  } else if (value.length != 16) {
                    return "Please Enter Correct Card Number";
                  }
                  return null;
                },
                style: const TextStyle(
                  fontSize: 14,
                  fontFamily: "Rubik",
                  fontWeight: FontWeight.w400,
                ),
                textAlignVertical: TextAlignVertical.bottom,
                maxLines: 1,
                decoration: InputDecoration(
                  hintText: "XXXXXX-XXXXXX-X",
                  fillColor: CustomColors.white,
                  focusColor: CustomColors.white,
                  hoverColor: CustomColors.white,
                  hintStyle: TextStyle(
                    color: CustomColors.paymentHint,
                    fontFamily: "Poppins",
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                  ),
                  filled: true,
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: ServiceRecieverColor.primaryColor, width: 0.7),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: ServiceRecieverColor.primaryColor, width: 0.7),
                    borderRadius: BorderRadius.circular(4.0),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: ServiceRecieverColor.primaryColor, width: 0.7),
                    borderRadius: BorderRadius.circular(4.0),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10),
            // Card Expiry Date
            Container(
              alignment: Alignment.topLeft,
              child: Text(
                "Expiry Date",
                style: TextStyle(
                  color: CustomColors.primaryColor,
                  fontFamily: "Rubik",
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
            const SizedBox(height: 5),
            Container(
              padding: EdgeInsets.zero,
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(6),
                  bottomLeft: Radius.circular(6),
                  bottomRight: Radius.circular(6),
                  topRight: Radius.circular(6),
                ),
                color: CustomColors.white,
              ),
              alignment: Alignment.center,
              width: MediaQuery.of(context).size.width,
              // height: 40,
              child: TextFormField(
                controller: cardExpiryDateController,
                textInputAction: TextInputAction.next,
                keyboardType: TextInputType.datetime,
                textAlignVertical: TextAlignVertical.bottom,
                inputFormatters: [
                  DateTextFormatter(),
                  LengthLimitingTextInputFormatter(7),
                ],
                validator: (String? value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a date';
                  }
                  if (!_dateRegex.hasMatch(value)) {
                    // print("object");
                    return 'Invalid date format (MM-YYYY)';
                  }
                  // You can add additional validation here if needed.
                  return null;
                },
                maxLines: 1,
                style: const TextStyle(
                  fontSize: 14,
                  fontFamily: "Rubik",
                  fontWeight: FontWeight.w400,
                ),
                decoration: InputDecoration(
                  hintText: "MM-YYYY",
                  counterText: "",
                  fillColor: CustomColors.white,
                  focusColor: CustomColors.white,
                  hoverColor: CustomColors.white,
                  hintStyle: TextStyle(
                    color: CustomColors.paymentHint,
                    fontFamily: "Poppins",
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                  ),
                  filled: true,
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: ServiceRecieverColor.primaryColor, width: 0.7),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: ServiceRecieverColor.primaryColor, width: 0.7),
                    borderRadius: BorderRadius.circular(4.0),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: ServiceRecieverColor.primaryColor, width: 0.7),
                    borderRadius: BorderRadius.circular(4.0),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10),
            // Card CVV
            Container(
              alignment: Alignment.topLeft,
              child: Text(
                "CVV",
                style: TextStyle(
                  color: CustomColors.primaryColor,
                  fontFamily: "Rubik",
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
            const SizedBox(height: 5),
            Container(
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(6),
                  bottomLeft: Radius.circular(6),
                  bottomRight: Radius.circular(6),
                  topRight: Radius.circular(6),
                ),
                color: CustomColors.white,
              ),
              alignment: Alignment.center,
              width: MediaQuery.of(context).size.width,
              // height: 40,
              child: TextFormField(
                controller: cardCvvController,
                textInputAction: TextInputAction.next,
                validator: (value) {
                  if (value == null) {
                    return "Please Enter Card CVV/CVC Number";
                  } else if (value.length != 3) {
                    return "Please Enter Correct Card CVV/CVC Number Length";
                  }
                  return null;
                },
                style: const TextStyle(
                  fontSize: 14,
                  fontFamily: "Rubik",
                  fontWeight: FontWeight.w400,
                ),
                textAlignVertical: TextAlignVertical.bottom,
                maxLines: 1,
                decoration: InputDecoration(
                  hintText: "XXXX",
                  fillColor: CustomColors.white,
                  focusColor: CustomColors.white,
                  hoverColor: CustomColors.white,
                  hintStyle: TextStyle(
                    color: CustomColors.paymentHint,
                    fontFamily: "Poppins",
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                  ),
                  filled: true,
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: ServiceRecieverColor.primaryColor, width: 0.7),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: ServiceRecieverColor.primaryColor, width: 0.7),
                    borderRadius: BorderRadius.circular(4.0),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: ServiceRecieverColor.primaryColor, width: 0.7),
                    borderRadius: BorderRadius.circular(4.0),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10),
            // Save For futher
            CheckboxListTile(
              value: saveFrom,
              activeColor: ServiceRecieverColor.primaryColor,
              onChanged: (value) {
                setState(() {
                  saveFrom = !saveFrom;
                });
              },
              title: Text(
                "Save For Future Use",
                style: TextStyle(
                  color: ServiceRecieverColor.primaryColor,
                  fontFamily: "Rubik",
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                ),
              ),
              controlAffinity: ListTileControlAffinity.leading,
              contentPadding: EdgeInsets.zero,
            ),
            const SizedBox(height: 10),
            // total payment
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Total Amount:",
                  style: TextStyle(
                    color: CustomColors.amount,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    fontFamily: "Rubik",
                  ),
                ),
                Text(
                  "${widget.amount}\$",
                  style: TextStyle(
                    color: CustomColors.primaryText,
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    fontFamily: "Rubik",
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),

            // BTN
            GestureDetector(
              onTap: sendReq == true
                  ? null
                  : () async {
                      if (newPaymentForm.currentState!.validate()) {
                        setState(() {
                          sendReq = true;
                        });
                        try {
                          var token = RecieverUserProvider.userToken;
                          var response = await Dio().post(
                            "${AppUrl.webBaseURL}/charge-card",
                            data: {
                              "job_id": widget.jobId,
                              "card_data": "card-form",
                              "save_card": saveFrom,
                              "name_on_card": cardHolderNameController.text.toString(),
                              "card_number": cardNumberController.text.toString(),
                              "card_expiration_month": cardExpiryDateController.text.toString().substring(0, 2),
                              "card_expiration_year": cardExpiryDateController.text.toString().substring(3, 7),
                              "cvv": cardCvvController.text.toString(),
                            },
                            options: Options(
                              headers: {
                                'Authorization': 'Bearer $token',
                                'Accept': 'application/json',
                              },
                            ),
                          );

                          if (response.statusCode == 200 && response.data['success']) {
                            Navigator.pop(context);
                          } else {
                            throw response.data['message'];
                          }
                        } catch (e) {
                          customErrorSnackBar(context, e.toString());
                        }
                        setState(() {
                          sendReq = false;
                        });
                      }
                    },
              child: Container(
                height: 60,
                decoration: BoxDecoration(
                  color: ServiceRecieverColor.redButton,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Center(
                  child: sendReq
                      ? const CircularProgressIndicator(
                          color: Colors.white,
                        )
                      : Text(
                          "Pay Now",
                          style: TextStyle(
                            color: CustomColors.white,
                            fontFamily: "Poppins",
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class DateTextFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    //this fixes backspace bug
    if (oldValue.text.length >= newValue.text.length) {
      return newValue;
    }
    var dateText = _addSeperators(newValue.text, '-');
    return newValue.copyWith(text: dateText, selection: updateCursorPosition(dateText));
  }

  String _addSeperators(String value, String seperator) {
    value = value.replaceAll('-', '');
    var newString = '';
    for (int i = 0; i < value.length; i++) {
      newString += value[i];
      if (i == 1) {
        newString += seperator;
      }
    }

    return newString;
  }

  TextSelection updateCursorPosition(String text) {
    return TextSelection.fromPosition(TextPosition(offset: text.length));
  }
}
