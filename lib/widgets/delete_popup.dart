import 'package:askenzo_admin_panel/api/api.dart';
import 'package:askenzo_admin_panel/data/constant_data.dart';
import 'package:askenzo_admin_panel/provider/navigation_provider.dart';
import 'package:askenzo_admin_panel/provider/refresh_provider.dart';
import 'package:askenzo_admin_panel/shared_functions/shared_functions.dart';
import 'package:askenzo_admin_panel/widgets/custom_waiting_widget.dart';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// The function `showDeleteDialog` displays a deletion dialog box in the given `BuildContext` with the
/// specified `id` and `typeContent`.
/// 
/// Args:
///   id (int): The unique identifier of the content that needs to be deleted.
///   typeContent (TypeApp): The `typeContent` parameter is of type `TypeApp`, which is likely an
/// enumeration or a class representing the type of content being deleted.
///   context (BuildContext): The `context` parameter is the current build context of the widget tree.
/// It is typically used to access the theme, media query, and other properties of the current build
/// context.
/// 
/// Returns:
///   The `showDeleteDialog` function is returning a `Future<void>`.
Future<void> showDeleteDialog(
    int id, TypeApp typeContent, BuildContext context) async {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return DeletionDialog(id: id, typeContent: typeContent);
    },
  );
}
/// The `DeletionDialog` class is a stateful widget that represents a dialog for confirming the deletion
/// of a specific content type in a Dart application.

class DeletionDialog extends ConsumerStatefulWidget {
  const DeletionDialog(
      {super.key, required this.id, required this.typeContent});
  final TypeApp typeContent;
  final int id;
  @override
  ConsumerState<DeletionDialog> createState() => _DeletionDialogState();
}

/// The `_DeletionDialogState` class is a stateful widget that displays a dialog box asking the user to
/// confirm the deletion of a specific content, and performs the deletion operation when the user clicks
/// the "Elimina" button.
class _DeletionDialogState extends ConsumerState<DeletionDialog> {
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    ScaffoldMessengerState scaffold = ScaffoldMessenger.of(context);
    final navigation = ref.read(navigationProvider.notifier);

    return CustomWaitingWidget(
      isWaiting: isLoading,
      child: AlertDialog(
        title: const Text("Elimina Contenuto"),
        content: const Text('Sei sicuro di voler eliminare questo contenuto?'),
        actions: <Widget>[
          ElevatedButton(
            child: const Text("Torna indietro"),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          ElevatedButton(
            child: const Text("Elimina"),
            onPressed: () async {
              setState(() {
                isLoading = true;
              });
              if (widget.typeContent == TypeApp.experience) {
                if (await deleteExperience(scaffold, widget.id) == true) {
                  showCustomSnackBar(
                      scaffold, 'Esperienza eliminata correttamente.');
                  navigation.pop();
                  ref.read(refreshProvider.notifier).toggle();
                }
              } else if (widget.typeContent == TypeApp.discovery) {
                if (await deleteDiscovery(scaffold, widget.id) == true) {
                  showCustomSnackBar(
                      scaffold, 'Discovery eliminata correttamente.');
                  navigation.pop();
                  ref.read(refreshProvider.notifier).toggle();
                }
              } else if (widget.typeContent == TypeApp.popup) {
                if (await deletePopup(scaffold, widget.id) == true) {
                  showCustomSnackBar(
                      scaffold, 'Popup eliminata correttamente.');
                  navigation.pop();
                  ref.read(refreshProvider.notifier).toggle();
                }
                setState(() {
                  isLoading = false;
                });
              }
            },
          ),
        ],
      ),
    );
  }
}
