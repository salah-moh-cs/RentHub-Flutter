import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'local_controler.dart';

class SelectedLanguageDialog extends StatelessWidget {
  const SelectedLanguageDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text(
              'selectLanguage'.tr,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18.0,
              ),
            ),
            const SizedBox(height: 16.0),
            ListTile(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
              selected: LocaleController.instance.getLang == const Locale('en'),
              leading: const Icon(Icons.language),
              title: Text('english'.tr),
              onTap: () {
                Navigator.pop(context);

                LocaleController.instance.changeLang("en");
              },
            ),
            ListTile(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
              selected: LocaleController.instance.getLang == const Locale('ar'),
              leading: const Icon(Icons.language),
              title: Text('arabic'.tr),
              onTap: () {
                Navigator.pop(context);
                LocaleController.instance.changeLang("ar");
              },
            ),
          ],
        ),
      ),
    );
  }
}
