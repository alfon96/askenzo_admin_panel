import 'package:askenzo_admin_panel/api/api.dart';
import 'package:askenzo_admin_panel/models/experience.dart';
import 'package:askenzo_admin_panel/shared_functions/validator_class.dart';
import 'package:flutter/material.dart';
/// The function `showSearchPopup` displays a dialog box with a form to enter an ID, and upon clicking
/// the "Search" button, it validates the ID, calls an asynchronous function `getExperience` to retrieve
/// an experience based on the ID, and displays a snackbar message based on the result.
/// 
/// Args:
///   context (BuildContext): The `BuildContext` of the current widget tree. It is used to access the
/// current `ScaffoldMessengerState` and to build the `AlertDialog` widget.
/// 
/// Returns:
///   The function `showSearchPopup` returns a `Future<UpdateExperienceModel?>`.

Future<UpdateExperienceModel?> showSearchPopup(BuildContext context) async {
  return showDialog<UpdateExperienceModel>(
    context: context,
    builder: (BuildContext context) {
      TextEditingController idController = TextEditingController();
      final formKey = GlobalKey<FormState>();
      ScaffoldMessengerState scaffold = ScaffoldMessenger.of(context);

      return AlertDialog(
        title: const Text("Select Id"),
        content: Form(
          key: formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              TextFormField(
                validator: (value) => validateId(value),
                controller: idController,
                decoration: const InputDecoration(
                  labelText: "Id",
                ),
              ),
            ],
          ),
        ),
        actions: <Widget>[
          ElevatedButton(
            child: const Text("Search"),
            onPressed: () {
              // Capture reference to ScaffoldMessengerState before async gap
              final scaffoldMessenger = ScaffoldMessenger.of(context);

              if (formKey.currentState!.validate()) {
                // Now use async code
                getExperience(scaffold, int.parse(idController.text))
                    .then((experience) {
                  if (experience != null) {
                    scaffoldMessenger.showSnackBar(
                      const SnackBar(
                        content: Text('Contenuto trovato!'),
                      ),
                    );
                    // Return the experience by popping it off the navigation stack
                    Navigator.of(context).pop(experience);
                  } else {
                    scaffoldMessenger.showSnackBar(
                      const SnackBar(
                        content: Text(
                            'Non esistono contenuti associati all\'id inserito'),
                      ),
                    );
                  }
                });
              }
            },
          ),
        ],
      );
    },
  );
}
