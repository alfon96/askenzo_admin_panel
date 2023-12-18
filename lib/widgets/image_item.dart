import 'dart:typed_data';

import 'package:askenzo_admin_panel/data/constant_data.dart';
import 'package:askenzo_admin_panel/widgets/custom_zoom_image.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
/// The `ImageItem` class is a stateless widget that displays an image with a delete button and supports
/// zooming functionality.

class ImageItem extends StatelessWidget {
  const ImageItem({
    super.key,
    this.imageUrl,
    this.imageBin,
    required this.removeItem,
  });

  final String? imageUrl;
  final Uint8List? imageBin;
  final Function removeItem;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: ConstantData.imgBoxSize,
      width: ConstantData.imgBoxSize,
      child: SizedBox(
        child: Stack(children: [
          Positioned(
              right: 0,
              top: 0,
              child: SizedBox(
                height: ConstantData.sizeDeleteContainer,
                width: ConstantData.sizeDeleteContainer,
                child: IconButton(
                  padding: EdgeInsets.zero,
                  iconSize: ConstantData.sizeDeleteContainer,
                  splashRadius: 20,
                  onPressed: () {
                    removeItem(this);
                  },
                  icon: const Icon(
                    Icons.cancel,
                    color: Colors.red,
                  ),
                ),
              )),
          CustomZoomImage(
            child: SizedBox(
              height: ConstantData.imgBoxSize,
              width: ConstantData.imgBoxSize,
              child: ClipOval(
                clipBehavior: Clip.hardEdge,
                child: Container(
                  height: ConstantData.imgBoxSize - ConstantData.sizeOffset,
                  width: ConstantData.imgBoxSize - ConstantData.sizeOffset,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.grey,
                  ),
                  child: imageBin == null && imageUrl != null
                      ? CachedNetworkImage(
                          imageUrl: imageUrl!,
                          fit: BoxFit.cover,
                        )
                      : Image.memory(
                          imageBin!,
                          fit: BoxFit.cover,
                        ),
                ),
              ),
            ),
          ),
        ]),
      ),
    );
  }
}
