// ignore_for_file: prefer_typing_uninitialized_variables, must_be_immutable

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:island_app/utils/app_url.dart';
import 'package:island_app/carereceiver/utils/colors.dart';
import 'package:island_app/utils/functions.dart';
import 'package:island_app/utils/http_handlers.dart';

class VerifyEmail extends StatefulWidget {
  String? token;
  VerifyEmail({
    super.key,
    required this.token,
  });

  @override
  State<VerifyEmail> createState() => _VerifyEmailState();
}

class _VerifyEmailState extends State<VerifyEmail> {
  var updatedData;

  Future<Response> postEmailVerify() async {
    showProgress(context);
    final response = await postRequesthandler(
      url: SessionUrl.emailVerification,
      token: widget.token,
    );

    return response;
  }

  @override
  Widget build(BuildContext context) {
    double baseWidth = 360;
    double fem = MediaQuery.of(context).size.width / baseWidth;
    double ffem = fem * 0.97;

    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: SizedBox(
            width: double.infinity,
            child: Container(
              width: double.infinity,
              height: 800 * fem,
              decoration: const BoxDecoration(
                color: Color(0xffffffff),
              ),
              child: Container(
                padding: EdgeInsets.fromLTRB(0 * fem, 0 * fem, 0 * fem, 56 * fem),
                width: double.infinity,
                height: double.infinity,
                decoration: const BoxDecoration(
                  color: Color(0xfff2f4f7),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 363 * fem,
                      height: 616 * fem,
                      child: Stack(
                        children: [
                          Positioned(
                            left: 0 * fem,
                            top: 0 * fem,
                            child: Align(
                              child: SizedBox(
                                width: 363 * fem,
                                height: 603 * fem,
                                child: Image.asset(
                                  fit: BoxFit.cover,
                                  'assets/images/loginBg.png',
                                  width: 363 * fem,
                                  height: 603 * fem,
                                ),
                              ),
                            ),
                          ),
                          Positioned(
                            left: 130 * fem,
                            top: 554 * fem,
                            child: GestureDetector(
                              onTap: () {
                                Navigator.pushReplacementNamed(context, '/');
                              },
                              child: Container(
                                width: 100 * fem,
                                height: 60 * fem,
                                decoration: BoxDecoration(
                                  color: const Color(0xffffffff),
                                  borderRadius: BorderRadius.circular(6 * fem),
                                  boxShadow: [
                                    BoxShadow(
                                      color: const Color(0x3f000000),
                                      offset: Offset(2 * fem, 4 * fem),
                                      blurRadius: 3.5 * fem,
                                    ),
                                  ],
                                ),
                                child: Center(
                                  child: Text(
                                    'Logout',
                                    style: TextStyle(
                                      fontFamily: 'Rubik',
                                      fontSize: 20 * ffem,
                                      fontWeight: FontWeight.w700,
                                      color: CustomColors.primaryColor,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Positioned(
                            left: 23 * fem,
                            top: 331 * fem,
                            child: SizedBox(
                              width: 320 * fem,
                              height: 162.8 * fem,
                              child: Stack(
                                children: [
                                  // Email Textfield
                                  Positioned(
                                    left: 0 * fem,
                                    top: 54 * fem,
                                    child: SizedBox(
                                      width: 320 * fem,
                                      height: 54.86 * fem,
                                    ),
                                  ),
                                  // Name Textfield
                                  Positioned(
                                    left: 0 * fem,
                                    top: 0 * fem,
                                    child: SizedBox(
                                      width: 320 * fem,
                                      height: 54.86 * fem,
                                      child: GestureDetector(
                                        onTap: () async {
                                          await postEmailVerify();
                                          setState(() {
                                            updatedData = "Verification link has been sent to your email address.";
                                          });
                                          Navigator.pop(context);
                                        },
                                        child: Container(
                                          width: 220 * fem,
                                          height: 60 * fem,
                                          decoration: BoxDecoration(
                                            color: CustomColors.white,
                                            borderRadius: BorderRadius.circular(6 * fem),
                                          ),
                                          child: Center(
                                            child: Text(
                                              'Resend Email Verification',
                                              style: TextStyle(
                                                fontFamily: 'Rubik',
                                                fontSize: 20 * ffem,
                                                fontWeight: FontWeight.w700,
                                                color: CustomColors.primaryColor,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  // Password TextField
                                  Positioned(
                                    left: 0 * fem,
                                    top: 107.9428710938 * fem,
                                    child: SizedBox(
                                      width: 320 * fem,
                                      height: 54.86 * fem,
                                      child: Text(
                                        "${updatedData ?? ""}",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          color: CustomColors.white,
                                          fontFamily: "Rubik",
                                          fontStyle: FontStyle.normal,
                                          fontSize: 24,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          // logo
                          Positioned(
                            left: 93 * fem,
                            top: 32 * fem,
                            child: Align(
                              child: SizedBox(
                                width: 175 * fem,
                                height: 121 * fem,
                                child: Image.asset(
                                  'assets/images/Logo-light.png',
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ),
                          Positioned(
                            left: 43 * fem,
                            top: 183 * fem,
                            child: SizedBox(
                              width: 269 * fem,
                              height: 300 * fem,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  // welcome
                                  Container(
                                    margin: EdgeInsets.fromLTRB(0 * fem, 0 * fem, 0 * fem, 7 * fem),
                                    child: Text(
                                      "Verify Your Email Address",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        color: CustomColors.white,
                                        fontFamily: "Rubik",
                                        fontStyle: FontStyle.normal,
                                        fontSize: 24,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                  // youcansearchcourseapplycoursea
                                  Container(
                                    constraints: BoxConstraints(
                                      maxWidth: 269 * fem,
                                    ),
                                    child: Text(
                                      'Before proceeding, please check your email for a verification link. If you did not receive the email,',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontFamily: 'Rubik',
                                        fontSize: 16 * ffem,
                                        fontWeight: FontWeight.w400,
                                        height: 1.6560000181 * ffem / fem,
                                        letterSpacing: -0.3000000119 * fem,
                                        color: const Color(0xffffffff),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
