import 'package:flutter/material.dart';
import 'package:easy_dynamic_theme/easy_dynamic_theme.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:praduation_project/modules/splashScreen/splash.dart';
import 'package:praduation_project/core/value/languages/local.dart';
import 'core/theme/app_theme.dart';
import 'modules/auth/controller/auth_controller.dart';
import 'core/value/languages/local_controler.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initServices();

  // await requestAllPermissions();

  runApp(
    EasyDynamicThemeWidget(child: const MyApp()),
  );
}

// Future<void> requestAllPermissions() async {
//   await Permission.camera.request();
//   await Permission.photos.request();
// }

Future<void> initServices() async {
  await Firebase.initializeApp();
  Get.put(AuthController());
  await GetStorage.init();
  // Get.put(MyLocaleController());
  await LocaleController.instance.initSharePref();
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'RentHub',
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: EasyDynamicTheme.of(context).themeMode!,
      locale: LocaleController.instance.initalLang,
      translations: MyLocale(),
      home: const SplashScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
