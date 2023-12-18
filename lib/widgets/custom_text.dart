import 'package:askenzo_admin_panel/data/constant_data.dart';
import 'package:flutter/material.dart';
/// The `CustomText` class is a customizable text widget in Dart that allows you to set various
/// properties such as text content, font size, color, padding, alignment, and more.

class CustomText extends StatelessWidget {
  const CustomText({
    super.key,
    required this.text,
    this.fontSize = 14.5,
    this.maxLines = 2,
    this.color = Colors.black,
    this.fontFamilyBody = ConstantData.fontFamilyBody,
    this.contentPaddingL = 0.0,
    this.contentPaddingT = 0.0,
    this.contentPaddingR = 0.0,
    this.contentPaddingB = 0.0,
    this.isTitle = false,
    this.centered = false,
    this.fontWeight = FontWeight.w500,
    this.alignment = TextAlign.left,
    this.overflow,
  });
  final String text;
  final int maxLines;
  final String fontFamilyBody;
  final double fontSize;
  final Color color;
  final double contentPaddingL;
  final double contentPaddingR;
  final double contentPaddingT;
  final double contentPaddingB;
  final bool isTitle;
  final bool centered;
  final FontWeight fontWeight;
  final TextAlign alignment;
  final TextOverflow? overflow;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(
          contentPaddingL, contentPaddingT, contentPaddingR, contentPaddingB),
      child: Text(
        overflow: overflow,
        text,
        maxLines: maxLines,
        textAlign: centered ? TextAlign.center : alignment,
        style: isTitle == false
            ? TextStyle(
                color: color,
                fontFamily: fontFamilyBody,
                fontSize: fontSize,
                fontWeight: fontWeight,
              )
            : TextStyle(
                color: color,
                fontWeight: FontWeight.w800,
                fontFamily: fontFamilyBody,
                fontSize: fontSize,
              ),
      ),
    );
  }
}
