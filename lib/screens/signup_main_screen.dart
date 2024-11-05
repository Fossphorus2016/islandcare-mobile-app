// ignore_for_file: must_be_immutable, unused_local_variable, prefer_typing_uninitialized_variables, use_build_context_synchronously, deprecated_member_use

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:island_app/models/register_model.dart';
import 'package:island_app/carereceiver/utils/colors.dart';
import 'package:island_app/utils/app_url.dart';
import 'package:island_app/utils/functions.dart';
import 'package:island_app/utils/http_handlers.dart';
import 'package:island_app/utils/navigation_service.dart';
import 'package:island_app/utils/routes_name.dart';
import 'package:island_app/utils/storage_service.dart';
import 'package:island_app/widgets/custom_text_field.dart';
import 'package:island_app/widgets/loading_button.dart';

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

  bool _isDateSelectable(DateTime date) {
    // Disable dates before today
    return date.isBefore(DateTime.now());
  }

  _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate!,
      firstDate: DateTime(1975),
      lastDate: DateTime.now(),
      selectableDayPredicate: _isDateSelectable,
      initialDatePickerMode: DatePickerMode.day,
      initialEntryMode: DatePickerEntryMode.calendarOnly,
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: ColorScheme.fromSwatch(
              primarySwatch: Colors.teal,
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

      setState(() {
        getPickedDate == picked;
      });
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
    List<dynamic> serviceData = resBody["services"];

    setState(() {
      data = serviceData;
    });

    return "Sucess";
  }

  @override
  void initState() {
    super.initState();
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

  var errors;

  @override
  Widget build(BuildContext context) {
    // print(errors);
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
                  const SizedBox(height: 20),
                  CustomTextFieldWidget(
                    obsecure: false,
                    keyboardType: TextInputType.name,
                    controller: firstNameController,
                    hintText: "First Name",
                    validation: (val) {
                      if (val == null || val.isEmpty) {
                        return 'Enter your First Name';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  CustomTextFieldWidget(
                    obsecure: false,
                    keyboardType: TextInputType.name,
                    controller: lastNameController,
                    hintText: "Last Name",
                    validation: (val) {
                      if (val == null || val.isEmpty) {
                        return 'Enter your Last Name';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  CustomTextFieldWidget(
                    obsecure: false,
                    keyboardType: TextInputType.emailAddress,
                    controller: emailController,
                    hintText: "Email",
                    validation: (val) {
                      if (val == null || val.isEmpty) {
                        return 'Enter your Email';
                      } else if (!val.contains(RegExp(r'^[a-zA-Z0-9._-]+@[a-zA-Z0-9.-]+\.[a-z]'))) {
                        return 'Please Enter Email Properly';
                      }
                      return null;
                    },
                  ),
                  if (errors != null && errors['email'] != null) ...[
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: Text(
                          errors['email'][0].toString(),
                          style: TextStyle(
                            color: CustomColors.red,
                          ),
                        ),
                      ),
                    ),
                  ],
                  const SizedBox(height: 20),
                  CustomTextFieldWidget(
                    obsecure: false,
                    keyboardType: TextInputType.number,
                    controller: phoneNumController,
                    hintText: "Phone Number (e.g: 1650251531)",
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                      LengthLimitingTextInputFormatter(10),
                    ],
                    validation: (val) {
                      if (val == null || val.isEmpty) {
                        return 'Enter your Phone Number';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  InkWell(
                    onTap: () {
                      _selectDate(context);
                    },
                    child: Container(
                      height: 54,
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey, width: 0.7),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      alignment: Alignment.centerLeft,
                      padding: const EdgeInsets.only(left: 12),
                      child: Text(
                        dobController.text.isEmpty ? "Date Of Birth" : dobController.text.toString(),
                        style: const TextStyle(
                          fontSize: 15,
                          color: Colors.black,
                          fontFamily: "Rubik",
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
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
                            });
                          },
                          child: Container(
                            height: 55.45,
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
                            });
                          },
                          child: Container(
                            height: 55.45,
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
                            hint: _isSelectedService == "4" ? const Text("Service You Require") : const Text("Services You Provide"),
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
                    validation: (value) {
                      if (value!.isEmpty) {
                        return 'please enter Password';
                      } else if (value.length < 8) {
                        return "The password field must be at least 8 characters";
                      } else if (!value.contains(RegExp(r"(?=.*\d)(?=.*[a-z])(?=.*[A-Z])(?=.*\W)"))) {
                        return 'please enter Capital letter, Special Character and Number';
                      }
                      return null;
                    },
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
                    validation: (p0) {
                      if (cpasswordController.text.isEmpty || passwordController.text != cpasswordController.text) {
                        return "Password dosn't Match";
                      }
                      return null;
                    },
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
                  const SizedBox(height: 20),
                  TextButton.icon(
                    style: TextButton.styleFrom(splashFactory: NoSplash.splashFactory),
                    onPressed: () {
                      _toggleradio();
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
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: CustomColors.primaryText,
                        fontFamily: "Rubik",
                        fontStyle: FontStyle.normal,
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  LoadingButton(
                    title: "Signup",
                    backgroundColor: CustomColors.primaryColor,
                    height: 54,
                    textStyle: TextStyle(
                      color: CustomColors.white,
                      fontFamily: "Rubik",
                      fontStyle: FontStyle.normal,
                      fontWeight: FontWeight.w500,
                      fontSize: 18,
                    ),
                    onPressed: () async {
                      if (!_signUpFormKey.currentState!.validate()) {
                      } else if (dobController.text.isEmpty) {
                        showErrorToast("Please Enter Date of Birth");
                      } else if (_isSelectedService == null) {
                        showErrorToast("Please Select Service ");
                      } else if (selectedService == null) {
                        showErrorToast("Please Select Services You Provide ");
                      } else if (_isRadioSelected == "0") {
                        showErrorToast("Please Select Terms of Services & Privacy Policy");
                      } else {
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

                        var formData = FormData.fromMap(request.toJson());
                        final response = await postRequesthandler(
                          url: SessionUrl.register,
                          formData: formData,
                        );

                        if (response.statusCode == 200) {
                          var data = response.data;
                          var role = data["user"]["role"];
                          var status = data["user"]["status"];
                          var token = data["token"];
                          var avatar = data["user"]["avatar"];
                          var userId = data["user"]['id'];
                          var name = data["user"]['first_name'];
                          var last = data["user"]['last_name'];

                          if (status == 3) {
                            showErrorToast("User Blocked");
                          } else {
                            if (data["user"]["email_verified_at"] == null) {
                              navigationService.pushReplacement(RoutesName.verifyEmail, arguments: {"token": data["token"]});
                            } else if (data["user"]["role"] == 3) {
                              await storageService.writeSecureData('userRole', data["user"]["role"].toString());
                              await storageService.writeSecureData('userToken', data["token"].toString());
                              await storageService.writeSecureData('userStatus', status.toString());
                              await storageService.writeSecureData('userId', userId.toString());
                              await storageService.writeSecureData('userAvatar', avatar.toString());
                              await storageService.writeSecureData('userName', "$name $last");

                              Navigator.pushNamedAndRemoveUntil(
                                context,
                                '/bottom-bar-giver',
                                (route) => false,
                              );
                            } else if (data["user"]["role"] == 4) {
                              await storageService.writeSecureData('userRole', data["user"]["role"].toString());
                              await storageService.writeSecureData('userToken', data["token"].toString());
                              await storageService.writeSecureData('userStatus', status.toString());
                              await storageService.writeSecureData('userId', userId.toString());
                              await storageService.writeSecureData('userAvatar', avatar.toString());
                              await storageService.writeSecureData('userName', "$name $last");

                              Navigator.pushNamedAndRemoveUntil(
                                context,
                                '/bottom-bar',
                                (route) => false,
                              );
                            }
                          }
                        } else {
                          setState(() {
                            errors = response.data['errors'];
                          });
                          showErrorToast(response.data['message']);
                        }
                      }
                      return false;
                    },
                  ),

                  const SizedBox(height: 10),
                  GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(context, "/login");
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
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class CustomTextInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    final StringBuffer newText = StringBuffer(newValue.text);

    // Always add a '+' sign at the beginning
    final String updatedText = newText.toString();
    final String finalText = updatedText.isNotEmpty && updatedText[0] != '+' ? '+$updatedText' : newText.toString();

    return TextEditingValue(
      text: finalText,
      selection: TextSelection.collapsed(offset: finalText.length),
    );
  }
}

class NumericRangeFormatter extends TextInputFormatter {
  final double min;
  final double max;

  NumericRangeFormatter({required this.min, required this.max});

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    if (newValue.text.isEmpty) {
      return newValue;
    }

    final newValueNumber = double.tryParse(newValue.text);

    if (newValueNumber == null) {
      return oldValue;
    }

    if (newValueNumber < min) {
      return newValue.copyWith(text: min.toString());
    } else if (newValueNumber > max) {
      return newValue.copyWith(text: max.toString());
    } else {
      return newValue;
    }
  }
}
