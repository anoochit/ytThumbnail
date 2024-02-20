import 'dart:developer';
import 'dart:io';

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
    return Stack(
      children: [
        // button
        Align(
          alignment: Alignment.center,
          child: TextButton.icon(
            onPressed: () => pickBaseImage(),
            label: const Text('Add base image'),
            icon: const Icon(Icons.add_circle),
          ),
        ),
        // base image
        Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: GetBuilder(
              id: 'canvas',
              init: HomeController(),
              builder: (controller) {
                return (controller.baseImage != null)
                    ? LayoutBuilder(builder: (context, screen) {
                        double scwidth = screen.maxWidth;
                        double scheight = screen.maxHeight;

                        log('screen = ${screen.maxWidth} x ${screen.maxHeight}');
                        log('image = ${controller.baseImageWidth} x ${controller.baseImageHeight}');
                        log('ratio = ${controller.baseImageRatio}');
                        log('----------------------------------------');

                        if (controller.baseImageRatio.value == 1) {
                          scheight = screen.maxHeight;
                          scwidth = screen.maxHeight;
                        }

                        if (controller.baseImageRatio > 1) {
                          if ((screen.maxWidth >
                                  controller.baseImageWidth.value) &&
                              (screen.maxHeight >
                                  controller.baseImageHeight.value)) {
                            scwidth = controller.baseImageWidth.value;
                            scheight = controller.baseImageHeight.value;
                          }

                          if ((screen.maxWidth <
                                  controller.baseImageWidth.value) &&
                              (screen.maxHeight >
                                  controller.baseImageHeight.value)) {
                            scwidth = screen.maxWidth;
                            scheight =
                                scwidth / controller.baseImageRatio.value;
                          }

                          if ((screen.maxWidth >
                                  controller.baseImageWidth.value) &&
                              (screen.maxHeight <
                                  controller.baseImageHeight.value)) {
                            scheight = screen.maxHeight;
                            scwidth =
                                scheight * controller.baseImageRatio.value;
                          }

                          if ((screen.maxWidth <
                                  controller.baseImageWidth.value) &&
                              (screen.maxHeight <
                                  controller.baseImageHeight.value)) {
                            scwidth = screen.maxWidth;
                            scheight =
                                scwidth / controller.baseImageRatio.value;
                          }
                        }

                        return Screenshot(
                          controller: screenshotController,
                          child: InkWell(
                            onTap: () => pickBaseImage(),
                            child: Container(
                              color: Colors.amber,
                              width: scwidth,
                              height: scheight,
                              child: Stack(
                                children: [
                                  Image.memory(
                                    controller.baseImage!,
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
                                      maxFontSize: 180.0,
                                      maxLines: 3,
                                    ),
                                  )
                                ],
                              ),
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
    );
  }

  pickBaseImage() async {
    {
      // add base image
      final picker = ImagePicker();
      final xfile = await picker.pickImage(source: ImageSource.gallery);
      if (xfile != null) {
        final baseImage = await xfile.readAsBytes();
        controller.baseImage = baseImage;

        final decodedImage = await decodeImageFromList(baseImage);
        controller.baseImageWidth.value = decodedImage.width.toDouble();
        controller.baseImageHeight.value = decodedImage.height.toDouble();
        controller.baseImageRatio.value =
            decodedImage.width / decodedImage.height;

        if (controller.listTitle.isNotEmpty) {
          controller.baseTitle.value = controller.listTitle.first;
        }

        controller.update(['canvas']);
      }
    }
  }
}
