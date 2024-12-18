// ignore_for_file: use_build_context_synchronously

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:island_app/carereceiver/models/manage_cards_model.dart';
import 'package:island_app/carereceiver/screens/hired_candidates_screen.dart';
import 'package:island_app/carereceiver/screens/manage_cards.dart';
import 'package:island_app/carereceiver/utils/colors.dart';
import 'package:island_app/utils/app_colors.dart';
import 'package:island_app/utils/app_url.dart';
import 'package:island_app/utils/functions.dart';
import 'package:island_app/utils/http_handlers.dart';
import 'package:island_app/utils/navigation_service.dart';
import 'package:island_app/utils/routes_name.dart';
import 'package:island_app/widgets/loading_button.dart';
import 'package:provider/provider.dart';

class RecieverTipPaymentsScreen extends StatefulWidget {
  final String jobId;
  final String providerId;
  final String comment;
  final int rating;
  const RecieverTipPaymentsScreen({
    super.key,
    required this.jobId,
    required this.providerId,
    required this.comment,
    required this.rating,
  });

  @override
  State<RecieverTipPaymentsScreen> createState() => _RecieverTipPaymentsScreenState();
}

class _RecieverTipPaymentsScreenState extends State<RecieverTipPaymentsScreen> {
  final paymentForm = GlobalKey<FormState>();

  CreditCard? selectedCard;

  final newPaymentForm = GlobalKey<FormState>();
  bool newCard = false;

  TextEditingController cardHolderNameController = TextEditingController();
  TextEditingController cardNumberController = TextEditingController();
  TextEditingController cardExpiryDateController = TextEditingController();
  TextEditingController cardCvvController = TextEditingController();
  TextEditingController zipCodeController = TextEditingController();
  TextEditingController tipAmountController = TextEditingController();

