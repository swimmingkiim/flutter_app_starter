import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../style/theme/color.dart';
import '../../util/notifier.dart';

class WithdrawalForm extends StatefulWidget {
  final Function onSubmit;
  final Function onCancel;
  const WithdrawalForm(
      {Key? key, required this.onSubmit, required this.onCancel})
      : super(key: key);

  @override
  _WithdrawalFormState createState() => _WithdrawalFormState();
}

class _WithdrawalFormState extends State<WithdrawalForm> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  _submit() async {
    if (emailController.text.isEmpty || passwordController.text.isEmpty) {
      Notifier.error(context, 'Please fill all information');
      return;
    }
    widget.onSubmit(emailController.text, passwordController.text);
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
                controller: emailController,
                onEditingComplete: () => FocusScope.of(context).nextFocus(),
                decoration: const InputDecoration(
                  hintStyle: TextStyle(
                      fontSize: 12.5, color: CustomColorScheme.onPrimary),
                  contentPadding: EdgeInsets.all(10),
                  hintText: 'Email',
                ),
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
                controller: passwordController,
                onEditingComplete: _submit,
                decoration: const InputDecoration(
                  hintStyle: TextStyle(
                      fontSize: 12.5, color: CustomColorScheme.onPrimary),
                  contentPadding: EdgeInsets.all(10),
                  hintText: 'Password',
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
