import 'package:askenzo_admin_panel/data/constant_data.dart';
import 'package:flutter/material.dart';
/// The `CustomIdText` class is a stateless widget that displays a ListTile with an ID, text, and an
/// icon.

class CustomIdText extends StatelessWidget {
  const CustomIdText({
    super.key,
    required this.id,
    required this.text,
    required this.icon,
  });
  final String id;
  final String text;
  final Icon icon;
  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Text(id,
          style: const TextStyle(
            fontWeight: FontWeight.w800,
          )),
      title: Text(
        text,
        textAlign: TextAlign.left,
        style: const TextStyle(fontFamily: ConstantData.fontFamilyBody),
      ),
      trailing: icon,
    );
  }
}
