import 'package:flutter/material.dart';
import 'package:island_app/carereceiver/utils/colors.dart';

class PaymentFormScreen extends StatefulWidget {
  const PaymentFormScreen({super.key});

  @override
  State<PaymentFormScreen> createState() => _PaymentFormScreenState();
}

class _PaymentFormScreenState extends State<PaymentFormScreen> {
  final paymentForm = GlobalKey<FormState>();

  Future<void> _showMyDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          contentPadding: EdgeInsets.zero,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                const SizedBox(
                  height: 20,
                ),
                Image.asset(
                  "assets/images/tick.png",
                  width: 70,
                  height: 70,
                ),
                const SizedBox(
                  height: 20,
                ),
                Center(
                  child: Text(
                    'Successful',
                    style: TextStyle(
                      fontFamily: "Poppins",
                      fontSize: 20,
                      fontWeight: FontWeight.w400,
                      color: CustomColors.primaryText,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Center(
                  child: Text(
                    'Lorem ipsum dolar sit emit consecteter aditising emit',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: CustomColors.primaryTextLight,
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      fontFamily: "Poppins",
                    ),
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Container(
                    alignment: Alignment.center,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    decoration: BoxDecoration(
                      border: Border(
                        top: BorderSide(
                          color: CustomColors.borderLight,
                          width: 0.5,
                        ),
                      ),
                    ),
                    child: Text(
                      "Done",
                      style: TextStyle(
                        color: CustomColors.primaryColor,
                        fontFamily: "Poppins",
                        fontSize: 17,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: CustomColors.paymentBg,
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
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Form(
                key: paymentForm,
                child: Column(
                  children: [
                    Stack(
                      children: [
                        Container(
                          decoration: const BoxDecoration(
                            color: Colors.transparent,
                          ),
                          alignment: Alignment.centerRight,
                          width: MediaQuery.of(context).size.width,
                          height: 200,
                          child: const RotatedBox(
                            quarterTurns: 1,
                            child: Text(
                              'Container 1',
                              style: TextStyle(
                                fontSize: 18.0,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          top: 0,
                          left: 0,
                          right: 0,
                          child: Center(
                            child: GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const PaymentFormScreen(),
                                  ),
                                );
                              },
                              child: Container(
                                width: MediaQuery.of(context).size.width,
                                height: 165,
                                padding: const EdgeInsets.symmetric(horizontal: 20),
                                decoration: const BoxDecoration(
                                  image: DecorationImage(
                                    alignment: Alignment.bottomCenter,
                                    image: AssetImage("assets/images/loginBg.png"),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    SizedBox(
                                      child: Column(
                                        children: [
                                          Text(
                                            "Proceed Payment",
                                            style: TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.w600,
                                              fontFamily: "Poppins",
                                              color: CustomColors.white,
                                            ),
                                          ),
                                          const SizedBox(
                                            height: 2,
                                          ),
                                          Text(
                                            "Lorem ipsum dolar sit amit consectrer",
                                            style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w600,
                                              fontFamily: "Poppins",
                                              color: CustomColors.white,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 12,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          bottom: 5,
                          right: 25,
                          left: 25,
                          child: Container(
                            decoration: const BoxDecoration(
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(100),
                                bottomLeft: Radius.circular(100),
                                bottomRight: Radius.circular(100),
                                topRight: Radius.circular(100),
                              ),
                              color: Colors.transparent,
                            ),
                            alignment: Alignment.center,
                            child: Row(
                              children: [
                                Expanded(
                                  child: Container(
                                    padding: const EdgeInsets.all(12),
                                    decoration: BoxDecoration(
                                      color: CustomColors.white,
                                      boxShadow: const [
                                        BoxShadow(
                                          color: Color.fromARGB(13, 0, 0, 0),
                                          blurRadius: 4.0,
                                          spreadRadius: 4.0,
                                          offset: Offset(2.0, 2.0),
                                        ),
                                      ],
                                    ),
                                    child: Image.asset(
                                      "assets/images/paypal.png",
                                      width: 100,
                                      height: 50,
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  width: 20,
                                ),
                                Expanded(
                                  child: Container(
                                    padding: const EdgeInsets.all(12),
                                    decoration: BoxDecoration(
                                      color: CustomColors.white,
                                      boxShadow: const [
                                        BoxShadow(
                                          color: Color.fromARGB(13, 0, 0, 0),
                                          blurRadius: 4.0,
                                          spreadRadius: 4.0,
                                          offset: Offset(2.0, 2.0),
                                        ),
                                      ],
                                    ),
                                    child: Image.asset(
                                      "assets/images/master.png",
                                      width: 100,
                                      height: 50,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
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
                          const SizedBox(
                            height: 5,
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
                            height: 40,
                            child: TextFormField(
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
                            height: 15,
                          ),
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
                          const SizedBox(
                            height: 5,
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
                            height: 40,
                            child: TextFormField(
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
                            height: 15,
                          ),
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
                          const SizedBox(
                            height: 5,
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
                            height: 40,
                            child: TextFormField(
                              style: const TextStyle(
                                fontSize: 14,
                                fontFamily: "Rubik",
                                fontWeight: FontWeight.w400,
                              ),
                              textAlignVertical: TextAlignVertical.bottom,
                              maxLines: 1,
                              decoration: InputDecoration(
                                hintText: "MONTH | DAY | YEAR",
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
                            height: 15,
                          ),
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
                          const SizedBox(
                            height: 5,
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
                            height: 40,
                            child: TextFormField(
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
                            height: 15,
                          ),
                          // Card ZIP CODE
                          Container(
                            alignment: Alignment.topLeft,
                            child: Text(
                              "ZIP CODE",
                              style: TextStyle(
                                color: CustomColors.primaryColor,
                                fontFamily: "Rubik",
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 5,
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
                            height: 40,
                            child: TextFormField(
                              style: const TextStyle(
                                fontSize: 14,
                                fontFamily: "Rubik",
                                fontWeight: FontWeight.w400,
                              ),
                              textAlignVertical: TextAlignVertical.bottom,
                              maxLines: 1,
                              decoration: InputDecoration(
                                hintText: "XXXXXX",
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
                            height: 25,
                          ),
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
                                "30\$",
                                style: TextStyle(
                                  color: CustomColors.primaryText,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                  fontFamily: "Rubik",
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 25,
                          ),
                          // BTN
                          GestureDetector(
                            onTap: () {
                              _showMyDialog();
                            },
                            child: Container(
                              height: 60,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                gradient: LinearGradient(
                                  begin: Alignment.center,
                                  end: Alignment.center,
                                  colors: [
                                    const Color(0xff90EAB4).withOpacity(0.1),
                                    const Color(0xff6BD294).withOpacity(0.8),
                                  ],
                                ),
                              ),
                              child: Center(
                                child: Text(
                                  "Subscribe",
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
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
