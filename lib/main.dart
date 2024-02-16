import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import 'app/routes/app_pages.dart';

void main() {
  runApp(
    GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: "ytThumbnail",
      initialRoute: AppPages.INITIAL,
      themeMode: ThemeMode.dark,
      theme: ThemeData(),
      darkTheme: ThemeData.dark(),
      getPages: AppPages.routes,
    ),
  );

  doWhenWindowReady(() {
    const initialSize = Size(1280, 720);
    appWindow.size = initialSize;
    appWindow.alignment = Alignment.center;
    appWindow.show();
  });
}
