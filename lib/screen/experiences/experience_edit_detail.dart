import 'package:askenzo_admin_panel/api/api.dart';
import 'package:askenzo_admin_panel/data/constant_data.dart';
import 'package:askenzo_admin_panel/data/form_data.dart';
import 'package:askenzo_admin_panel/models/experience.dart';
import 'package:askenzo_admin_panel/provider/navigation_provider.dart';
import 'package:askenzo_admin_panel/provider/refresh_provider.dart';
import 'package:askenzo_admin_panel/shared_functions/image_insert_functions.dart';
import 'package:askenzo_admin_panel/shared_functions/shared_functions.dart';
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
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ExperienceEditDetail extends ConsumerStatefulWidget {
  const ExperienceEditDetail({super.key, required this.experience});
  final UpdateExperienceModel experience;

  @override
  ConsumerState<ExperienceEditDetail> createState() =>
      _ExperienceEditDetailState();
}
/// The `_ExperienceEditDetailState` class is a stateful widget that handles the editing of experience
/// details, including form validation, data retrieval, and submission.

class _ExperienceEditDetailState extends ConsumerState<ExperienceEditDetail> {
  final _formKey = GlobalKey<FormState>();
  final GlobalKey<DraggableInputImagesState> previewKey = GlobalKey();
  final GlobalKey<DraggableInputImagesState> imageKey = GlobalKey();
  late ExperienceDataForm startingValues;
  TextEditingController controllerTitle = TextEditingController();
  TextEditingController controllerDescription = TextEditingController();
  TextEditingController controllerPrice = TextEditingController();
  TextEditingController controllerDuration = TextEditingController();
  TextEditingController controllerImgPreviewPath = TextEditingController();
  TextEditingController controllerImgPaths = TextEditingController();
  int choiceStateId = 1;
  int choiceDifficulty = 1;
  int choiceCurrency = 1;
  int experienceId = 0;
  List<ImageItem> imageWidgets = [];
  ImageItem? previewWidgets;
  bool isLoading = false;
  int retrieveCurrency(Map<String, double> priceMap) {
    if (priceMap.keys.first == '\$') {
      return 1;
    }
    return 2;
  }

  Map<String, double> buildPrice(double price) {
    if (choiceCurrency == 1) {
      return {'\$': price};
    } else {
      return {'€': price};
    }
  }

  ExperienceDataForm stateFromControllers() {
    return ExperienceDataForm(
      id: experienceId,
      title: controllerTitle.text,
      description: controllerDescription.text,
      imgPreviewPath: controllerImgPreviewPath.text,
      imgPaths: controllerImgPaths.text,
      price: controllerPrice.text,
      duration: controllerDuration.text,
      stateId: choiceStateId,
      difficultyId: choiceDifficulty,
      currency: choiceCurrency,
    );
  }

  @override
  void initState() {
    super.initState();
    experienceId = widget.experience.id;
    controllerTitle.text = widget.experience.title;
    controllerDescription.text = widget.experience.description;
    controllerPrice.text = '${widget.experience.price.values.first}';
    controllerDuration.text = widget.experience.duration;
    controllerImgPreviewPath.text = widget.experience.imgPreviewPath;
    controllerImgPaths.text = concatenateStrings(widget.experience.imgPaths);
    choiceStateId = widget.experience.stateId;
    choiceDifficulty = widget.experience.difficultyId;
    choiceCurrency = retrieveCurrency(widget.experience.price);
    // Store the initial values to tell when something has changed
    startingValues = stateFromControllers();
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
    bool imageEdited = false;
    setState(() {
      isLoading = true;
    });
    if (_formKey.currentState!.validate()) {
      // check if there are differences between initial and new data
      _formKey.currentState!.save();

      if (imageKey.currentState != null &&
          previewKey.currentState != null &&
          (imageKey.currentState!.isThereSomethingNew() ||
              previewKey.currentState!.isThereSomethingNew())) {
        imageEdited = true;

        await loadImageFromChild(
          scaffold,
          imageKey,
          previewKey,
          controllerImgPreviewPath,
          controllerImgPaths,
        );
      }
      ExperienceDataForm newData = stateFromControllers();
      bool formDataChanged = startingValues.checkDifferences(newData);
      if (formDataChanged || imageEdited) {
        // create experience object
        UpdateExperienceModel result = UpdateExperienceModel(
          id: widget.experience.id,
          title: controllerTitle.text,
          description: controllerDescription.text,
          difficultyId: choiceDifficulty,
          price: buildPrice(double.parse(controllerPrice.text)),
          duration: controllerDuration.text,
          imgPreviewPath: controllerImgPreviewPath.text,
          imgPaths: dividePaths(controllerImgPaths.text),
          stateId: choiceStateId,
        );

        // send it to api
        if (await updateExperience(scaffold, result)) {
          startingValues = stateFromControllers();
          showCustomSnackBar(scaffold, 'Esperienza aggiornata con successo');
          ref.read(refreshProvider.notifier).toggle();
        }
      } else {
        showCustomSnackBar(
            scaffold, 'Non ci sono modifiche, esperienza non aggiornata');
      }
    }
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final navigationNotifier = ref.read(navigationProvider.notifier);
    ScaffoldMessengerState scaffold = ScaffoldMessenger.of(context);

    return WillPopScope(
      onWillPop: () async {
        ref.read(refreshProvider.notifier).toggle();
        navigationNotifier.pop();
        return true;
      },
      child: Scaffold(
        appBar: CustomAppBar(
          title: 'Experience Edit',
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
                      inputDecoration: 'DIFFICULTY:',
                      initialValue: choiceDifficulty,
                      updateValue: (value) => choiceDifficulty = value,
                    ),
                    const SizedBox(height: ConstantData.spacingHeight),
                    CustomDropDownButton(
                      mapValues: currencyMap,
                      inputDecoration: 'CURRENCY:',
                      initialValue: choiceCurrency,
                      updateValue: (value) => choiceCurrency = value,
                    ),
                    const SizedBox(height: ConstantData.spacingHeight * 2),
                    CustomTextFormField(
                      title: 'Price',
                      validatorFun: (value) => validatePrice(value),
                      maxlines: 1,
                      hintText:
                          'Inserisci il prezzo dell\'esperienza, lascia vuoto se è gratuita.',
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
