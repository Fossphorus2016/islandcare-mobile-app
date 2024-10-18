import 'package:flutter/cupertino.dart';
import 'package:island_app/carereceiver/utils/colors.dart';

class RecentJobWidget extends StatelessWidget {
  final String? title;
  final String? subTitle;
  final String? rate;
  final String? time;
  const RecentJobWidget({
    super.key,
    this.title,
    this.subTitle,
    this.rate,
    this.time,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(
        vertical: 10,
        horizontal: 20,
      ),
      width: MediaQuery.of(context).size.width * .90,
      padding: const EdgeInsets.all(20),
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
          bottomLeft: Radius.circular(20),
          bottomRight: Radius.circular(20),
        ),
        boxShadow: [
          BoxShadow(
            color: Color.fromRGBO(26, 41, 96, 0.05999999865889549),
            offset: Offset(0, 4),
            blurRadius: 45,
          )
        ],
        color: Color.fromRGBO(255, 255, 255, 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title!,
                        style: TextStyle(
                          color: CustomColors.primaryText,
                          fontSize: 16,
                          fontFamily: "Poppins",
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        subTitle!,
                        style: TextStyle(
                          color: CustomColors.darkGreyRecommended,
                          fontSize: 12,
                          fontFamily: "Poppins",
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(
            height: 8,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              RichText(
                text: TextSpan(
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                    height: 1.1849999428,
                    color: CustomColors.primaryText,
                  ),
                  children: [
                    TextSpan(
                      text: '\$$rate',
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        height: 1.2575,
                        color: CustomColors.primaryText,
                      ),
                    ),
                    TextSpan(
                      text: '/hour',
                      style: TextStyle(
                        fontFamily: 'Rubik',
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                        height: 1.185,
                        color: CustomColors.primaryText,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                child: Text(
                  time!,
                  style: TextStyle(
                    color: CustomColors.hintText,
                    fontSize: 12,
                    fontFamily: "Poppins",
                    fontWeight: FontWeight.w400,
                  ),
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}
