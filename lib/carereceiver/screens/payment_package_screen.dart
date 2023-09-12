import 'package:flutter/material.dart';
import 'package:island_app/carereceiver/screens/payment_form_screen.dart';
import 'package:island_app/carereceiver/utils/colors.dart';

class PaymentPackageScreen extends StatefulWidget {
  const PaymentPackageScreen({super.key});

  @override
  State<PaymentPackageScreen> createState() => _PaymentPackageScreenState();
}

class _PaymentPackageScreenState extends State<PaymentPackageScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
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
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            child: Column(
              children: [
                const SizedBox(
                  height: 20,
                ),
                Container(
                  alignment: Alignment.center,
                  child: Text(
                    "Hire with Premium",
                    style: TextStyle(
                      color: CustomColors.primaryText,
                      fontSize: 22,
                      fontFamily: "Rubik",
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 5,
                ),
                Container(
                  alignment: Alignment.center,
                  child: Text(
                    "You`re currently on a limited membership. Get Premium to directly connect with sitters",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: CustomColors.primaryText,
                      fontSize: 14,
                      fontFamily: "Rubik",
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
                // Package Card Basic
                Stack(
                  children: [
                    Container(
                      decoration: const BoxDecoration(
                        color: Colors.transparent,
                      ),
                      alignment: Alignment.centerRight,
                      width: MediaQuery.of(context).size.width,
                      height: 190,
                      child: const RotatedBox(
                        quarterTurns: 1,
                        child: Text(
                          'Container 1',
                          style: TextStyle(fontSize: 18.0, color: Colors.white),
                        ),
                      ),
                    ),
                    Positioned(
                      top: 0,
                      left: 10,
                      right: 10,
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
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.center,
                                end: Alignment.center,
                                colors: [
                                  const Color(0xff90EAB4).withOpacity(0.1),
                                  const Color(0xff6BD294).withOpacity(0.8),
                                ],
                              ),
                              boxShadow: const [
                                BoxShadow(
                                  color: Color.fromARGB(25, 0, 0, 0),
                                  blurRadius: 4.0,
                                  spreadRadius: 2.0,
                                  offset: Offset(2.0, 2.0),
                                ),
                              ],
                              borderRadius: const BorderRadius.only(
                                bottomLeft: Radius.circular(10),
                                bottomRight: Radius.circular(10),
                                topLeft: Radius.circular(10),
                                topRight: Radius.circular(10),
                              ),
                            ),
                            width: MediaQuery.of(context).size.width * .90,
                            height: 165,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  "Basic",
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w400,
                                    fontFamily: "Poppins",
                                    color: CustomColors.white,
                                  ),
                                ),
                                const SizedBox(
                                  height: 12,
                                ),
                                Text(
                                  "\$ 0.00",
                                  style: TextStyle(
                                    fontSize: 40,
                                    fontWeight: FontWeight.w500,
                                    fontFamily: "Poppins",
                                    color: CustomColors.white,
                                  ),
                                ),
                                const SizedBox(
                                  height: 12,
                                ),
                                Text(
                                  "Free Trial",
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
                      ),
                    ),
                    Positioned(
                      top: 70,
                      right: -2,
                      height: 30,
                      width: 30,
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(100),
                            bottomLeft: Radius.circular(100),
                            bottomRight: Radius.circular(100),
                            topRight: Radius.circular(100),
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
                        width: 30,
                        height: 30,
                        child: Icon(
                          Icons.arrow_forward_ios,
                          size: 14,
                          color: CustomColors.primaryColor,
                        ),
                      ),
                    ),
                  ],
                ),
                // Package Card Standard
                Stack(
                  children: [
                    Container(
                      decoration: const BoxDecoration(
                        color: Colors.transparent,
                      ),
                      alignment: Alignment.centerRight,
                      width: MediaQuery.of(context).size.width,
                      height: 190,
                      child: const RotatedBox(
                        quarterTurns: 1,
                        child: Text(
                          'Container 1',
                          style: TextStyle(fontSize: 18.0, color: Colors.white),
                        ),
                      ),
                    ),
                    Positioned(
                      top: 0,
                      left: 10,
                      right: 10,
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
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.center,
                                end: Alignment.center,
                                colors: [
                                  const Color(0xff90EAB4).withOpacity(0.1),
                                  const Color(0xff6BD294).withOpacity(0.8),
                                ],
                              ),
                              boxShadow: const [
                                BoxShadow(
                                  color: Color.fromARGB(25, 0, 0, 0),
                                  blurRadius: 4.0,
                                  spreadRadius: 4.0,
                                  offset: Offset(2.0, 2.0),
                                ),
                              ],
                              borderRadius: const BorderRadius.only(
                                bottomLeft: Radius.circular(10),
                                bottomRight: Radius.circular(10),
                                topLeft: Radius.circular(10),
                                topRight: Radius.circular(10),
                              ),
                            ),
                            width: MediaQuery.of(context).size.width * .90,
                            height: 165,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  "Standard",
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w400,
                                    fontFamily: "Poppins",
                                    color: CustomColors.white,
                                  ),
                                ),
                                const SizedBox(
                                  height: 12,
                                ),
                                Text(
                                  "\$ 30.00",
                                  style: TextStyle(
                                    fontSize: 40,
                                    fontWeight: FontWeight.w500,
                                    fontFamily: "Poppins",
                                    color: CustomColors.white,
                                  ),
                                ),
                                const SizedBox(
                                  height: 12,
                                ),
                                Text(
                                  "1 Month",
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
                      ),
                    ),
                    Positioned(
                      top: 70,
                      right: -2,
                      height: 30,
                      width: 30,
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(100),
                            bottomLeft: Radius.circular(100),
                            bottomRight: Radius.circular(100),
                            topRight: Radius.circular(100),
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
                        width: 30,
                        height: 30,
                        child: Icon(
                          Icons.arrow_forward_ios,
                          size: 14,
                          color: CustomColors.primaryColor,
                        ),
                      ),
                    ),
                  ],
                ),
                // Package Card Premium
                Stack(
                  children: [
                    Container(
                      decoration: const BoxDecoration(
                        color: Colors.transparent,
                      ),
                      alignment: Alignment.centerRight,
                      width: MediaQuery.of(context).size.width,
                      height: 190,
                      child: const RotatedBox(
                        quarterTurns: 1,
                        child: Text(
                          'Container 1',
                          style: TextStyle(fontSize: 18.0, color: Colors.white),
                        ),
                      ),
                    ),
                    Positioned(
                      top: 0,
                      left: 10,
                      right: 10,
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
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.center,
                                end: Alignment.center,
                                colors: [
                                  const Color(0xff90EAB4).withOpacity(0.1),
                                  const Color(0xff6BD294).withOpacity(0.8),
                                ],
                              ),
                              boxShadow: const [
                                BoxShadow(
                                  color: Color.fromARGB(25, 0, 0, 0),
                                  blurRadius: 4.0,
                                  spreadRadius: 2.0,
                                  offset: Offset(2.0, 2.0),
                                ),
                              ],
                              borderRadius: const BorderRadius.only(
                                bottomLeft: Radius.circular(10),
                                bottomRight: Radius.circular(10),
                                topLeft: Radius.circular(10),
                                topRight: Radius.circular(10),
                              ),
                            ),
                            width: MediaQuery.of(context).size.width * .90,
                            height: 165,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  "Premium",
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w400,
                                    fontFamily: "Poppins",
                                    color: CustomColors.white,
                                  ),
                                ),
                                const SizedBox(
                                  height: 12,
                                ),
                                Text(
                                  "\$ 45.00",
                                  style: TextStyle(
                                    fontSize: 40,
                                    fontWeight: FontWeight.w500,
                                    fontFamily: "Poppins",
                                    color: CustomColors.white,
                                  ),
                                ),
                                const SizedBox(
                                  height: 12,
                                ),
                                Text(
                                  "Yearly",
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
                      ),
                    ),
                    Positioned(
                      top: 70,
                      right: -2,
                      height: 30,
                      width: 30,
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(100),
                            bottomLeft: Radius.circular(100),
                            bottomRight: Radius.circular(100),
                            topRight: Radius.circular(100),
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
                        width: 30,
                        height: 30,
                        child: Icon(
                          Icons.arrow_forward_ios,
                          size: 14,
                          color: CustomColors.primaryColor,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
