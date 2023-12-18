import 'package:askenzo_admin_panel/api/api.dart';
import 'package:askenzo_admin_panel/data/constant_data.dart';
import 'package:askenzo_admin_panel/data/form_data.dart';
import 'package:askenzo_admin_panel/models/discovery.dart';
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
/// The `DiscoveryEditDetail` class is a stateful widget that allows users to edit details of a
/// discovery object.

class DiscoveryEditDetail extends ConsumerStatefulWidget {
  const DiscoveryEditDetail({super.key, required this.discovery});

  final UpdateDiscoveryModel discovery;

  @override
  ConsumerState<DiscoveryEditDetail> createState() =>
      _DiscoveryEditDetailState();
}
/// The `getPaths` function takes a list of paths as input and returns a concatenated string of paths.

String getPaths(List<String> listPaths) {
  String result = '';
  if (listPaths.isNotEmpty && listPaths[0] != "") {
    for (String path in listPaths) {
      result += '${path.replaceAll(';', '')};';
    }
  }
  return result;
}
/// The `_DiscoveryEditDetailState` class is a stateful widget that handles the editing of a discovery
/// item, including form validation, data retrieval, and submission.

class _DiscoveryEditDetailState extends ConsumerState<DiscoveryEditDetail> {
  late DiscoveryDataForm startingValues;
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
  int choiceStateId = 1;
  int choiceKind = 1;
  int discoveryId = 0;
  bool isLoading = false;
  List<ImageItem> imageWidgets = [];
  ImageItem? previewWidgets;
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

  @override
  void initState() {
    super.initState();
    // Inizializzazione Form
    discoveryId = widget.discovery.id;
    controllerTitle.text = widget.discovery.title;
    controllerDescription.text = widget.discovery.description;
    controllerImgPreviewPath.text = widget.discovery.imgPreviewPath;
    controllerImgPaths.text = getPaths(widget.discovery.imgPaths);
    choiceStateId = widget.discovery.stateId;
    controllerLongitude.text = '${widget.discovery.longitude}';
    controllerLatitude.text = '${widget.discovery.latitude}';
    controllerAddress.text = widget.discovery.address;
    controllerVideoPaths.text = getPaths(widget.discovery.videoPaths);
    choiceKind = widget.discovery.kindId;
    choiceStateId = widget.discovery.stateId;

    startingValues = stateFromControllers();
  }

  DiscoveryDataForm stateFromControllers() {
    return DiscoveryDataForm(
      id: discoveryId,
      title: controllerTitle.text,
      description: controllerDescription.text,
      imgPreviewPath: controllerImgPreviewPath.text,
      imgPaths: controllerImgPaths.text,
      address: controllerAddress.text,
      kindId: choiceKind,
      latitude: double.parse(controllerLatitude.text),
      longitude: double.parse(controllerLongitude.text),
      videoPath: controllerVideoPaths.text,
      stateId: choiceStateId,
    );
  }

  void submitFun(ScaffoldMessengerState scaffold) async {
    {
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

        DiscoveryDataForm newData = stateFromControllers();

        if (startingValues.checkDifferences(newData) || imageEdited) {
          // create experience object
          UpdateDiscoveryModel result = newData.toUpdateDiscoveryModel();

          // send it to api
          if (await updateDiscovery(
                scaffold,
                result,
              ) ==
              true) {
            ref.read(refreshProvider.notifier).toggle();
            showCustomSnackBar(scaffold, 'Discovery modificata con successo.');
            ref.read(refreshProvider.notifier).toggle();
          }
          setState(() {
            isLoading = false;
          });
        }
      }
    }
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
          bckgColor: ConstantData.coloreDiscoveryPage,
          title: 'Discovery Edit',
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
                      mapValues: discoveryKindsMap,
                      inputDecoration: 'KIND:',
                      initialValue: choiceKind,
                      updateValue: (value) => choiceKind = value,
                    ),
                    const SizedBox(height: ConstantData.spacingHeight * 2),
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
    );
  }
}
