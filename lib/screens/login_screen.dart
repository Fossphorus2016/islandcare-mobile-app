// ignore_for_file: avoid_print, use_build_context_synchronously, unused_local_variable, non_constant_identifier_names

import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:island_app/carereceiver/utils/colors.dart';
import 'package:island_app/carereceiver/widgets/bottom_bar.dart';
import 'package:island_app/models/login_model.dart';
import 'package:island_app/res/app_url.dart';
import 'package:island_app/screens/splash_screen.dart';
import 'package:island_app/screens/verify_email.dart';
import 'package:island_app/widgets/progress_dialog.dart';
import 'package:pinput/pinput.dart';
// import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:island_app/utils/utils.dart';

// import "package:htt"/
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _signInFormKey = GlobalKey<FormState>();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController cpasswordController = TextEditingController();
  final forgetformKey = GlobalKey<FormState>();
  final AddformKey = GlobalKey<FormState>();

  final pinController = TextEditingController();
  final pinfocusNode = FocusNode();
  final addPassformKey = GlobalKey<FormState>();
  final pinformKey = GlobalKey<FormState>();
  // Post Login Req
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

  Future<Response> postLogin(LoginModel model) async {
    showProgress(context);
    try {
      final response = await Dio().post(
        SessionUrl.login,
        data: jsonEncode(model.toJson()),
        options: Options(
          headers: {"Content-Type": "application/json"},
        ),
      );
      hideProgress();
      return response;
    } catch (e) {
      hideProgress();
      return Response(requestOptions: RequestOptions(), statusCode: 400);
    }
  }

  // Show/Hide
  bool _showPassword = false;
  void _togglevisibility() {
    setState(() {
      _showPassword = !_showPassword;
    });
  }

  @override
  void dispose() {
    super.dispose();
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    cpasswordController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double baseWidth = 360;
    double fem = MediaQuery.of(context).size.width / baseWidth;
    double ffem = fem * 0.97;

    const focusedBorderColor = Color.fromRGBO(23, 171, 144, 1);
    const fillColor = Color.fromRGBO(243, 246, 249, 0);
    const borderColor = Color.fromRGBO(23, 171, 144, 0.4);

    final defaultPinTheme = PinTheme(
      width: 56,
      height: 56,
      textStyle: TextStyle(
        fontSize: 26,
        color: CustomColors.otpText,
        fontStyle: FontStyle.normal,
        fontWeight: FontWeight.w700,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: CustomColors.hintText, width: 0.5),
      ),
    );
    return SafeArea(
      child: Scaffold(
        body: ListView(
          children: [
            SizedBox(
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
                  child: Form(
                    key: _signInFormKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: 363 * fem,
                          height: 546 * fem,
                          child: Stack(
                            children: [
                              Positioned(
                                left: 0 * fem,
                                top: 0 * fem,
                                child: Align(
                                  child: SizedBox(
                                    width: 363 * fem,
                                    height: 503 * fem,
                                    child: Image.asset(
                                      fit: BoxFit.cover,
                                      'assets/images/loginBg.png',
                                      width: 363 * fem,
                                      height: 503 * fem,
                                      scale: 2.5,
                                      alignment: Alignment.bottomCenter,
                                    ),
                                  ),
                                ),
                              ),
                              // Login btn
                              Positioned(
                                left: 74 * fem,
                                top: 470 * fem,
                                child: GestureDetector(
                                  onTap: () {
                                    if (emailController.text.isEmpty) {
                                      customErrorSnackBar(
                                        context,
                                        "Please Enter Email",
                                      );
                                    } else if (passwordController.text.isEmpty) {
                                      customErrorSnackBar(
                                        context,
                                        "Please Enter Password",
                                      );
                                    } else if (passwordController.text.length < 3) {
                                      customErrorSnackBar(
                                        context,
                                        "Please Enter 3 digit Password",
                                      );
                                    } else {
                                      if (_signInFormKey.currentState!.validate()) {
                                        var request = LoginModel(
                                          email: emailController.text.toString(),
                                          password: passwordController.text.toString(),
                                        );
                                        postLogin(request).then((response) async {
                                          print(response.data);
                                          if (response.statusCode == 200) {
                                            var data = response.data;
                                            var role = data["user"]["role"];
                                            var status = data["user"]["status"];
                                            var token = data["token"];
                                            var isProfileCompleted = data["is_profile_completed"];
                                            var userId = data["user"]['id'];
                                            var avatar = data["user"]['avatar'];
                                            var name = data["user"]['first_name'];
                                            var last = data["user"]['last_name'];

                                            // print("User role ${data["user"]["role"]}");
                                            // print("User status $status");
                                            // print("User token $token");

                                            // print(data);

                                            if (status == 3) {
                                              customErrorSnackBar(
                                                context,
                                                "User Blocked",
                                              );
                                            } else {
                                              if (data["user"]["email_verified_at"] == null) {
                                                Navigator.pushReplacement(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) => VerifyEmail(token: data["token"]),
                                                  ),
                                                );
                                              } else if (data["user"]["role"] == 3) {
                                                if (data["user"]["status"] == 0) {
                                                  SharedPreferences pref = await SharedPreferences.getInstance();
                                                  await pref.setString('userStatus', status.toString());
                                                  await pref.setString('userTokenProfile', data["token"].toString());
                                                  await pref.setString('userAvatar', avatar.toString());
                                                  await pref.setString('userId', userId.toString());
                                                  await pref.setString('isProfileCompleted', isProfileCompleted.toString());
                                                  await pref.setString('userName', "$name $last");
                                                  // Provider.of<NotificationProvider>(context, listen: false).connectNotificationChannel(3);
                                                  Navigator.pushNamedAndRemoveUntil(
                                                    context,
                                                    'bottom-bar-giver-2',
                                                    (route) => false,
                                                  );
                                                } else {
                                                  // Navigator.pushNamedAndRemoveUntil(
                                                  //   context,
                                                  //   'bottom-bar-giver',
                                                  //   (route) => false,
                                                  // );
                                                  // Provider.of<NotificationProvider>(context, listen: false).connectNotificationChannel(3);

                                                  SharedPreferences pref = await SharedPreferences.getInstance();
                                                  await pref.setString('userRole', data["user"]["role"].toString());
                                                  await pref.setString('userToken', data["token"].toString());
                                                  await pref.setString('userStatus', status.toString());
                                                  await pref.setString('userId', userId.toString());
                                                  await pref.setString('userAvatar', avatar.toString());
                                                  await pref.setString('userName', "$name $last");
                                                  await pref.setString('isProfileCompleted', isProfileCompleted.toString());
                                                  Navigator.push(context, MaterialPageRoute(builder: (context) => const SplashScreen()));
                                                }
                                              } else if (data["user"]["role"] == 4) {
                                                if (data["user"]["status"] == 0) {
                                                  SharedPreferences pref = await SharedPreferences.getInstance();
                                                  await pref.setString('userStatus', status.toString());
                                                  await pref.setString('userTokenProfile', data["token"].toString());
                                                  await pref.setString('userAvatar', avatar.toString());
                                                  await pref.setString('userId', userId.toString());
                                                  await pref.setString('userName', "$name $last");
                                                  await pref.setString('isProfileCompleted', isProfileCompleted.toString());

                                                  Navigator.pushAndRemoveUntil(
                                                    context,
                                                    // 'bottom-bar-2',
                                                    MaterialPageRoute(
                                                      builder: (context) => BottomBar(
                                                        data: data['token'].toString(),
                                                      ),
                                                    ),
                                                    (route) => false,
                                                  );
                                                } else {
                                                  // Provider.of<NotificationProvider>(context, listen: false).connectNotificationChannel(4);

                                                  SharedPreferences pref = await SharedPreferences.getInstance();
                                                  await pref.setString('userRole', data["user"]["role"].toString());
                                                  await pref.setString('userToken', data["token"].toString());
                                                  await pref.setString('userStatus', status.toString());
                                                  await pref.setString('userId', userId.toString());
                                                  await pref.setString('userAvatar', avatar.toString());
                                                  await pref.setString('userName', "$name $last");
                                                  await pref.setString('isProfileCompleted', isProfileCompleted.toString());
                                                  Navigator.push(context, MaterialPageRoute(builder: (context) => const SplashScreen()));
                                                }
                                              }
                                            }
                                            // if(response.body.["user"]){}
                                          } else {
                                            customErrorSnackBar(
                                              context,
                                              "Bad Credentials",
                                            );
                                          }
                                        });
                                      }
                                    }
                                  },
                                  child: Container(
                                    width: 220 * fem,
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
                                        'Log In',
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
                                top: 281 * fem,
                                child: Container(
                                  width: 320 * fem,
                                  height: 130.8 * fem,
                                  decoration: const BoxDecoration(),
                                  child: Stack(
                                    children: [
                                      // Name Textfield
                                      Positioned(
                                        left: 0 * fem,
                                        top: 0 * fem,
                                        child: Container(
                                          width: 320 * fem,
                                          height: 48.86 * fem,
                                          decoration: BoxDecoration(
                                            border: Border.all(color: const Color(0xff938284)),
                                            color: const Color(0x28efefef),
                                            borderRadius: BorderRadius.only(
                                              topLeft: Radius.circular(6 * fem),
                                              topRight: Radius.circular(6 * fem),
                                              bottomLeft: Radius.circular(6 * fem),
                                              bottomRight: Radius.circular(6 * fem),
                                            ),
                                            boxShadow: [
                                              BoxShadow(
                                                color: const Color(0x16000000),
                                                offset: Offset(0 * fem, 4 * fem),
                                                blurRadius: 2 * fem,
                                              ),
                                            ],
                                          ),
                                          child: TextFormField(
                                            controller: emailController,
                                            validator: (value) {
                                              if (value!.isEmpty) {
                                                return customErrorSnackBar(
                                                  context,
                                                  "Please Enter Email",
                                                );
                                              }
                                              if (!RegExp("^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+.[a-z]").hasMatch(value)) {
                                                return customErrorSnackBar(
                                                  context,
                                                  "Please Enter Email",
                                                );
                                              }
                                              return null;
                                            },
                                            keyboardType: TextInputType.emailAddress,
                                            textInputAction: TextInputAction.next,
                                            style: TextStyle(
                                              color: CustomColors.white,
                                              fontSize: 16,
                                              fontFamily: "Rubik",
                                              fontWeight: FontWeight.w400,
                                            ),
                                            textAlignVertical: TextAlignVertical.center,
                                            maxLines: 1,
                                            decoration: InputDecoration(
                                              border: InputBorder.none,
                                              prefixIcon: Icon(
                                                Icons.mail_outline,
                                                size: 20,
                                                color: CustomColors.white,
                                              ),
                                              hintText: "Email",
                                              hintStyle: TextStyle(
                                                fontFamily: 'Calibri',
                                                fontSize: 18 * ffem,
                                                fontWeight: FontWeight.w400,
                                                height: 1.2575 * ffem / fem,
                                                color: CustomColors.white,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      // Password TextField
                                      Positioned(
                                        left: 0 * fem,
                                        top: 65.9428710938 * fem,
                                        child: Container(
                                          width: 320 * fem,
                                          height: 48.86 * fem,
                                          decoration: BoxDecoration(
                                            border: Border.all(color: const Color(0xff948284)),
                                            color: const Color(0x28efefef),
                                            borderRadius: BorderRadius.only(
                                              bottomRight: Radius.circular(6 * fem),
                                              bottomLeft: Radius.circular(6 * fem),
                                              topLeft: Radius.circular(6 * fem),
                                              topRight: Radius.circular(6 * fem),
                                            ),
                                            boxShadow: [
                                              BoxShadow(
                                                color: const Color(0x16000000),
                                                offset: Offset(0 * fem, 4 * fem),
                                                blurRadius: 2 * fem,
                                              ),
                                            ],
                                          ),
                                          child: TextFormField(
                                            controller: passwordController,
                                            obscureText: !_showPassword,
                                            style: TextStyle(
                                              color: CustomColors.white,
                                              fontSize: 16,
                                              fontFamily: "Rubik",
                                              fontWeight: FontWeight.w400,
                                            ),
                                            textAlignVertical: TextAlignVertical.center,
                                            maxLines: 1,
                                            decoration: InputDecoration(
                                              border: InputBorder.none,
                                              prefixIcon: Icon(
                                                Icons.lock_outline,
                                                size: 20,
                                                color: CustomColors.white,
                                              ),
                                              suffixIcon: GestureDetector(
                                                onTap: () {
                                                  _togglevisibility();
                                                },
                                                child: Padding(
                                                  padding: const EdgeInsets.only(left: 8.0),
                                                  child: Icon(
                                                    _showPassword ? Icons.visibility : Icons.visibility_off,
                                                    size: 20,
                                                    color: CustomColors.white,
                                                  ),
                                                ),
                                              ),
                                              hintText: "Password",
                                              hintStyle: TextStyle(
                                                fontFamily: 'Calibri',
                                                fontSize: 18 * ffem,
                                                fontWeight: FontWeight.w400,
                                                height: 1.2575 * ffem / fem,
                                                color: CustomColors.white,
                                              ),
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
                                top: 163 * fem,
                                child: SizedBox(
                                  width: 269 * fem,
                                  height: 89 * fem,
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      // welcome
                                      Container(
                                        margin: EdgeInsets.fromLTRB(0 * fem, 0 * fem, 0 * fem, 7 * fem),
                                        child: Text(
                                          "Welcome",
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
                                          'You can search course, apply course \nand find caregiver',
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
                              // Forget Password
                              // Positioned(
                              //   left: 50 * fem,
                              //   top: 395 * fem,
                              //   child: Align(
                              //     child: GestureDetector(
                              //       onTap: () {
                              //         showModalBottomSheet(
                              //           isScrollControlled: true,
                              //           context: context,
                              //           backgroundColor: Colors.white,
                              //           shape: const RoundedRectangleBorder(
                              //             borderRadius: BorderRadius.only(
                              //               topLeft: Radius.circular(30.0),
                              //               topRight: Radius.circular(30.0),
                              //             ),
                              //           ),
                              //           builder: (context) {
                              //             return Padding(
                              //               padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
                              //               child: Container(
                              //                 padding: const EdgeInsets.symmetric(horizontal: 25),
                              //                 child: Column(
                              //                   crossAxisAlignment: CrossAxisAlignment.start,
                              //                   mainAxisAlignment: MainAxisAlignment.center,
                              //                   mainAxisSize: MainAxisSize.min,
                              //                   children: [
                              //                     const SizedBox(
                              //                       height: 20,
                              //                     ),
                              //                     Center(
                              //                       child: Container(
                              //                         width: 130,
                              //                         height: 5,
                              //                         decoration: BoxDecoration(
                              //                           color: const Color(0xffC4C4C4),
                              //                           borderRadius: BorderRadius.circular(6),
                              //                         ),
                              //                       ),
                              //                     ),
                              //                     const SizedBox(
                              //                       height: 40,
                              //                     ),
                              //                     Center(
                              //                       child: Text(
                              //                         "Forgot Password",
                              //                         textAlign: TextAlign.center,
                              //                         style: TextStyle(
                              //                           color: CustomColors.black,
                              //                           fontFamily: "Rubik",
                              //                           fontStyle: FontStyle.normal,
                              //                           fontSize: 24,
                              //                           fontWeight: FontWeight.w600,
                              //                         ),
                              //                       ),
                              //                     ),
                              //                     const SizedBox(
                              //                       height: 10,
                              //                     ),
                              //                     Center(
                              //                       child: Text(
                              //                         "Enter your email for the verification proccess we will send 4 digit code to your email.",
                              //                         textAlign: TextAlign.center,
                              //                         style: TextStyle(
                              //                           color: CustomColors.primaryText,
                              //                           fontFamily: "Rubik",
                              //                           fontStyle: FontStyle.normal,
                              //                           fontSize: 14,
                              //                           fontWeight: FontWeight.w400,
                              //                         ),
                              //                       ),
                              //                     ),
                              //                     const SizedBox(
                              //                       height: 40,
                              //                     ),
                              //                     Form(
                              //                       key: forgetformKey,
                              //                       child: Column(
                              //                         mainAxisAlignment: MainAxisAlignment.center,
                              //                         children: [
                              //                           CustomTextFieldWidget(
                              //                             borderColor: CustomColors.loginBorder,
                              //                             sufIcon: Icon(
                              //                               Icons.done,
                              //                               color: CustomColors.hintText,
                              //                               size: 20,
                              //                             ),
                              //                             textStyle: TextStyle(
                              //                               fontSize: 15,
                              //                               color: CustomColors.hintText,
                              //                               fontFamily: "Calibri",
                              //                               fontWeight: FontWeight.w400,
                              //                             ),
                              //                             hintText: "xxxxxxxxxxxxx@gmail.com",
                              //                             controller: emailController,
                              //                             obsecure: false,
                              //                           ),
                              //                           const SizedBox(
                              //                             height: 20,
                              //                           ),
                              //                           // OTP
                              //                           GestureDetector(
                              //                             onTap: () {
                              //                               if (forgetformKey.currentState!.validate()) {
                              //                                 // signInUser();
                              //                                 showModalBottomSheet(
                              //                                   isScrollControlled: true,
                              //                                   context: context,
                              //                                   backgroundColor: Colors.white,
                              //                                   shape: const RoundedRectangleBorder(
                              //                                     borderRadius: BorderRadius.only(
                              //                                       topLeft: Radius.circular(30.0),
                              //                                       topRight: Radius.circular(30.0),
                              //                                     ),
                              //                                   ),
                              //                                   builder: (context) {
                              //                                     return Padding(
                              //                                       padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
                              //                                       child: Container(
                              //                                         padding: const EdgeInsets.symmetric(horizontal: 25),
                              //                                         child: Column(
                              //                                           crossAxisAlignment: CrossAxisAlignment.start,
                              //                                           mainAxisAlignment: MainAxisAlignment.center,
                              //                                           mainAxisSize: MainAxisSize.min,
                              //                                           children: [
                              //                                             const SizedBox(
                              //                                               height: 20,
                              //                                             ),
                              //                                             Center(
                              //                                               child: Container(
                              //                                                 width: 130,
                              //                                                 height: 5,
                              //                                                 decoration: BoxDecoration(
                              //                                                   color: const Color(0xffC4C4C4),
                              //                                                   borderRadius: BorderRadius.circular(6),
                              //                                                 ),
                              //                                               ),
                              //                                             ),
                              //                                             const SizedBox(
                              //                                               height: 50,
                              //                                             ),
                              //                                             Center(
                              //                                               child: Text(
                              //                                                 "Enter 4 Digits Code",
                              //                                                 textAlign: TextAlign.center,
                              //                                                 style: TextStyle(
                              //                                                   color: CustomColors.black,
                              //                                                   fontFamily: "Rubik",
                              //                                                   fontStyle: FontStyle.normal,
                              //                                                   fontSize: 24,
                              //                                                   fontWeight: FontWeight.w600,
                              //                                                 ),
                              //                                               ),
                              //                                             ),
                              //                                             const SizedBox(
                              //                                               height: 10,
                              //                                             ),
                              //                                             Center(
                              //                                               child: Text(
                              //                                                 "Enter the 4 digits code that you received on your email.",
                              //                                                 textAlign: TextAlign.center,
                              //                                                 style: TextStyle(
                              //                                                   color: CustomColors.primaryText,
                              //                                                   fontFamily: "Rubik",
                              //                                                   fontStyle: FontStyle.normal,
                              //                                                   fontSize: 14,
                              //                                                   fontWeight: FontWeight.w400,
                              //                                                 ),
                              //                                               ),
                              //                                             ),
                              //                                             const SizedBox(
                              //                                               height: 30,
                              //                                             ),
                              //                                             Form(
                              //                                               key: pinformKey,
                              //                                               child: Column(
                              //                                                 mainAxisAlignment: MainAxisAlignment.center,
                              //                                                 children: [
                              //                                                   Directionality(
                              //                                                     // Specify direction if desired1
                              //                                                     textDirection: ui.TextDirection.ltr,
                              //                                                     child: Center(
                              //                                                       child: Pinput(
                              //                                                         closeKeyboardWhenCompleted: true,
                              //                                                         mainAxisAlignment: MainAxisAlignment.spaceAround,
                              //                                                         controller: pinController,
                              //                                                         focusNode: pinfocusNode,
                              //                                                         androidSmsAutofillMethod: AndroidSmsAutofillMethod.smsUserConsentApi,
                              //                                                         listenForMultipleSmsOnAndroid: true,
                              //                                                         defaultPinTheme: defaultPinTheme,
                              //                                                         validator: (value) {
                              //                                                           return value == '2222' ? null : 'Pin is incorrect';
                              //                                                         },
                              //                                                         // onClipboardFound: (value) {
                              //                                                         //   debugPrint('onClipboardFound: $value');
                              //                                                         //   pinController.setText(value);
                              //                                                         // },
                              //                                                         hapticFeedbackType: HapticFeedbackType.lightImpact,
                              //                                                         onCompleted: (pin) {
                              //                                                           debugPrint('onCompleted: $pin');
                              //                                                         },
                              //                                                         onChanged: (value) {
                              //                                                           debugPrint('onChanged: $value');
                              //                                                         },
                              //                                                         cursor: Column(
                              //                                                           mainAxisAlignment: MainAxisAlignment.end,
                              //                                                           children: [
                              //                                                             Container(
                              //                                                               margin: const EdgeInsets.only(bottom: 9),
                              //                                                               width: 22,
                              //                                                               height: 1,
                              //                                                               color: focusedBorderColor,
                              //                                                             ),
                              //                                                           ],
                              //                                                         ),
                              //                                                         focusedPinTheme: defaultPinTheme.copyWith(
                              //                                                           textStyle: TextStyle(
                              //                                                             fontSize: 26,
                              //                                                             color: CustomColors.otpText,
                              //                                                             fontStyle: FontStyle.normal,
                              //                                                             fontWeight: FontWeight.w700,
                              //                                                           ),
                              //                                                           decoration: defaultPinTheme.decoration!.copyWith(
                              //                                                             borderRadius: BorderRadius.circular(12),
                              //                                                             border: Border.all(color: focusedBorderColor),
                              //                                                           ),
                              //                                                         ),
                              //                                                         submittedPinTheme: defaultPinTheme.copyWith(
                              //                                                           decoration: defaultPinTheme.decoration!.copyWith(
                              //                                                             color: fillColor,
                              //                                                             borderRadius: BorderRadius.circular(12),
                              //                                                             border: Border.all(color: focusedBorderColor),
                              //                                                           ),
                              //                                                         ),
                              //                                                         errorPinTheme: defaultPinTheme.copyBorderWith(
                              //                                                           border: Border.all(color: Colors.redAccent),
                              //                                                         ),
                              //                                                       ),
                              //                                                     ),
                              //                                                   ),
                              //                                                   const SizedBox(
                              //                                                     height: 20,
                              //                                                   ),
                              //                                                   GestureDetector(
                              //                                                     onTap: () {
                              //                                                       // Add New Password
                              //                                                       if (pinformKey.currentState!.validate()) {}
                              //                                                       showModalBottomSheet(
                              //                                                         isScrollControlled: true,
                              //                                                         context: context,
                              //                                                         backgroundColor: Colors.white,
                              //                                                         shape: const RoundedRectangleBorder(
                              //                                                           borderRadius: BorderRadius.only(
                              //                                                             topLeft: Radius.circular(30.0),
                              //                                                             topRight: Radius.circular(30.0),
                              //                                                           ),
                              //                                                         ),
                              //                                                         builder: (context) {
                              //                                                           return Padding(
                              //                                                             padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
                              //                                                             child: Container(
                              //                                                               padding: const EdgeInsets.symmetric(horizontal: 25),
                              //                                                               child: Column(
                              //                                                                 crossAxisAlignment: CrossAxisAlignment.start,
                              //                                                                 mainAxisAlignment: MainAxisAlignment.center,
                              //                                                                 mainAxisSize: MainAxisSize.min,
                              //                                                                 children: [
                              //                                                                   const SizedBox(
                              //                                                                     height: 20,
                              //                                                                   ),
                              //                                                                   Center(
                              //                                                                     child: Container(
                              //                                                                       width: 130,
                              //                                                                       height: 5,
                              //                                                                       decoration: BoxDecoration(
                              //                                                                         color: const Color(0xffC4C4C4),
                              //                                                                         borderRadius: BorderRadius.circular(6),
                              //                                                                       ),
                              //                                                                     ),
                              //                                                                   ),
                              //                                                                   const SizedBox(
                              //                                                                     height: 40,
                              //                                                                   ),
                              //                                                                   Center(
                              //                                                                     child: Text(
                              //                                                                       "Reset Password",
                              //                                                                       textAlign: TextAlign.center,
                              //                                                                       style: TextStyle(
                              //                                                                         color: CustomColors.black,
                              //                                                                         fontFamily: "Rubik",
                              //                                                                         fontStyle: FontStyle.normal,
                              //                                                                         fontSize: 24,
                              //                                                                         fontWeight: FontWeight.w600,
                              //                                                                       ),
                              //                                                                     ),
                              //                                                                   ),
                              //                                                                   const SizedBox(
                              //                                                                     height: 10,
                              //                                                                   ),
                              //                                                                   Center(
                              //                                                                     child: Text(
                              //                                                                       "Set the new password for your account so you can login and access all the features.",
                              //                                                                       textAlign: TextAlign.center,
                              //                                                                       style: TextStyle(
                              //                                                                         color: CustomColors.primaryText,
                              //                                                                         fontFamily: "Rubik",
                              //                                                                         fontStyle: FontStyle.normal,
                              //                                                                         fontSize: 14,
                              //                                                                         fontWeight: FontWeight.w400,
                              //                                                                       ),
                              //                                                                     ),
                              //                                                                   ),
                              //                                                                   const SizedBox(
                              //                                                                     height: 40,
                              //                                                                   ),
                              //                                                                   Form(
                              //                                                                     key: addPassformKey,
                              //                                                                     child: Column(
                              //                                                                       mainAxisAlignment: MainAxisAlignment.center,
                              //                                                                       children: [
                              //                                                                         CustomTextFieldWidget(
                              //                                                                           borderColor: CustomColors.loginBorder,
                              //                                                                           textStyle: TextStyle(
                              //                                                                             fontSize: 15,
                              //                                                                             color: CustomColors.hintText,
                              //                                                                             fontFamily: "Calibri",
                              //                                                                             fontWeight: FontWeight.w400,
                              //                                                                           ),
                              //                                                                           hintText: "New Password",
                              //                                                                           controller: passwordController,
                              //                                                                           obsecure: !_showPassword,
                              //                                                                           sufIcon: GestureDetector(
                              //                                                                             onTap: () {
                              //                                                                               _togglevisibility();
                              //                                                                             },
                              //                                                                             child: Padding(
                              //                                                                               padding: const EdgeInsets.only(left: 8.0),
                              //                                                                               child: Icon(
                              //                                                                                 _showPassword ? Icons.visibility : Icons.visibility_off,
                              //                                                                                 size: 20,
                              //                                                                                 color: CustomColors.hintText,
                              //                                                                               ),
                              //                                                                             ),
                              //                                                                           ),
                              //                                                                         ),
                              //                                                                         const SizedBox(
                              //                                                                           height: 10,
                              //                                                                         ),
                              //                                                                         CustomTextFieldWidget(
                              //                                                                           borderColor: CustomColors.loginBorder,
                              //                                                                           textStyle: TextStyle(
                              //                                                                             fontSize: 15,
                              //                                                                             color: CustomColors.hintText,
                              //                                                                             fontFamily: "Calibri",
                              //                                                                             fontWeight: FontWeight.w400,
                              //                                                                           ),
                              //                                                                           hintText: "Re-enter Password",
                              //                                                                           controller: cpasswordController,
                              //                                                                           obsecure: !_showPassword,
                              //                                                                           sufIcon: GestureDetector(
                              //                                                                             onTap: () {
                              //                                                                               _togglevisibility();
                              //                                                                             },
                              //                                                                             child: Padding(
                              //                                                                               padding: const EdgeInsets.only(left: 8.0),
                              //                                                                               child: Icon(
                              //                                                                                 _showPassword ? Icons.visibility : Icons.visibility_off,
                              //                                                                                 size: 20,
                              //                                                                                 color: CustomColors.hintText,
                              //                                                                               ),
                              //                                                                             ),
                              //                                                                           ),
                              //                                                                         ),
                              //                                                                         const SizedBox(
                              //                                                                           height: 20,
                              //                                                                         ),
                              //                                                                         // OTP
                              //                                                                         GestureDetector(
                              //                                                                           onTap: () {
                              //                                                                             Navigator.push(
                              //                                                                               context,
                              //                                                                               MaterialPageRoute(
                              //                                                                                 builder: (context) => const BottomBar(),
                              //                                                                               ),
                              //                                                                             );
                              //                                                                           },
                              //                                                                           child: Container(
                              //                                                                             width: MediaQuery.of(context).size.width,
                              //                                                                             height: 54,
                              //                                                                             decoration: BoxDecoration(
                              //                                                                               color: CustomColors.primaryColor,
                              //                                                                               borderRadius: BorderRadius.circular(10),
                              //                                                                             ),
                              //                                                                             child: Center(
                              //                                                                               child: Text(
                              //                                                                                 "Continue",
                              //                                                                                 style: TextStyle(
                              //                                                                                   color: CustomColors.white,
                              //                                                                                   fontFamily: "Rubik",
                              //                                                                                   fontStyle: FontStyle.normal,
                              //                                                                                   fontWeight: FontWeight.w500,
                              //                                                                                   fontSize: 18,
                              //                                                                                 ),
                              //                                                                               ),
                              //                                                                             ),
                              //                                                                           ),
                              //                                                                         ),
                              //                                                                         const SizedBox(
                              //                                                                           height: 30,
                              //                                                                         ),
                              //                                                                       ],
                              //                                                                     ),
                              //                                                                   ),
                              //                                                                 ],
                              //                                                               ),
                              //                                                             ),
                              //                                                           );
                              //                                                         },
                              //                                                       );
                              //                                                     },
                              //                                                     child: Container(
                              //                                                       width: MediaQuery.of(context).size.width,
                              //                                                       height: 54,
                              //                                                       decoration: BoxDecoration(
                              //                                                         color: CustomColors.primaryColor,
                              //                                                         borderRadius: BorderRadius.circular(10),
                              //                                                       ),
                              //                                                       child: Center(
                              //                                                         child: Text(
                              //                                                           "Continue",
                              //                                                           style: TextStyle(
                              //                                                             color: CustomColors.white,
                              //                                                             fontFamily: "Rubik",
                              //                                                             fontStyle: FontStyle.normal,
                              //                                                             fontWeight: FontWeight.w500,
                              //                                                             fontSize: 18,
                              //                                                           ),
                              //                                                         ),
                              //                                                       ),
                              //                                                     ),
                              //                                                   ),
                              //                                                   const SizedBox(
                              //                                                     height: 30,
                              //                                                   ),
                              //                                                 ],
                              //                                               ),
                              //                                             ),
                              //                                           ],
                              //                                         ),
                              //                                       ),
                              //                                     );
                              //                                   },
                              //                                 );
                              //                               }
                              //                             },
                              //                             child: Container(
                              //                               width: MediaQuery.of(context).size.width,
                              //                               height: 54,
                              //                               decoration: BoxDecoration(
                              //                                 color: CustomColors.primaryColor,
                              //                                 borderRadius: BorderRadius.circular(10),
                              //                               ),
                              //                               child: Center(
                              //                                 child: Text(
                              //                                   "Continue",
                              //                                   style: TextStyle(
                              //                                     color: CustomColors.white,
                              //                                     fontFamily: "Rubik",
                              //                                     fontStyle: FontStyle.normal,
                              //                                     fontWeight: FontWeight.w500,
                              //                                     fontSize: 18,
                              //                                   ),
                              //                                 ),
                              //                               ),
                              //                             ),
                              //                           ),
                              //                           const SizedBox(
                              //                             height: 30,
                              //                           ),
                              //                         ],
                              //                       ),
                              //                     ),
                              //                   ],
                              //                 ),
                              //               ),
                              //             );
                              //           },
                              //         );
                              //       },
                              //       child: Padding(
                              //         padding: const EdgeInsets.only(top: 8.0),
                              //         child: SizedBox(
                              //           width: 105 * fem,
                              //           height: 17 * fem,
                              //           child: Text(
                              //             'Forgor password',
                              //             style: TextStyle(
                              //               fontFamily: 'Rubik',
                              //               fontSize: 14 * ffem,
                              //               fontWeight: FontWeight.w400,
                              //               height: 1.185 * ffem / fem,
                              //               letterSpacing: -0.3000000119 * fem,
                              //               color: const Color(0xffffffff),
                              //             ),
                              //           ),
                              //         ),
                              //       ),
                              //     ),
                              //   ),
                              // ),
                            ],
                          ),
                        ),
                        // Need help logging in
                        Container(
                          margin: EdgeInsets.fromLTRB(
                            16 * fem,
                            12 * fem,
                            0 * fem,
                            49.5 * fem,
                          ),
                          child: Text(
                            'Need help logging in?',
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              fontStyle: FontStyle.italic,
                              fontSize: 16 * ffem,
                              fontWeight: FontWeight.w500,
                              height: 1.2575 * ffem / fem,
                              color: const Color(0xff131313),
                            ),
                          ),
                        ),
                        // Don’t have an account
                        Container(
                          margin: EdgeInsets.fromLTRB(0 * fem, 0 * fem, 0 * fem, 0 * fem),
                          child: RichText(
                            text: TextSpan(
                              style: TextStyle(
                                fontFamily: 'Poppins',
                                fontSize: 16 * ffem,
                                fontWeight: FontWeight.w400,
                                height: 1.1849999428 * ffem / fem,
                                color: const Color(0xff201e1d),
                              ),
                              children: [
                                TextSpan(
                                  text: 'Don’t have an account?',
                                  style: TextStyle(
                                    fontFamily: 'Poppins',
                                    fontStyle: FontStyle.italic,
                                    fontSize: 16 * ffem,
                                    fontWeight: FontWeight.w400,
                                    height: 1.2575 * ffem / fem,
                                    color: const Color(0xff201e1d),
                                  ),
                                ),
                                TextSpan(
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = () {
                                      Navigator.pushNamed(context, "sign-up");
                                    },
                                  text: ' Register here',
                                  style: TextStyle(
                                    fontFamily: 'Rubik',
                                    fontSize: 16 * ffem,
                                    fontWeight: FontWeight.w700,
                                    height: 1.185 * ffem / fem,
                                    color: const Color(0xff201e1d),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
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
