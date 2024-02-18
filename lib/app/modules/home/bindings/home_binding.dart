import 'package:get/get.dart';
import 'package:ythumbnail/app/modules/home/controllers/draggable_controller.dart';

import '../controllers/home_controller.dart';

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<HomeController>(
      () => HomeController(),
    );

    Get.lazyPut<DraggableController>(
      () => DraggableController(),
    );
  }
}
