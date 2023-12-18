import 'package:askenzo_admin_panel/data/constant_data.dart';
import 'package:askenzo_admin_panel/widgets/custom_text.dart';
import 'package:flutter/material.dart';
/// The CustomDropDownButton class is a stateful widget that represents a custom drop-down button with
/// specified map values, input decoration, initial value, and a function to update the value.

class CustomDropDownButton extends StatefulWidget {
  const CustomDropDownButton({
    super.key,
    required this.mapValues,
    required this.inputDecoration,
    required this.initialValue,
    required this.updateValue,
  });
  final Map<String, int> mapValues;
  final String inputDecoration;
  final int initialValue;
  final Function updateValue;

  @override
  State<CustomDropDownButton> createState() => _CustomDropDownButtonState();
}
/// The `_CustomDropDownButtonState` class is a stateful widget that represents a custom dropdown button
/// in Dart.

class _CustomDropDownButtonState extends State<CustomDropDownButton> {
  int? dropdownValue;
  @override
  void initState() {
    super.initState();
    dropdownValue = widget.initialValue;
  }

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<int>(
      decoration: InputDecoration(
        labelText: widget.inputDecoration,
        labelStyle: const TextStyle(
            color: ConstantData.colorePrimario,
            fontFamily: ConstantData.fontFamilyBody,
            fontWeight: FontWeight.w500,
            fontSize: 20),
      ),
      value: widget.initialValue,
      items: widget.mapValues.entries.map((entry) {
        return DropdownMenuItem<int>(
          value: entry.value,
          child: CustomText(text: entry.key, color: Colors.purple),
        );
      }).toList(),
      onChanged: (int? newValue) {
        setState(() {
          dropdownValue = newValue!;
          widget.updateValue(dropdownValue);
        });
      },
      onSaved: (int? newValue) {
        dropdownValue = newValue!;
      },
    );
  }
}
