import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../style/theme/color.dart';
import '../../util/notifier.dart';

class SignUpForm extends StatefulWidget {
  final Function onSubmit;
  const SignUpForm({Key? key, required this.onSubmit}) : super(key: key);

  @override
  _SignUpFormState createState() => _SignUpFormState();
}

class _SignUpFormState extends State<SignUpForm> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  _submit() {
    if (nameController.text.isEmpty ||
        emailController.text.isEmpty ||
        passwordController.text.isEmpty) {
      Notifier.error(context, 'Please fill all information');
      return;
    }
    widget.onSubmit(
        nameController.text, emailController.text, passwordController.text);
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
                controller: nameController,
                onEditingComplete: () => FocusScope.of(context).nextFocus(),
                decoration: const InputDecoration(
                  contentPadding: EdgeInsets.all(20),
                  hintText: 'Name',
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
            padding: const EdgeInsets.only(top: 30),
            child: InkWell(
              child: Text('Sign Up',
                  style: GoogleFonts.firaMono(
                      textStyle: const TextStyle(
                    fontSize: 25,
                    color: CustomColorScheme.primary,
                  ))),
              onTap: _submit,
            ),
          )
        ],
      ),
    );
  }
}
