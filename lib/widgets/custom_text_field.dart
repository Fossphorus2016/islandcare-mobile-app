// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
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

  CustomTextFieldWidget({Key? key, this.prefIcon, this.sufIcon, required this.hintText, required this.controller, required this.obsecure, this.keyboardType, this.topLeftBorder = const Radius.circular(12), this.bottomLeftBorder = const Radius.circular(12), this.bottomRightBorder = const Radius.circular(12), this.topRightBorder = const Radius.circular(12), this.borderColor = const Color(0xff677294), this.textStyle, this.onChanged, this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 54,
      width: MediaQuery.of(context).size.width,
      child: TextFormField(
        keyboardType: keyboardType,
        obscureText: obsecure!,
        controller: controller,
        textInputAction: TextInputAction.next,
        decoration: InputDecoration(
          fillColor: Colors.white,
          prefixIcon: prefIcon,
          suffixIcon: sufIcon,
          hintText: hintText,
          hintStyle: textStyle,
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.only(
              topLeft: topLeftBorder!,
              bottomLeft: bottomLeftBorder!,
              topRight: topRightBorder!,
            ),
            borderSide: BorderSide(
              width: 0.5,
              color: borderColor!,
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.only(
              topLeft: topLeftBorder!,
              bottomLeft: bottomLeftBorder!,
              bottomRight: bottomRightBorder!,
              topRight: topRightBorder!,
            ),
            borderSide: BorderSide(
              color: borderColor!,
              width: 0.5,
            ),
          ),
        ),
        onChanged: onChanged,
        onTap: onTap,
        validator: (val) {
          if (val == null || val.isEmpty) {
            return 'Enter your $hintText';
          }
          return null;
        },
      ),
    );
  }
}
