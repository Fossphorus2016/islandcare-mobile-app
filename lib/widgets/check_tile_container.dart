import 'package:flutter/material.dart';

class CheckTileContainer extends StatelessWidget {
  const CheckTileContainer({
    super.key,
    this.onTap,
    this.onChanged,
    required this.title,
    this.checked,
  });

  final void Function()? onTap;
  final void Function(bool?)? onChanged;
  final bool? checked;
  final String title;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Checkbox(
              value: checked,
              onChanged: onChanged,
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            Text(
              title,
              style: const TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
