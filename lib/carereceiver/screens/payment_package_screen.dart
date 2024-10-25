// ignore_for_file: unnecessary_null_comparison, use_build_context_synchronously

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:island_app/carereceiver/models/manage_cards_model.dart';
import 'package:island_app/carereceiver/models/profile_model.dart';
import 'package:island_app/carereceiver/screens/manage_cards.dart';
import 'package:island_app/carereceiver/utils/colors.dart';
import 'package:island_app/providers/subscription_provider.dart';
import 'package:island_app/providers/user_provider.dart';
import 'package:island_app/utils/app_colors.dart';
import 'package:island_app/utils/app_url.dart';
import 'package:island_app/utils/functions.dart';
import 'package:island_app/utils/http_handlers.dart';
import 'package:island_app/widgets/loading_button.dart';
import 'package:provider/provider.dart';

class PaymentPackageScreen extends StatefulWidget {
  const PaymentPackageScreen({super.key});

  @override
  State<PaymentPackageScreen> createState() => _PaymentPackageScreenState();
}

class _PaymentPackageScreenState extends State<PaymentPackageScreen> {
  @override
  void initState() {
    callInInit();
    super.initState();
  }

  callInInit() {
    // var firstcard = Provider.of<CardProvider>(context, listen: false).gWAallCards.first;
    // Provider.of<SubscriptionProvider>(context, listen: false).setSelectCardOnInit(firstcard);
  }

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    List allpackages = context.watch<SubscriptionProvider>().allPackages;
    ProfileReceiverModel? user = context.watch<RecieverUserProvider>().gWAUserProfile;
    UserSubscriptionDetail? userSubsDetail = user!.data!.userSubscriptionDetail;
    // print(MediaQuery.of(context).size.width * .90);
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
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
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            child: Column(
              children: [
                const SizedBox(height: 20),
                // Container(
                //   alignment: Alignment.center,
                //   child: Text(
                //     "Hire with Premium",
                //     style: TextStyle(
                //       color: CustomColors.primaryText,
                //       fontSize: 22,
                //       fontFamily: "Rubik",
                //       fontWeight: FontWeight.w500,
                //     ),
                //   ),
                // ),
                // const SizedBox(height: 5),
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

                for (int i = 0; i < allpackages.length; i++) ...[
                  if (userSubsDetail != null && userSubsDetail.subscriptionId.toString() == allpackages[i]['id'].toString() && userSubsDetail.isActive == 1) ...[
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.center,
                            end: Alignment.center,
                            colors: [const Color(0xff90EAB4).withOpacity(0.1), const Color(0xff6BD294).withOpacity(0.8)],
                          ),
                          boxShadow: const [BoxShadow(color: Color.fromARGB(25, 0, 0, 0), blurRadius: 4.0, spreadRadius: 2.0, offset: Offset(2.0, 2.0))],
                          borderRadius: const BorderRadius.only(bottomLeft: Radius.circular(10), bottomRight: Radius.circular(10), topLeft: Radius.circular(10), topRight: Radius.circular(10))),
                      width: MediaQuery.of(context).size.width > 320 ? 320 : MediaQuery.of(context).size.width,
                      height: 170,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            allpackages[i]['subscription_name'],
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w400,
                              fontFamily: "Poppins",
                              color: CustomColors.white,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            "\$ ${allpackages[i]['price']}",
                            style: TextStyle(
                              fontSize: 26,
                              fontWeight: FontWeight.w500,
                              fontFamily: "Poppins",
                              color: CustomColors.white,
                            ),
                          ),
                          // const SizedBox(height: 10),
                          // Text(
                          //   allpackages[i]['period_type'],
                          //   style: TextStyle(
                          //     fontSize: 14,
                          //     fontWeight: FontWeight.w400,
                          //     fontFamily: "Poppins",
                          //     color: CustomColors.white,
                          //   ),
                          // ),
                          const SizedBox(height: 05),
                          TextButton(
                            onPressed: () async {
                              if (userSubsDetail.subscriptionId != null) {
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
                                        onPressed: () async {
                                          try {
                                            var resp = await Provider.of<SubscriptionProvider>(context, listen: false).unSubscribe(userSubsDetail.id);
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
                                            // print(e);
                                            Navigator.pop(context);
                                            showErrorToast(e.toString());
                                            return false;
                                          }
                                        },
                                      ),
                                      // TextButton(
                                      //   onPressed: () async {
                                      //     try {
                                      //       var resp = await Provider.of<SubscriptionProvider>(context, listen: false).unSubscribe(userSubsDetail.id);
                                      //       if (resp.statusCode == 200 && resp.data['success']) {
                                      //         Provider.of<RecieverUserProvider>(context, listen: false).fetchProfileReceiverModel();

                                      //         Provider.of<SubscriptionProvider>(context, listen: false).getPackages();
                                      //         Navigator.pop(context);
                                      //         showSuccessToast(resp.data['message'].toString());
                                      //       } else {
                                      //         throw "something went wrong please try again later";
                                      //       }
                                      //     } catch (e) {
                                      //       // print(e);
                                      //       Navigator.pop(context);
                                      //       showErrorToast(e.toString());
                                      //     }
                                      //   },
                                      //   style: ButtonStyle(
                                      //     backgroundColor: WidgetStateProperty.resolveWith((states) => Colors.blue),
                                      //   ),
                                      //   child: const Text(
                                      //     "Yes, unsubscribe please!",
                                      //     style: TextStyle(color: Colors.white),
                                      //   ),
                                      // ),
                                      TextButton(
                                        onPressed: () {
                                          // print("object");
                                          Navigator.pop(context);
                                        },
                                        style: ButtonStyle(
                                          backgroundColor: WidgetStateProperty.resolveWith((states) => Colors.red.shade400),
                                        ),
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
                        Provider.of<SubscriptionProvider>(context, listen: false).setSelectedPackage(allpackages[i]);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => PaymentsFormScreen(
                              subsId: allpackages[i]['id'].toString(),
                            ),
                          ),
                        );
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.center,
                              end: Alignment.center,
                              colors: [const Color(0xff90EAB4).withOpacity(0.1), const Color(0xff6BD294).withOpacity(0.8)],
                            ),
                            boxShadow: const [BoxShadow(color: Color.fromARGB(25, 0, 0, 0), blurRadius: 4.0, spreadRadius: 2.0, offset: Offset(2.0, 2.0))],
                            borderRadius: const BorderRadius.only(bottomLeft: Radius.circular(10), bottomRight: Radius.circular(10), topLeft: Radius.circular(10), topRight: Radius.circular(10))),
                        width: MediaQuery.of(context).size.width * .90,
                        height: 165,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              allpackages[i]['subscription_name'],
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w400,
                                fontFamily: "Poppins",
                                color: CustomColors.white,
                              ),
                            ),
                            const SizedBox(height: 12),
                            Text(
                              "\$ ${allpackages[i]['price']}",
                              style: TextStyle(
                                fontSize: 40,
                                fontWeight: FontWeight.w500,
                                fontFamily: "Poppins",
                                color: CustomColors.white,
                              ),
                            ),
                            const SizedBox(height: 12),
                            Text(
                              "BUY ${allpackages[i]['period_type']} SUBSCRIPTION",
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
  }
}

