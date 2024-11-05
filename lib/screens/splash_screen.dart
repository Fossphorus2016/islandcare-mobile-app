// ignore_for_file: use_build_context_synchronously

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:island_app/utils/navigation_service.dart';
import 'package:island_app/utils/routes_name.dart';
import 'package:island_app/utils/storage_service.dart';
import '../carereceiver/utils/colors.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  Future check() async {
    var userRole = await storageService.readSecureStorage('userRole');
    var userToken = await storageService.readSecureStorage('userToken');

    if (userRole == null && userToken == null) {
      navigationService.pushReplacement(RoutesName.onBoard);
    } else if (userRole == "3") {
      navigationService.pushNamedAndRemoveUntil(RoutesName.bottomBarGiver);
    } else if (userRole == "4") {
      navigationService.pushNamedAndRemoveUntil(RoutesName.bottomBar);
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
