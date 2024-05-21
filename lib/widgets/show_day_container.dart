import 'package:flutter/material.dart';
import 'package:island_app/carereceiver/utils/colors.dart';

class ShowDaysContainer extends StatelessWidget {
  const ShowDaysContainer({super.key, required this.date, required this.time, required this.duration, this.removeIconTap});
  final String date;
  final String time;
  final String duration;
  final void Function()? removeIconTap;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      height: 100,
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 10,
                vertical: 10,
              ),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.shade300,
                    spreadRadius: 01,
                    blurRadius: 05,
                    blurStyle: BlurStyle.outer,
                  ),
                ],
              ),
              height: 85,
              width: MediaQuery.of(context).size.width,
              child: Column(
                children: [
                  Row(
                    children: [
                      const Text("Date: "),
                      Expanded(
                        child: Text(
                          date,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      const Text("Time: "),
                      Expanded(
                        child: Text(time),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      const Text("Duration: "),
                      Expanded(
                        child: Text("$duration hours"),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            top: -10,
            right: 0,
            child: GestureDetector(
              onTap: removeIconTap,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(100),
                    bottomLeft: Radius.circular(100),
                    bottomRight: Radius.circular(100),
                    topRight: Radius.circular(100),
                  ),
                  color: CustomColors.white,
                  boxShadow: const [
                    BoxShadow(
                      color: Color.fromARGB(13, 0, 0, 0),
                      blurRadius: 4.0,
                      spreadRadius: 2.0,
                      offset: Offset(2.0, 2.0),
                    ),
                  ],
                ),
                width: 30,
                height: 30,
                child: const Icon(
                  Icons.close,
                  size: 16,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
