// ignore_for_file: must_be_immutable

import 'package:flutter/cupertino.dart';
import 'package:island_app/carereceiver/utils/colors.dart';

class JobBoardCartWidget extends StatelessWidget {
  String? jobTitle;
  String? jobType;
  VoidCallback? detail;
  VoidCallback? delete;

  JobBoardCartWidget({
    Key? key,
    this.jobTitle,
    this.jobType,
    this.detail,
    this.delete,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 15),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: CustomColors.borderLight,
            width: 0.1,
          ),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                jobTitle.toString(),
                style: TextStyle(
                  color: CustomColors.primaryText,
                  fontFamily: "Poppins",
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                ),
              ),
              Text(
                jobType.toString(),
                style: TextStyle(
                  color: CustomColors.hintText,
                  fontFamily: "Poppins",
                  fontWeight: FontWeight.w500,
                  fontSize: 12,
                ),
              ),
            ],
          ),
          Row(
            children: [
              GestureDetector(
                onTap: detail,
                child: Container(
                  height: 24,
                  width: 70,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(2),
                    color: CustomColors.primaryColor,
                  ),
                  child: Center(
                    child: Text(
                      "DETAIL".toUpperCase(),
                      style: TextStyle(
                        color: CustomColors.white,
                        fontSize: 12,
                        fontFamily: "Poppins",
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(
                width: 10,
              ),
            ],
          )
        ],
      ),
    );
  }
}
