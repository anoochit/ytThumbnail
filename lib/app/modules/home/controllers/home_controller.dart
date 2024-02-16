import 'dart:typed_data';

import 'package:get/get.dart';

class HomeController extends GetxController {
  // list title
  RxList<String> listTitle = <String>[].obs;

  Uint8List? baseImage;

  RxString baseTitle = ''.obs;

  String sampleTitle =
      'Aliquip do nostrud anim voluptate dolor culpa reprehenderit veniam ad minim nulla ut anim adipisicing.';

  // image

  @override
  void onInit() {
    listTitle.add(
        'Est consequat ut irure minim dolore excepteur duis officia est qui ullamco.');
    listTitle
        .add('Reprehenderit reprehenderit proident commodo ut ex ullamco.');
    super.onInit();
  }
}
