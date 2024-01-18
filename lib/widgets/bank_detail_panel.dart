import 'package:flutter/material.dart';
import 'package:island_app/carereceiver/utils/colors.dart';
import 'package:island_app/widgets/custom_expansion_panel.dart';

class BankDetailPanel extends StatefulWidget {
  const BankDetailPanel({
    super.key,
    required this.bankName,
    required this.accountTitle,
    required this.accountNumber,
    required this.defaulBank,
    required this.status,
    required this.deleteBank,
    required this.setDefaultBank,
  });
  final String bankName;
  final String accountTitle;
  final String accountNumber;
  final bool? defaulBank;
  final String status;
  final void Function()? deleteBank;
  final void Function()? setDefaultBank;
  @override
  State<BankDetailPanel> createState() => _BankDetailPanelState();
}

class _BankDetailPanelState extends State<BankDetailPanel> {
  bool expanded = false;
  @override
  Widget build(BuildContext context) {
    return CustomExpansionPanelList(
      borderColor: Colors.grey.shade300,
      expandedHeaderPadding: EdgeInsets.zero,
      elevation: 1,
      expansionCallback: (panelIndex, isExpanded) {
        setState(() {
          expanded = !expanded;
        });
      },
      children: [
        CustomExpansionPanel(
          canTapOnHeader: true,
          isExpanded: expanded,
          headerBuilder: (context, isExpanded) {
            return Padding(
              padding: const EdgeInsets.only(right: 10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                // crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.bankName.toString(),
                    style: TextStyle(
                      color: CustomColors.primaryText,
                      fontFamily: "Poppins",
                      fontWeight: FontWeight.w600,
                      fontSize: 13,
                    ),
                  ),
                  Text(
                    widget.accountTitle.toString(),
                    style: TextStyle(
                      color: CustomColors.primaryText,
                      fontFamily: "Poppins",
                      fontWeight: FontWeight.w600,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            );
          },
          body: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Account Number",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(widget.accountNumber),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Status",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(
                      widget.status.toString().toUpperCase(),
                      style: TextStyle(
                        color: widget.status.toString().toLowerCase() == "approved" ? Colors.green : null,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Selected Default Bank",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(widget.defaulBank.toString().toUpperCase()),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    if (widget.defaulBank != true) ...[
                      TextButton(
                        onPressed: widget.setDefaultBank,
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.resolveWith((states) => Colors.green),
                          shape: MaterialStateProperty.resolveWith(
                            (states) => RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                        child: const Text(
                          "Set Default Bank",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ],
                    TextButton(
                      onPressed: widget.deleteBank,
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.resolveWith((states) => Colors.red),
                        shape: MaterialStateProperty.resolveWith(
                          (states) => RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                      child: const Text(
                        "Delete",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                ),
                const Divider(),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
