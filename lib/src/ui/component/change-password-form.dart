import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../style/theme/color.dart';
import '../../util/notifier.dart';

class ChangePasswordForm extends StatefulWidget {
  final Function onSubmit;
  final Function onCancel;
  const ChangePasswordForm(
      {Key? key, required this.onSubmit, required this.onCancel})
      : super(key: key);

  @override
  _ChangePasswordFormState createState() => _ChangePasswordFormState();
}

class _ChangePasswordFormState extends State<ChangePasswordForm> {
  final TextEditingController currentPasswordController =
      TextEditingController();
  final TextEditingController newPasswordController = TextEditingController();
  final TextEditingController newPasswordAgainController =
      TextEditingController();

  _submit() async {
    if (currentPasswordController.text.isEmpty ||
        newPasswordController.text.isEmpty) {
      Notifier.error(context, 'Please fill all information');
      return;
    }
    if (newPasswordAgainController.text != newPasswordController.text) {
      Notifier.error(context, 'Make sure you typed a new password right');
      return;
    }
    widget.onSubmit(currentPasswordController.text, newPasswordController.text);
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: SizedBox(
              width: MediaQuery.of(context).size.width > 700
                  ? MediaQuery.of(context).size.width * 0.35
                  : MediaQuery.of(context).size.width * 0.7,
              child: TextFormField(
                style: const TextStyle(
                    fontSize: 12.5, color: CustomColorScheme.onPrimary),
                controller: currentPasswordController,
                onEditingComplete: () => FocusScope.of(context).nextFocus(),
                decoration: const InputDecoration(
                  hintStyle: TextStyle(
                      fontSize: 12.5, color: CustomColorScheme.onPrimary),
                  contentPadding: EdgeInsets.all(10),
                  hintText: 'Current Password',
                ),
                obscureText: true,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: SizedBox(
              width: MediaQuery.of(context).size.width > 700
                  ? MediaQuery.of(context).size.width * 0.35
                  : MediaQuery.of(context).size.width * 0.7,
              child: TextFormField(
                style: const TextStyle(
                    fontSize: 12.5, color: CustomColorScheme.onPrimary),
                controller: newPasswordController,
                onEditingComplete: _submit,
                decoration: const InputDecoration(
                  hintStyle: TextStyle(
                      fontSize: 12.5, color: CustomColorScheme.onPrimary),
                  contentPadding: EdgeInsets.all(10),
                  hintText: 'New Password',
                ),
                obscureText: true,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: SizedBox(
              width: MediaQuery.of(context).size.width > 700
                  ? MediaQuery.of(context).size.width * 0.35
                  : MediaQuery.of(context).size.width * 0.7,
              child: TextFormField(
                style: const TextStyle(
                    fontSize: 12.5, color: CustomColorScheme.onPrimary),
                controller: newPasswordAgainController,
                onEditingComplete: _submit,
                decoration: const InputDecoration(
                  hintStyle: TextStyle(
                      fontSize: 12.5, color: CustomColorScheme.onPrimary),
                  contentPadding: EdgeInsets.all(10),
                  hintText: 'New Password Again',
                ),
                obscureText: true,
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: [
              Padding(
                padding: const EdgeInsets.all(10),
                child: InkWell(
                  child: Text('Confirm',
                      style: GoogleFonts.firaMono(
                          textStyle: const TextStyle(
                        fontSize: 15,
                        color: CustomColorScheme.error,
                      ))),
                  onTap: _submit,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10),
                child: InkWell(
                  child: Text('Cancel',
                      style: GoogleFonts.firaMono(
                          textStyle: const TextStyle(
                        fontSize: 15,
                        color: CustomColorScheme.success,
                      ))),
                  onTap: () {
                    widget.onCancel();
                  },
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}
