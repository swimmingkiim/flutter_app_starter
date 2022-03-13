import 'package:flutter/material.dart';
import 'package:flutter_app_starter/src/style/theme/color.dart';
import 'package:flutter_app_starter/src/ui/component/change-password-form.dart';
import 'package:flutter_app_starter/src/ui/component/withdrawal-form.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomDialog {
  static showWithdrawalDialog(BuildContext context, Function onSubmitForm,
      {bool blockDismiss = false}) {
    showDialog(
        context: context,
        barrierLabel: 'Withdrawal',
        barrierColor: Colors.transparent,
        barrierDismissible: !blockDismiss,
        builder: (BuildContext context) {
          return AlertDialog(
            backgroundColor: CustomColorScheme.background,
            title: Text(
              'Confirm withdrawal by type in your password',
              style: GoogleFonts.firaMono(
                  textStyle: const TextStyle(
                fontSize: 10,
                color: CustomColorScheme.primary,
              )),
            ),
            content: WithdrawalForm(
              onSubmit: (String email, String password) async {
                Navigator.pop(context);
                await onSubmitForm(email, password);
              },
              onCancel: () {
                Navigator.pop(context);
              },
            ),
          );
        });
  }

  static showChangePasswordDialog(BuildContext context, Function onSubmitForm,
      {bool blockDismiss = false}) {
    showDialog(
        context: context,
        barrierLabel: 'Change Password',
        barrierColor: Colors.transparent,
        barrierDismissible: !blockDismiss,
        builder: (BuildContext context) {
          return AlertDialog(
            backgroundColor: CustomColorScheme.background,
            title: Text(
              'Confirm by type in your current password and new password',
              style: GoogleFonts.firaMono(
                  textStyle: const TextStyle(
                fontSize: 10,
                color: CustomColorScheme.primary,
              )),
            ),
            content: ChangePasswordForm(
              onSubmit: (String currentPassword, String newPassword) async {
                Navigator.pop(context);
                await onSubmitForm(currentPassword, newPassword);
              },
              onCancel: () {
                Navigator.pop(context);
              },
            ),
          );
        });
  }

  static showSimpleDialog(BuildContext context, {required Widget child}) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return Dialog(
            backgroundColor: CustomColorScheme.background,
            elevation: 0,
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: child,
            ),
          );
        });
  }
}
