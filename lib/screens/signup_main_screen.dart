// ignore_for_file: must_be_immutable, unused_local_variable, prefer_typing_uninitialized_variables, use_build_context_synchronously, deprecated_member_use

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:island_app/models/register_model.dart';
import 'package:island_app/carereceiver/utils/colors.dart';
import 'package:island_app/res/app_url.dart';
import 'package:island_app/screens/verify_email.dart';
import 'package:island_app/utils/utils.dart';
import 'package:island_app/widgets/custom_text_field.dart';
import 'package:island_app/widgets/progress_dialog.dart';
// import 'package:pinput/pinput.dart';
// import 'package:easy_localization/easy_localization.dart' hide TextDirection;
// import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

// import 'dart:ui';
class SignupScreen extends StatefulWidget {
  bool? isSelectedService = false;

  SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _signUpFormKey = GlobalKey<FormState>();
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneNumController = TextEditingController();
  final TextEditingController dobController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController cpasswordController = TextEditingController();

  String? _isSelectedService = "3";
  var service = "Caregiver";
// Show/Hide
  bool _showPassword = false;
  void _togglevisibility() {
    setState(() {
      _showPassword = !_showPassword;
    });
  }

  bool _cshowPassword = false;
  void _ctogglevisibility() {
    setState(() {
      _cshowPassword = !_cshowPassword;
    });
  }

// DatePicker
  var getPickedDate;
  DateTime? selectedDate = DateTime.now();
  var myFormat = DateFormat('d-MM-yyyy');
  _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate!,
      firstDate: DateTime(1930),
      lastDate: DateTime(2050),
      initialDatePickerMode: DatePickerMode.day,
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: ColorScheme.fromSwatch(
              primarySwatch: Colors.teal,
              primaryColorDark: CustomColors.primaryColor,
              accentColor: const Color(0xff55CE86),
            ),
            dialogBackgroundColor: Colors.white,
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      dobController.text = DateFormat('yyyy-MM-dd').format(picked);
      // print(dobController.text);
      // print("picked $picked");
      // picked == dobController;
      // print("controller ${dobController.text}");
      setState(() {
        getPickedDate == picked;
      });

