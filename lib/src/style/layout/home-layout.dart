import 'package:flutter/material.dart';

import '../../ui/component/header.dart';
import '../theme/color.dart';

class HomeLayout extends StatelessWidget {
  final Widget child;

  HomeLayout({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        child: Scaffold(
            backgroundColor: CustomColorScheme.colorScheme.background,
            resizeToAvoidBottomInset: false,
            appBar: Header(
              title: 'flutter app starter',
            ),
            body: child));
  }
}
