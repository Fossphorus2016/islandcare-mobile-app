import 'package:flutter/material.dart';
import 'package:island_app/carereceiver/utils/colors.dart';

class JobDetailTile extends StatelessWidget {
  const JobDetailTile({super.key, required this.name, required this.title});
  final String title;
  final String name;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 17, vertical: 10),
      width: double.infinity,
      decoration: BoxDecoration(
        color: CustomColors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            name,
            style: const TextStyle(
              color: Colors.grey,
              fontSize: 14,
              fontFamily: "Rubik",
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontFamily: "Rubik",
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