      // print("GetPickedDate $getPickedDate");
    }
  }

  var _isRadioSelected = "0";
  void _toggleradio() {
    if (_isRadioSelected == "0") {
      setState(() {
        _isRadioSelected = "1";
      });
    } else {
      {
        setState(() {
          _isRadioSelected = "0";
        });
      }
    }
  }

  final pinController = TextEditingController();
  final pinfocusNode = FocusNode();
  final pinformKey = GlobalKey<FormState>();

  // Services API
  String? selectedService;

  final String url = AppUrl.services;

  List? data = []; //edited line

  Future<String> getSWData() async {
    var res = await Dio().get(
      url,
      options: Options(
        headers: {
          'Accept': 'application/json',
        },
      ),
    );
    Map<String, dynamic> resBody = res.data;
    // Map<String, dynamic> map = json.decode(response.body);
    List<dynamic> serviceData = resBody["services"];
    // print(data![0]["name"]);

    setState(() {
      data = serviceData;
    });

    // print(resBody);

    return "Sucess";
  }

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

  Future<Response> postRegister(RegisterModel model) async {
    showProgress(context);
    try {
      var formData = FormData.fromMap(model.toJson());
      final response = await Dio().post(
        SessionUrl.register,
        data: formData,
        options: Options(
          headers: {
            'Accept': 'application/json',
          },
        ),
      );
      hideProgress();
      return response;
    } on DioError catch (e) {
      // print(e.response!.data);
      hideProgress();
      return Response(requestOptions: RequestOptions(), statusCode: 500, data: e.response!.data);
    }
  }

  @override
  void initState() {
    super.initState();
    // _isSelectedService = widget.isSelectedService;
    getSWData();
  }

  @override
  void dispose() {
    super.dispose();
    firstNameController.dispose();
    lastNameController.dispose();
    emailController.dispose();
    phoneNumController.dispose();
    dobController.dispose();
    passwordController.dispose();
    pinController.dispose();
    pinfocusNode.dispose();
    cpasswordController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // const focusedBorderColor = Color.fromRGBO(23, 171, 144, 1);
    // const fillColor = Color.fromRGBO(243, 246, 249, 0);
    // const borderColor = Color.fromRGBO(23, 171, 144, 0.4);
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
        appBar: AppBar(
          automaticallyImplyLeading: false,
          elevation: 0,
          backgroundColor: Colors.transparent,
          title: Text(
            "Join us to start searching",
            textAlign: TextAlign.center,
            style: TextStyle(
              color: CustomColors.primaryTextLight,
              fontFamily: "Poppins",
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          child: Form(
            key: _signUpFormKey,
            child: Container(
              padding: const EdgeInsets.all(15),
              child: Column(
                children: [
                  const SizedBox(
                    height: 20,
                  ),
                  CustomTextFieldWidget(
                    obsecure: false,
                    keyboardType: TextInputType.name,
                    controller: firstNameController,
                    hintText: "First Name",
                  ),
                  const SizedBox(height: 20),
                  CustomTextFieldWidget(
                    obsecure: false,
                    keyboardType: TextInputType.name,
                    controller: lastNameController,
                    hintText: "Last Name",
                  ),
                  const SizedBox(height: 20),
                  CustomTextFieldWidget(
                    obsecure: false,
                    keyboardType: TextInputType.emailAddress,
                    controller: emailController,
                    hintText: "Email",
                  ),
                  const SizedBox(height: 20),
                  CustomTextFieldWidget(
                    obsecure: false,
                    keyboardType: TextInputType.number,
                    controller: phoneNumController,
                    hintText: "Phone Number",
                  ),
                  const SizedBox(height: 20),
                  CustomTextFieldWidget(
                    obsecure: false,
                    keyboardType: TextInputType.number,
                    controller: dobController,
                    hintText: "DOB",
                    onTap: () async {
                      _selectDate(context);
                    },
                  ),
                  // Choose Service
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              _isSelectedService = "3";
                              // print(_isSelectedService);
                            });
                          },
                          child: Container(
                            height: 50.45,
                            // width: 149.49,
                            padding: const EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              color: _isSelectedService == "3" ? CustomColors.primaryColor : CustomColors.white,
                              borderRadius: BorderRadius.circular(8),
                              boxShadow: const [
                                BoxShadow(
                                  color: Color.fromARGB(15, 0, 0, 0),
                                  blurRadius: 4,
                                  spreadRadius: 4,
                                  offset: Offset(2, 2), // Shadow position
                                ),
                              ],
                            ),
                            child: TextButton.icon(
                              style: TextButton.styleFrom(splashFactory: NoSplash.splashFactory),
                              onPressed: () {
                                setState(() {
                                  _isSelectedService = "3";
                                  // print(_isSelectedService);
                                });
                              },
                              icon: Image.asset(
                                _isSelectedService == "3" ? "assets/images/icons/caregiverwhite.png" : "assets/images/icons/caregiver1.png",
                                scale: 1.0,
                                height: 24,
                                width: 24,
                                fit: BoxFit.contain,
                              ),
                              label: Text(
                                "i’m a Caregiver",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: _isSelectedService == "3" ? CustomColors.white : CustomColors.primaryText,
                                  fontFamily: "Rubik",
                                  fontSize: 12,
                                  fontWeight: FontWeight.w300,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 15,
                      ),
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              _isSelectedService = "4";
                              // print(_isSelectedService);
                            });
                          },
                          child: Container(
                            height: 50.45,
                            // width: 149.49,
                            padding: const EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              color: _isSelectedService == "4" ? CustomColors.primaryColor : CustomColors.white,
                              borderRadius: BorderRadius.circular(8),
                              boxShadow: const [
                                BoxShadow(
                                  color: Color.fromARGB(15, 0, 0, 0),
                                  blurRadius: 4,
                                  spreadRadius: 4,
                                  offset: Offset(2, 2),
                                ),
                              ],
                            ),
                            child: TextButton.icon(
                              style: TextButton.styleFrom(splashFactory: NoSplash.splashFactory),
                              onPressed: () {
                                setState(() {
                                  _isSelectedService = "4";
                                  // print(_isSelectedService);
                                });
                              },
                              icon: Image.asset(
                                _isSelectedService == "4" ? "assets/images/icons/carereceiverwhite.png" : "assets/images/icons/caregiver-Rpng2.png",
                                scale: 1.0,
                                height: 24,
                                width: 24,
                                fit: BoxFit.contain,
                              ),
                              label: Text(
                                "i’m a Carereceiver",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: _isSelectedService == "4" ? CustomColors.white : CustomColors.primaryText,
                                  fontFamily: "Rubik",
                                  fontSize: 12,
                                  fontWeight: FontWeight.w300,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Center(
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        color: Colors.transparent,
                        border: Border.all(color: const Color(0xff677294), width: 0.5),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 4,
                        ),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton(
                            hint: const Text("Services You Provide"),
                            isExpanded: true,
                            items: data!.map((item) {
                              return DropdownMenuItem(
                                value: item['id'].toString(),
                                child: Text(item['name']),
                              );
                            }).toList(),
                            onChanged: (newVal) {
                              setState(() {
                                selectedService = newVal;
                                // print(selectedService);
                              });
                            },
                            value: selectedService,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  CustomTextFieldWidget(
                    obsecure: !_showPassword,
                    controller: passwordController,
                    hintText: "Password",
                    sufIcon: GestureDetector(
                      onTap: () {
                        _togglevisibility();
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: Icon(
                          _showPassword ? Icons.visibility : Icons.visibility_off,
                          size: 22,
                          color: CustomColors.darkGrey,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  CustomTextFieldWidget(
                    obsecure: !_cshowPassword,
                    controller: cpasswordController,
                    hintText: "Confirm Password",
                    sufIcon: GestureDetector(
                      onTap: () {
                        _ctogglevisibility();
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: Icon(
                          _cshowPassword ? Icons.visibility : Icons.visibility_off,
                          size: 22,
                          color: CustomColors.darkGrey,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(
                    height: 30,
                  ),
                  TextButton.icon(
                    style: TextButton.styleFrom(splashFactory: NoSplash.splashFactory),
                    onPressed: () {
                      _toggleradio();
                      // print(_isRadioSelected);
                    },
                    icon: CircleAvatar(
                      backgroundColor: const Color.fromARGB(181, 171, 171, 171),
                      radius: 8,
                      child: CircleAvatar(
                        radius: 4,
                        backgroundColor: _isRadioSelected == "1" ? CustomColors.primaryText : const Color.fromARGB(181, 171, 171, 171),
                      ),
                    ),
                    label: Text(
                      "I agree with the Terms of Service & Privacy Policy",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: CustomColors.primaryText,
                        fontFamily: "Rubik",
                        fontStyle: FontStyle.normal,
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  GestureDetector(
                    onTap: () {
                      if (firstNameController.text.isEmpty) {
                        customErrorSnackBar(
                          context,
                          "Please Enter First Name",
                        );
                      } else if (lastNameController.text.isEmpty) {
                        customErrorSnackBar(
                          context,
                          "Please Enter Last Name",
                        );
                      } else if (emailController.text.isEmpty) {
                        customErrorSnackBar(
                          context,
                          "Please Enter Email",
                        );
                      } else if (passwordController.text.isEmpty) {
                        customErrorSnackBar(
                          context,
                          "Please Enter Password",
                        );
                      } else if (passwordController.text.length < 7) {
                        customErrorSnackBar(
                          context,
                          "Please Enter 8 digit Password",
                        );
                      } else if (cpasswordController.text.isEmpty) {
                        customErrorSnackBar(
                          context,
                          "Please Enter 8 digit Password",
                        );
                      } else if (cpasswordController.text != passwordController.text) {
                        customErrorSnackBar(
                          context,
                          "Password Not Match",
                        );
                      } else if (dobController.text.isEmpty) {
                        customErrorSnackBar(
                          context,
                          "Please Enter Date of Birth",
                        );
                      } else if (phoneNumController.text.isEmpty) {
                        customErrorSnackBar(
                          context,
                          "Please Enter Phone Number",
                        );
                      } else if (_isSelectedService == null) {
                        customErrorSnackBar(
                          context,
                          "Please Select Service ",
                        );
                      } else if (selectedService == null) {
                        customErrorSnackBar(
                          context,
                          "Please Select Services You Provide ",
                        );
                      } else if (_isRadioSelected == "0") {
                        customErrorSnackBar(
                          context,
                          "Please Select Terms of Services & Privacy Policy",
                        );
                      } else {
                        if (_signUpFormKey.currentState!.validate()) {
                          var request = RegisterModel(
                            firstName: firstNameController.text.toString(),
                            lastName: lastNameController.text.toString(),
                            email: emailController.text.toString(),
                            date: dobController.text.toString(),
                            password: passwordController.text.toString(),
                            passwordConfirmation: cpasswordController.text.toString(),
                            phone: phoneNumController.text.toString(),
                            role: _isSelectedService.toString(),
                            service: selectedService.toString(),
                          );
                          postRegister(request).then((response) async {
                            // print(jsonDecode(response.body));
                            if (response.statusCode == 200) {
                              var data = response.data;
                              var role = data["user"]["role"];
                              var status = data["user"]["status"];
                              var token = data["token"];
                              var avatar = data["user"]["avatar"];
                              var userId = data["user"]['id'];
                              var name = data["user"]['first_name'];
                              var last = data["user"]['last_name'];
                              var isProfileCompleted = data["is_profile_completed"];

                              // print("User role ${data["user"]["role"]}");
                              // print("User status $status");
                              // print("User token $token");
                              // print("Signup user data $data");

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
                                    await pref.setString('userToken', data["token"].toString());
                                    await pref.setString('userAvatar', avatar.toString());
                                    await pref.setString('userId', userId.toString());
                                    await pref.setString('userName', "$name $last");
                                    await pref.setString('isProfileCompleted', isProfileCompleted.toString());

                                    Navigator.pushNamedAndRemoveUntil(
                                      context,
                                      'bottom-bar-giver-2',
                                      (route) => false,
                                    );
                                  } else {
                                    Navigator.pushNamedAndRemoveUntil(
                                      context,
                                      'bottom-bar-giver',
                                      (route) => false,
                                    );

                                    SharedPreferences pref = await SharedPreferences.getInstance();
                                    await pref.setString('userRole', data["user"]["role"].toString());
                                    await pref.setString('userToken', data["token"].toString());
                                    await pref.setString('userStatus', status.toString());
                                    await pref.setString('userId', userId.toString());
                                    await pref.setString('userAvatar', avatar.toString());
                                    await pref.setString('userName', "$name $last");
                                    await pref.setString('isProfileCompleted', isProfileCompleted.toString());
                                  }
                                } else if (data["user"]["role"] == 4) {
                                  if (data["user"]["status"] == 0) {
                                    SharedPreferences pref = await SharedPreferences.getInstance();
                                    await pref.setString('userStatus', status.toString());
                                    await pref.setString('userToken', data["token"].toString());
                                    await pref.setString('userId', userId.toString());
                                    await pref.setString('userAvatar', avatar.toString());
                                    await pref.setString('userTokenProfile', data["token"].toString());
                                    await pref.setString('userName', "$name $last");
                                    await pref.setString('isProfileCompleted', isProfileCompleted.toString());
                                    Navigator.pushNamedAndRemoveUntil(
                                      context,
                                      'bottom-bar-2',
                                      (route) => false,
                                    );
                                  } else {
                                    Navigator.pushNamedAndRemoveUntil(
                                      context,
                                      'bottom-bar',
                                      (route) => false,
                                    );

                                    SharedPreferences pref = await SharedPreferences.getInstance();
                                    await pref.setString('userRole', data["user"]["role"].toString());
                                    await pref.setString('userToken', data["token"].toString());
                                    await pref.setString('userStatus', status.toString());
                                    await pref.setString('userId', userId.toString());
                                    await pref.setString('userAvatar', avatar.toString());
                                    await pref.setString('userName', "$name $last");
                                    await pref.setString('isProfileCompleted', isProfileCompleted.toString());
                                  }
                                }
                              }
                              // if(response.body.["user"]){}
                            } else {
                              customErrorSnackBar(
                                context,
                                response.data['message'],
                              );
                            }
                          });
                        }
                      }
                      // if (_signUpFormKey.currentState!.validate()) {

                      // signInUser();
                      // OTP Dailogs
                      // showModalBottomSheet(
                      //   isScrollControlled: true,
                      //   context: context,
                      //   backgroundColor: Colors.white,
                      //   shape: const RoundedRectangleBorder(
                      //     borderRadius: BorderRadius.only(
                      //       topLeft: Radius.circular(30.0),
                      //       topRight: Radius.circular(30.0),
                      //     ),
                      //   ),
                      //   builder: (context) {
                      //     return Padding(
                      //       padding: EdgeInsets.only(
                      //           bottom:
                      //               MediaQuery.of(context).viewInsets.bottom),
                      //       child: Container(
                      //         padding:
                      //             const EdgeInsets.symmetric(horizontal: 25),
                      //         child: Column(
                      //           crossAxisAlignment: CrossAxisAlignment.start,
                      //           mainAxisAlignment: MainAxisAlignment.center,
                      //           mainAxisSize: MainAxisSize.min,
                      //           children: [
                      //             const SizedBox(
                      //               height: 20,
                      //             ),
                      //             Center(
                      //               child: Container(
                      //                 width: 130,
                      //                 height: 5,
                      //                 decoration: BoxDecoration(
                      //                   color: const Color(0xffC4C4C4),
                      //                   borderRadius:
                      //                       BorderRadius.circular(6),
                      //                 ),
                      //               ),
                      //             ),
                      //             const SizedBox(
                      //               height: 50,
                      //             ),
                      //             Center(
                      //               child: Text(
                      //                 "Enter 4 Digits Code",
                      //                 textAlign: TextAlign.center,
                      //                 style: TextStyle(
                      //                   color: CustomColors.black,
                      //                   fontFamily: "Rubik",
                      //                   fontStyle: FontStyle.normal,
                      //                   fontSize: 24,
                      //                   fontWeight: FontWeight.w600,
                      //                 ),
                      //               ),
                      //             ),
                      //             const SizedBox(
                      //               height: 10,
                      //             ),
                      //             Center(
                      //               child: Text(
                      //                 "Enter the 4 digits code that you received on your email.",
                      //                 textAlign: TextAlign.center,
                      //                 style: TextStyle(
                      //                   color: CustomColors.primaryText,
                      //                   fontFamily: "Rubik",
                      //                   fontStyle: FontStyle.normal,
                      //                   fontSize: 14,
                      //                   fontWeight: FontWeight.w400,
                      //                 ),
                      //               ),
                      //             ),
                      //             const SizedBox(
                      //               height: 30,
                      //             ),
                      //             Form(
                      //               key: pinformKey,
                      //               child: Column(
                      //                 mainAxisAlignment:
                      //                     MainAxisAlignment.center,
                      //                 children: [
                      //                   Directionality(
                      //                     // Specify direction if desired1
                      //                     textDirection: ui.TextDirection.ltr,
                      //                     child: Center(
                      //                       child: Pinput(
                      //                         closeKeyboardWhenCompleted:
                      //                             true,
                      //                         mainAxisAlignment:
                      //                             MainAxisAlignment
                      //                                 .spaceAround,
                      //                         controller: pinController,
                      //                         focusNode: pinfocusNode,
                      //                         androidSmsAutofillMethod:
                      //                             AndroidSmsAutofillMethod
                      //                                 .smsUserConsentApi,
                      //                         listenForMultipleSmsOnAndroid:
                      //                             true,
                      //                         defaultPinTheme:
                      //                             defaultPinTheme,
                      //                         validator: (value) {
                      //                           return value == '2222'
                      //                               ? null
                      //                               : 'Pin is incorrect';
                      //                         },
                      //                         // onClipboardFound: (value) {
                      //                         //   debugPrint('onClipboardFound: $value');
                      //                         //   pinController.setText(value);
                      //                         // },
                      //                         hapticFeedbackType:
                      //                             HapticFeedbackType
                      //                                 .lightImpact,
                      //                         onCompleted: (pin) {
                      //                           debugPrint(
                      //                               'onCompleted: $pin');
                      //                         },
                      //                         onChanged: (value) {
                      //                           debugPrint(
                      //                               'onChanged: $value');
                      //                         },
                      //                         cursor: Column(
                      //                           mainAxisAlignment:
                      //                               MainAxisAlignment.end,
                      //                           children: [
                      //                             Container(
                      //                               margin:
                      //                                   const EdgeInsets.only(
                      //                                       bottom: 9),
                      //                               width: 22,
                      //                               height: 1,
                      //                               color: focusedBorderColor,
                      //                             ),
                      //                           ],
                      //                         ),
                      //                         focusedPinTheme:
                      //                             defaultPinTheme.copyWith(
                      //                           textStyle: TextStyle(
                      //                             fontSize: 26,
                      //                             color: CustomColors.otpText,
                      //                             fontStyle: FontStyle.normal,
                      //                             fontWeight: FontWeight.w700,
                      //                           ),
                      //                           decoration: defaultPinTheme
                      //                               .decoration!
                      //                               .copyWith(
                      //                             borderRadius:
                      //                                 BorderRadius.circular(
                      //                                     12),
                      //                             border: Border.all(
                      //                                 color:
                      //                                     focusedBorderColor),
                      //                           ),
                      //                         ),
                      //                         submittedPinTheme:
                      //                             defaultPinTheme.copyWith(
                      //                           decoration: defaultPinTheme
                      //                               .decoration!
                      //                               .copyWith(
                      //                             color: fillColor,
                      //                             borderRadius:
                      //                                 BorderRadius.circular(
                      //                                     12),
                      //                             border: Border.all(
                      //                                 color:
                      //                                     focusedBorderColor),
                      //                           ),
                      //                         ),
                      //                         errorPinTheme: defaultPinTheme
                      //                             .copyBorderWith(
                      //                           border: Border.all(
                      //                               color: Colors.redAccent),
                      //                         ),
                      //                       ),
                      //                     ),
                      //                   ),
                      //                   const SizedBox(
                      //                     height: 20,
                      //                   ),
                      //                   GestureDetector(
                      //                     onTap: () {
                      //                       if (pinformKey.currentState!
                      //                           .validate()) {
                      //                         Navigator.push(
                      //                           context,
                      //                           MaterialPageRoute(
                      //                             builder: (context) =>
                      //                                 const LoginScreen(),
                      //                           ),
                      //                         );
                      //                       }
                      //                     },
                      //                     child: Container(
                      //                       width: MediaQuery.of(context)
                      //                           .size
                      //                           .width,
                      //                       height: 54,
                      //                       decoration: BoxDecoration(
                      //                         color:
                      //                             CustomColors.primaryColor,
                      //                         borderRadius:
                      //                             BorderRadius.circular(10),
                      //                       ),
                      //                       child: Center(
                      //                         child: Text(
                      //                           "Continue",
                      //                           style: TextStyle(
                      //                             color: CustomColors.white,
                      //                             fontFamily: "Rubik",
                      //                             fontStyle: FontStyle.normal,
                      //                             fontWeight: FontWeight.w500,
                      //                             fontSize: 18,
                      //                           ),
                      //                         ),
                      //                       ),
                      //                     ),
                      //                   ),
                      //                   const SizedBox(
                      //                     height: 30,
                      //                   ),
                      //                 ],
                      //               ),
                      //             ),
                      //           ],
                      //         ),
                      //       ),
                      //     );
                      //   },
                      // );
                      // }
                    },
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      height: 54,
                      decoration: BoxDecoration(
                        color: CustomColors.primaryColor,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Center(
                        child: Text(
                          "Signup",
                          style: TextStyle(
                            color: CustomColors.white,
                            fontFamily: "Rubik",
                            fontStyle: FontStyle.normal,
                            fontWeight: FontWeight.w500,
                            fontSize: 18,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(context, "login");
                    },
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width,
                      child: Text(
                        "Have an account? Log in",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: CustomColors.primaryColor,
                          fontFamily: "Rubik",
                          fontStyle: FontStyle.normal,
                          fontSize: 15,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
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
