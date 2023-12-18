import 'package:askenzo_admin_panel/api/api.dart';
import 'package:askenzo_admin_panel/data/constant_data.dart';
import 'package:askenzo_admin_panel/models/discovery.dart';
import 'package:askenzo_admin_panel/provider/data_provider.dart';
import 'package:askenzo_admin_panel/provider/navigation_provider.dart';
import 'package:askenzo_admin_panel/provider/refresh_provider.dart';
import 'package:askenzo_admin_panel/shared_functions/image_insert_functions.dart';
import 'package:askenzo_admin_panel/shared_functions/shared_functions.dart';
import 'package:askenzo_admin_panel/shared_functions/validator_class.dart';
import 'package:askenzo_admin_panel/widgets/app_bar.dart';
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
/// The `DiscoveryCreate` class is a stateful widget that extends `ConsumerStatefulWidget` in Dart.

class DiscoveryCreate extends ConsumerStatefulWidget {
  const DiscoveryCreate({super.key});

  @override
  ConsumerState<DiscoveryCreate> createState() => _DiscoveryCreateState();
}
/// The `getPaths` function takes a list of strings `listPaths` as input and concatenates all the
/// strings in the list with a semicolon (`;`) separator. It then returns the resulting string.

String getPaths(List<String> listPaths) {
  String result = '';
  for (String path in listPaths) {
    result += '$path;';
  }
  return result;
}
/// The `_DiscoveryCreateState` class is a stateful widget that handles the creation of a discovery
/// object, including form validation and submission.

class _DiscoveryCreateState extends ConsumerState<DiscoveryCreate> {
  final _formKey = GlobalKey<FormState>();
  final GlobalKey<DraggableInputImagesState> previewKey = GlobalKey();
  final GlobalKey<DraggableInputImagesState> imageKey = GlobalKey();
  TextEditingController controllerTitle = TextEditingController();
  TextEditingController controllerDescription = TextEditingController();
  TextEditingController controllerImgPreviewPath = TextEditingController();
  TextEditingController controllerImgPaths = TextEditingController();
  TextEditingController controllerVideoPaths = TextEditingController();
  TextEditingController controllerLongitude = TextEditingController();
  TextEditingController controllerLatitude = TextEditingController();
  TextEditingController controllerAddress = TextEditingController();
  bool isLoading = false;
  List<ImageItem> imageWidgets = [];
  ImageItem? previewWidgets;
  int choiceStateId = 1;
  int choiceKind = 1;
  int discoveryId = 0;

  @override
  void dispose() {
    controllerTitle.dispose();
    controllerDescription.dispose();
    controllerImgPreviewPath.dispose();
    controllerImgPaths.dispose();
    controllerVideoPaths.dispose();
    controllerLongitude.dispose();
    controllerLatitude.dispose();
    controllerAddress.dispose();
    super.dispose();
  }

  void submitFun(ScaffoldMessengerState scaffold) async {
    {
      setState(() {
        isLoading = true;
      });
      ScaffoldMessengerState scaffold = ScaffoldMessenger.of(context);

      if (_formKey.currentState!.validate()) {
        _formKey.currentState!.save();
        await loadImageFromChild(scaffold, imageKey, previewKey,
            controllerImgPreviewPath, controllerImgPaths);

        if (await createDiscovery(
              scaffold,
              UpdateDiscoveryModel(
                  id: discoveryId,
                  title: controllerTitle.text,
                  description: controllerDescription.text,
                  imgPreviewPath: controllerImgPreviewPath.text,
                  imgPaths: dividePaths(controllerImgPaths.text),
                  address: controllerAddress.text,
                  kindId: choiceKind,
                  latitude: double.parse(controllerLatitude.text),
                  longitude: double.parse(controllerLongitude.text),
                  videoPaths: dividePaths(controllerVideoPaths.text),
                  stateId: choiceStateId),
            ) ==
            true) {
          ref.read(refreshProvider.notifier).toggle();
          showCustomSnackBar(scaffold, 'Discovery Aggiunta!');
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
        ref.read(refreshProvider.notifier).toggle();
        navigationNotifier.pop();
        return true;
      },
      child: Scaffold(
        appBar: CustomAppBar(
          bckgColor: ConstantData.coloreDiscoveryPage,
          title: 'Discovery Create',
          actions: [
            IconButton(
                icon: const Icon(Icons.person),
                onPressed: () async => await showLoginDialog(context)),
          ],
        ),
        body: WillPopScope(
          onWillPop: () async {
            await ref.read(discoveryProvider.notifier).fetchData(scaffold);
            return true;
          },
          child: CustomWaitingWidget(
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
                        mapValues: discoveryKindsMap,
                        inputDecoration: 'KIND:',
                        initialValue: choiceKind,
                        updateValue: (value) => choiceKind = value,
                      ),
                      const SizedBox(height: ConstantData.spacingHeight),
                      CustomTextFormField(
                        title: 'Video paths',
                        validatorFun: (value) =>
                            validateVideoPath(value, choiceKind),
                        maxlines: 3,
                        hintText:
                            'Inserisci i link dei video aggiuntivi, separati dal carattere \';\'\nAd esempio: link_vid1;link_vid2;link_vid3',
                        fieldValue: controllerVideoPaths,
                      ),
                      const SizedBox(height: ConstantData.spacingHeight),
                      CustomTextFormField(
                        title: 'Indirizzo',
                        validatorFun: (value) => validateAddress(value),
                        hintText: 'Via Marconi 25, Milano(MI)',
                        fieldValue: controllerAddress,
                      ),
                      const SizedBox(height: ConstantData.spacingHeight),
                      CustomTextFormField(
                        title: 'Latitudine',
                        validatorFun: (value) => validateLatGps(value),
                        hintText: '21.5',
                        fieldValue: controllerLatitude,
                      ),
                      const SizedBox(height: ConstantData.spacingHeight),
                      CustomTextFormField(
                        title: 'Longitudine',
                        validatorFun: (value) => validateLonGps(value),
                        hintText: '25.6',
                        fieldValue: controllerLongitude,
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
      ),
    );
  }
}
