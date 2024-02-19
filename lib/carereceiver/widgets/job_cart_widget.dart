// ignore_for_file: must_be_immutable

// import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
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
                const Icon(
                  Icons.arrow_circle_right_rounded,
                  color: Color(0xFF50cd89),
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
            // Expanded(
            //   child: Column(
            //     crossAxisAlignment: CrossAxisAlignment.start,
            //     mainAxisAlignment: MainAxisAlignment.center,
            //     children: [
            //       Text(
            //         jobTitle.toString(),
            //         overflow: TextOverflow.ellipsis,
            //         maxLines: 2,
            //         style: TextStyle(
            //           color: CustomColors.primaryText,
            //           fontFamily: "Poppins",
            //           fontWeight: FontWeight.w600,
            //           fontSize: 14,
            //         ),
            //       ),
            //       Text(
            //         jobType.toString(),
            //         maxLines: 1,
            //         overflow: TextOverflow.fade,
            //         style: TextStyle(
            //           color: CustomColors.hintText,
            //           fontFamily: "Poppins",
            //           fontWeight: FontWeight.w500,
            //           fontSize: 12,
            //         ),
            //       ),
            //     ],
            //   ),
            // ),
            // const SizedBox(width: 10),
            // GestureDetector(
            //   onTap: detail,
            //   child: Container(
            //     height: 44,
            //     decoration: BoxDecoration(borderRadius: BorderRadius.circular(2), color: CustomColors.primaryColor),
            //     padding: const EdgeInsets.all(10),
            //     child: Center(
            //       child: Text(
            //         "View Detail",
            //         style: TextStyle(
            //           color: CustomColors.white,
            //           fontSize: 12,
            //           fontFamily: "Poppins",
            //           fontWeight: FontWeight.w500,
            //         ),
            //       ),
            //     ),
            //   ),
            // )
          ],
        ),
      ),
    );
  }
}
