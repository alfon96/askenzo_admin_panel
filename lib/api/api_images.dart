import 'dart:convert';
import 'dart:typed_data';
import 'package:askenzo_admin_panel/api/api.dart';
import 'package:askenzo_admin_panel/data/constant_data.dart';
/// The `handleApiErrors` function handles different types of exceptions that can occur during an API
/// call and displays an appropriate error message using a `ScaffoldMessenger`.
/// 
/// Args:
///   apiCall (Future<T> Function()): A function that makes an API call and returns a Future<T> where T
/// is the expected response type.
///   scaffoldMessenger (ScaffoldMessengerState): The `scaffoldMessenger` parameter is an instance of
/// `ScaffoldMessengerState`, which is used to show a `SnackBar` widget to display error messages to the
/// user. The `SnackBar` widget is a temporary notification that appears at the bottom of the screen and
/// automatically disappears after a certain duration or
/// 
/// Returns:
///   a `Future<T?>`.
import 'package:askenzo_admin_panel/exceptions/exceptions.dart';
import 'package:askenzo_admin_panel/shared_functions/shared_functions.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:io';
/// The `apiPostImage` function sends a POST request to upload an image file to a specified URL and
/// returns the result.
/// 
/// Args:
///   scaffoldMessenger (ScaffoldMessengerState): The `scaffoldMessenger` parameter is of type
/// `ScaffoldMessengerState` and is used to display error messages or notifications on the screen. It is
/// typically associated with a `ScaffoldMessenger` widget.
///   file (Uint8List): The `file` parameter is a required `Uint8List` that represents the image file to
/// be uploaded.
/// 
/// Returns:
///   a `Future<String?>`.

Future<String?> apiPostImage(ScaffoldMessengerState scaffoldMessenger,
    {required Uint8List file}) async {
  try {
    String url = ConstantData.apiPostImage;

    var request = http.MultipartRequest('POST', Uri.parse(url));
    request.headers.addAll(getFileHeaders());
    request.files
        .add(http.MultipartFile.fromBytes('file', file, filename: 'image.jpg'));

    final response = await request.send();

    if (response.statusCode == 200) {
      final responseBytes = await http.ByteStream(response.stream).toBytes();
      return jsonDecode((utf8.decode(responseBytes)))['result'];
    } else {
      exceptionHandler(response.statusCode, scaffoldMessenger);
      return null;
    }
  } catch (e) {
    showCustomSnackBar(scaffoldMessenger, e.toString());
  }
  return null;
}
/// The function `apiUpdateImage` is a Dart function that sends a PATCH request to update an image file
/// on a server and returns the result.
/// 
/// Args:
///   scaffoldMessenger (ScaffoldMessengerState): The `scaffoldMessenger` parameter is of type
/// `ScaffoldMessengerState` and is used to display snackbar messages in the UI.
///   imgFile (File): The `imgFile` parameter is of type `File` and represents the new image file that
/// needs to be uploaded.
///   oldImgPath (String): The `oldImgPath` parameter is a required String that represents the path of
/// the old image file.
/// 
/// Returns:
///   a `Future<String?>`.

/// The `apiUpdateImage` function sends a PATCH request to update an image file, and returns the updated
/// image URL.
/// 
/// Args:
///   scaffoldMessenger (ScaffoldMessengerState): The `scaffoldMessenger` parameter is of type
/// `ScaffoldMessengerState` and is used to display snackbar messages in the UI. It is typically
/// obtained by calling `ScaffoldMessenger.of(context)` in a widget's build method.
///   imgFile (File): The `imgFile` parameter is of type `File` and represents the new image file that
/// needs to be updated.
///   oldImgPath (String): The `oldImgPath` parameter is a required string that represents the path of
/// the image that needs to be updated.
/// 
/// Returns:
///   The function `apiUpdateImage` returns a `Future<String?>`.
Future<String?> apiUpdateImage(ScaffoldMessengerState scaffoldMessenger,
    {required File imgFile, required String oldImgPath}) async {
  try {
    String url =
        '${ConstantData.apiUpdateImage}?old_file_name=${getFileNameWithExtension(oldImgPath)}';

    var request = http.MultipartRequest('PATCH', Uri.parse(url));
    request.headers.addAll(getFileHeaders());
    request.files.add(await http.MultipartFile.fromPath('file', imgFile.path));

    final response = await request.send();
/// The function `apiDeleteImage` sends a DELETE request to a specified URL to delete an image, and
/// returns a boolean indicating whether the deletion was successful.
/// 
/// Args:
///   scaffoldMessenger (ScaffoldMessengerState): The `scaffoldMessenger` parameter is of type
/// `ScaffoldMessengerState` and is used to display snackbar messages in the UI. It is typically
/// obtained by calling `ScaffoldMessenger.of(context)` in a widget's build method.
///   imgPath (String): The `imgPath` parameter is a required string that represents the path of the
/// image that needs to be deleted.
/// 
/// Returns:
///   a `Future<bool>`.

    if (response.statusCode == 200) {
      final responseBytes = await http.ByteStream(response.stream).toBytes();
      return jsonDecode((utf8.decode(responseBytes)))['result'];
    } else {
      exceptionHandler(response.statusCode, scaffoldMessenger);
      return null;
    }
  } catch (e) {
    showCustomSnackBar(scaffoldMessenger, e.toString());
  }
  return null;
}

