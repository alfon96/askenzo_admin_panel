import 'package:askenzo_admin_panel/data/constant_data.dart';
import 'package:askenzo_admin_panel/provider/navigation_provider.dart';
import 'package:askenzo_admin_panel/screen/login/login.dart';
import 'package:askenzo_admin_panel/widgets/custom_text.dart';
import 'package:flutter/material.dart';
/// The function divides a given input string into a list of strings based on a specified delimiter.
/// 
/// Args:
///   input (String): A string representing a path or a series of paths separated by a delimiter.
/// 
/// Returns:
///   The method `dividePaths` returns a `List<String>`.

List<String> dividePaths(
  String input,
) {
  if (input.isEmpty || input == "") {
    return [];
  }
  return input.split(ConstantData.pathsDelimiter);
}
/// The function `concatenateStrings` takes a list of strings and returns a single string by joining
/// them together with a semicolon.
/// 
/// Args:
///   strings (List<String>): A list of strings that need to be concatenated.
/// 
/// Returns:
///   a string that is the concatenation of all the strings in the input list, separated by semicolons.

String concatenateStrings(List<String> strings) {
  return strings.join(';');
}
/// The `showCustomSnackBar` function displays a custom SnackBar with an optional login button and a
/// close button.
/// 
/// Args:
///   scaffoldMessenger (ScaffoldMessengerState): The `scaffoldMessenger` parameter is an instance of
/// `ScaffoldMessengerState`, which is used to show and hide snack bars within a `Scaffold` widget. It
/// is typically obtained by calling `ScaffoldMessenger.of(context)`.
///   message (String): The message parameter is a string that represents the text content of the
/// SnackBar. It is the main message that will be displayed to the user.
///   forceLink (bool): The `forceLink` parameter is a boolean value that determines whether to show a
/// login button in the snackbar. If `forceLink` is set to `true`, the login button will always be
/// shown. If `forceLink` is set to `false` (default value), the login button. Defaults to false

void showCustomSnackBar(
    ScaffoldMessengerState scaffoldMessenger, String message,
    {bool forceLink = false}) {
  // Questa variabile serve per capire quando è necessario mostrare il pulsante di login
  bool isAdditionalInfo =
      kAuthentication.jwt == null && checkRouteName() || forceLink;

  scaffoldMessenger.hideCurrentSnackBar();
  scaffoldMessenger.showSnackBar(
    SnackBar(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(11),
          topRight: Radius.circular(11),
        ),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      backgroundColor: mapSnackbarColors[contextColor],
      content: SizedBox(
        height: 30,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomText(
              text: message,
              color: Colors.white,
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
            if (isAdditionalInfo) const SizedBox(width: 20),
            if (isAdditionalInfo)
              Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.white,
                    width: 1.0,
                  ),
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: TextButton(
                  style: TextButton.styleFrom(padding: EdgeInsets.zero),
                  onPressed: () {
                    scaffoldMessenger.hideCurrentSnackBar();
                    routeNames.add(ConstantData.loginAdmin);
                    globalNavigatorKey.currentState?.push(
                      MaterialPageRoute(
                        builder: (context) => const LoginPage(),
                      ),
                    );
                  },
                  child: const Padding(
                    padding: EdgeInsets.all(4.0),
                    child: CustomText(
                      text: 'Accedi',
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            IconButton(
              splashRadius: 25,
              iconSize: 20,
              padding: EdgeInsets.zero,
              onPressed: () => scaffoldMessenger.hideCurrentSnackBar(),
              icon: const Icon(
                Icons.close,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
      duration: const Duration(seconds: 3),
    ),
  );
}
/// The function checks if the last element in the routeNames list is equal to ConstantData.loginAdmin
/// and returns false if it is, otherwise it returns true.
/// 
/// Returns:
///   a boolean value.

bool checkRouteName() {
  if (routeNames.isNotEmpty) {
    if (routeNames.last == ConstantData.loginAdmin) {
      return false;
    }
  }
  return true;
}

// Experience Api


