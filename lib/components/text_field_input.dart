import 'package:ecosort_app_test/utils/colors.dart';
import 'package:flutter/material.dart';

class TextFieldInput extends StatelessWidget {
  final TextEditingController textEditingController;
  final bool isPass;
  final String hintText;
  final TextInputType textInputType;

  const TextFieldInput({
    super.key,
    required this.hintText,
    this.isPass = false,
    required this.textEditingController,
    required this.textInputType,
  });

  @override
  Widget build(BuildContext context) {
    final inputBorder = OutlineInputBorder(
      borderSide: Divider.createBorderSide(context, color: secondaryColor),
    );

    return TextField(
      controller: textEditingController,
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle:
            const TextStyle(color: secondaryColor), // Updated hint text color
        border: inputBorder,
        focusedBorder: inputBorder,
        enabledBorder: inputBorder,
        filled: true,
        fillColor: primaryColor
            .withOpacity(0.1), // Updated text field background color
        contentPadding: const EdgeInsets.all(8.0),
      ),
      keyboardType: textInputType,
      obscureText: isPass,
    );
  }
}
