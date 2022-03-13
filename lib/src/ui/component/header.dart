import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../style/theme/color.dart';

class Header extends StatelessWidget with PreferredSizeWidget {
  @override
  final Size preferredSize = const Size.fromHeight(100.0);
  final String title;

  Header({Key? key, this.title = "flutter app starter"}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      actions: [],
      automaticallyImplyLeading: false,
      backgroundColor: CustomColorScheme.colorScheme.background,
      flexibleSpace: FlexibleSpaceBar(
        centerTitle: true,
        title: Text(title,
            style: GoogleFonts.firaMono(
                textStyle: const TextStyle(
              fontSize: 30,
              color: CustomColorScheme.primary,
            ))),
      ),
      elevation: 0,
    );
  }
}
