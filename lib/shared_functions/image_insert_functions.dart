import 'dart:async';
// ignore: avoid_web_libraries_in_flutter
import 'dart:html';
import 'dart:typed_data';

import 'package:askenzo_admin_panel/shared_functions/shared_functions.dart';
import 'package:askenzo_admin_panel/widgets/draggable_input_image.dart';

import 'package:flutter/material.dart';
/// The `loadImageFromChild` function is a Dart function that loads images from a child widget and
/// updates the image paths in the provided `TextEditingController` objects.

Future<bool> loadImageFromChild(
  ScaffoldMessengerState scaffold,
  GlobalKey<DraggableInputImagesState> imageKey,
  GlobalKey<DraggableInputImagesState> previewKey,
  TextEditingController controllerImgPreviewPath,
  TextEditingController controllerImgPaths,
) async {
  bool result = false;
  List<String>? images = await imageKey.currentState?.getFilesPath(scaffold);
  List<String>? preview = await previewKey.currentState?.getFilesPath(scaffold);

  if (preview != null &&
      preview.isNotEmpty &&
      images != null &&
      images.isNotEmpty) {
    controllerImgPreviewPath.text = preview.first;
    controllerImgPaths.text = concatenateStrings(images);
    result = true;
  } else {
    return false;
  }

  return result;
}
/// The `chooseAndStoreImage` function allows the user to select an image file, reads the file as an
/// `Uint8List`, and returns a `Future` that completes with the image data.
/// 
/// Returns:
///   The function `chooseAndStoreImage()` returns a `Future<Uint8List?>`.

Future<Uint8List?> chooseAndStoreImage() async {
  final fileInput = FileUploadInputElement();
  fileInput.accept = 'image/*';

  final completer = Completer<Uint8List?>();

  fileInput.onChange.listen((event) {
    final files = fileInput.files;
    if (files != null) {
      if (files.length == 1) {
        final file = files[0];
        final reader = FileReader();

        reader.onLoadEnd.listen((event) {
          if (reader.result != null) {
            final result = reader.result;
            if (result is Uint8List) {
              completer.complete(result);
            }
          }
        });

        reader.onError.listen((event) {
          completer.completeError('Error reading the selected file.');
        });

        reader.readAsArrayBuffer(file);
      }
    }
  });

  fileInput.click();

  return completer.future;
}
