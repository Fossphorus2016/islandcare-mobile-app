// ignore_for_file: use_build_context_synchronously, unused_local_variable, non_constant_identifier_names

import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:island_app/carereceiver/utils/colors.dart';
import 'package:island_app/carereceiver/widgets/bottom_bar.dart';
import 'package:island_app/models/login_model.dart';
import 'package:island_app/providers/user_provider.dart';
import 'package:island_app/utils/app_url.dart';
import 'package:island_app/screens/splash_screen.dart';
import 'package:island_app/screens/verify_email.dart';
import 'package:island_app/utils/storage_service.dart';
import 'package:island_app/widgets/progress_dialog.dart';
import 'package:provider/provider.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:island_app/utils/utils.dart';

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
          headers: {"Content-Type": "application/json", "Accept": "application/json"},
          validateStatus: (status) => true,
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
    const focusedBorderColor = Color.fromRGBO(23, 171, 144, 1);
    const fillColor = Color.fromRGBO(243, 246, 249, 0);
    const borderColor = Color.fromRGBO(23, 171, 144, 0.4);

    // final defaultPinTheme = PinTheme(
    //   width: 56,
    //   height: 56,
    //   textStyle: TextStyle(
    //     fontSize: 26,
    //     color: CustomColors.otpText,
    //     fontStyle: FontStyle.normal,
    //     fontWeight: FontWeight.w700,
    //   ),
    //   decoration: BoxDecoration(
    //     borderRadius: BorderRadius.circular(12),
    //     border: Border.all(color: CustomColors.hintText, width: 0.5),
    //   ),
    // );
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: SizedBox(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: Form(
              key: _signInFormKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    decoration: const BoxDecoration(
                      image: DecorationImage(
                        fit: BoxFit.cover,
                        alignment: Alignment.bottomCenter,
                        image: AssetImage('assets/images/loginBg.png'),
                      ),
                    ),
                    width: MediaQuery.of(context).size.width,
                    padding: const EdgeInsets.fromLTRB(40, 0, 40, 60),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // logo
                        SizedBox(
                          height: ResponsiveBreakpoints.of(context).isMobile ? 150 : 200,
                          child: Image.asset(
                            'assets/images/Logo-light.png',
                            fit: BoxFit.cover,
                          ),
                        ),
                        Text(
                          "Welcome",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: CustomColors.white,
                            fontFamily: "Rubik",
                            fontStyle: FontStyle.normal,
                            fontSize: MediaQuery.of(context).size.width > 460 ? 32 : 24,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 10),
                        // youcansearchcourseapplycoursea
                        Text(
                          'You can search course, apply course \nand find caregiver',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontFamily: 'Rubik',
                            fontSize: MediaQuery.of(context).size.width > 460 ? 24 : 16,
                            fontWeight: FontWeight.w400,
                            color: const Color(0xffffffff),
                          ),
                        ),
                        const SizedBox(height: 20),
                        // Login Fields
                        TextFormField(
                          controller: emailController,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return customErrorSnackBar(context, "Please Enter Email");
                            }
                            if (!RegExp("^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+.[a-z]").hasMatch(value)) {
                              return customErrorSnackBar(context, "Please Enter Email");
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
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: const BorderSide(
                                style: BorderStyle.solid,
                                color: Colors.white,
                              ),
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: const BorderSide(
                                style: BorderStyle.solid,
                                color: Colors.white,
                              ),
                            ),
                            prefixIcon: Icon(
                              Icons.mail_outline,
                              color: CustomColors.white,
                            ),
                            hintText: "Email",
                            hintStyle: TextStyle(
                              fontFamily: 'Calibri',
                              fontWeight: FontWeight.w400,
                              color: CustomColors.white,
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        // Password TextField
                        TextFormField(
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
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: const BorderSide(
                                style: BorderStyle.solid,
                                color: Colors.white,
                              ),
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: const BorderSide(
                                style: BorderStyle.solid,
                                color: Colors.white,
                                // color: Color(0xff938284),
                              ),
                            ),
                            prefixIcon: Icon(
                              Icons.lock_outline,
                              color: CustomColors.white,
                            ),
                            suffixIcon: GestureDetector(
                              onTap: () {
                                _togglevisibility();
                              },
                              child: Padding(
                                padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                                child: Icon(
                                  _showPassword ? Icons.visibility : Icons.visibility_off,
                                  color: CustomColors.white,
                                ),
                              ),
                            ),
                            hintText: "Password",
                            hintStyle: TextStyle(
                              fontFamily: 'Calibri',
                              fontWeight: FontWeight.w400,
                              color: CustomColors.white,
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        // Login btn
                        GestureDetector(
                          onTap: () {
                            if (emailController.text.isEmpty) {
                              customErrorSnackBar(context, "Please Enter Email");
                            } else if (passwordController.text.isEmpty) {
                              customErrorSnackBar(context, "Please Enter Password");
                            } else if (passwordController.text.length < 3) {
                              customErrorSnackBar(context, "Please Enter 3 digit Password");
                            } else {
                              if (_signInFormKey.currentState!.validate()) {
                                var request = LoginModel(
                                  email: emailController.text.toString(),
                                  password: passwordController.text.toString(),
                                );
                                postLogin(request).then((response) async {
                                  // print(response.data);
                                  if (response.statusCode == 200) {
                                    var data = response.data;
                                    var role = data["user"]["role"];
                                    var status = data["user"]["status"];
                                    var token = data["token"];
                                    // var isProfileCompleted = data["is_profile_completed"];
                                    var userId = data["user"]['id'];
                                    var avatar = data["user"]['avatar'];
                                    var name = data["user"]['first_name'];
                                    var last = data["user"]['last_name'];

                                    if (status == 3) {
                                      customErrorSnackBar(context, "User Blocked");
                                    } else {
                                      if (data["user"]["email_verified_at"] == null) {
                                        Navigator.pushReplacement(
                                          context,
                                          MaterialPageRoute(builder: (context) => VerifyEmail(token: data["token"])),
                                        );
                                      } else if (data["user"]["role"] == 3) {
                                        await storageService.writeSecureData('userRole', data["user"]["role"].toString());
                                        await storageService.writeSecureData('userToken', data["token"].toString());
                                        await storageService.writeSecureData('userStatus', status.toString());
                                        await storageService.writeSecureData('userId', userId.toString());
                                        await storageService.writeSecureData('userAvatar', avatar.toString());
                                        await storageService.writeSecureData('userName', "$name $last");
                                        Navigator.push(context, MaterialPageRoute(builder: (context) => const SplashScreen()));

                                        Provider.of<RecieverUserProvider>(context, listen: false).getUserToken();
                                      } else if (data["user"]["role"] == 4) {
                                        if (data["user"]["status"] == 0) {
                                          await storageService.writeSecureData('userStatus', status.toString());
                                          await storageService.writeSecureData('userToken', data["token"].toString());
                                          await storageService.writeSecureData('userAvatar', avatar.toString());
                                          await storageService.writeSecureData('userId', userId.toString());
                                          await storageService.writeSecureData('userName', "$name $last");

                                          Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => BottomBar(data: data['token'].toString())), (route) => false);
                                        } else {
                                          await storageService.writeSecureData('userRole', data["user"]["role"].toString());
                                          await storageService.writeSecureData('userToken', data["token"].toString());
                                          await storageService.writeSecureData('userStatus', status.toString());
                                          await storageService.writeSecureData('userId', userId.toString());
                                          await storageService.writeSecureData('userAvatar', avatar.toString());
                                          await storageService.writeSecureData('userName', "$name $last");
                                          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const SplashScreen()));
                                        }
                                        Provider.of<RecieverUserProvider>(context, listen: false).getUserToken();
                                      }
                                    }
                                  } else {
                                    customErrorSnackBar(context, "Bad Credentials");
                                  }
                                });
                              }
                            }
                          },
                          child: Container(
                            width: 220,
                            height: 60,
                            decoration: BoxDecoration(
                              color: const Color(0xffffffff),
                              borderRadius: BorderRadius.circular(15),
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
                                'Log In',
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
                      ],
                    ),
                  ),
                  Expanded(
                    child: Column(
                      children: [
                        // Need help logging in
                        Text(
                          'Need help logging in?',
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontStyle: FontStyle.italic,
                            fontSize: MediaQuery.of(context).size.width > 460 ? 24 : 16,
                            fontWeight: FontWeight.w500,
                            height: 3.2575,
                            color: const Color(0xff131313),
                          ),
                        ),
                        // Don’t have an account
                        RichText(
                          text: TextSpan(
                            style: const TextStyle(
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w400,
                              color: Color(0xff201e1d),
                            ),
                            children: [
                              TextSpan(
                                text: 'Don’t have an account?',
                                style: TextStyle(
                                  fontFamily: 'Poppins',
                                  fontStyle: FontStyle.italic,
                                  fontSize: MediaQuery.of(context).size.width > 460 ? 24 : 16,
                                  fontWeight: FontWeight.w400,
                                  color: const Color(0xff201e1d),
                                ),
                              ),
                              TextSpan(
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () {
                                    Navigator.pushNamed(context, "/sign-up");
                                  },
                                text: ' Register here',
                                style: TextStyle(
                                  fontFamily: 'Rubik',
                                  fontSize: MediaQuery.of(context).size.width > 460 ? 24 : 16,
                                  fontWeight: FontWeight.w700,
                                  color: const Color(0xff201e1d),
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
        ),
      ),
    );
  }
}
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