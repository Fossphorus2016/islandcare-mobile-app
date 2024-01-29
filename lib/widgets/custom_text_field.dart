// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:island_app/carereceiver/utils/colors.dart';

class CustomTextFieldWidget extends StatelessWidget {
  Widget? prefIcon;
  Widget? sufIcon;
  String? hintText;
  TextEditingController? controller;
  bool? obsecure = false;
  TextInputType? keyboardType;
  Radius? topLeftBorder = const Radius.circular(12);
  Radius? bottomLeftBorder = const Radius.circular(12);
  Radius? bottomRightBorder = const Radius.circular(12);
  Radius? topRightBorder = const Radius.circular(12);
  TextStyle? textStyle = TextStyle(
    fontSize: 15,
    color: CustomColors.hintText,
    fontFamily: "Rubik",
    fontWeight: FontWeight.w200,
  );
  Color? borderColor = CustomColors.borderLight;
  void Function()? onTap;
  void Function(String)? onChanged;
  String? Function(String?)? validation;
  List<TextInputFormatter>? inputFormatters;
  CustomTextFieldWidget({
    Key? key,
    this.prefIcon,
    this.sufIcon,
    required this.hintText,
    required this.controller,
    required this.obsecure,
    this.keyboardType,
    this.topLeftBorder = const Radius.circular(12),
    this.bottomLeftBorder = const Radius.circular(12),
    this.bottomRightBorder = const Radius.circular(12),
    this.topRightBorder = const Radius.circular(12),
    this.borderColor = const Color(0xff677294),
    this.textStyle,
    this.onChanged,
    this.onTap,
    this.validation,
    this.inputFormatters,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      keyboardType: keyboardType,
      obscureText: obsecure!,
      controller: controller,
      textInputAction: TextInputAction.next,
      inputFormatters: inputFormatters,
      decoration: InputDecoration(
        fillColor: Colors.white,
        prefixIcon: prefIcon,
        suffixIcon: sufIcon,
        hintText: hintText,
        hintStyle: textStyle,
        contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(
            color: Color(0xff677294),
            width: 0.5,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(
            color: Color(0xff677294),
            width: 0.5,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(
            color: Color.fromARGB(255, 194, 0, 0),
            width: 0.5,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(
            color: Color(0xff677294),
            width: 0.5,
          ),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(
            color: Color.fromARGB(255, 194, 0, 0),
            width: 0.5,
          ),
        ),
      ),
      onChanged: onChanged,
      onTap: onTap,
      validator: validation,
    );
  }
}
