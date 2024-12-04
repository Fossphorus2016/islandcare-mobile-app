import 'package:flutter/material.dart';
import 'package:responsive_framework/responsive_framework.dart';

class ProfileNotApprovedText extends StatelessWidget {
  const ProfileNotApprovedText({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      padding: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        "Your profile is not approve",
        style: TextStyle(
          fontSize: ResponsiveBreakpoints.of(context).isTablet ? 28 : 24,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

class ProfileNotCompletedText extends StatelessWidget {
  const ProfileNotCompletedText({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      padding: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        "Please Complete \n Your Profile",
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: ResponsiveBreakpoints.of(context).isTablet ? 28 : 24,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
