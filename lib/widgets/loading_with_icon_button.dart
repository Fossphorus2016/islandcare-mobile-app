import 'package:flutter/material.dart';

class LoadingButtonWithIcon extends StatefulWidget {
  const LoadingButtonWithIcon({
    super.key,
    required this.onPressed,
    required this.icon,
    this.backgroundColor,
    this.loadingColor,
    this.buttonStyle,
  });

  final Future<bool> Function() onPressed;
  final Color? backgroundColor;
  final Color? loadingColor;
  final ButtonStyle? buttonStyle;
  final Widget icon;
  @override
  State<LoadingButtonWithIcon> createState() => _LoadingButtonWithIconState();
}

class _LoadingButtonWithIconState extends State<LoadingButtonWithIcon> {
  bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    return IconButton(
      style: widget.buttonStyle,
      onPressed: () async {
        if (isLoading) {
          return;
        }
        setState(() {
          isLoading = true;
        });
        await widget.onPressed();
        setState(() {
          isLoading = false;
        });
      },
      icon: widget.icon,
    );
  }
}
