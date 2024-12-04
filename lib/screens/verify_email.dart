// ignore_for_file: prefer_typing_uninitialized_variables, must_be_immutable

import 'package:flutter/material.dart';
import 'package:island_app/utils/app_url.dart';
import 'package:island_app/carereceiver/utils/colors.dart';
import 'package:island_app/utils/functions.dart';
import 'package:island_app/utils/http_handlers.dart';
import 'package:island_app/widgets/loading_button.dart';

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

  // Future<Response> postEmailVerify() async {
  //   // showProgress(context);
  //   final response = await postRequesthandler(
  //     url: SessionUrl.emailVerification,
  //     token: widget.token,
  //   );
  //   if (response != null) {
  //     return response;
  //   } else {
  //     return Response(requestOptions: RequestOptions(data: {"message": "something went wrong"}), statusCode: 400);
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            decoration: const BoxDecoration(color: Color(0xffffffff)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  width: 363,
                  height: 616,
                  child: Stack(
                    children: [
                      Positioned(
                        left: 0,
                        top: 0,
                        child: Align(
                          child: SizedBox(
                            width: 363,
                            height: 603,
                            child: Image.asset(
                              fit: BoxFit.cover,
                              'assets/images/loginBg.png',
                              width: 363,
                              height: 603,
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        left: 130,
                        top: 554,
                        child: GestureDetector(
                          onTap: () {
                            Navigator.pushReplacementNamed(context, '/');
                          },
                          child: Container(
                            width: 100,
                            height: 60,
                            decoration: BoxDecoration(
                              color: const Color(0xffffffff),
                              borderRadius: BorderRadius.circular(6),
                              boxShadow: const [
                                BoxShadow(
                                  color: Color(0x3f000000),
                                  offset: Offset(2, 4),
                                  blurRadius: 3.5,
                                ),
                              ],
                            ),
                            child: Center(
                              child: Text(
                                'Back to login',
                                style: TextStyle(
                                  fontFamily: 'Rubik',
                                  fontSize: 20,
                                  fontWeight: FontWeight.w700,
                                  color: CustomColors.primaryColor,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        left: 23,
                        top: 341,
                        child: SizedBox(
                          width: 320,
                          height: 200,
                          child: Stack(
                            children: [
                              Positioned(
                                left: 0,
                                top: 0,
                                child: SizedBox(
                                  width: 320,
                                  height: 54.86,
                                  child: LoadingButton(
                                    onPressed: () async {
                                      final response = await postRequesthandler(
                                        url: SessionUrl.emailVerification,
                                        token: widget.token,
                                      );
                                      if (response != null && response.statusCode == 200) {
                                        showSuccessToast("Verification link has been sent to your email address.");
                                        setState(() {
                                          updatedData = "Verification link has been sent to your email address.";
                                        });
                                      }
                                      return false;
                                    },
                                    height: 60,
                                    title: "Resend Email Verification",
                                    textStyle: TextStyle(
                                      fontFamily: 'Rubik',
                                      fontSize: 20,
                                      fontWeight: FontWeight.w700,
                                      color: CustomColors.primaryColor,
                                    ),
                                  ),
                                ),
                              ),
                              Positioned(
                                left: 0,
                                top: 107.9428710938,
                                child: SizedBox(
                                  width: 320,
                                  height: 120.86,
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
                        left: 93,
                        top: 50,
                        child: Align(
                          child: SizedBox(
                            width: 175,
                            height: 121,
                            child: Image.asset(
                              'assets/images/Logo-light.png',
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                      // verify email text
                      Positioned(
                        left: 43,
                        top: 183,
                        child: SizedBox(
                          width: 269,
                          height: 320,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              // welcome
                              Container(
                                margin: const EdgeInsets.fromLTRB(0, 0, 0, 7),
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
                                constraints: const BoxConstraints(
                                  maxWidth: 269,
                                ),
                                child: const Text(
                                  'Before proceeding, please check your email for a verification link. If you did not receive the email,',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontFamily: 'Rubik',
                                    fontSize: 16,
                                    fontWeight: FontWeight.w400,
                                    height: 1.6560000181,
                                    letterSpacing: -0.3000000119,
                                    color: Color(0xffffffff),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 10),
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
    );
  }
}
