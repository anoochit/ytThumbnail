import 'package:get/get.dart';

class DraggableController extends GetxController {
  RxDouble width = 400.0.obs;
  RxDouble height = 200.0.obs;
  RxDouble left = 50.0.obs;
  RxDouble top = 50.0.obs;

  void updatePosition(double deltaX, double deltaY) {
    left.value += deltaX;
    top.value += deltaY;
  }

  void updateSize(double deltaWidth, double deltaHeight) {
    width.value -= deltaWidth;
    height.value -= deltaHeight;
    left.value += deltaWidth;
    top.value += deltaHeight;
  }
}
