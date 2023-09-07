import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:island_app/carereceiver/screens/availability.dart';
import 'package:island_app/carereceiver/utils/colors.dart';

class DetailScreen extends StatefulWidget {
  const DetailScreen({super.key});

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  @override
  Widget build(BuildContext context) {
    double baseWidth = 360;
    double fem = MediaQuery.of(context).size.width / baseWidth;
    double ffem = fem * 0.97;
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: SizedBox(
            width: double.infinity,
            child: Column(
              children: [
                const SizedBox(
                  height: 20,
                ),
                // Header
                SizedBox(
                  width: 314.8 * fem,
                  height: 70 * fem,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(
                        // margin: EdgeInsets.fromLTRB(
                        //     0 * fem, 0 * fem, 200.52 * fem, 0 * fem),
                        height: double.infinity,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            GestureDetector(
                              onTap: () {
                                Navigator.pop(context);
                              },
                              child: Container(
                                // backzzS (15:118)
                                margin: EdgeInsets.fromLTRB(0 * fem, 0 * fem, 0 * fem, 10 * fem),
                                child: Text(
                                  '< Back',
                                  style: TextStyle(
                                    fontFamily: 'Rubik',
                                    fontSize: 14 * ffem,
                                    fontWeight: FontWeight.w300,
                                    height: 1.185 * ffem / fem,
                                    letterSpacing: -0.3000000119 * fem,
                                    color: const Color(0xff0ebe7f),
                                  ),
                                ),
                              ),
                            ),
                            Text(
                              // detailsWSz (15:101)
                              'Details',
                              style: TextStyle(
                                fontFamily: 'Rubik',
                                fontSize: 20 * ffem,
                                fontWeight: FontWeight.w600,
                                height: 1.185 * ffem / fem,
                                letterSpacing: -0.3000000119 * fem,
                                color: const Color(0xff333333),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Icon(
                        Icons.search,
                        color: CustomColors.hintText,
                        size: 24,
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                // Card Area
                Container(
                  padding: EdgeInsets.fromLTRB(15 * fem, 17 * fem, 15.18 * fem, 17.05 * fem),
                  width: 317 * fem,
                  height: 161 * fem,
                  decoration: BoxDecoration(
                    color: const Color(0xffffffff),
                    borderRadius: BorderRadius.circular(8 * fem),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0x14000000),
                        offset: Offset(0 * fem, 0 * fem),
                        blurRadius: 10 * fem,
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        margin: EdgeInsets.fromLTRB(0 * fem, 0 * fem, 0 * fem, 0.42 * fem),
                        width: double.infinity,
                        height: 96.22 * fem,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              margin: EdgeInsets.fromLTRB(0 * fem, 0 * fem, 5.56 * fem, 0 * fem),
                              width: 90.51 * fem,
                              height: double.infinity,
                              child: Align(
                                child: SizedBox(
                                  width: 87 * fem,
                                  height: 87 * fem,
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(12),
                                    child: Image.asset(
                                      'assets/images/category.png',
                                      width: 87 * fem,
                                      height: 87 * fem,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.fromLTRB(0 * fem, 4.93 * fem, 0 * fem, 0 * fem),
                              width: 190.75 * fem,
                              height: 69.89 * fem,
                              child: SizedBox(
                                width: 185.82 * fem,
                                height: 64.82 * fem,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      margin: EdgeInsets.fromLTRB(
                                        0 * fem,
                                        0 * fem,
                                        0 * fem,
                                        1 * fem,
                                      ),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            'Fillerup Grab',
                                            style: TextStyle(
                                              fontFamily: 'Rubik',
                                              fontSize: 18 * ffem,
                                              fontWeight: FontWeight.w500,
                                              height: 1.185 * ffem / fem,
                                              letterSpacing: -0.3000000119 * fem,
                                              color: const Color(0xff333333),
                                            ),
                                          ),
                                          Icon(
                                            Icons.favorite,
                                            size: 18,
                                            color: CustomColors.red,
                                          ),
                                        ],
                                      ),
                                    ),
                                    Container(
                                      margin: EdgeInsets.fromLTRB(0 * fem, 0 * fem, 0 * fem, 5.82 * fem),
                                      child: Text(
                                        'Babysitters',
                                        style: TextStyle(
                                          fontFamily: 'Rubik',
                                          fontSize: 16 * ffem,
                                          fontWeight: FontWeight.w300,
                                          height: 1.185 * ffem / fem,
                                          color: const Color(0xff0ebe7f),
                                        ),
                                      ),
                                    ),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        SizedBox(
                                          height: 10,
                                          child: RatingBar.builder(
                                            initialRating: 3,
                                            minRating: 1,
                                            direction: Axis.horizontal,
                                            allowHalfRating: true,
                                            ignoreGestures: true,
                                            itemSize: 16,
                                            itemCount: 5,
                                            itemBuilder: (context, _) => const Icon(
                                              Icons.star,
                                              color: Colors.amber,
                                            ),
                                            onRatingUpdate: (rating) {
                                              // print(rating);
                                              setState(() => rating = rating);
                                            },
                                          ),
                                        ),
                                        SizedBox(
                                          child: RichText(
                                            text: TextSpan(
                                              style: TextStyle(
                                                fontFamily: 'Rubik',
                                                fontSize: 14 * ffem,
                                                fontWeight: FontWeight.w500,
                                                height: 1.1850000109 * ffem / fem,
                                                letterSpacing: -0.3000000119 * fem,
                                                color: const Color(0xff333333),
                                              ),
                                              children: [
                                                TextSpan(
                                                  text: '\$',
                                                  style: TextStyle(
                                                    fontFamily: 'Rubik',
                                                    fontSize: 14 * ffem,
                                                    fontWeight: FontWeight.w500,
                                                    height: 1.185 * ffem / fem,
                                                    letterSpacing: -0.3000000119 * fem,
                                                    color: const Color(0xff0ebe7f),
                                                  ),
                                                ),
                                                TextSpan(
                                                  text: ' ',
                                                  style: TextStyle(
                                                    fontFamily: 'Rubik',
                                                    fontSize: 14 * ffem,
                                                    fontWeight: FontWeight.w500,
                                                    height: 1.185 * ffem / fem,
                                                    letterSpacing: -0.3000000119 * fem,
                                                    color: const Color(0xff333333),
                                                  ),
                                                ),
                                                TextSpan(
                                                  text: '28.00/hr',
                                                  style: TextStyle(
                                                    fontFamily: 'Rubik',
                                                    fontSize: 14 * ffem,
                                                    fontWeight: FontWeight.w300,
                                                    height: 1.185 * ffem / fem,
                                                    letterSpacing: -0.3000000119 * fem,
                                                    color: const Color(0xe5677294),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      // Card Button
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const Availability(),
                            ),
                          );
                        },
                        child: Container(
                          margin: EdgeInsets.fromLTRB(77.81 * fem, 0 * fem, 76.42 * fem, 0 * fem),
                          width: double.infinity,
                          height: 30.31 * fem,
                          decoration: BoxDecoration(
                            color: const Color(0xff0ebe7f),
                            borderRadius: BorderRadius.circular(4 * fem),
                          ),
                          child: Center(
                            child: Text(
                              'Book Now',
                              style: TextStyle(
                                fontFamily: 'Rubik',
                                fontSize: 14 * ffem,
                                fontWeight: FontWeight.w500,
                                height: 1.185 * ffem / fem,
                                color: const Color(0xffffffff),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
                // Boxes Area
                Container(
                  padding: EdgeInsets.fromLTRB(10.36 * fem, 10.36 * fem, 9.32 * fem, 10.36 * fem),
                  width: 315.89 * fem,
                  height: 87 * fem,
                  decoration: BoxDecoration(
                    color: const Color(0xffffffff),
                    borderRadius: BorderRadius.circular(10 * fem),
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
                        // runingzF8 (15:68)
                        padding: EdgeInsets.fromLTRB(25.89 * fem, 10.36 * fem, 23.32 * fem, 15.11 * fem),
                        width: 93.21 * fem,
                        height: double.infinity,
                        decoration: BoxDecoration(
                          color: const Color(0x1ecacaca),
                          borderRadius: BorderRadius.circular(10 * fem),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              // t5c (15:71)
                              margin: EdgeInsets.fromLTRB(0 * fem, 0 * fem, 3.71 * fem, 1.82 * fem),
                              child: Text(
                                '100',
                                style: TextStyle(
                                  fontFamily: 'Rubik',
                                  fontSize: 18 * ffem,
                                  fontWeight: FontWeight.w500,
                                  height: 1.185 * ffem / fem,
                                  letterSpacing: -0.3000000119 * fem,
                                  color: const Color(0xff333333),
                                ),
                              ),
                            ),
                            Text(
                              // runingQ3x (15:70)
                              'Runing',
                              style: TextStyle(
                                fontFamily: 'Rubik',
                                fontSize: 14 * ffem,
                                fontWeight: FontWeight.w300,
                                height: 1.185 * ffem / fem,
                                letterSpacing: -0.3000000119 * fem,
                                color: const Color(0xff677294),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        width: 8.29 * fem,
                      ),
                      Container(
                        padding: EdgeInsets.fromLTRB(20.57 * fem, 10.36 * fem, 24.64 * fem, 14.04 * fem),
                        width: 93.21 * fem,
                        height: double.infinity,
                        decoration: BoxDecoration(
                          color: const Color(0x1ecacaca),
                          borderRadius: BorderRadius.circular(10 * fem),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              margin: EdgeInsets.fromLTRB(0.79 * fem, 0 * fem, 0 * fem, 3.89 * fem),
                              child: Text(
                                '500',
                                style: TextStyle(
                                  fontFamily: 'Rubik',
                                  fontSize: 18 * ffem,
                                  fontWeight: FontWeight.w500,
                                  height: 1.185 * ffem / fem,
                                  letterSpacing: -0.3000000119 * fem,
                                  color: const Color(0xff333333),
                                ),
                              ),
                            ),
                            Text(
                              // ongoingXXt (15:66)
                              'Ongoing',
                              style: TextStyle(
                                fontFamily: 'Rubik',
                                fontSize: 13 * ffem,
                                fontWeight: FontWeight.w300,
                                height: 1.185 * ffem / fem,
                                letterSpacing: -0.3000000119 * fem,
                                color: const Color(0xff677294),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        width: 8.29 * fem,
                      ),
                      Container(
                        // patientrKG (15:60)
                        padding: EdgeInsets.fromLTRB(24.86 * fem, 10.36 * fem, 25.36 * fem, 0 * fem),
                        width: 93.21 * fem,
                        height: double.infinity,
                        decoration: BoxDecoration(
                          color: const Color(0x1ecacaca),
                          borderRadius: BorderRadius.circular(10 * fem),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              // mBL (15:63)
                              margin: EdgeInsets.fromLTRB(0.36 * fem, 0 * fem, 0 * fem, 3.89 * fem),
                              child: Text(
                                '700',
                                style: TextStyle(
                                  fontFamily: 'Rubik',
                                  fontSize: 18 * ffem,
                                  fontWeight: FontWeight.w500,
                                  height: 1.185 * ffem / fem,
                                  letterSpacing: -0.3000000119 * fem,
                                  color: const Color(0xff333333),
                                ),
                              ),
                            ),
                            Text(
                              'Patient',
                              style: TextStyle(
                                fontFamily: 'Rubik',
                                fontSize: 14 * ffem,
                                fontWeight: FontWeight.w300,
                                height: 1.185 * ffem / fem,
                                letterSpacing: -0.3000000119 * fem,
                                color: const Color(0xff677294),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                // Services Area
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(
                      height: 20,
                    ),
                    Container(
                      margin: EdgeInsets.fromLTRB(0 * fem, 0 * fem, 0 * fem, 16 * fem),
                      child: Text(
                        'Services',
                        style: TextStyle(
                          fontFamily: 'Rubik',
                          fontSize: 18 * ffem,
                          fontWeight: FontWeight.w500,
                          height: 1.185 * ffem / fem,
                          letterSpacing: -0.3000000119 * fem,
                          color: const Color(0xff333333),
                        ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.fromLTRB(0.99 * fem, 0 * fem, 0 * fem, 16.2 * fem),
                      padding: EdgeInsets.fromLTRB(0.01 * fem, 0 * fem, 0.01 * fem, 0 * fem),
                      width: 320.01 * fem,
                      height: 30.8 * fem,
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                            width: .2,
                            color: CustomColors.borderLight,
                          ),
                        ),
                      ),
                      child: RichText(
                        text: TextSpan(
                          style: TextStyle(
                            fontFamily: 'Rubik',
                            fontSize: 13 * ffem,
                            fontWeight: FontWeight.w300,
                            height: 1.1849999061 * ffem / fem,
                            letterSpacing: -0.3000000119 * fem,
                            color: const Color(0xe5677294),
                          ),
                          children: [
                            TextSpan(
                              text: '1.',
                              style: TextStyle(
                                fontFamily: 'Rubik',
                                fontSize: 13 * ffem,
                                fontWeight: FontWeight.w500,
                                height: 1.185 * ffem / fem,
                                letterSpacing: -0.3000000119 * fem,
                                color: const Color(0xff0ebe7f),
                              ),
                            ),
                            TextSpan(
                              text: '   ',
                              style: TextStyle(
                                fontFamily: 'Rubik',
                                fontSize: 13 * ffem,
                                fontWeight: FontWeight.w300,
                                height: 1.185 * ffem / fem,
                                letterSpacing: -0.3000000119 * fem,
                                color: const Color(0xe5677294),
                              ),
                            ),
                            TextSpan(
                              text: 'Patient care should be the number one priority.',
                              style: TextStyle(
                                fontFamily: 'Rubik',
                                fontSize: 13 * ffem,
                                fontWeight: FontWeight.w400,
                                height: 1.185 * ffem / fem,
                                letterSpacing: -0.3000000119 * fem,
                                color: const Color(0xe5677294),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.fromLTRB(1 * fem, 0 * fem, 0 * fem, 16.2 * fem),
                      width: 320 * fem,
                      height: 30.8 * fem,
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                            width: .2,
                            color: CustomColors.borderLight,
                          ),
                        ),
                      ),
                      child: RichText(
                        text: TextSpan(
                          style: TextStyle(
                            fontFamily: 'Rubik',
                            fontSize: 13 * ffem,
                            fontWeight: FontWeight.w300,
                            height: 1.1849999061 * ffem / fem,
                            letterSpacing: -0.3000000119 * fem,
                            color: const Color(0xe5677294),
                          ),
                          children: [
                            TextSpan(
                              text: '2.',
                              style: TextStyle(
                                fontFamily: 'Rubik',
                                fontSize: 13 * ffem,
                                fontWeight: FontWeight.w500,
                                height: 1.185 * ffem / fem,
                                letterSpacing: -0.3000000119 * fem,
                                color: const Color(0xff0eb67a),
                              ),
                            ),
                            TextSpan(
                              text: '   ',
                              style: TextStyle(
                                fontFamily: 'Rubik',
                                fontSize: 13 * ffem,
                                fontWeight: FontWeight.w300,
                                height: 1.185 * ffem / fem,
                                letterSpacing: -0.3000000119 * fem,
                                color: const Color(0xe5677294),
                              ),
                            ),
                            TextSpan(
                              text: 'If you run your practiceyou know how frustrating.',
                              style: TextStyle(
                                fontFamily: 'Rubik',
                                fontSize: 13 * ffem,
                                fontWeight: FontWeight.w400,
                                height: 1.185 * ffem / fem,
                                letterSpacing: -0.3000000119 * fem,
                                color: const Color(0xe5677294),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.fromLTRB(1 * fem, 0 * fem, 0 * fem, 0 * fem),
                      child: RichText(
                        text: TextSpan(
                          style: TextStyle(
                            fontFamily: 'Rubik',
                            fontSize: 13 * ffem,
                            fontWeight: FontWeight.w300,
                            height: 1.1849999061 * ffem / fem,
                            letterSpacing: -0.3000000119 * fem,
                            color: const Color(0xe5677294),
                          ),
                          children: [
                            TextSpan(
                              text: '3.',
                              style: TextStyle(
                                fontFamily: 'Rubik',
                                fontSize: 13 * ffem,
                                fontWeight: FontWeight.w500,
                                height: 1.185 * ffem / fem,
                                letterSpacing: -0.3000000119 * fem,
                                color: const Color(0xff0eb478),
                              ),
                            ),
                            TextSpan(
                              text: '   ',
                              style: TextStyle(
                                fontFamily: 'Rubik',
                                fontSize: 13 * ffem,
                                fontWeight: FontWeight.w300,
                                height: 1.185 * ffem / fem,
                                letterSpacing: -0.3000000119 * fem,
                                color: const Color(0xe5677294),
                              ),
                            ),
                            TextSpan(
                              text: 'That’s why some of appointment reminder system.',
                              style: TextStyle(
                                fontFamily: 'Rubik',
                                fontSize: 13 * ffem,
                                fontWeight: FontWeight.w400,
                                height: 1.185 * ffem / fem,
                                letterSpacing: -0.3000000119 * fem,
                                color: const Color(0xe5677294),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    // Map Area
                    const SizedBox(
                      height: 20,
                    ),
                    SizedBox(
                      width: 322.62 * fem,
                      height: 202.24 * fem,
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10 * fem),
                          color: const Color(0xffffffff),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0x14000000),
                              offset: Offset(0 * fem, 0 * fem),
                              blurRadius: 15 * fem,
                            ),
                          ],
                        ),
                        child: Image.asset("assets/images/map.png"),
                      ),
                    ),
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