  @override
  Widget build(BuildContext context) {
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
          child: Padding(
            padding: const EdgeInsets.only(top: 20, left: 20, right: 20),
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
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        height: 60,
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: selectedCard != null && selectedCard!.id == allCards[j].id ? ServiceRecieverColor.primaryColor : ServiceRecieverColor.redButton,
                            width: selectedCard != null && selectedCard!.id == allCards[j].id ? 2 : 0.5,
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
                  ],
                  if (selectedCard != null) ...[
                    const SizedBox(height: 10),
                    SizedBox(
                      width: MediaQuery.of(context).size.width,
                      height: 50,
                      child: TextFormField(
                        controller: tipAmountController,
                        keyboardType: TextInputType.phone,
                        onChanged: (value) {},
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                        ],
                        decoration: InputDecoration(
                          hintText: "Add Tip Amount",
                          hintStyle: const TextStyle(fontWeight: FontWeight.w600),
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    // Submit Button
                    LoadingButton(
                      title: "Pay Now",
                      backgroundColor: ServiceRecieverColor.redButton,
                      height: 50,
                      loadingColor: Colors.green,
                      textStyle: TextStyle(
                        color: CustomColors.white,
                        fontFamily: "Poppins",
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                      onPressed: () async {
                        if (tipAmountController.text.isEmpty) {
                          showErrorToast("Tip amount is required");
                          return false;
                        }
                        try {
                          var token = await getToken();
                          var response = await postRequesthandler(
                            url: CareReceiverURl.serviceReceiverJobCompleted,
                            formData: FormData.fromMap({
                              "job_id": widget.jobId,
                              "tip_amount": tipAmountController.text,
                              "comment": widget.comment,
                              "rating": widget.rating,
                              "card_data": selectedCard!.id.toString(),
                              "save_card": false,
                              "name_on_card": selectedCard!.nameOnCard.toString(),
                              "card_number": selectedCard!.cardNumber.toString(),
                              "card_expiration_month": selectedCard!.cardExpirationMonth.toString(),
                              "card_expiration_year": selectedCard!.cardExpirationYear.toString(),
                              "cvv": selectedCard!.cvv.toString(),
                            }),
                            token: token,
                          );
                          if (response != null && response.statusCode == 200 && response.data['status'] == true) {
                            showSuccessToast(response.data['message']);
                            Provider.of<HiredCandidatesProvider>(context, listen: false).fetchHiredCandidateModel();
                            navigationService.pop();
                            navigationService.push(RoutesName.serviceRecieverHireCandidates);
                          } else {
                            // if (response != null && response.data['error'].toString().contains("Job Already Funded")) {
                            //   showSuccessToast("Job Already Funded");
                            // } else
                            if (response != null && response.data != null && response.data['error'] != null) {
                              throw response.data['error']['original'][0];
                            } else {
                              throw "something went wrong";
                            }
                          }
                          return true;
                        } catch (e) {
                          showErrorToast(e.toString());
                          return false;
                        }
                      },
                    ),
                  ],
                ],
                const SizedBox(height: 10),
                InkWell(
                  onTap: () {
                    setState(() {
                      newCard = true;
                      selectedCard = null;
                    });
                  },
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    height: 60,
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: newCard == true ? ServiceRecieverColor.primaryColor : ServiceRecieverColor.redButton,
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

  // bool sendReq = false;

  final RegExp _dateRegex = RegExp(r'^(0[1-9]|1[0-2])-\d{4}$');
  bool saveFrom = false;
  Form newCardForm() {
    return Form(
      key: newPaymentForm,
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
          Container(
            alignment: Alignment.topLeft,
            child: Text(
              "Tip Amount",
              style: TextStyle(
                color: CustomColors.primaryColor,
                fontFamily: "Rubik",
                fontSize: 14,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
          const SizedBox(height: 5),
          SizedBox(
            width: MediaQuery.of(context).size.width,
            height: 60,
            // padding: const EdgeInsets.symmetric(horizontal: 15),
            child: TextFormField(
              controller: tipAmountController,
              keyboardType: TextInputType.phone,
              onChanged: (value) {},
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
              ],
              decoration: InputDecoration(
                hintText: "Add Tip Amount",
                hintStyle: TextStyle(
                  color: CustomColors.paymentHint,
                  fontFamily: "Poppins",
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                ),
                border: OutlineInputBorder(
                  borderSide: BorderSide(color: ServiceRecieverColor.primaryColor),
                  borderRadius: BorderRadius.circular(05),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: ServiceRecieverColor.primaryColor),
                  borderRadius: BorderRadius.circular(05),
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),
          // BTN
          LoadingButton(
            title: "Pay Now",
            backgroundColor: ServiceRecieverColor.redButton,
            height: 60,
            loadingColor: Colors.white,
            textStyle: TextStyle(
              color: CustomColors.white,
              fontFamily: "Poppins",
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
            onPressed: () async {
              if (newPaymentForm.currentState!.validate()) {
                if (tipAmountController.text.isEmpty) {
                  showErrorToast("Tip amount is required");
                  return false;
                }
                try {
                  var token = await getToken();
                  var response = await postRequesthandler(
                    url: CareReceiverURl.serviceReceiverJobCompleted,
                    formData: FormData.fromMap({
                      "job_id": widget.jobId,
                      "tip_amount": tipAmountController.text,
                      "comment": widget.comment,
                      "rating": widget.rating,
                      "card_data": "card-form",
                      "save_card": saveFrom,
                      "name_on_card": cardHolderNameController.text.toString(),
                      "card_number": cardNumberController.text.toString(),
                      "card_expiration_month": cardExpiryDateController.text.toString().substring(0, 2),
                      "card_expiration_year": cardExpiryDateController.text.toString().substring(3, 7),
                      "cvv": cardCvvController.text.toString(),
                    }),
                    token: token,
                  );

                  if (response != null && response.statusCode == 200 && response.data['status'] == true) {
                    showSuccessToast(response.data['message']);
                    Provider.of<HiredCandidatesProvider>(context, listen: false).fetchHiredCandidateModel();
                    navigationService.pop();
                    navigationService.push(RoutesName.serviceRecieverHireCandidates);
                  } else {
                    // if (response != null && response.data != null && response.data["error"] != null ) {
                    //   showSuccessToast("Job Already Funded");
                    // } else
                    if (response != null && response.data != null && response.data['error'] != null) {
                      throw response.data['error'];
                    } else {
                      throw "something went wrong";
                    }
                  }
                  return true;
                } catch (e) {
                  showErrorToast(e.toString());
                  return false;
                }
              }
              return true;
            },
          ),
        ],
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
