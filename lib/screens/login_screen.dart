// ignore_for_file: use_build_context_synchronously, unused_local_variable, non_constant_identifier_names

import 'package:dio/dio.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:island_app/carereceiver/utils/colors.dart';
import 'package:island_app/carereceiver/screens/bottom_bar.dart';
import 'package:island_app/models/login_model.dart';
import 'package:island_app/utils/app_url.dart';
import 'package:island_app/screens/splash_screen.dart';
import 'package:island_app/utils/functions.dart';
import 'package:island_app/utils/http_handlers.dart';
import 'package:island_app/utils/navigation_service.dart';
import 'package:island_app/utils/routes_name.dart';
import 'package:island_app/utils/storage_service.dart';
import 'package:island_app/widgets/loading_button.dart';
import 'package:responsive_framework/responsive_framework.dart';

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
                        SizedBox(
                          height: MediaQuery.of(context).size.width > 650 ? 200 : 00,
                        ),
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
                              return "Please Enter Email";
                            }
                            if (!RegExp("^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+.[a-z]").hasMatch(value)) {
                              return "Please Enter Email";
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
                        LoadingButton(
                          title: "Log In",
                          width: 220,
                          height: 60,
                          backgroundColor: const Color(0xffffffff),
                          loadingColor: CustomColors.green,
                          textStyle: TextStyle(
                            fontFamily: 'Rubik',
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                            color: CustomColors.primaryColor,
                          ),
                          onPressed: () async {
                            if (emailController.text.isEmpty) {
                              showErrorToast("Please Enter Email");
                            } else if (passwordController.text.isEmpty) {
                              showErrorToast("Please Enter Password");
                            } else if (passwordController.text.length < 3) {
                              showErrorToast("Please Enter 3 digit Password");
                            } else {
                              if (_signInFormKey.currentState!.validate()) {
                                var request = LoginModel(
                                  email: emailController.text.toString(),
                                  password: passwordController.text.toString(),
                                );
                                try {
                                  final response = await postRequesthandler(
                                    url: SessionUrl.login,
                                    formData: FormData.fromMap(request.toJson()),
                                  );

                                  if (response != null && response.statusCode == 200) {
                                    var data = response.data;
                                    var role = data["user"]["role"];
                                    var status = data["user"]["status"];
                                    var token = data["token"];

                                    var userId = data["user"]['id'];
                                    var avatar = data["user"]['avatar'];
                                    var name = data["user"]['first_name'];
                                    var last = data["user"]['last_name'];

                                    if (status == 3) {
                                      showErrorToast("User Blocked");
                                    } else {
                                      if (data["user"]["email_verified_at"] == null) {
                                        navigationService.pushReplacement(
                                          RoutesName.verifyEmail,
                                          arguments: {"token": data["token"]},
                                        );
                                      } else if (data["user"]["role"] == 3) {
                                        await storageService.writeSecureData('userRole', data["user"]["role"].toString());
                                        await storageService.writeSecureData('userToken', data["token"].toString());
                                        await storageService.writeSecureData('userStatus', status.toString());
                                        await storageService.writeSecureData('userId', userId.toString());
                                        await storageService.writeSecureData('userAvatar', avatar.toString());
                                        await storageService.writeSecureData('userName', "$name $last");

                                        Navigator.push(context, MaterialPageRoute(builder: (context) => const SplashScreen()));
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
                                          navigationService.pushReplacement(RoutesName.initalRoute);
                                        }
                                      }
                                    }
                                  } else {
                                    showErrorToast("Bad Credentials");
                                  }
                                } catch (e) {
                                  showErrorToast("something went wrong");
                                }
                              }
                            }
                            return false;
                          },
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
