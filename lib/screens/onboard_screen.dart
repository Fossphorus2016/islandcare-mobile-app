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
              Navigator.pushNamed(context, "login");
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
                  "Signin",
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
        body: SingleChildScrollView(
          child: SizedBox(
            height: MediaQuery.of(context).size.height,
            child: Column(
              children: [
                Stack(
                  children: [
                    Column(
                      children: <Widget>[
                        Container(
                          height: MediaQuery.of(context).size.height * .60,
                          color: Colors.blue,
                          child: Image.asset(
                            "assets/images/onboardBg.png",
                            height: MediaQuery.of(context).size.height * .7,
                            width: MediaQuery.of(context).size.width,
                            fit: BoxFit.cover,
                            alignment: Alignment.topCenter,
                            color: const Color.fromARGB(46, 0, 0, 0),
                            colorBlendMode: BlendMode.darken,
                          ),
                        ),
                        Container(
                          height: MediaQuery.of(context).size.height * .35,
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(40),
                              topRight: Radius.circular(40),
                              bottomLeft: Radius.circular(0),
                              bottomRight: Radius.circular(0),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Container(
                      alignment: Alignment.topCenter,
                      padding: EdgeInsets.only(
                        top: MediaQuery.of(context).size.height * .55,
                        right: 0.0,
                        left: 0.0,
                      ),
                      decoration: const BoxDecoration(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(40),
                          topRight: Radius.circular(40),
                        ),
                      ),
                      child: Container(
                        decoration: const BoxDecoration(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(40),
                            topRight: Radius.circular(40),
                          ),
                        ),
                        height: MediaQuery.of(context).size.height * .4,
                        width: MediaQuery.of(context).size.width,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          decoration: const BoxDecoration(
                            image: DecorationImage(
                              fit: BoxFit.fill,
                              image: AssetImage("assets/images/rectangle.png"),
                            ),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Island Care In Your Neighbourhood",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: CustomColors.primaryText,
                                  fontFamily: "Poppins",
                                  fontSize: 26.2702,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 20),
                            ],
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
