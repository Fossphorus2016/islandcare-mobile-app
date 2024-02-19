import 'package:flutter/material.dart';
import 'package:island_app/carereceiver/utils/colors.dart';

class OnBoardScreen extends StatefulWidget {
  const OnBoardScreen({super.key});

  @override
  State<OnBoardScreen> createState() => _OnBoardScreenState();
}

class _OnBoardScreenState extends State<OnBoardScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 17, vertical: 8),
          child: GestureDetector(
            onTap: () {
              Navigator.pushNamed(context, "/login");
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
                  "Login",
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
        ),
        body: SizedBox(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: Column(
            children: [
              Expanded(
                flex: 7,
                child: Stack(
                  children: [
                    Image.asset(
                      "assets/images/main-bg.png",
                      height: MediaQuery.of(context).size.height * .7,
                      width: MediaQuery.of(context).size.width,
                      fit: BoxFit.cover,
                      alignment: Alignment.topCenter,
                      color: const Color.fromARGB(46, 0, 0, 0),
                      colorBlendMode: BlendMode.darken,
                    ),
                    const Center(
                      child: Image(
                        image: AssetImage("assets/images/Logo-light.png"),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                flex: 3,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(height: 20),
                      Text(
                        "Welcome to Island Care",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: CustomColors.primaryText,
                          fontFamily: "Poppins",
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        "Everyone needs a community network they can rely on... we’re here to help!",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: CustomColors.primaryText,
                          fontFamily: "Poppins",
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
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
    );
  }
}