class PaymentsFormScreen extends StatefulWidget {
  final String subsId;
  const PaymentsFormScreen({super.key, required this.subsId});

  @override
  State<PaymentsFormScreen> createState() => _PaymentsFormScreenState();
}

class _PaymentsFormScreenState extends State<PaymentsFormScreen> {
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
                  // height: MediaQuery.of(context).size.height,
                  color: Colors.white,
                  padding: const EdgeInsets.only(top: 20),
                  child: Column(
                    children: [
                      if (cardProvider.allCards != null && cardProvider.allCards!.isNotEmpty) ...[
                        for (int j = 0; j < cardProvider.allCards!.length; j++) ...[
                          // RadioListTile(
                          //   groupValue: selectedCard,
                          //   activeColor: ServiceRecieverColor.primaryColor.withOpacity(0.8),
                          //   value: cardProvider.allCards[j],
                          //   onChanged: (value) {
                          //     setState(() {
                          //       newCard = false;
                          //       selectedCard = value;
                          //     });
                          //     // Provider.of<SubscriptionProvider>(context, listen: false).setSelectCard(value);
                          //   },
                          //   title: Text(
                          //     "Select Card: ${cardProvider.allCards[j].cardNumber}",
                          //     style: const TextStyle(color: Colors.black),
                          //   ),
                          // ),
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
    // CreditCard? selectedCard = context.watch<SubscriptionProvider>().cardValue;
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
                          "${selectedSubscribe['price']}\$",
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
                          // print(response);
                          if (response.statusCode == 200 && response.data['success']) {
                            Provider.of<RecieverUserProvider>(context, listen: false).fetchProfileReceiverModel();
                            Provider.of<SubscriptionProvider>(context, listen: false).getPackages();

                            showSuccessToast(response.data['message']);
                            Navigator.pop(context);
                          } else {
                            throw response.data['message'];
                          }
                        } catch (e) {
                          // print(e);
                          showErrorToast(e.toString());
                        }
                        return false;
                      },
                    ),
                    // GestureDetector(
                    //   onTap: !sendReq
                    //       ? () async {
                    //           setState(() {
                    //             sendReq = true;
                    //           });
                    //           try {
                    //             var token = await getToken();
                    //             var response = await postRequesthandler(
                    //               url: CareReceiverURl.serviceReceiverSubscribePackage,
                    //               formData: FormData.fromMap({
                    //                 "subscription_id": selectedSubscribe['id'],
                    //                 "card_data": selectedCard!.id.toString(),
                    //                 "save_card": false,
                    //                 "name_on_card": selectedCard!.nameOnCard.toString(),
                    //                 "card_number": selectedCard!.cardNumber.toString(),
                    //                 "card_expiration_month": selectedCard!.cardExpirationMonth.toString(),
                    //                 "card_expiration_year": selectedCard!.cardExpirationYear.toString(),
                    //                 "cvv": selectedCard!.cvv.toString(),
                    //               }),
                    //               token: token,
                    //             );
                    //             // print(response);
                    //             if (response.statusCode == 200 && response.data['success']) {
                    //               Provider.of<RecieverUserProvider>(context, listen: false).fetchProfileReceiverModel();
                    //               Provider.of<SubscriptionProvider>(context, listen: false).getPackages();

                    //               showSuccessToast(response.data['message']);
                    //               Navigator.pop(context);
                    //             } else {
                    //               throw response.data['message'];
                    //             }
                    //           } catch (e) {
                    //             // print(e);
                    //             showErrorToast(e.toString());
                    //           }

                    //           setState(() {
                    //             sendReq = false;
                    //           });
                    //         }
                    //       : null,
                    //   child: !sendReq
                    //       ? Container(
                    //           height: 60,
                    //           decoration: BoxDecoration(
                    //             borderRadius: BorderRadius.circular(10),
                    //             color: ServiceRecieverColor.redButton,
                    //           ),
                    //           child: Center(
                    //             child: Text(
                    //               "Subscribe",
                    //               style: TextStyle(
                    //                 color: CustomColors.white,
                    //                 fontFamily: "Poppins",
                    //                 fontSize: 18,
                    //                 fontWeight: FontWeight.w600,
                    //               ),
                    //             ),
                    //           ),
                    //         )
                    //       : const Center(
                    //           child: CircularProgressIndicator(color: Colors.green),
                    //         ),
                    // ),
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
                  "${selectedSubscribe['price']}\$",
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
                    // print(response);
                    // print(response.data['message']);
                    if (response.statusCode == 200 && response.data['success']) {
                      Provider.of<RecieverUserProvider>(context, listen: false).fetchProfileReceiverModel();
                      Provider.of<SubscriptionProvider>(context, listen: false).getPackages();
                      await Provider.of<CardProvider>(context, listen: false).fetchManageCardsModel();
                      showSuccessToast(response.data['message']);
                      Navigator.pop(context);
                    } else {
                      throw response.data['message'];
                    }
                  } catch (e) {
                    // print(e);
                    showErrorToast(e.toString());
                  }
                }
                return false;
              },
            ),
            // GestureDetector(
            //   onTap: sendReq == true
            //       ? null
            //       : () async {
            //           if (newPaymentForm.currentState!.validate()) {
            //             setState(() {
            //               sendReq = true;
            //             });
            //             try {
            //               var token = await getToken();
            //               var response = await postRequesthandler(
            //                 url: CareReceiverURl.serviceReceiverSubscribePackage,
            //                 formData: FormData.fromMap({
            //                   "subscription_id": selectedSubscribe['id'],
            //                   "card_data": "card-form",
            //                   "save_card": saveFrom,
            //                   "name_on_card": cardHolderNameController.text.toString(),
            //                   "card_number": cardNumberController.text.toString(),
            //                   "card_expiration_month": cardExpiryDateController.text.toString().substring(0, 2),
            //                   "card_expiration_year": cardExpiryDateController.text.toString().substring(3, 7),
            //                   "cvv": cardCvvController.text.toString(),
            //                 }),
            //                 token: token,
            //               );
            //               // print(response);
            //               // print(response.data['message']);
            //               if (response.statusCode == 200 && response.data['success']) {
            //                 Provider.of<RecieverUserProvider>(context, listen: false).fetchProfileReceiverModel();
            //                 Provider.of<SubscriptionProvider>(context, listen: false).getPackages();
            //                 await Provider.of<CardProvider>(context, listen: false).fetchManageCardsModel();
            //                 showSuccessToast(response.data['message']);
            //                 Navigator.pop(context);
            //               } else {
            //                 throw response.data['message'];
            //               }
            //             } catch (e) {
            //               // print(e);
            //               showErrorToast(e.toString());
            //             }
            //             setState(() {
            //               sendReq = false;
            //             });
            //           }
            //         },
            //   child: Container(
            //     height: 60,
            //     decoration: BoxDecoration(
            //       color: ServiceRecieverColor.redButton,
            //       borderRadius: BorderRadius.circular(10),
            //     ),
            //     child: Center(
            //       child: sendReq
            //           ? const CircularProgressIndicator(
            //               color: Colors.white,
            //             )
            //           : Text(
            //               "Subscribe",
            //               style: TextStyle(
            //                 color: CustomColors.white,
            //                 fontFamily: "Poppins",
            //                 fontSize: 18,
            //                 fontWeight: FontWeight.w600,
            //               ),
            //             ),
            //     ),
            //   ),
            // ),
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
