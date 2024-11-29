// ignore_for_file: must_be_immutable, unused_local_variable, prefer_typing_uninitialized_variables, use_build_context_synchronously, deprecated_member_use
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:island_app/carereceiver/utils/colors.dart';
import 'package:island_app/screens/terms_condition_screen.dart';
import 'package:island_app/utils/app_url.dart';
import 'package:island_app/utils/functions.dart';
import 'package:island_app/utils/http_handlers.dart';
import 'package:island_app/utils/navigation_service.dart';
import 'package:island_app/utils/routes_name.dart';
import 'package:island_app/utils/storage_service.dart';
import 'package:island_app/widgets/custom_text_field.dart';
import 'package:island_app/widgets/loading_button.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';

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
  List<String> selectedService = [];

  // final String url = AppUrl.services;

  List? allServices = []; //edited line

  Future<String> getSWData() async {
    var res = await Dio().get(
      AppUrl.services,
      options: Options(
        headers: {
          'Accept': 'application/json',
        },
      ),
    );
    Map<String, dynamic> resBody = res.data;
    List<dynamic> serviceData = resBody["services"];

    setState(() {
      allServices = serviceData;
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
  String phone = "";

  bool showDOBError = false;
  bool showServiceProvideSelectError = false;
  @override
  Widget build(BuildContext context) {
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
            child: Padding(
              padding: const EdgeInsets.all(15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),
                  const Text(
                    "First Name",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 05),
                  CustomTextFieldWidget(
                    obsecure: false,
                    keyboardType: TextInputType.name,
                    controller: firstNameController,
                    hintText: "First Name",
                    validation: (val) {
                      if (val == null || val.isEmpty) {
                        return 'Please enter your first name';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    "Last Name",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 05),
                  CustomTextFieldWidget(
                    obsecure: false,
                    keyboardType: TextInputType.name,
                    controller: lastNameController,
                    hintText: "Last Name",
                    validation: (val) {
                      if (val == null || val.isEmpty) {
                        return 'Please enter your last name';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    "Email",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 05),
                  CustomTextFieldWidget(
                    obsecure: false,
                    keyboardType: TextInputType.emailAddress,
                    controller: emailController,
                    hintText: "Email",
                    validation: (val) {
                      if (val == null || val.isEmpty) {
                        return 'Please enter your email';
                      } else if (!val.contains(RegExp(r'^[a-zA-Z0-9._-]+@[a-zA-Z0-9.-]+\.[a-z]'))) {
                        return 'Please enter email properly';
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
                  const Text(
                    "Phone",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 05),
                  IntlPhoneField(
                    showCountryFlag: true,
                    initialCountryCode: "BM",
                    controller: phoneNumController,
                    showDropdownIcon: false,
                    flagsButtonMargin: const EdgeInsets.symmetric(horizontal: 8),
                    textAlignVertical: TextAlignVertical.center,
                    dropdownIconPosition: IconPosition.leading,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    languageCode: "en",
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(08),
                      ),
                      contentPadding: EdgeInsets.zero,
                    ),
                    onChanged: (value) {
                      if (value.number.isNotEmpty) {
                        phone = "${value.countryCode}${value.number}";
                      } else {
                        phone = "";
                      }
                    },
                    keyboardType: const TextInputType.numberWithOptions(signed: true, decimal: true),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    "Date of Birth",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 05),
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
                        dobController.text.isEmpty ? "Date of Birth" : dobController.text.toString(),
                        style: const TextStyle(
                          fontSize: 15,
                          color: Colors.black,
                          fontFamily: "Rubik",
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                  ),
                  if (showDOBError) ...[
                    const SizedBox(height: 05),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: Text(
                          "Please select date of birth",
                          style: TextStyle(
                            color: CustomColors.red,
                          ),
                        ),
                      ),
                    ),
                  ],
                  // Choose Service
                  const SizedBox(height: 20),
                  const Text(
                    "Service",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 05),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              _isSelectedService = "3";
                              selectedService = [];
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
                                  selectedService = [];
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
                      const SizedBox(width: 15),
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              _isSelectedService = "4";
                              selectedService = [];
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
                                  selectedService = [];
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
                                "i’m Looking for Care",
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
                  _isSelectedService == "4"
                      ? const Text(
                          "Services You Require",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        )
                      : const Text(
                          "Service You Provide",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                  const SizedBox(height: 05),
                  if (_isSelectedService == "4") ...[
                    MultiSelectDialogField(
                      items: allServices!
                          .map(
                            (item) => MultiSelectItem(
                              item["id"].toString(),
                              item["name"],
                            ),
                          )
                          .toList(),
                      listType: MultiSelectListType.CHIP,
                      buttonIcon: const Icon(Icons.arrow_drop_down),
                      initialValue: selectedService,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(08),
                        border: Border.all(color: Colors.black, width: 0.5),
                      ),
                      searchHint: "Select Services You Require",
                      title: const Text(
                        "Select Services You Require",
                        style: TextStyle(fontSize: 18, color: Colors.black),
                      ),
                      buttonText: const Text(
                        "Select Services You Require",
                        style: TextStyle(fontSize: 14),
                      ),
                      confirmText: const Text("ok"),
                      cancelText: const Text("cancel"),
                      onConfirm: (values) {
                        setState(() {
                          selectedService = values;
                        });
                      },
                    ),
                  ] else ...[
                    Container(
                      width: MediaQuery.of(context).size.width,
                      height: 50,
                      alignment: Alignment.centerLeft,
                      decoration: BoxDecoration(
                        color: Colors.transparent,
                        border: Border.all(color: const Color(0xff677294), width: 0.5),
                        borderRadius: BorderRadius.circular(08),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton(
                          hint: const Text("Service You Provide"),
                          isExpanded: true,
                          items: allServices!.map((item) {
                            return DropdownMenuItem(
                              value: item['id'].toString(),
                              child: Text(item['name']),
                            );
                          }).toList(),
                          onChanged: (newVal) {
                            setState(() {
                              selectedService.clear();
                              selectedService.add(newVal.toString());
                            });
                          },
                          value: selectedService.isNotEmpty ? selectedService.first : null,
                        ),
                      ),
                    ),
                  ],
                  if (showServiceProvideSelectError) ...[
                    const SizedBox(height: 05),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: Text(
                          _isSelectedService == "4" ? "Please select services you Require" : "Please select service you Provide",
                          style: TextStyle(
                            color: CustomColors.red,
                          ),
                        ),
                      ),
                    ),
                  ],
                  const SizedBox(height: 20),
                  const Text(
                    "Password",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 05),
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
                  const Text(
                    "Confirm Password",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 05),
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
                  Row(
                    children: [
                      TextButton.icon(
                        style: TextButton.styleFrom(
                          splashFactory: NoSplash.splashFactory,
                          // backgroundColor: Colors.amber,
                          padding: const EdgeInsets.only(left: 10, bottom: 10, top: 10),
                        ),
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
                          "I agree",
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
                      const SizedBox(width: 05),
                      InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const TermsConditionScreen(),
                            ),
                          );
                        },
                        child: const Text(
                          "Terms and conditions.",
                          textAlign: TextAlign.center,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: Colors.blue,
                            fontFamily: "Rubik",
                            fontStyle: FontStyle.normal,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
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
                      _signUpFormKey.currentState?.save();
                      setState(() {
                        showDOBError = false;
                        showServiceProvideSelectError = false;
                      });
                      if (!_signUpFormKey.currentState!.validate()) {
                      } else if (dobController.text.isEmpty) {
                        showErrorToast("Please Enter Date of Birth");
                        setState(() {
                          showDOBError = true;
                        });
                      } else if (_isSelectedService == null) {
                        showErrorToast("Please Select Service ");
                      } else if (selectedService.isEmpty) {
                        setState(() {
                          showServiceProvideSelectError = true;
                        });
                        if (_isSelectedService == " 3") {
                          showErrorToast("Please Select Service You Provide");
                        } else {
                          showErrorToast("Please Select Service You Require");
                        }
                      } else if (_isRadioSelected == "0") {
                        showErrorToast("Please agree to terms and conditions");
                      } else {
                        var formData = FormData.fromMap({
                          "first_name": firstNameController.text.toString(),
                          "last_name": lastNameController.text.toString(),
                          "email": emailController.text.toString(),
                          "date": dobController.text.toString(),
                          "password": passwordController.text.toString(),
                          "password_confirmation": cpasswordController.text.toString(),
                          "phone": phone.toString(),
                          "role": _isSelectedService.toString(),
                          "services[]": selectedService,
                        });
                        final response = await postRequesthandler(
                          url: SessionUrl.register,
                          formData: formData,
                        );

                        if (response != null && response.statusCode == 200) {
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
                          if (response != null && response.data != null && response.data["message"] != null) {
                            setState(() {
                              errors = response.data['errors'];
                            });
                            showErrorToast(response.data['message']);
                          } else {
                            showErrorToast("something went wrong");
                          }
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

  String getServiceNameById() {
    var getSer = allServices!.where((item) => item["id"].toString() == selectedService[0]).first;
    return getSer["name"];
  }

  // AlertDialog servicesDailog() {
  //   return AlertDialog(
  //     // backgroundColor: AppColors.ligthBlueGrey,
  //     title: _isSelectedService == "4"
  //         ? const Text(
  //             "Service You Require",
  //             style: TextStyle(
  //               fontSize: 16,
  //               fontWeight: FontWeight.w600,
  //             ),
  //           )
  //         : const Text(
  //             "Services You Provide",
  //             style: TextStyle(
  //               fontSize: 16,
  //               fontWeight: FontWeight.w600,
  //             ),
  //           ),
  //     content: SizedBox(
  //       height: 200,
  //       child: SingleChildScrollView(
  //         child: Column(
  //           crossAxisAlignment: CrossAxisAlignment.start,
  //           children: [
  //             const SizedBox(height: 10),
  //             if (allServices != null) ...[
  //               MultiSelectDialogField(
  //                 items: allServices!
  //                     .map(
  //                       (item) => MultiSelectItem(
  //                         item["id"].toString(),
  //                         item["name"],
  //                       ),
  //                     )
  //                     .toList(),
  //                 listType: MultiSelectListType.CHIP,
  //                 buttonIcon: const Icon(Icons.arrow_drop_down),
  //                 initialValue: selectedService,
  //                 decoration: BoxDecoration(borderRadius: BorderRadius.circular(08)),
  //                 title: const Text(
  //                   "SELECT",
  //                   style: TextStyle(fontSize: 18, color: Colors.black),
  //                 ),
  //                 buttonText: const Text(
  //                   "select",
  //                   style: TextStyle(fontSize: 14),
  //                 ),
  //                 confirmText: const Text("ok"),
  //                 cancelText: const Text("cancel"),
  //                 onConfirm: (values) {
  //                   setState(() {
  //                     selectedService = values;
  //                   });
  //                 },
  //               ),
  //             ],
  //           ],
  //         ),
  //       ),
  //     ),
  //     actions: [
  //       TextButton(
  //         onPressed: () {
  //           Navigator.pop(context);
  //         },
  //         style: ButtonStyle(
  //           backgroundColor: WidgetStatePropertyAll(ServiceRecieverColor.primaryColor),
  //           shape: WidgetStatePropertyAll(RoundedRectangleBorder(borderRadius: BorderRadius.circular(08))),
  //         ),
  //         child: const Text(
  //           "OK",
  //           style: TextStyle(color: Colors.white),
  //         ),
  //       ),
  //     ],
  //   );
  // }
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
