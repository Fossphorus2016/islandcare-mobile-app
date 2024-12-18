// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:island_app/carereceiver/utils/colors.dart';
import 'package:island_app/utils/app_colors.dart';

class JobBoardCartWidget extends StatelessWidget {
  String? jobTitle;
  String? jobType;
  VoidCallback? detail;
  VoidCallback? delete;

  JobBoardCartWidget({
    super.key,
    this.jobTitle,
    this.jobType,
    this.detail,
    this.delete,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: detail,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: CustomColors.borderLight,
            width: 0.1,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width - 150,
                  child: Text(
                    jobTitle.toString(),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                    style: TextStyle(
                      color: CustomColors.primaryText,
                      fontFamily: "Poppins",
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    ),
                  ),
                ),
                Row(
                  children: [
                    Text(
                      "Type: ",
                      style: TextStyle(
                        fontSize: 12,
                        color: CustomColors.black,
                      ),
                    ),
                    Text(
                      jobType.toString(),
                      maxLines: 1,
                      overflow: TextOverflow.fade,
                      style: TextStyle(
                        color: CustomColors.hintText,
                        fontFamily: "Poppins",
                        fontWeight: FontWeight.w500,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            Icon(
              Icons.arrow_circle_right_outlined,
              color: ServiceGiverColor.black,
            ),
          ],
        ),
      ),
    );
  }
}
