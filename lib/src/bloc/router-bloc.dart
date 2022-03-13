import 'package:flutter/material.dart';
import 'package:flutter_app_starter/src/ui/page/Home.dart';

class RouterBloc {
  RouterBloc();

  static Route<dynamic> generateRoutes(RouteSettings settings) {
    switch (settings.name) {
      // case '/':
      //   final args = settings.arguments;
      //   return MaterialPageRoute(
      //       builder: (BuildContext context) => args != null
      //           ? Todo(
      //               date: (args as TodoArguments).date,
      //             )
      //           : Todo());
      // case '/logs':
      //   return MaterialPageRoute(builder: (BuildContext context) => Log());
      // case '/calendar':
      //   final args = settings.arguments;
      //   return MaterialPageRoute(
      //       builder: (BuildContext context) => args != null
      //           ? Calendar(
      //               targetDate: (args as CalendarArguments).targetDate,
      //             )
      //           : Calendar());
      // case '/login':
      //   return MaterialPageRoute(builder: (BuildContext context) => Login());
      // case '/signup':
      //   return MaterialPageRoute(builder: (BuildContext context) => SignUp());
      // case '/setting':
      //   return MaterialPageRoute(builder: (BuildContext context) => Setting());
      default:
        return MaterialPageRoute(
            builder: (BuildContext context) => const Home());
    }
  }
}
