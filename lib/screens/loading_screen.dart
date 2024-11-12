import 'package:flutter/material.dart';
import 'package:island_app/carereceiver/utils/colors.dart';

class LoadingScreen extends StatelessWidget {
  const LoadingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
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
      ),
    );
  }
}
