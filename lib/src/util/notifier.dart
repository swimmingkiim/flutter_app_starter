import 'package:flutter/material.dart';
import 'package:flutter_app_starter/src/style/theme/color.dart';

class Notifier {
  static success(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      behavior: SnackBarBehavior.floating,
      content: Text(message, textAlign: TextAlign.center),
      backgroundColor: CustomColorScheme.success,
    ));
  }

  static error(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      behavior: SnackBarBehavior.floating,
      content: Text(message, textAlign: TextAlign.center),
      backgroundColor: CustomColorScheme.error,
    ));
  }
}
