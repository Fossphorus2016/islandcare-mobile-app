import 'package:flutter/material.dart';
import 'package:island_app/carereceiver/utils/colors.dart';
import 'package:island_app/widgets/assistance_tag_container.dart';

class AssistanceContainer extends StatelessWidget {
  const AssistanceContainer({super.key, this.dd});

  final List? dd;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 0),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: CustomColors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            alignment: Alignment.topLeft,
            child: const Text(
              "Requires Assistance ",
              style: TextStyle(
                fontFamily: "Poppins",
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: Wrap(
                  runSpacing: 5.0,
                  spacing: 5.0,
                  children: [
                    if (dd != null) ...[
                      for (var i = 0; i < dd!.length; i++) ...[
                        AssistanceTagContainer(
                          title: dd![i].toString(),
                        ),
                      ],
                    ],
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
