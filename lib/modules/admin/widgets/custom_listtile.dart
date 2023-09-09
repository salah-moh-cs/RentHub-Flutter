import 'package:flutter/material.dart';

class CustomListTile extends StatelessWidget {
  final IconData icons;
  final String label;
  final int? num;
  final VoidCallback? onTap;
  const CustomListTile({
    super.key,
    required this.icons,
    required this.label,
    this.num,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ListTileTheme(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: ListTile(
          leading: Icon(icons),
          title: Text(label),
          trailing: num != null
              ? Container(
                  padding: const EdgeInsets.all(4.0),
                  decoration: BoxDecoration(
                    color: num! > 0 ? Colors.green : Colors.red,
                    shape: BoxShape.circle,
                  ),
                  child: Text(
                    "${num! > 0 ? num : num! * -1}",
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                )
              : const SizedBox(),
          onTap: onTap,
        ),
      ),
    );
  }
}
