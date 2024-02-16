// ignore_for_file: use_build_context_synchronously

import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';

import '../../../utils/image_util.dart';
import '../controllers/home_controller.dart';
import 'base_canvas_view.dart';

class TitleListView extends GetView<HomeController> {
  TitleListView({Key? key}) : super(key: key);

  final TextEditingController titleTextController = TextEditingController();

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
                hintText: 'Video title ...',
                suffixIcon: IconButton(
                  onPressed: () {
                    final title = titleTextController.text.trim();
                    if (title.isNotEmpty) {
                      // add title
                      controller.listTitle.add(title);
                      titleTextController.clear();
                    }
                  },
                  icon: const Icon(Icons.add_circle_rounded),
                ),
              ),
            ),
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
          Container(
            width: constraints.maxWidth,
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton.icon(
              onPressed: () => exportImage(context),
              icon: const Icon(Icons.download_for_offline),
              label: const Text('Export ...'),
            ),
          )
        ],
      );
    });
  }

  exportImage(BuildContext context) async {
    if ((controller.listTitle.isNotEmpty) && (controller.baseImage != null)) {
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
                // CircularProgressIndicator.adaptive(),
                Icon(Icons.schedule),
                SizedBox(width: 16.0),

                Text('Generating...'),
                // Spacer(),
                // IconButton(
                //   onPressed: () => Get.back(),
                //   icon: const Icon(Icons.close),
                // )
              ],
            ),
            actionsAlignment: MainAxisAlignment.center,
          );
        },
      );

      // generate image
      generateImage(context);
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

  Future<void> generateImage(BuildContext context) async {
    final Directory appDocumentsDir = await getApplicationDocumentsDirectory();

    final titleLength = controller.listTitle.length;

    log('lenght = ${controller.listTitle.length}');

    for (int index = 0; index < titleLength; index++) {
      log(controller.listTitle[index]);
      // update ui
      controller.baseTitle.value = controller.listTitle[index];
      controller.update(['canvas']);

      final fileName = 'export_$index.png';
      log('filename = $fileName');

      log('screenshotController is blank = ${screenshotController.isBlank}');

      try {
        Uint8List? result = await screenshotController.capture(
          delay: const Duration(milliseconds: 50),
        );

        // final result = await screenshotController.captureAndSave(
        //   appDocumentsDir.path,
        //   fileName: 'export_$index.png',
        //   delay: const Duration(milliseconds: 100),
        // );

        // resize
        if (result != null) {
          ImageResizer.resizeAndSaveImage(
              result, 1280, 720, "${appDocumentsDir.path}/$fileName");
        }
      } catch (e) {
        log('Error : $e');
      }
    }
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
}
