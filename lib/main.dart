import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import 'app/routes/app_pages.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
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
    const initialSize = Size(1440, 824);
    appWindow.size = initialSize;
    appWindow.minSize = initialSize;
    appWindow.alignment = Alignment.center;
    appWindow.show();
  });
}
