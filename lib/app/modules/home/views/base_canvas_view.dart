import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ythumbnail/app/modules/home/controllers/home_controller.dart';

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
                  controller.baseImage = await xfile.readAsBytes();
                  controller.update(['canvas']);
                }
              },
              label: Text('Add base image'),
              icon: Icon(Icons.add_circle),
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
                      ? Image.memory(
                          controller.baseImage!,
                        )
                      : Container();
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
