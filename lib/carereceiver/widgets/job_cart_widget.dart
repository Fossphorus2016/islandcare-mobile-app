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
      height: 80,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: CustomColors.borderLight,
            width: 0.1,
          ),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            flex: 7,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  jobTitle.toString(),
                  // "Babysitters",
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                  style: TextStyle(
                    color: CustomColors.primaryText,
                    fontFamily: "Poppins",
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
                Text(
                  jobType.toString(),
                  // "One-Time",
                  style: TextStyle(
                    color: CustomColors.hintText,
                    fontFamily: "Poppins",
                    fontWeight: FontWeight.w500,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            flex: 3,
            child: GestureDetector(
              onTap: detail,
              // onTap: () {
              //   Navigator.push(
              //     context,
              //     MaterialPageRoute(
              //       builder: (context) => const MyJobsDetail(),
              //     ),
              //   );
              // },
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
          )
        ],
      ),
    );
  }
}
