import 'package:flutter/material.dart';
import 'package:island_app/widgets/job_detail_tile.dart';

class JobInfoContainer extends StatelessWidget {
  const JobInfoContainer({
    super.key,
    required this.title,
    required this.address,
    required this.location,
    required this.hourlyRate,
  });

  final String title;
  final String address;
  final String location;
  final String hourlyRate;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Align(
          alignment: Alignment.centerLeft,
          child: Text(
            "Job Information",
            style: TextStyle(
              fontFamily: "Poppins",
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const SizedBox(height: 10),
        JobDetailTile(
          name: "Job Title",
          title: title,
        ),
        const SizedBox(height: 10),
        JobDetailTile(
          name: "Job Address",
          title: address,
        ),
        const SizedBox(height: 10),
        JobDetailTile(
          name: "Job Area",
          title: location,
        ),
        const SizedBox(height: 10),
        JobDetailTile(
          name: "Hourly Rate",
          title: hourlyRate,
        ),
      ],
    );
  }
}
