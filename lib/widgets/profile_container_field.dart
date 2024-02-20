import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:island_app/carereceiver/utils/colors.dart';
import 'package:island_app/utils/utils.dart';

class ProfileContainerField extends StatefulWidget {
  const ProfileContainerField({
    super.key,
    required this.title,
    this.controller,
    this.hintText,
    this.validator,
    this.inputFormatters,
    this.keyboardType,
    this.textInputAction,
  });
  final String title;
  final TextEditingController? controller;
  final String? hintText;
  final String? Function(String?)? validator;
  final List<TextInputFormatter>? inputFormatters;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  @override
  State<ProfileContainerField> createState() => _ProfileContainerFieldState();
}

class _ProfileContainerFieldState extends State<ProfileContainerField> {
  final FocusNode _focusNode = FocusNode();
  bool _hasInteractedByUser = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 17, vertical: 10),
      decoration: BoxDecoration(
        color: CustomColors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.title,
            style: TextStyle(
              color: ServiceGiverColor.black,
              fontSize: 12,
              fontFamily: "Rubik",
              fontWeight: FontWeight.w600,
            ),
          ),
          // const SizedBox(height: 05),
          FormField(
            autovalidateMode: _hasInteractedByUser ? AutovalidateMode.onUserInteraction : AutovalidateMode.disabled,
            builder: (FormFieldState<String> state) {
              // print(state.hasError);
              if (state.hasInteractedByUser) {
                _focusNode.requestFocus();
              }
              return Container(
                padding: state.hasError ? const EdgeInsets.only(left: 12) : null,
                decoration: state.hasError
                    ? BoxDecoration(
                        border: Border.all(color: Colors.red),
                        borderRadius: BorderRadius.circular(12),
                      )
                    : null,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextField(
                      controller: widget.controller,
                      focusNode: _focusNode,
                      inputFormatters: widget.inputFormatters,
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.zero,
                        constraints: const BoxConstraints(maxHeight: 40, minHeight: 40),
                        hintText: widget.hintText,
                        border: InputBorder.none,
                        fillColor: Colors.white24,
                        filled: true,
                      ),
                      onChanged: (value) {
                        // ignore: invalid_use_of_protected_member
                        state.setValue(value);
                        // state.didChange(value);
                      },
                      onTap: () {
                        if (!_hasInteractedByUser) {
                          setState(() {
                            _hasInteractedByUser = true;
                          });
                        }
                      },
                    ),
                    if (state.hasError) ...[
                      Text(
                        state.errorText.toString(),
                        style: const TextStyle(
                          color: Colors.red,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ],
                ),
              );
            },
            validator: widget.validator,
          ),
        ],
      ),
    );
  }
}
