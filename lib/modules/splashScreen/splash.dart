// ignore_for_file: file_names

import 'dart:async';

import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:praduation_project/constants/image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:praduation_project/core/theme/text_theme.dart';
import 'package:praduation_project/global%20widget/no_internet_view.dart';
import 'package:praduation_project/modules/splashScreen/widgets/transition.dart';
import '../../data/services/get_db.dart';
import '../../data/services/database.dart';
import '../../data/model/user_account_model.dart';
import '../home/bindings/home_binding.dart';
import '../home/views/home_view.dart';
import '../auth/view/login/login_view.dart';
import '../select_lang/select_lang.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  double fontSize = 2;
  double containerSize = 1.5;
  double textOpacity = 0.0;
  double containerOpacity = 0.0;

  late AnimationController controller;
  late Animation<double> animation1;

  @override
  void initState() {
    super.initState();

    Connectivity().onConnectivityChanged.listen((event) {
      if (event == ConnectivityResult.none) {
        Get.offAll(() => const NoInternetView());
      }
    });

    controller =
        AnimationController(vsync: this, duration: const Duration(seconds: 3));

    animation1 = Tween<double>(begin: 40, end: 20).animate(CurvedAnimation(
        parent: controller, curve: Curves.fastLinearToSlowEaseIn))
      ..addListener(() {
        setState(() {
          textOpacity = 1.0;
        });
      });

    controller.forward();

    Timer(const Duration(seconds: 3), () {
      setState(() {
        fontSize = 1.06;
      });
    });

    Timer(const Duration(seconds: 3), () {
      setState(() {
        containerSize = 2;
        containerOpacity = 1;
      });
    });

    //!.................................
    Timer(const Duration(seconds: 4), () async {
      Get.put(DatabaseFirestore());

      await DatabaseFirestore.getUser();

      final isUserExist = FirebaseAuth.instance.currentUser != null;
      if (Database.isFirstTime) {
        // ignore: use_build_context_synchronously
        Navigator.of(context)
            .pushReplacement(PageTransition(const SelectLanguage()));
      } else {
        //?.........................................................
        Get.put(DatabaseFirestore());
        if (isUserExist) {
          if (UserAccount.info!.isEmailVerified == false) {
            Get.offAll(() => const LoginView());
          } else {
            Get.off(() => HomeView(), binding: HomeBinding());
          }
        } else {
          // ignore: use_build_context_synchronously
          Navigator.pushReplacement(context, PageTransition(const LoginView()));
        }
      } //?.........................................................
    }); //!.................................
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Get.theme.colorScheme.background,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness:
              Get.isDarkMode ? Brightness.light : Brightness.dark,
        ),
      ),
      body: Stack(
        children: [
          Column(
            children: [
              AnimatedContainer(
                duration: const Duration(seconds: 2),
                curve: Curves.fastLinearToSlowEaseIn,
                height: (height / fontSize) - height * .15,
              ),
              AnimatedOpacity(
                duration: const Duration(seconds: 2),
                opacity: textOpacity,
                child: DefaultTextStyle(
                  style: AppStyles.headLine1.copyWith(
                    color: Get.theme.colorScheme.onBackground,
                  ),
                  child: AnimatedTextKit(
                    animatedTexts: [
                      WavyAnimatedText('appName'.tr),
                    ],
                    isRepeatingAnimation: false,
                  ),
                ),
              ),
            ],
          ),
          Center(
            child: AnimatedOpacity(
              duration: const Duration(seconds: 2),
              curve: Curves.fastLinearToSlowEaseIn,
              opacity: containerOpacity,
              child: AnimatedContainer(
                duration: const Duration(seconds: 2),
                curve: Curves.fastLinearToSlowEaseIn,
                height: width / containerSize,
                width: width,
                alignment: Alignment.center,
                child: Image(
                  image:
                      AssetImage(Get.isDarkMode ? kAppLogoDark : kAppLogoLight),
                  fit: BoxFit.fitHeight,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