Future<bool> apiDeleteImage(ScaffoldMessengerState scaffoldMessenger,
    {required String imgPath}) async {
  try {
    String url =
        '${ConstantData.apiDeleteImage}?image_name=${getFileNameWithExtension(imgPath)}';
    final response = await http.delete(
      Uri.parse(url),
      headers: headers,
    );

    if (response.statusCode == 200) {
      return jsonDecode((utf8.decode(response.bodyBytes)))['result'];
    } else {
      exceptionHandler(response.statusCode, scaffoldMessenger);
      return false;
    }
  } catch (e) {
    showCustomSnackBar(scaffoldMessenger, e.toString());
  }
  return false;
}
/// The `getFileNameWithExtension` function is a Dart function that takes an `imagePath` as input and
/// returns the file name with its extension.

String getFileNameWithExtension(String imagePath) {
  final lastIndex = imagePath.lastIndexOf('/');
  if (lastIndex != -1 && lastIndex < imagePath.length - 1) {
    return imagePath.substring(lastIndex + 1);
  }
  return '';
}
/// The function `apiPostListOfImage` is a Dart function that sends a list of images to an API endpoint
/// and returns a list of strings representing the uploaded image URLs.
/// 
/// Args:
///   scaffoldMessenger (ScaffoldMessengerState): The `scaffoldMessenger` parameter is of type
/// `ScaffoldMessengerState` and is used to display snackbar messages or other notifications to the
/// user.
///   files (List<Uint8List>): A list of Uint8List objects, which represent the image files to be
/// uploaded.
/// 
/// Returns:
///   a `Future<List<String>>`.
/// The function `apiPostListOfImage` is a Dart function that sends a list of images to an API endpoint
/// using a multipart request and returns a list of strings representing the response.
/// 
/// Args:
///   scaffoldMessenger (ScaffoldMessengerState): The `scaffoldMessenger` parameter is of type
/// `ScaffoldMessengerState` and is used to display snackbar messages or other notifications to the
/// user.
///   files (List<Uint8List>): A list of Uint8List objects, which represent the image files to be
/// uploaded.
/// 
/// Returns:
///   a `Future<List<String>>`.

Future<List<String>> apiPostListOfImage(
    ScaffoldMessengerState scaffoldMessenger,
    {required List<Uint8List> files}) async {
  if (files.isNotEmpty) {
    try {
      String url = ConstantData.apiPostListOfImage;

      var request = http.MultipartRequest('POST', Uri.parse(url));
      request.headers.addAll(getFileHeaders());

      for (Uint8List file in files) {
        request.files.add(
          http.MultipartFile.fromBytes(
            'fileList',
            file,
            filename: '${DateTime.now.toString()}.jpg',
          ),
        );
      }
      final response = await request.send();

      if (response.statusCode == 200) {
        final responseBytes = await http.ByteStream(response.stream).toBytes();
        return (jsonDecode(utf8.decode(responseBytes))['result'] as List)
            .map((item) => item.toString())
            .toList();
      } else {
        exceptionHandler(response.statusCode, scaffoldMessenger);
        return [];
      }
    } catch (e) {
      showCustomSnackBar(scaffoldMessenger, e.toString());
    }
  }
  return [];
}

/// The function `apiDeleteListOfImage` sends a DELETE request to a specified URL with a list of image
/// paths as the request body, and returns a boolean indicating whether the request was successful.
/// 
/// Args:
///   scaffoldMessenger (ScaffoldMessengerState): The `scaffoldMessenger` parameter is of type
/// `ScaffoldMessengerState` and is used to display snackbar messages or other notifications to the
/// user. It is typically obtained from the `ScaffoldMessenger.of(context)` method.
///   imgPaths (List<String>): A list of strings representing the paths of the images to be deleted.
/// 
/// Returns:
///   a `Future<bool>`.
Future<bool> apiDeleteListOfImage(ScaffoldMessengerState scaffoldMessenger,
    {required List<String> imgPaths}) async {
  try {
    String url = ConstantData.apiDeleteListOfImage;
    final response = await http.delete(
      Uri.parse(url),
      headers: headers,
      body: imgPaths,
    );

    if (response.statusCode == 200) {
      return jsonDecode((utf8.decode(response.bodyBytes)))['result'];
    } else {
      exceptionHandler(response.statusCode, scaffoldMessenger);
      return false;
    }
  } catch (e) {
    showCustomSnackBar(scaffoldMessenger, e.toString());
  }
  return false;
}
