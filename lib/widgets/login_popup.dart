import 'package:askenzo_admin_panel/api/api.dart';
import 'package:askenzo_admin_panel/data/constant_data.dart';
import 'package:askenzo_admin_panel/provider/navigation_provider.dart';
import 'package:askenzo_admin_panel/shared_functions/shared_functions.dart';
import 'package:askenzo_admin_panel/shared_functions/validator_class.dart';
import 'package:askenzo_admin_panel/widgets/custom_text_form_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
/// The function `showLoginDialog` displays a login dialog in the given `BuildContext` context.
/// 
/// Args:
///   context (BuildContext): The context parameter is the BuildContext object, which represents the
/// location of a widget in the widget tree. It is used to access the current theme, media query
/// information, and other dependencies of the widget tree.
/// 
/// Returns:
///   The `showLoginDialog` function is returning a `Future<void>`.

Future<void> showLoginDialog(BuildContext context) async {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return const AccessDialogs();
    },
  );
}
/// The `AccessDialogs` class is a Dart widget that displays a login or logout dialog based on the
/// authentication status.

class AccessDialogs extends ConsumerWidget {
  const AccessDialogs({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final navigator = ref.read(navigationProvider.notifier);
    TextEditingController usernameController = TextEditingController();
    TextEditingController passwordController = TextEditingController();
    final formKey = GlobalKey<FormState>();
    ScaffoldMessengerState scaffold = ScaffoldMessenger.of(context);

    return kAuthentication.jwt == null
        ? AlertDialog(
            title: const Text("Login"),
            content: Form(
              key: formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  const SizedBox(height: ConstantData.spacingHeight / 2),
                  CustomTextFormField(
                    validatorFun: (value) => validateUsername(value),
                    fieldValue: usernameController,
                    title: "Username",
                  ),
                  const SizedBox(height: ConstantData.spacingHeight),
                  CustomTextFormField(
                    obscureText: true,
                    validatorFun: (value) => validatePassword(value),
                    fieldValue: passwordController,
                    title: 'Password',
                    icon: const Icon(Icons.remove_red_eye_rounded),
                    iconBtnFun: null,
                  ),
                ],
              ),
            ),
            actions: <Widget>[
              ElevatedButton(
                child: const Text("Cancel"),
                onPressed: () {
                  // close the dialog
                  Navigator.of(context).pop();
                },
              ),
              ElevatedButton(
                child: const Text("Login"),
                onPressed: () async {
                  NavigatorState navigator = Navigator.of(context);
                  ScaffoldMessengerState scaffoldMessenger =
                      ScaffoldMessenger.of(context);
                  if (formKey.currentState!.validate()) {
                    if (await adminLogin(scaffold, usernameController.text,
                            passwordController.text,
                            alternativeMessage:
                                'Impossibile accedere, controlla le credenziali oppure la connessione internet.') ==
                        true) {
                      navigator.pop();
                      showCustomSnackBar(scaffoldMessenger, 'Benvenuto!');
                    }
                  }
                },
              ),
            ],
          )
        : AlertDialog(
            title: const Text("Logout"),
            content: const Text('Vuoi davvero eseguire il logout?'),
            actions: <Widget>[
                ElevatedButton(
                  child: const Text("Cancel"),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                ElevatedButton(
                    child: const Text("Logout"),
                    onPressed: () {
                      kAuthentication.jwt = null;
                      updateHeader();

                      navigator.pushReplacement(ConstantData.home);
                      showCustomSnackBar(
                          scaffold, 'Logout eseguito correttamente');
                    }),
              ]);

    
  }
}
