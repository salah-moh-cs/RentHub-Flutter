import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:praduation_project/modules/OnboardingScreen/onboarding_view.dart';
import 'package:praduation_project/constants/image.dart';

import '../../core/theme/text_theme.dart';
import '../../core/value/languages/local_controler.dart';
import '../../global widget/custom_button.dart';

class SelectLanguage extends StatefulWidget {
  const SelectLanguage({super.key});

  @override
  State<SelectLanguage> createState() => _SelectLanguageState();
}

class _SelectLanguageState extends State<SelectLanguage> {
  bool isEnglish = LocaleController.instance.getLang == const Locale('en');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: [
                Expanded(
                  child: Image.asset(
                    Get.isDarkMode ? kAppLogoDark : kAppLogoLight,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 25),
            Text(
              "selectlanguage".tr,
              style: AppStyles.headLine3,
            ),
            const SizedBox(height: 25),
            Row(
              children: [
                Expanded(
                  child: CustomCard(
                    title: "english".tr,
                    checked: isEnglish,
                    onChange: (_) {
                      LocaleController.instance.changeLang('en');
                      setState(() => isEnglish = true);
                    },
                  ),
                ),
                Expanded(
                  child: CustomCard(
                    title: "arabic".tr,
                    icons: Icons.language,
                    checked: !isEnglish,
                    onChange: (_) {
                      LocaleController.instance.changeLang('ar');
                      setState(() => isEnglish = false);
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 25),
            Text(
              "*${"changelanglater".tr}",
              style: AppStyles.bodyText3.copyWith(
                color: Get.theme.colorScheme.secondary,
              ),
            ),
            const Spacer(),
            CustomButton(
              color: Get.theme.colorScheme.primary,
              onPressed: () => Get.off(() => const OnBoardingScreen()),
              label: Text(
                'save'.tr,
                style: AppStyles.button.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Get.theme.colorScheme.onPrimary,
                ),
              ),
            ),
            const SizedBox(height: 15),
          ],
        ),
      ),
    );
  }
}

class CustomCard extends StatelessWidget {
  final String title;
  final bool checked;
  final ValueChanged<bool>? onChange;
  final IconData icons;
  const CustomCard({
    super.key,
    required this.title,
    this.checked = false,
    this.onChange,
    this.icons = Icons.g_translate,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: () {
          if (onChange != null) {
            onChange!(!checked);
          }
        },
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Icon(
                    checked ? Icons.check_circle : null,
                    color: Get.theme.colorScheme.primary,
                  ),
                ],
              ),
              const SizedBox(height: 15),
              Icon(
                icons,
                size: 60,
              ),
              const SizedBox(height: 15),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 18,
                ),
              ),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }
}
