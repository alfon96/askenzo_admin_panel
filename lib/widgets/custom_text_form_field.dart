import 'package:askenzo_admin_panel/data/constant_data.dart';
import 'package:flutter/material.dart';
/// The `CustomTextFormField` class is a custom form field widget in Dart that allows for customization
/// of various properties such as title, field value, validator function, obscure text, max lines, hint
/// text, icon, icon button function, keyboard type, content padding, and initial value.

class CustomTextFormField extends StatefulWidget {
  const CustomTextFormField({
    super.key,
    required this.title,
    required this.fieldValue,
    required this.validatorFun,
    this.obscureText = false,
    this.maxlines = 1,
    this.hintText,
    this.icon,
    this.iconBtnFun,
    this.keyboardType = TextInputType.text,
    this.contentPaddingL = 0.0,
    this.contentPaddingT = 0.0,
    this.contentPaddingR = 0.0,
    this.contentPaddingB = 0.0,
    this.initialValue,
  });
  final int maxlines;
  final bool obscureText;
  final String title;
  final String? hintText;
  final TextEditingController fieldValue;
  final Function validatorFun;
  final Icon? icon;
  final Function? iconBtnFun;
  final TextInputType keyboardType;
  final double contentPaddingL;
  final double contentPaddingR;
  final double contentPaddingT;
  final double contentPaddingB;
  final String? initialValue;
  @override
  State<CustomTextFormField> createState() => _CustomTextFormFieldState();
}
/// The `_CustomTextFormFieldState` class is a stateful widget that creates a custom text form field
/// with various properties and functionalities.

class _CustomTextFormFieldState extends State<CustomTextFormField> {
  late bool obscuredField;
  Color iconColor = Colors.black54;
  @override
  void initState() {
    super.initState();
    obscuredField = widget.obscureText;
    widget.fieldValue.text = widget.initialValue ?? widget.fieldValue.text;
  }

  @override
  Widget build(BuildContext context) {
    void toggleVisibility() {
      setState(() {
        obscuredField = !obscuredField;
      });
    }

    void toggleColor() {
      if (iconColor == Colors.black54) {
        iconColor = const Color.fromARGB(255, 43, 107, 150);
      } else {
        iconColor = Colors.black54;
      }
    }

    void iconBtnFunLogic() {
      if (widget.iconBtnFun != null) {
        widget.iconBtnFun!();
      } else {
        toggleVisibility();
      }

      toggleColor();
    }

    return TextFormField(
      controller: widget.fieldValue,
      maxLines: widget.maxlines,
      autofocus: false,
      obscureText: obscuredField,
      validator: (value) => widget.validatorFun(value),
      keyboardType: widget.keyboardType,
      decoration: InputDecoration(
        contentPadding: EdgeInsets.fromLTRB(
          widget.contentPaddingL,
          widget.contentPaddingT,
          widget.contentPaddingR,
          widget.contentPaddingB,
        ),
        errorMaxLines: 2,
        floatingLabelBehavior: FloatingLabelBehavior.always,
        labelText: widget.title,
        //border: InputBorder.none,
        hintText: widget.hintText,
        labelStyle: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w500,
          color: ConstantData.colorePrimario,
        ),
        suffixIcon: widget.icon != null
            ? IconButton(
                color: iconColor,
                icon: widget.icon!,
                onPressed: () => iconBtnFunLogic(),
              )
            : null,
      ),
      style: Theme.of(context).textTheme.bodyMedium,
    );
  }
}
