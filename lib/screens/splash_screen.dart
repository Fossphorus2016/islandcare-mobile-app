// ignore_for_file: use_build_context_synchronously

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:island_app/screens/onboard_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../carereceiver/utils/colors.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  Future check() async {
    SharedPreferences? prefs = await SharedPreferences.getInstance();
    var userRole = prefs.getString('userRole');
    var userToken = prefs.getString('userToken');

    if (userRole == null && userToken == null) {
      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => const OnBoardScreen()));
    } else if (userRole == "3") {
      Navigator.pushNamedAndRemoveUntil(
        context,
        'bottom-bar-giver',
        (route) => false,
      );
    } else if (userRole == "4") {
      Navigator.pushNamedAndRemoveUntil(
        context,
        'bottom-bar',
        (route) => false,
      );
    }
  }

  @override
  void initState() {
    Timer(const Duration(seconds: 3), () {
      check();
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          color: CustomColors.primaryColor,
        ),
        child: Center(
          child: Image.asset("assets/images/loaderLight.gif"),
        ),
      ),
    );
  }
}
