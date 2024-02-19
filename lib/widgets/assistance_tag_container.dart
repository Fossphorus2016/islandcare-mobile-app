import 'package:flutter/material.dart';
import 'package:island_app/carereceiver/utils/colors.dart';

class AssistanceTagContainer extends StatelessWidget {
  const AssistanceTagContainer({
    super.key,
    required this.title,
  });
  final String title;
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 3),
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(color: CustomColors.primaryLight, borderRadius: BorderRadius.circular(6)),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 13,
          fontFamily: "Poppins",
          fontWeight: FontWeight.w500,
          color: CustomColors.primaryTextLight,
        ),
      ),
    );
  }
}
