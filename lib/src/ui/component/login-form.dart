import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../style/theme/color.dart';
import '../../util/custom-dialog.dart';
import '../../util/notifier.dart';

class LoginForm extends StatefulWidget {
  final Function onSubmit;
  final Function onSubmitResetPassword;
  const LoginForm(
      {Key? key, required this.onSubmit, required this.onSubmitResetPassword})
      : super(key: key);

  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final TextEditingController emailForResetPasswordController =
      TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  _submit() {
    if (emailController.text.isEmpty || passwordController.text.isEmpty) {
      Notifier.error(context, 'Please fill all information');
      return;
    }
    widget.onSubmit(emailController.text, passwordController.text);
  }

  _submitResetPassword() {
    if (emailForResetPasswordController.text.isEmpty) {
      Notifier.error(context, 'Please fill all information');
      return;
    }
    widget.onSubmitResetPassword(emailForResetPasswordController.text);
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 30),
            child: SizedBox(
              width: MediaQuery.of(context).size.width > 700
                  ? MediaQuery.of(context).size.width * 0.35
                  : MediaQuery.of(context).size.width * 0.7,
              child: TextFormField(
                controller: emailController,
                onEditingComplete: () => FocusScope.of(context).nextFocus(),
                decoration: const InputDecoration(
                  contentPadding: EdgeInsets.all(20),
                  hintText: 'Email',
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 30),
            child: SizedBox(
              width: MediaQuery.of(context).size.width > 700
                  ? MediaQuery.of(context).size.width * 0.35
                  : MediaQuery.of(context).size.width * 0.7,
              child: TextFormField(
                controller: passwordController,
                onEditingComplete: _submit,
                decoration: const InputDecoration(
                  contentPadding: EdgeInsets.all(20),
                  hintText: 'Password',
                ),
                obscureText: true,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(30),
            child: InkWell(
              child: Text('Login',
                  style: GoogleFonts.firaMono(
                      textStyle: const TextStyle(
                    fontSize: 30,
                    color: CustomColorScheme.primary,
                  ))),
              onTap: _submit,
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Padding(
                padding: const EdgeInsets.all(30),
                child: InkWell(
                  child: Text('forgot password',
                      style: GoogleFonts.firaMono(
                          textStyle: const TextStyle(
                        fontSize: 15,
                        color: CustomColorScheme.primary,
                      ))),
                  onTap: () {
                    CustomDialog.showSimpleDialog(context,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(bottom: 30),
                              child: SizedBox(
                                width: MediaQuery.of(context).size.width > 700
                                    ? MediaQuery.of(context).size.width * 0.35
                                    : MediaQuery.of(context).size.width * 0.7,
                                child: TextFormField(
                                  controller: emailForResetPasswordController,
                                  onEditingComplete: () =>
                                      FocusScope.of(context).nextFocus(),
                                  decoration: const InputDecoration(
                                    contentPadding: EdgeInsets.all(20),
                                    hintText: 'Email',
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(30),
                              child: InkWell(
                                child: Text('Set new password',
                                    style: GoogleFonts.firaMono(
                                        textStyle: const TextStyle(
                                      fontSize: 15,
                                      color: CustomColorScheme.primary,
                                    ))),
                                onTap: _submitResetPassword,
                              ),
                            )
                          ],
                        ));
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(30),
                child: InkWell(
                  child: Text('sign up',
                      style: GoogleFonts.firaMono(
                          textStyle: const TextStyle(
                        fontSize: 15,
                        color: CustomColorScheme.primary,
                      ))),
                  onTap: () {
                    Navigator.of(context).popAndPushNamed('/signup');
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
