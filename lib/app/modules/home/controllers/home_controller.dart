import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

class HomeController extends GetxController {
  // list title
  RxList<String> listTitle = <String>[].obs;

  Uint8List? baseImage;

  RxString baseTitle = ''.obs;

  RxBool editVisible = true.obs;

  RxDouble baseImageWidth = 100.0.obs;
  RxDouble baseImageHeight = 100.0.obs;
  RxDouble baseImageRatio = 1.0.obs;

  RxDouble screenWidth = 0.0.obs;
  RxDouble screenHeight = 0.0.obs;

  Rx<Color> bodyTextColor = const Color(0xFF42A5F5).obs;

  RxInt currentTitleIndex = 0.obs;

  Rx<TextAlign> textJusify = TextAlign.left.obs;

  String accessToken = '';

  RxBool isLoading = false.obs;

  /*

Enim dolor est exercitation exercitation exercitation irure cillum non esse do
Amet aliquip reprehenderit mollit eiusmod velit ex et nisi in commodo Lorem culpa
Amet ex commodo magna enim Velit consequat consequat aute laborum ex laboris
Excepteur culpa labore sit reprehenderit et enim ad ullamco
Officia occaecat deserunt ad elit officia minim nulla est ipsum ad sunt sit
Commodo sint amet enim nulla proident anim cillum cupidatat tempor mollit dolore excepteur
Elit do nostrud tempor id fugiat incididunt proident ullamco et est commodo in ullamco
Dolor officia tempor laboris dolor velit ipsum ullamco ad eiusmod commodo dolore in cupidatat
Aliquip adipisicing ipsum adipisicing eiusmod aliqua ut nostrud id ipsum ea aute
Consectetur irure exercitation ea ut id consectetur non deserunt proident excepteur ex labore

  */

  @override
  void onInit() {
    // set access token
    accessToken = const String.fromEnvironment('ACCESS_TOKEN');

    // sample title
    const sample = [
      'Enim dolor est exercitation exercitation exercitation irure cillum non esse do',
      'Amet aliquip reprehenderit mollit eiusmod velit ex et nisi in commodo Lorem culpa',
      'Amet ex commodo magna enim Velit consequat consequat aute laborum ex laboris',
      'Excepteur culpa labore sit reprehenderit et enim ad ullamco',
      'Officia occaecat deserunt ad elit officia minim nulla est ipsum ad sunt sit',
      'Commodo sint amet enim nulla proident anim cillum cupidatat tempor mollit dolore excepteur',
      'Elit do nostrud tempor id fugiat incididunt proident ullamco et est commodo in ullamco',
      'Dolor officia tempor laboris dolor velit ipsum ullamco ad eiusmod commodo dolore in cupidatat',
      'Aliquip adipisicing ipsum adipisicing eiusmod aliqua ut nostrud id ipsum ea aute',
      'Consectetur irure exercitation ea ut id consectetur non deserunt proident excepteur ex labore',
    ];

    // load sample title on debug mode
    if (kDebugMode) {
      for (var element in sample) {
        listTitle.add(element);
      }
    }

    super.onInit();
  }
}
