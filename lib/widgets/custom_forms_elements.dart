import 'package:askenzo_admin_panel/data/constant_data.dart';
import 'package:askenzo_admin_panel/shared_functions/validator_class.dart';
import 'package:askenzo_admin_panel/widgets/custom_dropdown_button.dart';
import 'package:askenzo_admin_panel/widgets/custom_text.dart';
import 'package:askenzo_admin_panel/widgets/custom_text_form_field.dart';
import 'package:askenzo_admin_panel/widgets/draggable_input_image.dart';

import 'package:flutter/material.dart';

/// The `CustomFormsElements` class is a Dart class that represents a custom form with various input
/// fields and draggable input images.
// ignore: must_be_immutable
class CustomFormsElements extends StatelessWidget {
  CustomFormsElements({
    super.key,
    required this.controllerDescription,
    required this.controllerImgPaths,
    required this.controllerImgPreviewPath,
    required this.choiceStateId,
    required this.controllerTitle,
    this.imageKey,
    this.previewKey,
  });
  TextEditingController controllerTitle;
  TextEditingController controllerDescription;
  TextEditingController controllerImgPreviewPath;
  TextEditingController controllerImgPaths;
  GlobalKey<DraggableInputImagesState>? imageKey;
  GlobalKey<DraggableInputImagesState>? previewKey;

  int choiceStateId;

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      CustomTextFormField(
        title: 'Title',
        validatorFun: (value) => validateTitle(value),
        hintText: 'Inserisci il titolo del contenuto.',
        fieldValue: controllerTitle,
      ),
      const SizedBox(height: ConstantData.spacingHeight),
      CustomDropDownButton(
        mapValues: statesMap,
        inputDecoration: 'State ID',
        initialValue: choiceStateId,
        updateValue: (value) => choiceStateId = value,
      ),
      const SizedBox(height: ConstantData.spacingHeight),
      CustomTextFormField(
        title: 'Description',
        validatorFun: (value) => validateDescription(value),
        maxlines: 6,
        hintText: 'Inserisci una descrizione del contenuto.',
        fieldValue: controllerDescription,
      ),
      const SizedBox(height: ConstantData.spacingHeight),
      Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: ConstantData.spacingHeight),
          const CustomText(
            text: 'Preview Image',
            color: ConstantData.colorePrimario,
          ),
          SizedBox(
            width: 800,
            height: 400,
            child: DraggableInputImages(
              key: previewKey,
              imageController: controllerImgPreviewPath,
              limited: true,
            ),
          ),
          const SizedBox(height: ConstantData.spacingHeight),
          const CustomText(
            text: 'Detail images',
            color: ConstantData.colorePrimario,
          ),
          SizedBox(
            width: 800,
            height: 400,
            child: DraggableInputImages(
              key: imageKey,
              imageController: controllerImgPaths,
              limited: false,
            ),
          ),
        ],
      ),
    ]);
  }
}
