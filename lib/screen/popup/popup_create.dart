
import 'package:askenzo_admin_panel/api/api.dart';
import 'package:askenzo_admin_panel/data/constant_data.dart';

import 'package:askenzo_admin_panel/models/popup.dart';
import 'package:askenzo_admin_panel/provider/navigation_provider.dart';
import 'package:askenzo_admin_panel/provider/refresh_provider.dart';
import 'package:askenzo_admin_panel/shared_functions/shared_functions.dart';
import 'package:askenzo_admin_panel/shared_functions/validator_class.dart';
import 'package:askenzo_admin_panel/widgets/app_bar.dart';
import 'package:askenzo_admin_panel/widgets/custom_drawer.dart';
import 'package:askenzo_admin_panel/widgets/custom_elevated_button.dart';

import 'package:askenzo_admin_panel/widgets/custom_text_form_field.dart';
import 'package:askenzo_admin_panel/widgets/custom_waiting_widget.dart';
import 'package:askenzo_admin_panel/widgets/login_popup.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
/// The above class is a Dart widget for creating a popup in an admin panel application.
class PopupCreate extends ConsumerStatefulWidget {
  const PopupCreate({super.key});
  @override
  ConsumerState<PopupCreate> createState() => _PopupCreateState();
}
/// The `_PopupCreateState` class is a stateful widget that represents a form for creating a popup,
/// including text input and a submit button.

class _PopupCreateState extends ConsumerState<PopupCreate> {
  bool isLoading = false;
  final _formKey = GlobalKey<FormState>();
  TextEditingController controllerText = TextEditingController();

  @override
  void dispose() {
    controllerText.dispose();

    super.dispose();
  }

  void submitFun(ScaffoldMessengerState scaffold) async {
    {
      setState(() {
        isLoading = true;
      });
      if (_formKey.currentState!.validate()) {
        _formKey.currentState!.save();
        ScaffoldMessengerState scaffold = ScaffoldMessenger.of(context);

        if (await createPopup(
                scaffold,
                PopupModel(
                  text: controllerText.text,
                )) ==
            true) {
          ref.read(refreshProvider.notifier).toggle();

          showCustomSnackBar(scaffold, 'Popup Aggiunto!');
        }
      }
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final navigationNotifier = ref.read(navigationProvider.notifier);
    ScaffoldMessengerState scaffold = ScaffoldMessenger.of(context);

    return WillPopScope(
      onWillPop: () async {
        navigationNotifier.pop();
        return true;
      },
      child: CustomWaitingWidget(
        isWaiting: isLoading,
        child: Scaffold(
          appBar: CustomAppBar(
            bckgColor: ConstantData.colorePopUpPage,
            title: 'Popup Create',
            actions: [
              IconButton(
                  icon: const Icon(Icons.person),
                  onPressed: () async => await showLoginDialog(context)),
            ],
          ),
          drawer: const CustomDrawer(),
          body: SingleChildScrollView(
            child: Container(
              margin: const EdgeInsets.symmetric(
                horizontal: ConstantData.marginHorizontal,
                vertical: ConstantData.marginVertical,
              ),
              child: Form(
                key: _formKey,
                child: Column(
                  children: <Widget>[
                    CustomTextFormField(
                      title: 'Testo Popup',
                      validatorFun: (value) => validatePopupText(value),
                      maxlines: 2,
                      hintText: 'Inserisci frase popup',
                      fieldValue: controllerText,
                    ),
                    const SizedBox(height: ConstantData.spacingHeight * 2),
                    CustomElevatedButton(
                      paddingHorizontal: ConstantData.paddingHorizontalSubmit,
                      paddingVertical: ConstantData.paddingVerticalSubmit,
                      title: 'Submit',
                      fun: () async => submitFun(scaffold),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
