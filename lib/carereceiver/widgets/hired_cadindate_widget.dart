// ignore_for_file: must_be_immutable, prefer_typing_uninitialized_variables

import 'package:flutter/cupertino.dart';
import 'package:island_app/carereceiver/utils/colors.dart';

class HiredCandidateWidget extends StatelessWidget {
  String? name;
  String? jobType;
  VoidCallback? markAsComplete;
  var isCompleted;

  HiredCandidateWidget({
    super.key,
    this.name,
    this.jobType,
    this.markAsComplete,
    this.isCompleted,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                name.toString(),
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
                onTap: markAsComplete,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  height: 24,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(2),
                    color: isCompleted == 3 ? CustomColors.primaryLight : CustomColors.primaryColor,
                  ),
                  child: Center(
                    child: Text(
                      isCompleted == 3 ? "Job Completed" : "Mark As Complete",
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
