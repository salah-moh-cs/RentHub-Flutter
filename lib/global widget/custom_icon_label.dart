import 'package:flutter/material.dart';

import '../core/theme/text_theme.dart';

class CustomIconLabel extends StatelessWidget {
  final String label;
  final IconData icons;
  final Color? iconColor;

  const CustomIconLabel({
    super.key,
    required this.label,
    required this.icons,
    this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          icons,
          color: iconColor ?? Colors.grey,
        ),
        const SizedBox(width: 4.0),
        SelectableText(
          label,
          style: AppStyles.bodyText1,
        ),
      ],
    );
  }
}
