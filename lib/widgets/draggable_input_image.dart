import 'dart:typed_data';
import 'package:askenzo_admin_panel/api/api_images.dart';
import 'package:askenzo_admin_panel/data/constant_data.dart';
import 'package:askenzo_admin_panel/shared_functions/image_insert_functions.dart';
import 'package:askenzo_admin_panel/shared_functions/shared_functions.dart';
import 'package:askenzo_admin_panel/shared_functions/validator_class.dart';
import 'package:askenzo_admin_panel/widgets/custom_text.dart';
import 'package:askenzo_admin_panel/widgets/custom_waiting_widget.dart';
import 'package:askenzo_admin_panel/widgets/image_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dropzone/flutter_dropzone.dart';
import 'package:reorderables/reorderables.dart';
/// The `DraggableInputImages` class is a stateful widget in Dart that allows users to drag and input
/// images, with options for limiting the number of images.

class DraggableInputImages extends StatefulWidget {
  DraggableInputImages({
    super.key,
    required this.imageController,
    this.limited = false,
  });

  final TextEditingController imageController;

  final bool limited;

  final ScrollController _imageScroller = ScrollController();
  @override
  DraggableInputImagesState createState() => DraggableInputImagesState();
}
/// The `DraggableInputImagesState` class is a stateful widget that allows users to drag and drop
/// images, add new images, and remove existing images.

class DraggableInputImagesState extends State<DraggableInputImages> {
  late List<ImageItem> imageWidgets;
  DropzoneViewController? controller;
  bool isLoading = false;
  bool isHovering = false;

  void loadImages() {
    List<String> imageUrls = dividePaths(widget.imageController.text);
    for (String imgUrl in imageUrls) {
      if (imgUrl.isNotEmpty) {
        imageWidgets.add(
          ImageItem(
            imageUrl: imgUrl,
            removeItem: removeItem,
          ),
        );
      }
    }
  }

  @override
  void initState() {
    imageWidgets = [];
    super.initState();
    loadImages();
  }

  void _onChooseImagePressed() async {
    final imageData = await chooseAndStoreImage();
    setState(() {
      if (imageData != null) {
        imageWidgets.add(
          ImageItem(
            imageBin: imageData,
            removeItem: removeItem,
          ),
        );
      }
    });
  }

  void removeItem(ImageItem item) {
    imageWidgets.remove(item);
    setState(() {});
  }

  void refreshLoading(bool value) {
    setState(() {
      isLoading = value;
    });
  }

  void refresh() {
    setState(() {});
  }

  bool isThereSomethingNew() {
    List<String> imageUrls = dividePaths(widget.imageController.text);
    for (String url in imageUrls) {
      for (ImageItem img in imageWidgets) {
        if (img.imageUrl != url) {
          return true;
        }
      }
    }
    return false;
  }

  Future<List<String>> getFilesPath(
    ScaffoldMessengerState scaffoldMessenger,
  ) async {
    // Retrieve files
    List<Uint8List> files = [];
    List<String> urls = [];
    List<int> indexTobeFilled = [];
    int i = 0;

    for (ImageItem img in imageWidgets) {
      if (img.imageUrl != null) {
        urls.add(img.imageUrl!);
      }
      if (img.imageBin != null) {
        indexTobeFilled.add(i);
        files.add(img.imageBin!);
      }
      i++;
    }

    // Call api only if there are binaries
    List<String> binUrls =
        await apiPostListOfImage(scaffoldMessenger, files: files);

    List<String> result = [];
    for (int i = 0; i < imageWidgets.length; i++) {
      if (!indexTobeFilled.contains(i)) {
        result.add(urls.first);
        urls.removeAt(0);
      } else {
        result.add(binUrls.first);
        binUrls.removeAt(0);
      }
    }
    return result;
  }

