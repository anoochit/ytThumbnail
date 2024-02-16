import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/home_controller.dart';
import 'base_canvas_view.dart';
import 'title_list_view.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ytThumbnail'),
        surfaceTintColor: Theme.of(context).colorScheme.inversePrimary,
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Flex(
        direction: Axis.horizontal,
        mainAxisSize: MainAxisSize.max,
        children: [
          const Expanded(
            flex: 12,
            child: BaseCanvasView(),
          ),
          const VerticalDivider(
            width: 1,
          ),
          Flexible(
            flex: 4,
            child: TitleListView(),
          ),
        ],
      ),
    );
  }
}
