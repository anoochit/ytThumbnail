import 'dart:developer';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gap/gap.dart';

import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:palette_generator/palette_generator.dart';
import 'package:screenshot/screenshot.dart';
import 'package:ythumbnail/app/data/base_image.dart';

import '../controllers/home_controller.dart';
import 'draggable_widget_view.dart';

ScreenshotController screenshotController =
    screenshotController = ScreenshotController();

class BaseCanvasView extends GetView<HomeController> {
  const BaseCanvasView({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // button
        Align(
          alignment: Alignment.center,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ElevatedButton.icon(
                onPressed: () => pickPresetImage(context),
                label: const Text('Add base image from preset...'),
                icon: const Icon(Icons.image),
              ),
              const Gap(16.0),
              ElevatedButton.icon(
                onPressed: () => pickBaseImage(),
                label: const Text('Browse base image...'),
                icon: const Icon(Icons.folder),
              ),
            ],
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
                        // calculate canvas ratio according to base image
                        double scwidth = screen.maxWidth;
                        double scheight = screen.maxHeight;
                        log('----------------------------------------');
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

                        return canvasThumbnail(
                            scwidth, scheight, controller, context);
                      })
                    : const SizedBox();
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget canvasThumbnail(double scwidth, double scheight,
      HomeController controller, BuildContext context) {
    return GestureDetector(
      onTap: () => pickBaseImage(),
      child: SizedBox(
        width: scwidth,
        height: scheight,
        child: Screenshot(
          controller: screenshotController,
          child: Stack(
            children: [
              Image.memory(
                controller.baseImage!,
              ),
              DraggableWidgetView(
                visible: controller.editVisible.value,
                child: AutoSizeText(
                  controller.baseTitle.value,
                  textAlign: controller.textJusify.value,
                  textScaleFactor: 2.0,
                  style: GoogleFonts.kanit(
                    textStyle:
                        Theme.of(context).textTheme.displayLarge!.copyWith(
                              color: controller.bodyTextColor.value,
                              height: 1.2,
                            ),
                  ),
                  maxLines: 5,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  pickBaseImage() async {
    {
      // add base image
      final picker = ImagePicker();
      final xfile = await picker.pickImage(source: ImageSource.gallery);
      if (xfile != null) {
        // read image data
        final baseImage = await xfile.readAsBytes();
        controller.baseImage = baseImage;

        // get base image size for export later
        final decodedImage = await decodeImageFromList(baseImage);
        controller.baseImageWidth.value = decodedImage.width.toDouble();
        controller.baseImageHeight.value = decodedImage.height.toDouble();
        controller.baseImageRatio.value =
            decodedImage.width / decodedImage.height;

        // get color palette from image and set default text color
        final palette = await PaletteGenerator.fromImage(decodedImage);
        controller.bodyTextColor.value =
            palette.dominantColor!.bodyTextColor.withAlpha(255);

        // set default title
        if (controller.listTitle.isNotEmpty) {
          controller.baseTitle.value = controller.listTitle.first;
        } else {
          controller.baseTitle.value = 'Your text place here!!';
        }

        // update canvas
        controller.update(['canvas']);
      }
    }
  }

  pickPresetImage(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          child: Container(
            padding: const EdgeInsets.all(16.0),
            width: MediaQuery.of(context).size.width * 0.8,
            height: MediaQuery.of(context).size.height * 0.8,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Choose preset image',
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                const Gap(16.0),
                Expanded(
                  child: GridView.builder(
                    itemCount: baseImages.length,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 4,
                      mainAxisSpacing: 4.0,
                      crossAxisSpacing: 4.0,
                    ),
                    itemBuilder: (context, index) {
                      return Card(
                        clipBehavior: Clip.antiAliasWithSaveLayer,
                        child: InkWell(
                          onTap: () =>
                              loadPresetImage(image: baseImages[index]),
                          child: GridTile(
                            child: Image.asset(
                              baseImages[index],
                              fit: BoxFit.contain,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: FilledButton(
                    onPressed: () => Get.back(),
                    child: const Text('Close'),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  loadPresetImage({required String image}) async {
    final assetByteData = await rootBundle.load(image);

    Uint8List baseImage = assetByteData.buffer
        .asUint8List(assetByteData.offsetInBytes, assetByteData.lengthInBytes);

    controller.baseImage = baseImage;

    // get base image size for export later
    final decodedImage = await decodeImageFromList(baseImage);
    controller.baseImageWidth.value = decodedImage.width.toDouble();
    controller.baseImageHeight.value = decodedImage.height.toDouble();
    controller.baseImageRatio.value = decodedImage.width / decodedImage.height;

    // get color palette from image and set default text color
    final palette = await PaletteGenerator.fromImage(decodedImage);
    controller.bodyTextColor.value =
        palette.dominantColor!.bodyTextColor.withAlpha(255);

    // set default title
    if (controller.listTitle.isNotEmpty) {
      controller.baseTitle.value = controller.listTitle.first;
    } else {
      controller.baseTitle.value = 'Your text place here!!';
    }

    // update canvas
    controller.update(['canvas']);

    Get.back();
  }
}
