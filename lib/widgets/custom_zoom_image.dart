import 'package:askenzo_admin_panel/data/constant_data.dart';
import 'package:flutter/material.dart';
/// The `CustomZoomImage` class is a Flutter widget that displays an image and allows the user to zoom
/// in on it when tapped.

class CustomZoomImage extends StatelessWidget {
  const CustomZoomImage({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
          showDialog(
              context: context,
              builder: (BuildContext context) {
                return Dialog(
                  shape: const CircleBorder(),
                  backgroundColor: Colors.transparent,
                  child: SizedBox(
                    height: ConstantData.imgBoxSize * ConstantData.zoomSize,
                    child: Stack(
                      alignment: Alignment.topRight,
                      children: <Widget>[
                        InteractiveViewer(
                          child: Center(
                              child: Transform.scale(
                            scale: ConstantData.zoomSize,
                            child: child,
                          )),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 30.0),
                          child: IconButton(
                            icon: const Icon(
                              size: 28,
                              Icons.close,
                              color: Color.fromARGB(255, 255, 255, 255),
                            ),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              });
        },
        child: child);
  }
}
