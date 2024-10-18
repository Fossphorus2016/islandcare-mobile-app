// ignore_for_file: must_be_immutable

// import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:island_app/carereceiver/utils/colors.dart';
import 'package:island_app/utils/utils.dart';

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
        // height: 100,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: CustomColors.borderLight,
            width: 0.1,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              children: [
                Expanded(
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
                Icon(
                  Icons.arrow_circle_right_outlined,
                  color: ServiceGiverColor.black,
                ),
              ],
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
      ),
    );
  }
}
