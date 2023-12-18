import 'package:askenzo_admin_panel/data/constant_data.dart';
import 'package:askenzo_admin_panel/widgets/custom_text.dart';
import 'package:flutter/material.dart';
/// The `CustomElevatedButton` class is a custom widget in Dart that extends `StatelessWidget` and
/// creates an elevated button with customizable properties such as title, font size, padding,
/// background color, alignment, and context color.

class CustomElevatedButton extends StatelessWidget {
  const CustomElevatedButton(
      {super.key,
      required this.title,
      required this.fun,
      this.fontSize = 15.0,
      this.paddingVertical = 0.0,
      this.paddingHorizontal = 0.0,
      this.bkgColor,
      this.alignment = TextAlign.left,
      this.ctxColor});
  final Function fun;
  final String title;
  final double fontSize;
  final double paddingVertical;
  final double paddingHorizontal;
  final Color? bkgColor;
  final TextAlign alignment;
  final int? ctxColor;
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        FocusScope.of(context).unfocus();
        fun();
        contextColor = ctxColor ?? contextColor;
      },
      style: ButtonStyle(
        backgroundColor: MaterialStatePropertyAll(
            bkgColor ?? mapSnackbarColors[contextColor]),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(
          vertical: paddingVertical,
          horizontal: paddingHorizontal,
        ),
        child: CustomText(
          text: title,
          color: Colors.white,
          fontSize: 16,
        ),
      ),
    );
  }
}
