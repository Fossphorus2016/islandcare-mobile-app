import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:island_app/carereceiver/utils/colors.dart';

class RecieverAvailabilityScreen extends StatefulWidget {
  const RecieverAvailabilityScreen({super.key});

  @override
  State<RecieverAvailabilityScreen> createState() => _RecieverAvailabilityScreenState();
}

class _RecieverAvailabilityScreenState extends State<RecieverAvailabilityScreen> {
  int? selectedIndex;
  int? selectedTimeIndex;
  int? selectedEveningTimeIndex;

  @override
  Widget build(BuildContext context) {
    double baseWidth = 360;
    double fem = MediaQuery.of(context).size.width / baseWidth;
    double ffem = fem * 0.97;
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        elevation: 0,
        backgroundColor: Colors.transparent,
        automaticallyImplyLeading: false,
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: Padding(
            padding: const EdgeInsets.all(13.0),
            child: Container(
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: CustomColors.white,
                borderRadius: BorderRadius.circular(10),
                boxShadow: const [
                  BoxShadow(
                    color: Color.fromARGB(30, 0, 0, 0),
                    offset: Offset(2, 2),
                    spreadRadius: 1,
                    blurRadius: 7,
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.only(left: 4.0),
                child: Icon(
                  Icons.arrow_back_ios,
                  color: CustomColors.primaryColor,
                  size: 18,
                ),
              ),
            ),
          ),
        ),
        title: Text(
          "Availability",
          style: TextStyle(
            fontSize: 19,
            fontWeight: FontWeight.w600,
            fontFamily: "Rubik",
            color: CustomColors.primaryText,
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 6),
        child: Container(
          height: 54,
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
              border: Border.all(
                width: 1.5,
                color: CustomColors.primaryColor,
              ),
              borderRadius: BorderRadius.circular(6)),
          child: Center(
            child: Text(
              "Contact",
              style: TextStyle(
                fontFamily: "Rubik",
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: CustomColors.primaryColor,
              ),
            ),
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            width: MediaQuery.of(context).size.width,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(
                  height: 20,
                ),
                Container(
                  padding: EdgeInsets.fromLTRB(14 * fem, 7 * fem, 0, 5 * fem),
                  width: double.infinity,
                  height: 88 * fem,
                  decoration: BoxDecoration(
                    color: CustomColors.white,
                    borderRadius: BorderRadius.circular(8 * fem),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0x14000000),
                        offset: Offset(0 * fem, 0 * fem),
                        blurRadius: 10 * fem,
                      ),
                    ],
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        margin: EdgeInsets.fromLTRB(0 * fem, 0 * fem, 10.95 * fem, 0 * fem),
                        width: 68 * fem,
                        height: 68 * fem,
                        child: Image.asset(
                          'assets/images/category.png',
                          width: 68 * fem,
                          height: 68 * fem,
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.fromLTRB(0 * fem, 9 * fem, 0 * fem, 0),
                        height: double.infinity,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const SizedBox(
                                    height: 5,
                                  ),
                                  SizedBox(
                                    child: Text(
                                      'Fillerup Grab',
                                      style: TextStyle(
                                        fontFamily: 'Rubik',
                                        fontSize: 16 * ffem,
                                        fontWeight: FontWeight.w600,
                                        height: 1.185 * ffem / fem,
                                        letterSpacing: -0.3000000119 * fem,
                                        color: const Color(0xff333333),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 15,
                                  ),
                                  Text(
                                    'lorem ipsum dolor sit amet, consectetur\n',
                                    style: TextStyle(
                                      fontFamily: 'Rubik',
                                      fontSize: 11 * ffem,
                                      fontWeight: FontWeight.w300,
                                      height: 0.185,
                                      letterSpacing: -0.3000000119 * fem,
                                      color: const Color(0xff677294),
                                    ),
                                  ),
                                  SizedBox(
                                    child: RatingBar.builder(
                                      initialRating: 3,
                                      minRating: 1,
                                      direction: Axis.horizontal,
                                      allowHalfRating: true,
                                      ignoreGestures: true,
                                      itemSize: 12,
                                      itemCount: 5,
                                      itemBuilder: (context, _) => const Icon(
                                        Icons.star,
                                        color: Colors.amber,
                                      ),
                                      onRatingUpdate: (rating) {
                                        setState(() => rating = rating);
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            // Star
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 25,
                ),
                SizedBox(
                  height: 60.0,
                  child: ListView.builder(
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    itemCount: 10,
                    itemBuilder: (BuildContext context, int index) {
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            selectedIndex = index;
                          });
                        },
                        child: Container(
                          margin: const EdgeInsets.only(right: 10),
                          decoration: BoxDecoration(
                            color: selectedIndex == index ? CustomColors.primaryColor : null,
                            border: Border.all(
                              width: .5,
                              color: const Color.fromRGBO(103, 114, 148, 0.1),
                            ),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          height: 54,
                          width: 150,
                          child: Center(
                            child: Text(
                              "Today, 23 Feb",
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                                fontFamily: "Rubik",
                                color: selectedIndex == index ? CustomColors.white : CustomColors.primaryText,
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(
                  height: 25,
                ),
                Text(
                  "Today, 23 Feb",
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    fontFamily: "Rubik",
                    color: CustomColors.primaryText,
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
                // Afternoon
                Container(
                  alignment: Alignment.topLeft,
                  child: Text(
                    "Afternoon",
                    textAlign: TextAlign.start,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      fontFamily: "Rubik",
                      color: CustomColors.primaryText,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: 7,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    childAspectRatio: (1.8),
                    crossAxisCount: 4,
                    crossAxisSpacing: 3,
                    mainAxisSpacing: 12,
                  ),
                  itemBuilder: (BuildContext context, int index) {
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedTimeIndex = index;
                        });
                      },
                      child: Container(
                        margin: const EdgeInsets.only(right: 10),
                        decoration: BoxDecoration(
                          color: selectedTimeIndex == index
                              ? CustomColors.primaryColor
                              : const Color.fromRGBO(14, 190, 127, 0.08),
                          border: Border.all(
                            width: .5,
                            color: const Color.fromRGBO(103, 114, 148, 0.1),
                          ),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Center(
                          child: Text(
                            "1:00 PM",
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              fontFamily: "Rubik",
                              color: selectedTimeIndex == index ? CustomColors.white : CustomColors.primaryColor,
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),

                const SizedBox(
                  height: 30,
                ),
                // Evening
                Container(
                  alignment: Alignment.topLeft,
                  child: Text(
                    "Evening",
                    textAlign: TextAlign.start,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      fontFamily: "Rubik",
                      color: CustomColors.primaryText,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: 5,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    childAspectRatio: (1.8),
                    crossAxisCount: 4,
                    crossAxisSpacing: 3,
                    mainAxisSpacing: 12,
                  ),
                  itemBuilder: (BuildContext context, int index) {
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedEveningTimeIndex = index;
                        });
                      },
                      child: Container(
                        margin: const EdgeInsets.only(right: 10),
                        decoration: BoxDecoration(
                          color: selectedEveningTimeIndex == index
                              ? CustomColors.primaryColor
                              : const Color.fromRGBO(14, 190, 127, 0.08),
                          border: Border.all(
                            width: .5,
                            color: const Color.fromRGBO(103, 114, 148, 0.1),
                          ),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Center(
                          child: Text(
                            "1:00 PM",
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              fontFamily: "Rubik",
                              color: selectedEveningTimeIndex == index ? CustomColors.white : CustomColors.primaryColor,
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
