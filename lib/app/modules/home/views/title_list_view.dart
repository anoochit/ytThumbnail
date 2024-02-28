// ignore_for_file: use_build_context_synchronously

import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:ythumbnail/gemini.dart';

import '../../../utils/image_util.dart';
import '../controllers/home_controller.dart';
import 'base_canvas_view.dart';

class TitleListView extends GetView<HomeController> {
  TitleListView({Key? key}) : super(key: key);

  final TextEditingController titleTextController = TextEditingController();
  final TextEditingController titleBulkTextController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      return Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            height: 48,
            child: TextFormField(
              controller: titleTextController,
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: 'Enter your title ...',
                suffixIcon: IconButton(
                  // show dialog to import title in multiple line
                  onPressed: () => importTitle(context, constraints),
                  icon: const Icon(Icons.upload_sharp),
                ),
              ),
              onFieldSubmitted: (value) {
                final title = titleTextController.text.trim();
                if (title.isNotEmpty) {
                  // add title
                  controller.listTitle.add(title);
                  titleTextController.clear();
                }
              },
            ),
          ),
          const Divider(height: 1),
          Obx(
            () => (controller.listTitle.isNotEmpty)
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        onPressed: () => setTextJusify(TextAlign.left),
                        icon: const Icon(
                          Icons.format_align_left,
                        ),
                      ),
                      IconButton(
                        onPressed: () => setTextJusify(TextAlign.center),
                        icon: const Icon(
                          Icons.format_align_center,
                        ),
                      ),
                      IconButton(
                        onPressed: () => setTextJusify(TextAlign.right),
                        icon: const Icon(
                          Icons.format_align_right,
                        ),
                      )
                    ],
                  )
                : const SizedBox(),
          ),
          const Divider(height: 1),
          Expanded(
            child: Obx(
              () => ListView.builder(
                itemCount: controller.listTitle.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    leading: CircleAvatar(
                      child: FittedBox(child: Text('${index + 1}')),
                    ),
                    title: Text(
                      controller.listTitle[index],
                    ),
                    onTap: () {
                      controller.currentTitleIndex.value = index;
                      controller.baseTitle.value = controller.listTitle[index];
                      controller.update(['canvas']);
                    },
                    trailing: IconButton(
                      onPressed: () {
                        controller.listTitle.removeAt(index);
                      },
                      icon: const Icon(Icons.delete),
                    ),
                  );
                },
              ),
            ),
          ),
          const SizedBox(height: 8.0),
          // export current title
          Container(
            width: constraints.maxWidth,
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: ElevatedButton.icon(
              onPressed: () => exportImage(
                context: context,
                currentIndex: controller.currentTitleIndex.value,
              ),
              icon: const Icon(Icons.download),
              label: const Text('Export...'),
            ),
          ),
          const SizedBox(height: 8.0),
          // export all titles
          Container(
            width: constraints.maxWidth,
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: ElevatedButton.icon(
              onPressed: () => exportImage(context: context),
              icon: const Icon(Icons.download),
              label: const Text('Export All ...'),
            ),
          ),
          const SizedBox(height: 8.0),
        ],
      );
    });
  }

  exportImage({required BuildContext context, int? currentIndex}) async {
    if ((controller.listTitle.isNotEmpty) && (controller.baseImage != null)) {
      // TODO : Change to progress bar
      // show progress
      showAdaptiveDialog(
        barrierDismissible: false,
        barrierColor: Colors.transparent,
        context: context,
        builder: (BuildContext context) {
          return const AlertDialog.adaptive(
            content: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.schedule),
                SizedBox(width: 8.0),
                Text('Generating...'),
              ],
            ),
            actionsAlignment: MainAxisAlignment.center,
          );
        },
      );

      // generate image
      generateImage(context, currentIndex);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Colors.red,
          content: Text(
            'Please add title and base image',
            style: TextStyle(color: Colors.white),
          ),
        ),
      );
    }
  }

  Future<void> generateImage(BuildContext context, [int? currentIndex]) async {
    // get document library
    final Directory appDocumentsDir = await getApplicationDocumentsDirectory();
    // title length
    final titleLength = controller.listTitle.length;
    log('lenght = ${controller.listTitle.length}');
    // check export type
    if (currentIndex == null) {
      // export all
      for (int index = 0; index < titleLength; index++) {
        await captureAndSave(index, appDocumentsDir);
      }
    } else {
      // export single
      await captureAndSave(currentIndex, appDocumentsDir);
    }
    // show result
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: Colors.green,
        content: Text(
          'Export images to ${appDocumentsDir.path}',
          style: const TextStyle(color: Colors.white),
        ),
      ),
    );
    Get.back();
  }

  Future<void> captureAndSave(int index, Directory appDocumentsDir) async {
    log(controller.listTitle[index]);
    // update ui
    controller.baseTitle.value = controller.listTitle[index];
    controller.editVisible.value = false;
    controller.update(['canvas']);

    final fileName = 'export_$index.png';
    log('filename = $fileName');

    log('screenshotController is blank = ${screenshotController.isBlank}');

    try {
      // capture image
      Uint8List? result = await screenshotController.capture(
        delay: const Duration(milliseconds: 50),
      );

      // Capture and save image
      // final result = await screenshotController.captureAndSave(
      //   appDocumentsDir.path,
      //   fileName: 'export_$index.png',
      //   delay: const Duration(milliseconds: 100),
      // );

      // resize to base image size
      if (result != null) {
        ImageResizer.resizeAndSaveImage(
          result,
          controller.baseImageWidth.value.toInt(),
          controller.baseImageHeight.value.toInt(),
          "${appDocumentsDir.path}/$fileName",
        );
      }
    } catch (e) {
      log('Error : $e');
    }

    controller.editVisible.value = true;
    controller.update(['canvas']);
  }

  importTitle(BuildContext context, BoxConstraints constraints) {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          child: SizedBox(
            width: constraints.maxWidth * 2,
            height: 410,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Import Title',
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  const SizedBox(height: 16.0),
                  TextFormField(
                    controller: titleBulkTextController,
                    decoration: const InputDecoration(
                      hintText: 'Type a title per line',
                      border: OutlineInputBorder(),
                    ),
                    maxLines: 10,
                  ),
                  const SizedBox(height: 16.0),
                  // cancel
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      ElevatedButton(
                        onPressed: () => Get.back(),
                        child: const Text('Cancel'),
                      ),
                      const SizedBox(width: 8.0),
                      ElevatedButton(
                        onPressed: () {
                          // TODO : use gemini to generate 5 SEO titles with a fine tune prompt
                          titleBulkTextController.text = accessToken;
                        },
                        child: const Text('Generate Title'),
                      ),
                      const SizedBox(width: 8.0),
                      // import
                      ElevatedButton(
                        onPressed: () {
                          final bulkTitle = titleBulkTextController.text.trim();
                          if (bulkTitle.isNotEmpty) {
                            final titles = bulkTitle.split('\n');
                            log('title size = ${titles.length}');

                            for (var element in titles) {
                              final title = element.trim();
                              if (title.isNotEmpty) {
                                controller.listTitle.add(title);
                              }
                            }
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                backgroundColor: Colors.green,
                                content: Text(
                                  'Import ${titles.length} titles complete!',
                                  style: const TextStyle(color: Colors.white),
                                ),
                              ),
                            );

                            Get.back();
                          }
                        },
                        child: const Text('Import'),
                      )
                    ],
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  setTextJusify(TextAlign align) {
    controller.textJusify.value = align;
    controller.update(['canvas']);
  }
}
