// ignore_for_file: unnecessary_null_comparison, use_build_context_synchronously

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:island_app/carereceiver/models/manage_cards_model.dart';
import 'package:island_app/carereceiver/screens/manage_cards.dart';
import 'package:island_app/carereceiver/utils/colors.dart';
import 'package:island_app/providers/subscription_provider.dart';
import 'package:island_app/providers/user_provider.dart';
import 'package:island_app/utils/app_colors.dart';
import 'package:island_app/utils/app_url.dart';
import 'package:island_app/utils/functions.dart';
import 'package:island_app/utils/http_handlers.dart';
import 'package:island_app/utils/navigation_service.dart';
import 'package:island_app/utils/routes_name.dart';
import 'package:island_app/widgets/loading_button.dart';
import 'package:provider/provider.dart';

class PackagePaymentScreen extends StatefulWidget {
  const PackagePaymentScreen({super.key});

  @override
  State<PackagePaymentScreen> createState() => _PackagePaymentScreenState();
}

class _PackagePaymentScreenState extends State<PackagePaymentScreen> {
  @override
  void initState() {
    super.initState();
  }

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Consumer2<SubscriptionProvider, RecieverUserProvider>(
      builder: (context, subscriptionProvider, recieverUserProvider, __) {
        return Scaffold(
          key: scaffoldKey,
          appBar: AppBar(
            elevation: 0,
            backgroundColor: CustomColors.primaryColor,
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
            title: const Text(
              "Subscribtion Center",
              style: TextStyle(
                fontSize: 19,
                fontWeight: FontWeight.w600,
                fontFamily: "Rubik",
                color: Colors.white,
              ),
            ),
          ),
          body: SafeArea(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12.0),
                child: Column(
                  children: [
                    const SizedBox(height: 20),

                    Container(
                      alignment: Alignment.center,
                      child: Text(
                        "Get recruitment pro perks - Subscribe monthly for flexibility or annually to maximize savings.",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: CustomColors.primaryText,
                          fontSize: 16,
                          fontFamily: "Rubik",
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    const SizedBox(height: 30),
                    // Package Card Basic

                    for (int i = 0; i < subscriptionProvider.allPackages.length; i++) ...[
                      if (recieverUserProvider.gWAUserProfile != null && recieverUserProvider.gWAUserProfile!.data != null && recieverUserProvider.gWAUserProfile!.data!.userSubscriptionDetail != null && recieverUserProvider.gWAUserProfile!.data!.userSubscriptionDetail!.subscriptionId.toString() == subscriptionProvider.allPackages[i]['id'].toString() && recieverUserProvider.gWAUserProfile!.data!.userSubscriptionDetail!.isActive == 1) ...[
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topRight,
                              end: Alignment.bottomLeft,
                              colors: [
                                CustomColors.primaryColor,
                                const Color(0xff6BD294).withOpacity(0.8),
                              ],
                            ),
                            boxShadow: const [
                              BoxShadow(
                                color: Color.fromARGB(25, 0, 0, 0),
                                blurRadius: 4.0,
                                spreadRadius: 2.0,
                                offset: Offset(2.0, 2.0),
                              )
                            ],
                            borderRadius: const BorderRadius.only(
                              bottomLeft: Radius.circular(10),
                              bottomRight: Radius.circular(10),
                              topLeft: Radius.circular(10),
                              topRight: Radius.circular(10),
                            ),
                          ),
                          width: MediaQuery.of(context).size.width > 320 ? 320 : MediaQuery.of(context).size.width,
                          height: 170,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                subscriptionProvider.allPackages[i]['subscription_name'],
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w400,
                                  fontFamily: "Poppins",
                                  color: CustomColors.white,
                                ),
                              ),
                              const SizedBox(height: 10),
                              if (subscriptionProvider.allPackages[i]['price'] != null) ...[
                                Text(
                                  "\$ ${subscriptionProvider.allPackages[i]['price']}",
                                  style: TextStyle(
                                    fontSize: 26,
                                    fontWeight: FontWeight.w500,
                                    fontFamily: "Poppins",
                                    color: CustomColors.white,
                                  ),
                                ),
                              ],
                              const SizedBox(height: 05),
                              TextButton(
                                onPressed: () async {
                                  if (recieverUserProvider.gWAUserProfile?.data?.userSubscriptionDetail?.subscriptionId != null) {
                                    showDialog(
                                      context: context,
                                      builder: (context) => AlertDialog(
                                        content: const SizedBox(
                                          width: 300,
                                          height: 120,
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              Icon(
                                                Icons.info_outline_rounded,
                                                size: 56,
                                                color: Color(0xFFffc700),
                                              ),
                                              Text(
                                                "Confirm Unsubscribe",
                                                style: TextStyle(color: Colors.red),
                                              ),
                                              Text(
                                                "Please make sure this action is irreversible",
                                                textAlign: TextAlign.center,
                                                style: TextStyle(color: Colors.red),
                                              ),
                                            ],
                                          ),
                                        ),
                                        actionsAlignment: MainAxisAlignment.center,
                                        actionsOverflowAlignment: OverflowBarAlignment.center,
                                        alignment: Alignment.center,
                                        actions: [
                                          LoadingButton(
                                            title: "Yes, unsubscribe please!",
                                            backgroundColor: Colors.blue,
                                            height: 54,
                                            onPressed: () async {
                                              try {
                                                var resp = await Provider.of<SubscriptionProvider>(context, listen: false).unSubscribe(recieverUserProvider.gWAUserProfile?.data?.userSubscriptionDetail?.id);
                                                if (resp.statusCode == 200 && resp.data['success']) {
                                                  Provider.of<RecieverUserProvider>(context, listen: false).fetchProfileReceiverModel();

                                                  Provider.of<SubscriptionProvider>(context, listen: false).getPackages();
                                                  Navigator.pop(context);
                                                  showSuccessToast(resp.data['message'].toString());
                                                } else {
                                                  throw "something went wrong please try again later";
                                                }
                                                return true;
                                              } catch (e) {
                                                Navigator.pop(context);
                                                showErrorToast(e.toString());
                                                return false;
                                              }
                                            },
                                          ),
                                          TextButton(
                                            onPressed: () {
                                              Navigator.pop(context);
                                            },
                                            style: ButtonStyle(backgroundColor: WidgetStateProperty.resolveWith((states) => Colors.red.shade400), shape: WidgetStatePropertyAll(RoundedRectangleBorder(borderRadius: BorderRadius.circular(08)))),
                                            child: const Text(
                                              "No, cancel please!",
                                              style: TextStyle(color: Colors.white),
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  }
                                },
                                style: ButtonStyle(
                                  maximumSize: WidgetStateProperty.resolveWith((states) => const Size(250, 80)),
                                  padding: WidgetStateProperty.resolveWith(
                                    (states) => const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                                  ),
                                  backgroundColor: WidgetStateProperty.resolveWith(
                                    (states) => Colors.red,
                                  ),
                                ),
                                child: const Text(
                                  "UnSubscribe",
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ] else ...[
                        InkWell(
                          onTap: () {
                            Provider.of<SubscriptionProvider>(context, listen: false).setSelectedPackage(subscriptionProvider.allPackages[i]);
                            navigationService.push(
                              RoutesName.recieverPaymentScreen,
                              arguments: {"subsId": subscriptionProvider.allPackages[i]['id'].toString()},
                            );
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            decoration: BoxDecoration(
                                color: CustomColors.primaryColor,
                                // gradient: LinearGradient(
                                //   begin: Alignment.topLeft,
                                //   end: Alignment.bottomRight,
                                //   colors: [
                                //     const Color(0xff55CE86),
                                //     const Color(0xff6BD294).withOpacity(0.5),
                                //   ],
                                // ),
                                boxShadow: const [BoxShadow(color: Color.fromARGB(25, 0, 0, 0), blurRadius: 4.0, spreadRadius: 2.0, offset: Offset(2.0, 2.0))],
                                borderRadius: const BorderRadius.only(bottomLeft: Radius.circular(10), bottomRight: Radius.circular(10), topLeft: Radius.circular(10), topRight: Radius.circular(10))),
                            width: MediaQuery.of(context).size.width * .90,
                            height: 165,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  subscriptionProvider.allPackages[i]['subscription_name'],
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w400,
                                    fontFamily: "Poppins",
                                    color: CustomColors.white,
                                  ),
                                ),
                                const SizedBox(height: 12),
                                Text(
                                  "\$ ${subscriptionProvider.allPackages[i]['price']}",
                                  style: TextStyle(
                                    fontSize: 40,
                                    fontWeight: FontWeight.w500,
                                    fontFamily: "Poppins",
                                    color: CustomColors.white,
                                  ),
                                ),
                                const SizedBox(height: 12),
                                Text(
                                  "BUY ${subscriptionProvider.allPackages[i]['period_type']} SUBSCRIPTION",
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w400,
                                    fontFamily: "Poppins",
                                    color: CustomColors.white,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                      const SizedBox(height: 30),
                    ],
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class RecieverPaymentScreen extends StatefulWidget {
  final String subsId;
  const RecieverPaymentScreen({super.key, required this.subsId});

  @override
  State<RecieverPaymentScreen> createState() => _RecieverPaymentScreenState();
}

class _RecieverPaymentScreenState extends State<RecieverPaymentScreen> {
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
    return Consumer<CardProvider>(
      builder: (context, cardProvider, child) {
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
            child: RefreshIndicator(
              onRefresh: () async {},
              child: SingleChildScrollView(
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  color: Colors.white,
                  padding: const EdgeInsets.only(top: 20),
                  child: Column(
                    children: [
                      if (cardProvider.allCards != null && cardProvider.allCards!.isNotEmpty) ...[
                        for (int j = 0; j < cardProvider.allCards!.length; j++) ...[
                          InkWell(
                            onTap: () {
                              setState(() {
                                newCard = false;
                                selectedCard = cardProvider.allCards![j];
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
                                    color: selectedCard != null && selectedCard!.id == cardProvider.allCards![j].id ? ServiceRecieverColor.primaryColor : ServiceRecieverColor.redButton,
                                    width: 0.5,
                                  ),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      "Card Name: ${cardProvider.allCards![j].nameOnCard}",
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 1,
                                      style: const TextStyle(color: Colors.black),
                                    ),
                                    Text(
                                      "Card Number: ${cardProvider.allCards![j].cardNumber}",
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
          ),
        );
      },
    );
  }

  bool sendReq = false;
  dynamic cardFormWidget(BuildContext context) {
    Map selectedSubscribe = Provider.of<SubscriptionProvider>(context).selectedPackage;
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
                      child: Text(
                        selectedCard!.cvv.toString(),
                      ),
                    ),
                    const SizedBox(height: 15),
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
                          "\$ ${selectedSubscribe['price']}",
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
                    // BTN
                    LoadingButton(
                      title: "Subscribe",
                      height: 60,
                      backgroundColor: ServiceRecieverColor.redButton,
                      textStyle: TextStyle(
                        color: CustomColors.white,
                        fontFamily: "Poppins",
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                      onPressed: () async {
                        try {
                          var token = await getToken();
                          var response = await postRequesthandler(
                            url: CareReceiverURl.serviceReceiverSubscribePackage,
                            formData: FormData.fromMap({
                              "subscription_id": selectedSubscribe['id'],
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

                          if (response != null && response.statusCode == 200 && response.data['success']) {
                            Provider.of<RecieverUserProvider>(context, listen: false).fetchProfileReceiverModel();
                            Provider.of<SubscriptionProvider>(context, listen: false).getPackages();

                            showSuccessToast(response.data['message']);
                            Navigator.pop(context);
                          } else {
                            if (response != null && response.data != null && response.data["message"] != null) {
                              showErrorToast(response.data['message']);
                            } else {
                              showErrorToast("something went wrong");
                            }
                          }
                        } catch (e) {
                          showErrorToast(e.toString());
                        }
                        return false;
                      },
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
    Map selectedSubscribe = Provider.of<SubscriptionProvider>(context).selectedPackage;
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
                  "\$ ${selectedSubscribe['price']}",
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
            LoadingButton(
              title: "Subscribe",
              height: 60,
              backgroundColor: ServiceRecieverColor.redButton,
              textStyle: TextStyle(
                color: CustomColors.white,
                fontFamily: "Poppins",
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
              onPressed: () async {
                if (newPaymentForm.currentState!.validate()) {
                  try {
                    var token = await getToken();
                    var response = await postRequesthandler(
                      url: CareReceiverURl.serviceReceiverSubscribePackage,
                      formData: FormData.fromMap({
                        "subscription_id": selectedSubscribe['id'],
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

                    if (response != null && response.statusCode == 200 && response.data['success']) {
                      Provider.of<RecieverUserProvider>(context, listen: false).fetchProfileReceiverModel();
                      Provider.of<SubscriptionProvider>(context, listen: false).getPackages();
                      await Provider.of<CardProvider>(context, listen: false).fetchManageCardsModel(notify: true);
                      showSuccessToast(response.data['message']);
                      Navigator.pop(context);
                    } else {
                      if (response != null && response.data != null && response.data["message"] != null) {
                        throw response.data['message'];
                      } else {
                        throw "something went wrong";
                      }
                    }
                  } catch (e) {
                    showErrorToast(e.toString());
                  }
                }
                return false;
              },
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
