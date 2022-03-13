import 'package:flutter/material.dart';

import 'src/app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const FlutterAppStarterApp());
}

class FlutterAppStarterApp extends StatelessWidget {
  const FlutterAppStarterApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return App();
  }
}
