import 'package:flutter/material.dart';
import 'package:instagram/utils/colors.dart';

class TextFieldInput extends StatelessWidget {
  final TextEditingController textEditingController;
  final bool isPassword;
  final TextInputType textInputType;
  final String hintText;
  const TextFieldInput(
      {Key? key,
      required this.textEditingController,
      this.isPassword = false,
      required this.textInputType,
      required this.hintText})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final inputBorder =
        OutlineInputBorder(borderSide: Divider.createBorderSide(context));
    return TextField(
      controller: textEditingController,
      decoration: InputDecoration(
        filled: true,
        fillColor: textFieldColor,
        border: inputBorder,
        contentPadding: const EdgeInsets.all(8),
        hintText: hintText,
        focusedBorder: inputBorder,
        enabledBorder: inputBorder,
      ),
      keyboardType: textInputType,
      obscureText: isPassword,
    );
  }
}
