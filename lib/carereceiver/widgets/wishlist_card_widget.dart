import 'package:flutter/material.dart';
import 'package:island_app/carereceiver/utils/colors.dart';

class WishlistCardWidget extends StatelessWidget {
  const WishlistCardWidget({
    super.key,
    required this.fem,
    required this.ffem,
  });

  final double fem;
  final double ffem;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(20 * fem, 18 * fem, 17 * fem, 13 * fem),
      width: 335 * fem,
      height: 170 * fem,
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
            margin: EdgeInsets.fromLTRB(0 * fem, 0 * fem, 0 * fem, 14 * fem),
            width: double.infinity,
            height: 87 * fem,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  margin: EdgeInsets.fromLTRB(0 * fem, 0 * fem, 14 * fem, 0 * fem),
                  height: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(4 * fem),
                  ),
                  child: Center(
                    child: SizedBox(
                      width: 92 * fem,
                      height: 87 * fem,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(4 * fem),
                        child: Image.asset(
                          'assets/images/category.png',
                        ),
                      ),
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.fromLTRB(0 * fem, 4 * fem, 0 * fem, 2 * fem),
                  width: 192 * fem,
                  height: double.infinity,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        margin: EdgeInsets.fromLTRB(0 * fem, 0 * fem, 0 * fem, 9 * fem),
                        width: double.infinity,
                        height: 58 * fem,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              margin: EdgeInsets.fromLTRB(0 * fem, 0 * fem, 69 * fem, 0 * fem),
                              height: double.infinity,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Watamaniuk',
                                    style: TextStyle(
                                      fontFamily: 'Rubik',
                                      fontSize: 18 * ffem,
                                      fontWeight: FontWeight.w500,
                                      height: 1.185 * ffem / fem,
                                      letterSpacing: -0.3000000119 * fem,
                                      color: const Color(0xff333333),
                                    ),
                                  ),
                                  Container(
                                    margin: EdgeInsets.fromLTRB(0 * fem, 0 * fem, 0 * fem, 4 * fem),
                                    child: Text(
                                      'Senior Care',
                                      style: TextStyle(
                                        fontFamily: 'Rubik',
                                        fontSize: 13 * ffem,
                                        fontWeight: FontWeight.w400,
                                        height: 1.2925 * ffem / fem,
                                        letterSpacing: -0.3000000119 * fem,
                                        color: const Color(0xff0ebe7f),
                                      ),
                                    ),
                                  ),
                                  Text(
                                    '9 Years experience ',
                                    style: TextStyle(
                                      fontFamily: 'Rubik',
                                      fontSize: 12 * ffem,
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
                              width: 19 * fem,
                              height: 17 * fem,
                              child: Icon(
                                Icons.favorite,
                                size: 18,
                                color: CustomColors.red,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        width: double.infinity,
                        height: 14 * fem,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              margin: EdgeInsets.fromLTRB(0 * fem, 0 * fem, 18 * fem, 0 * fem),
                              height: double.infinity,
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Container(
                                    margin: EdgeInsets.fromLTRB(0 * fem, 0 * fem, 4 * fem, 2 * fem),
                                    width: 10 * fem,
                                    height: 10 * fem,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(5 * fem),
                                      color: const Color(0xff0ebe7f),
                                    ),
                                  ),
                                  Text(
                                    '74%',
                                    style: TextStyle(
                                      fontFamily: 'Rubik',
                                      fontSize: 11 * ffem,
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
                              height: double.infinity,
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Container(
                                    margin: EdgeInsets.fromLTRB(0 * fem, 0 * fem, 4 * fem, 2 * fem),
                                    width: 10 * fem,
                                    height: 10 * fem,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(5 * fem),
                                      color: const Color(0xff0ebe7f),
                                    ),
                                  ),
                                  Text(
                                    '78 Patient Stories',
                                    style: TextStyle(
                                      fontFamily: 'Rubik',
                                      fontSize: 11 * ffem,
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
                    ],
                  ),
                ),
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.fromLTRB(1 * fem, 0 * fem, 0 * fem, 0 * fem),
            width: double.infinity,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  margin: EdgeInsets.fromLTRB(0 * fem, 3 * fem, 82 * fem, 0 * fem),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        margin: EdgeInsets.fromLTRB(0 * fem, 0 * fem, 0 * fem, 4 * fem),
                        child: Text(
                          'Next Available ',
                          style: TextStyle(
                            fontFamily: 'Rubik',
                            fontSize: 13 * ffem,
                            fontWeight: FontWeight.w500,
                            height: 1.185 * ffem / fem,
                            letterSpacing: -0.3000000119 * fem,
                            color: const Color(0xff0ebe7f),
                          ),
                        ),
                      ),
                      RichText(
                        text: TextSpan(
                          style: TextStyle(
                            fontFamily: 'Rubik',
                            fontSize: 12 * ffem,
                            fontWeight: FontWeight.w300,
                            height: 1.185 * ffem / fem,
                            letterSpacing: -0.3000000119 * fem,
                            color: const Color(0xff677294),
                          ),
                          children: [
                            TextSpan(
                              text: '12:00',
                              style: TextStyle(
                                fontFamily: 'Rubik',
                                fontSize: 12 * ffem,
                                fontWeight: FontWeight.w500,
                                height: 1.185 * ffem / fem,
                                letterSpacing: -0.3000000119 * fem,
                                color: const Color(0xff677294),
                              ),
                            ),
                            const TextSpan(
                              text: ' AM tomorrow',
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  width: 112 * fem,
                  height: 34 * fem,
                  decoration: BoxDecoration(
                    color: const Color(0xff0ebe7f),
                    borderRadius: BorderRadius.circular(4 * fem),
                  ),
                  child: Center(
                    child: Text(
                      'Book Now',
                      style: TextStyle(
                        fontFamily: 'Rubik',
                        fontSize: 12 * ffem,
                        fontWeight: FontWeight.w500,
                        height: 1.185 * ffem / fem,
                        color: const Color(0xffffffff),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
