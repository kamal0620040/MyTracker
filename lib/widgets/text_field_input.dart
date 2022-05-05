import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TextFieldInput extends StatelessWidget {
  final TextEditingController textEditingController;
  final bool isPass;
  final String hintText;
  final TextInputType textInputType;

  const TextFieldInput(
      {Key? key,
      this.isPass = false,
      required this.textEditingController,
      required this.hintText,
      required this.textInputType})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    const inputBorder = OutlineInputBorder(
      // borderSide: Divider.createBorderSide(context),
      borderSide: BorderSide(color: Color.fromRGBO(87, 87, 87, 1), width: 1.0),
    );
    const inputBorderFocus = OutlineInputBorder(
      borderSide: BorderSide(
        color: Color.fromRGBO(101, 146, 233, 0.5),
        width: 1.0,
      ),
    );
    return TextField(
      style: GoogleFonts.poppins(
        textStyle: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w400,
        ),
      ),
      controller: textEditingController,
      decoration: InputDecoration(
        // fillColor: mobileBackgroundColorDark,
        hintText: hintText,
        border: inputBorder,
        focusedBorder: inputBorderFocus,
        enabledBorder: inputBorder,
        filled: true,
        contentPadding: const EdgeInsets.all(16),
      ),
      keyboardType: textInputType,
      obscureText: isPass,
    );
  }
}
