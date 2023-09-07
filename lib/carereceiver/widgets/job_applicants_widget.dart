import 'package:flutter/cupertino.dart';
import 'package:island_app/carereceiver/utils/colors.dart';

class JobApplicantsWidget extends StatelessWidget {
  final String? name;
  final String? jobType;
  final String? count;
  final VoidCallback? onTap;

  const JobApplicantsWidget({
    Key? key,
    this.name,
    this.jobType,
    this.count,
    this.onTap,
  }) : super(key: key);

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
              SizedBox(
                width: MediaQuery.of(context).size.width * .3,
                child: Text(
                  name.toString(),
                  // "Babysitters",
                  style: TextStyle(
                    color: CustomColors.primaryText,
                    fontFamily: "Poppins",
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width * .3,
                child: Text(
                  jobType.toString(),
                  // "One-Time",
                  style: TextStyle(
                    color: CustomColors.hintText,
                    fontFamily: "Poppins",
                    fontWeight: FontWeight.w500,
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(
            width: MediaQuery.of(context).size.width * .3,
            child: Text(count.toString()),
          ),
          Row(
            children: [
              GestureDetector(
                onTap: onTap,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  height: 24,
                  // width: 70,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(2),
                    color: CustomColors.blackLight,
                  ),
                  child: Center(
                    child: Text(
                      ">",
                      style: TextStyle(
                        color: CustomColors.black,
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
