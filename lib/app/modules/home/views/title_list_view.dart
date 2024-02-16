import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:ythumbnail/app/modules/home/controllers/home_controller.dart';

class TitleListView extends GetView<HomeController> {
  TitleListView({Key? key}) : super(key: key);

  TextEditingController titleTextController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Column(
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 8.0),
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
                    }
                  },
                  icon: const Icon(Icons.add_circle_rounded),
                ),
              ),
            ),
          ),
          const Divider(height: 1),
          Expanded(
            child: ListView.builder(
              itemCount: controller.listTitle.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(
                    controller.listTitle[index],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
