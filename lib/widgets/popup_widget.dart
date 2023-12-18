import 'package:askenzo_admin_panel/models/popup.dart';
import 'package:flutter/material.dart';
/// The `PopupWidget` class is a stateless widget that displays a popup with an ID and text in a
/// horizontal row.

class PopupWidget extends StatelessWidget {
  const PopupWidget({super.key, required this.popup});
  final UpdatePopupModel popup;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 800,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            Text('${popup.id}'),
            const SizedBox(width: 5),
            Text(popup.text),
            const SizedBox(width: 5),
          ],
        ),
      ),
    );
  }
}
