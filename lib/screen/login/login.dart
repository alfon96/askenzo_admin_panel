import 'package:askenzo_admin_panel/api/api.dart';
import 'package:askenzo_admin_panel/data/constant_data.dart';
import 'package:askenzo_admin_panel/provider/navigation_provider.dart';
import 'package:askenzo_admin_panel/shared_functions/validator_class.dart';
import 'package:askenzo_admin_panel/widgets/app_bar.dart';
import 'package:askenzo_admin_panel/widgets/custom_elevated_button.dart';
import 'package:askenzo_admin_panel/widgets/custom_text_form_field.dart';
import 'package:askenzo_admin_panel/widgets/custom_waiting_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
/// The LoginPage class is a stateful widget that extends ConsumerStatefulWidget.

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}
/// The `_LoginPageState` class represents the state of the LoginPage widget and handles the login
/// functionality.

class _LoginPageState extends ConsumerState<LoginPage> {
  bool isLoading = false;
  TextEditingController username = TextEditingController();
  TextEditingController password = TextEditingController();
  final formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    username.dispose();
    password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final navigation = ref.read(navigationProvider.notifier);
    final ScaffoldMessengerState scaffold = ScaffoldMessenger.of(context);

    return CustomWaitingWidget(
      isWaiting: isLoading,
      child: Scaffold(
        appBar: const CustomAppBar(title: 'Login'),
        body: Container(
          margin: const EdgeInsets.symmetric(
            horizontal: ConstantData.marginHorizontal,
            vertical: ConstantData.marginVertical,
          ),
          child: Form(
            key: formKey,
            child: Column(children: [
              CustomTextFormField(
                validatorFun: (value) => validateUsername(value),
                fieldValue: username,
                title: "Username",
              ),
              const SizedBox(height: ConstantData.spacingHeight),
              CustomTextFormField(
                obscureText: true,
                validatorFun: (value) => validatePassword(value),
                fieldValue: password,
                title: 'Password',
                icon: const Icon(Icons.remove_red_eye_rounded),
                iconBtnFun: null,
              ),
              const SizedBox(height: 40),
              CustomElevatedButton(
                title: 'Accedi',
                fun: () async {
                  formKey.currentState!.save();

                  if (formKey.currentState!.validate()) {
                    setState(() {
                      isLoading = true;
                    });
                    bool? isLoggedIn = await adminLogin(
                        scaffold, username.text, password.text,
                        alternativeMessage:
                            'Impossibile accedere, controlla le credenziali oppure la connessione internet.');

                    if (isLoggedIn == true) {
                      navigation.pop();
                    }
                  }
                  setState(() {
                    isLoading = false;
                  });
                },
              )
            ]),
          ),
        ),
      ),
    );
  }
}
