import 'package:flutter/material.dart';
import 'package:flutter_app_starter/src/style/layout/home-layout.dart';
import 'package:google_fonts/google_fonts.dart';

class Home extends StatelessWidget {
  const Home({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return HomeLayout(
        child: Center(
      child: Text(
        'Start Customizing!',
        style: GoogleFonts.firaMono(textStyle: const TextStyle(fontSize: 30)),
      ),
    ));
  }
}
