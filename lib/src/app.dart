import 'package:flutter/material.dart';

import 'bloc/router-bloc.dart';
import 'style/theme/color.dart';

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'flutter app starter',
      theme: ThemeData(
          colorScheme: CustomColorScheme.colorScheme,
          pageTransitionsTheme: const PageTransitionsTheme(builders: {
            TargetPlatform.android: FadeUpwardsPageTransitionsBuilder(),
            TargetPlatform.iOS: FadeUpwardsPageTransitionsBuilder(),
          })),
      initialRoute: '/',
      onGenerateRoute: RouterBloc.generateRoutes,
    );
  }
}
