import 'package:flutter/material.dart';

class CustomDropDownOption extends StatelessWidget {
  final List<Option> options;

  const CustomDropDownOption({Key? key, required this.options})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<Option>(
      icon: const Icon(Icons.more_vert),
      itemBuilder: (BuildContext context) {
        return options.map((Option option) {
          return PopupMenuItem<Option>(
            value: option,
            child: ListTile(
              leading: option.icon,
              title: Text(option.label),
              onTap: option.onTap,
            ),
          );
        }).toList();
      },
    );
  }
}

class Option {
  final String label;
  final Widget? icon;
  final VoidCallback? onTap;
  Option({
    required this.label,
    this.icon,
    this.onTap,
  });
}
