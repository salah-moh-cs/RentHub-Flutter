import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CustomCard extends StatelessWidget {
  final String title;
  final IconData icons;
  final VoidCallback? onTap;
  const CustomCard({
    super.key,
    required this.title,
    this.onTap,
    this.icons = Icons.g_translate,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 8,
      color: Get.theme.colorScheme.onBackground,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              const SizedBox(height: 15),
              Icon(
                icons,
                size: 60,
                color: Get.theme.colorScheme.background,
              ),
              const SizedBox(height: 15),
              Text(
                title,
                style: TextStyle(
                  color: Get.theme.colorScheme.background,
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
