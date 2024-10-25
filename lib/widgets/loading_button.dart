import 'package:flutter/material.dart';

class LoadingButton extends StatefulWidget {
  const LoadingButton({
    super.key,
    required this.title,
    required this.onPressed,
    this.backgroundColor,
    this.loadingColor,
    this.width,
    this.height,
    this.textStyle,
    this.buttonStyle,
  });
  final String title;
  final Future<bool> Function() onPressed;
  final Color? backgroundColor;
  final Color? loadingColor;
  final double? width;
  final double? height;
  final TextStyle? textStyle;
  final ButtonStyle? buttonStyle;
  @override
  State<LoadingButton> createState() => _LoadingButtonState();
}

class _LoadingButtonState extends State<LoadingButton> {
  bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.width ?? MediaQuery.of(context).size.width,
      height: widget.height ?? 80,
      child: TextButton(
        style: widget.buttonStyle ??
            ButtonStyle(
              backgroundColor: WidgetStatePropertyAll(widget.backgroundColor),
              shape: WidgetStatePropertyAll(RoundedRectangleBorder(borderRadius: BorderRadius.circular(08))),
            ),
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
        child: isLoading
            ? SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(
                  color: widget.loadingColor ?? Colors.white,
                ),
              )
            : Text(
                widget.title,
                style: widget.textStyle ?? const TextStyle(color: Colors.white),
              ),
      ),
    );
  }
}
