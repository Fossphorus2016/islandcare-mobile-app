import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:island_app/models/schedule_model.dart';
import 'package:island_app/widgets/job_detail_tile.dart';

class JobScheduleContainer extends StatelessWidget {
  const JobScheduleContainer({
    super.key,
    required this.data,
  });

  final List<Schedule>? data;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Job schedule",
          style: TextStyle(
            fontFamily: "Poppins",
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 10),
        if (data != null) ...[
          for (var i = 0; i < data!.length; i++) ...[
            if (data!.length > 1) ...[
              Text("Schedule ${i + 1}"),
              const SizedBox(height: 05),
            ],
            JobDetailTile(
              name: "Date",
              title: DateFormat.yMMMMd().format(DateTime.parse(data![i].startingDate.toString()).toLocal()),
            ),
            const SizedBox(height: 10),
            JobDetailTile(
              name: "Start Time",
              title: data![i].startingTime.toString(),
            ),
            const SizedBox(height: 10),
            JobDetailTile(
              name: "Duration",
              title: "${data![i].duration.toString()} hour",
            ),
            const SizedBox(height: 10),
          ],
        ],
      ],
    );
  }
}
