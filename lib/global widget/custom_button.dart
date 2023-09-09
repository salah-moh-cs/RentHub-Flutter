// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../core/theme/text_theme.dart';
import '../modules/auth/view/login/widgets/themehelper.dart';

class CustomButton extends StatelessWidget {
  const CustomButton({
    super.key,
    required this.onPressed,
    this.label,
    this.color,
    this.height,
    this.width,
    this.padding,
  });

  final VoidCallback? onPressed;
  final Widget? label;
  final Color? color;

  final double? width;
  final double? height;
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      padding: padding ?? const EdgeInsets.all(14.0),
      color: color,
      minWidth: width ?? double.infinity,
      height: height,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0),
      ),
      onPressed: onPressed,
      child: label,
    );
  }
}

class CustomButtonWithLoading extends StatefulWidget {
  const CustomButtonWithLoading(
      {super.key,
      required this.onPressed,
      this.label,
      this.color,
      this.height,
      this.width,
      this.padding,
      this.loadingColor});

  final Future<void> Function()? onPressed;
  final Widget? label;
  final Color? color;
  final double? width;
  final double? height;
  final EdgeInsetsGeometry? padding;
  final Color? loadingColor;

  @override
  State<CustomButtonWithLoading> createState() =>
      _CustomButtonWithLoadingState();
}

class _CustomButtonWithLoadingState extends State<CustomButtonWithLoading> {
  bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      padding: widget.padding ?? const EdgeInsets.all(14.0),
      color: isLoading ? null : widget.color,
      minWidth: widget.width ?? double.infinity,
      height: widget.height,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0),
      ),
      onPressed: () async {
        setState(() => isLoading = true);
        await widget.onPressed?.call().whenComplete(() => null);
        setState(() => isLoading = false);
      },
      child: isLoading
          ? Center(
              child: CircularProgressIndicator(
                color: widget.loadingColor,
              ),
            )
          : widget.label,
    );
  }
}

class CustomPrimaryButton extends StatelessWidget {
  final String? label;
  final VoidCallback? onPresssed;
  final int? maxLines;
  final Color? backgroundColor;
  final Color? textColor;
  const CustomPrimaryButton({
    super.key,
    this.onPresssed,
    this.label,
    this.maxLines,
    this.backgroundColor,
    this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: ThemeHelper().buttonBoxDecoration(context),
      width: double.infinity,
      child: ElevatedButton(
        style: ThemeHelper().buttonStyle().copyWith(
              backgroundColor: MaterialStateProperty.all(
                  backgroundColor ?? Get.theme.colorScheme.primary),
            ),
        onPressed: onPresssed,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(40, 10, 40, 10),
          child: Text(
            label ?? "label",
            maxLines: maxLines,
            overflow: TextOverflow.ellipsis,
            style: AppStyles.button.copyWith(
              color: textColor ?? Get.theme.colorScheme.background,
            ),
          ),
        ),
      ),
    );
  }
}