  @override
  Widget build(BuildContext context) {
    ScaffoldMessengerState scaffoldMessenger = ScaffoldMessenger.of(context);
    void onReorder(int oldIndex, int newIndex) {
      setState(() {
        ImageItem row = imageWidgets.removeAt(oldIndex);
        imageWidgets.insert(newIndex, row);
      });
    }

    void onMultiDrag(evList) async {
      if (evList.length > 1 && widget.limited) {
        showCustomSnackBar(scaffoldMessenger,
            'Non è possibile inserire più di una immagine di copertina. Riprova con una sola immagine.');
        setState(() {
          isHovering = false;
        });
        return;
      }
      List<ImageItem> draggedImgs = [];
      for (final ev in evList) {
        final data = await controller!.getFileData(ev);
        final uint8list = Uint8List.fromList(data);

        draggedImgs.add(ImageItem(
          imageBin: uint8list,
          removeItem: removeItem,
        ));
      }
      if (draggedImgs.isNotEmpty) {
        setState(() {
          if (widget.limited) {
            if (imageWidgets.isEmpty) {
              imageWidgets.add(draggedImgs[0]);
            } else {
              imageWidgets.removeAt(0);
              imageWidgets.add(draggedImgs[0]);
            }
          } else {
            imageWidgets.addAll(draggedImgs);
          }
          isHovering = false;
        });
      }
    }

    Widget displayImage(field) {
      return imageWidgets.isEmpty
          ? Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Center(
                  child: CustomText(
                    text: 'Aggiungi un\'immagine',
                    centered: true,
                  ),
                ),
                if (field.errorText != null)
                  Center(
                    child: CustomText(
                      text: field.errorText!,
                      color: Colors.red,
                    ),
                  ),
              ],
            )
          : Center(
              child: ReorderableWrap(
                controller: widget._imageScroller,
                spacing: 20.0,
                runSpacing: 10.0,
                padding: const EdgeInsets.all(8),
                onReorder: onReorder,
                alignment: WrapAlignment.center,
                direction: Axis.horizontal,
                children: imageWidgets,
              ),
            );
    }

    String? validation(value) {
      if (widget.limited) {
        return validateImgPreviewPath(imageWidgets);
      } else {
        return validateImgPaths(imageWidgets);
      }
    }

    return Scaffold(
      body: FormField(
          validator: validation,
          builder: (field) {
            return CustomWaitingWidget(
              isWaiting: isLoading,
              child: Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    const SizedBox(height: 20),
                    Expanded(
                      child: Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(40),
                              gradient: const LinearGradient(colors: [
                                Color.fromARGB(255, 236, 236, 236),
                                Color.fromARGB(255, 221, 221, 221),
                              ])),
                          child: displayImage(field)),
                    ),
                    const SizedBox(height: 20),
                    Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          IconButton(
                            iconSize: 50,
                            icon: const Icon(Icons.add_circle),
                            color: ConstantData.colorePrimario,
                            padding: const EdgeInsets.all(0.0),
                            onPressed: () {
                              _onChooseImagePressed();
                            },
                          ),
                          IconButton(
                              iconSize: 50,
                              icon: const Icon(Icons.remove_circle),
                              color: imageWidgets.isNotEmpty
                                  ? Colors.red
                                  : Colors.grey,
                              padding: const EdgeInsets.all(0.0),
                              onPressed: imageWidgets.isNotEmpty
                                  ? () {
                                      setState(() {
                                        removeItem(imageWidgets.removeAt(0));
                                      });
                                    }
                                  : null),
                          const Spacer(),
                          SizedBox(
                            height: ConstantData.heightDropArea,
                            width: ConstantData.widthDropArea,
                            child: Stack(
                              children: [
                                AnimatedContainer(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    gradient: isHovering
                                        ? const LinearGradient(
                                            begin: Alignment.topLeft,
                                            end: Alignment.bottomRight,
                                            colors: [
                                              Colors.purple,
                                              Colors.blue
                                            ],
                                            stops: [0.0, 1.0],
                                          )
                                        : const LinearGradient(
                                            begin: Alignment.topLeft,
                                            end: Alignment.bottomRight,
                                            colors: [Colors.red, Colors.blue],
                                            stops: [0.0, 1.0],
                                          ),
                                  ),
                                  duration: const Duration(milliseconds: 200),
                                  child: const Center(
                                      child: CustomText(
                                    text: 'Drop your files here',
                                    fontSize: 17,
                                    color: Colors.white,
                                  )),
                                ),
                                DropzoneView(
                                  operation: DragOperation.copy,
                                  cursor: CursorType.grab,
                                  onCreated: (ctrl) => controller = ctrl,
                                  onError: (ev) => showCustomSnackBar(
                                      scaffoldMessenger, 'Error: $ev'),
                                  onHover: () =>
                                      setState(() => isHovering = true),
                                  onLeave: () =>
                                      setState(() => isHovering = false),
                                  onDropMultiple: (evList) async =>
                                      onMultiDrag(evList),
                                ),
                              ],
                            ),
                          ),
                        ]),
                  ],
                ),
              ),
            );
          }),
    );
  }
}
