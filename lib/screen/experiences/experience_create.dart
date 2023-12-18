import 'package:askenzo_admin_panel/api/api.dart';
import 'package:askenzo_admin_panel/data/constant_data.dart';
import 'package:askenzo_admin_panel/models/experience.dart';
import 'package:askenzo_admin_panel/provider/navigation_provider.dart';
import 'package:askenzo_admin_panel/provider/refresh_provider.dart';
import 'package:askenzo_admin_panel/shared_functions/image_insert_functions.dart';
import 'package:askenzo_admin_panel/shared_functions/validator_class.dart';
import 'package:askenzo_admin_panel/widgets/app_bar.dart';
import 'package:askenzo_admin_panel/widgets/custom_drawer.dart';
import 'package:askenzo_admin_panel/widgets/custom_dropdown_button.dart';
import 'package:askenzo_admin_panel/widgets/custom_elevated_button.dart';
import 'package:askenzo_admin_panel/widgets/custom_forms_elements.dart';
import 'package:askenzo_admin_panel/widgets/custom_text_form_field.dart';
import 'package:askenzo_admin_panel/widgets/custom_waiting_widget.dart';
import 'package:askenzo_admin_panel/widgets/draggable_input_image.dart';
import 'package:askenzo_admin_panel/widgets/image_item.dart';
import 'package:askenzo_admin_panel/widgets/login_popup.dart';
import 'package:flutter/material.dart';
import 'package:askenzo_admin_panel/shared_functions/shared_functions.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
/// The `ExperienceCreate` class is a stateful widget that extends `ConsumerStatefulWidget` in Dart.

class ExperienceCreate extends ConsumerStatefulWidget {
  const ExperienceCreate({super.key});

  @override
  ConsumerState<ExperienceCreate> createState() => _ExperienceCreateState();
}
/// The `_ExperienceCreateState` class is a stateful widget that handles the creation of a new
/// experience, including form validation, input controllers, and submission functionality.

class _ExperienceCreateState extends ConsumerState<ExperienceCreate> {
  final GlobalKey<DraggableInputImagesState> previewKey = GlobalKey();
  final GlobalKey<DraggableInputImagesState> imageKey = GlobalKey();
  final _formKey = GlobalKey<FormState>();
  TextEditingController controllerTitle = TextEditingController();
  TextEditingController controllerDescription = TextEditingController();
  TextEditingController controllerPrice = TextEditingController();
  TextEditingController controllerDuration = TextEditingController();
  TextEditingController controllerImgPreviewPath = TextEditingController();
  TextEditingController controllerImgPaths = TextEditingController();

  int choiceStateId = 1;
  int choiceDifficulty = 1;
  int choiceCurrency = 1;
  bool isLoading = false;
  List<ImageItem> imageWidgets = [];
  ImageItem? previewWidgets;
  Map<String, double> buildPrice(double price) {
    if (choiceCurrency == 1) {
      return {'\$': price};
    } else {
      return {'€': price};
    }
  }

  @override
  void dispose() {
    controllerTitle.dispose();
    controllerDescription.dispose();
    controllerImgPreviewPath.dispose();
    controllerImgPaths.dispose();
    controllerPrice.dispose();
    controllerDuration.dispose();

    super.dispose();
  }

  void submitFun(ScaffoldMessengerState scaffold) async {
    setState(() {
      isLoading = true;
    });
    ScaffoldMessengerState scaffold = ScaffoldMessenger.of(context);

    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      await loadImageFromChild(scaffold, imageKey, previewKey,
          controllerImgPreviewPath, controllerImgPaths);

      if (await createExperience(
        scaffold,
        ExperienceModel(
            title: controllerTitle.text,
            description: controllerDescription.text,
            difficultyId: choiceDifficulty,
            price: buildPrice(double.parse(controllerPrice.text)),
            duration: controllerDuration.text,
            imgPreviewPath: controllerImgPreviewPath.text,
            imgPaths: dividePaths(controllerImgPaths.text),
            stateId: choiceStateId),
      )) {
        ref.read(refreshProvider.notifier).toggle();
        showCustomSnackBar(scaffold, 'Experience Aggiunta!');
      }
    }
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    ScaffoldMessengerState scaffold = ScaffoldMessenger.of(context);

    final navigationNotifier = ref.read(navigationProvider.notifier);

    return WillPopScope(
      onWillPop: () async {
        navigationNotifier.pop();
        return true;
      },
      child: Scaffold(
        appBar: CustomAppBar(
          bckgColor: ConstantData.coloreExperiencePage,
          title: 'Experience Create',
          actions: [
            IconButton(
                icon: const Icon(Icons.person),
                onPressed: () async => await showLoginDialog(context)),
          ],
        ),
        drawer: const CustomDrawer(),
        body: CustomWaitingWidget(
          isWaiting: isLoading,
          child: SingleChildScrollView(
            child: Container(
              margin: const EdgeInsets.symmetric(
                horizontal: ConstantData.marginHorizontal,
                vertical: ConstantData.marginVertical,
              ),
              child: Form(
                key: _formKey,
                child: Column(
                  children: <Widget>[
                    CustomFormsElements(
                      controllerDescription: controllerDescription,
                      controllerImgPaths: controllerImgPaths,
                      controllerImgPreviewPath: controllerImgPreviewPath,
                      choiceStateId: choiceStateId,
                      controllerTitle: controllerTitle,
                      imageKey: imageKey,
                      previewKey: previewKey,
                    ),
                    const SizedBox(height: ConstantData.spacingHeight),
                    CustomDropDownButton(
                      mapValues: difficultyMap,
                      inputDecoration: 'Difficulty',
                      initialValue: choiceDifficulty,
                      updateValue: (value) => choiceDifficulty = value,
                    ),
                    const SizedBox(height: ConstantData.spacingHeight),
                    CustomDropDownButton(
                      mapValues: currencyMap,
                      inputDecoration: 'Currency',
                      initialValue: choiceCurrency,
                      updateValue: (value) => choiceCurrency = value,
                    ),
                    const SizedBox(height: ConstantData.spacingHeight),
                    CustomTextFormField(
                      title: 'Price',
                      initialValue: '0.0',
                      validatorFun: (value) => validatePrice(value),
                      maxlines: 1,
                      hintText: 'Inserisci il prezzo dell\'esperienza.',
                      fieldValue: controllerPrice,
                    ),
                    const SizedBox(height: ConstantData.spacingHeight),
                    CustomTextFormField(
                      title: 'Duration',
                      validatorFun: (value) => validateDuration(value),
                      maxlines: 1,
                      hintText:
                          'Inserisci la durata dell\'esperienza nel formato hh:mm:ss, ad esempio 01:00:00.',
                      fieldValue: controllerDuration,
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
