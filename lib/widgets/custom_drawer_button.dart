import 'package:askenzo_admin_panel/widgets/custom_text.dart';
import 'package:flutter/material.dart';

/// The `CustomDrawerButton` class is a stateless widget that represents a button in a custom drawer
/// with customizable properties such as background color, container height, button text, and an
/// associated function to be executed when the button is pressed.
class CustomDrawerButton extends StatelessWidget {
  const CustomDrawerButton(
      {super.key,
      required this.backgroundColor,
      required this.containerHeight,
      required this.fun,
      required this.buttonText});
  final double containerHeight;
  final Color backgroundColor;
  final Function fun;
  final String buttonText;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: containerHeight,
      color: backgroundColor,
      child: Center(
        child: ListTile(
          title: TextButton(
            child: CustomText(
              text: buttonText,
              color: Colors.white,
              fontSize: 18,
            ),
            onPressed: () async => await fun(),
          ),
        ),
      ),
    );
  }
}
