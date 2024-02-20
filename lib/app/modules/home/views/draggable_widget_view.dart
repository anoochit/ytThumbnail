import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/draggable_controller.dart';

class DraggableWidgetView extends GetView<DraggableController> {
  const DraggableWidgetView(
      {Key? key, required this.child, required this.visible})
      : super(key: key);
  final Widget child;
  final bool visible;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onPanUpdate: (details) {
        controller.updatePosition(details.delta.dx, details.delta.dy);
      },
      child: Obx(() => Stack(
            children: [
              Positioned(
                left: controller.left.value,
                top: controller.top.value,
                child: LongPressDraggable(
                  feedback: SizedBox(
                    width: controller.width.value,
                    height: controller.height.value,
                  ),
                  childWhenDragging: Container(),
                  onDragEnd: (details) {
                    controller.left.value = details.offset.dx;
                    controller.top.value = details.offset.dy;
                  },
                  child: GestureDetector(
                    onLongPress: () {
                      log("Long press detected");
                      // You can add your desired functionality here
                    },
                    child: Container(
                      width: controller.width.value,
                      height: controller.height.value,
                      decoration: const BoxDecoration(
                          // color: Colors.blue,
                          ),
                      child: Stack(
                        children: [
                          SizedBox(
                            width: controller.width.value,
                            height: controller.height.value,
                            child: child,
                          ),
                          Positioned(
                            left: 0,
                            top: 0,
                            child: GestureDetector(
                              onPanUpdate: (details) {
                                controller.updateSize(
                                    details.delta.dx, details.delta.dy);
                              },
                              child: DraggableIcon(
                                visible: visible,
                              ),
                            ),
                          ),
                          Positioned(
                            right: 0,
                            top: 0,
                            child: GestureDetector(
                              onPanUpdate: (details) {
                                controller.width.value += details.delta.dx;
                                controller.height.value -= details.delta.dy;
                                controller.top.value += details.delta.dy;
                              },
                              child: DraggableIcon(
                                visible: visible,
                              ),
                            ),
                          ),
                          Positioned(
                            left: 0,
                            bottom: 0,
                            child: GestureDetector(
                              onPanUpdate: (details) {
                                controller.width.value -= details.delta.dx;
                                controller.height.value += details.delta.dy;
                                controller.left.value += details.delta.dx;
                              },
                              child: DraggableIcon(
                                visible: visible,
                              ),
                            ),
                          ),
                          Positioned(
                            right: 0,
                            bottom: 0,
                            child: GestureDetector(
                              onPanUpdate: (details) {
                                controller.width.value += details.delta.dx;
                                controller.height.value += details.delta.dy;
                              },
                              child: DraggableIcon(
                                visible: visible,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          )),
    );
  }
}

class DraggableIcon extends StatelessWidget {
  const DraggableIcon({super.key, required this.visible});

  final bool visible;

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: visible,
      child: const Icon(
        Icons.add,
        color: Colors.lightGreen,
        size: 18,
      ),
    );
  }
}
