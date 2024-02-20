import 'dart:developer';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:screenshot/screenshot.dart';

import '../controllers/home_controller.dart';
import 'draggable_widget_view.dart';

ScreenshotController screenshotController =
    screenshotController = ScreenshotController();

class BaseCanvasView extends GetView<HomeController> {
  const BaseCanvasView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          // button
          Align(
            alignment: Alignment.centerRight,
            child: TextButton.icon(
              onPressed: () async {
                // add base image
                final picker = ImagePicker();
                final xfile =
                    await picker.pickImage(source: ImageSource.gallery);
                if (xfile != null) {
                  final baseImage = await xfile.readAsBytes();
                  controller.baseImage = baseImage;

                  final decodedImage = await decodeImageFromList(baseImage);
                  controller.baseImageWidth.value =
                      decodedImage.width.toDouble();
                  controller.baseImageHeight.value =
                      decodedImage.height.toDouble();
                  controller.baseImageRatio.value =
                      decodedImage.width / decodedImage.height;

                  if (controller.listTitle.isNotEmpty) {
                    controller.baseTitle.value = controller.listTitle.first;
                  }

                  controller.update(['canvas']);
                }
              },
              label: const Text('Add base image'),
              icon: const Icon(Icons.add_circle),
            ),
          ),
          // base image
          Expanded(
            child: Center(
              child: GetBuilder(
                id: 'canvas',
                init: HomeController(),
                builder: (controller) {
                  return (controller.baseImage != null)
                      ? LayoutBuilder(builder: (context, constraints) {
                          double scwidth = 0;
                          log('screen width = ${constraints.maxWidth}');
                          log('image width = ${controller.baseImageWidth}');
                          if (controller.baseImageWidth.value <
                              constraints.maxWidth) {
                            scwidth = controller.baseImageWidth.value;
                          } else {
                            scwidth = constraints.maxWidth;
                          }

                          final scheight =
                              scwidth / controller.baseImageRatio.value;
                          return Screenshot(
                            controller: screenshotController,
                            child: SizedBox(
                              width: scwidth,
                              height: scheight,
                              child: Stack(
                                children: [
                                  Image.memory(
                                    controller.baseImage!,
                                    // fit: BoxFit.fitWidth,
                                  ),
                                  DraggableWidgetView(
                                    visible: controller.editVisible.value,
                                    child: AutoSizeText(
                                      controller.baseTitle.value,
                                      style: GoogleFonts.kanit(
                                        textStyle: Theme.of(context)
                                            .textTheme
                                            .displayLarge,
                                      ),
                                      maxLines: 4,
                                    ),
                                  )
                                ],
                              ),
                            ),
                          );
                        })
                      : const SizedBox();
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
