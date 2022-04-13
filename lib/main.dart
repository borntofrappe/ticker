import 'package:flutter/material.dart';

import 'package:ticker/routes/splash_screen.dart';
import 'package:ticker/routes/home.dart';
import 'package:ticker/routes/settings.dart';

import 'package:ticker/helpers/slide_to_route.dart';
import 'package:ticker/helpers/screen_arguments.dart';

void main() {
  runApp(const App());
}

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primaryColor: Colors.black87,
        highlightColor: Colors.black12,
        fontFamily: 'Inter',
      ),
      home: const SplashScreen(
        text: 'Ticker',
      ),
      onGenerateRoute: (RouteSettings settings) {
        if (settings.name == '/home') {
          const int slideDuration = 1000;
          final args = settings.arguments as ScreenArguments;
          return slideToRoute(
            Home(
              scrollValue: args.scrollValue,
            ),
            slideDuration,
          );
        } else if (settings.name == '/settings') {
          final args = settings.arguments as ScreenArguments;
          return slideToRoute(
            Settings(
              scrollValue: args.scrollValue,
            ),
          );
        }

        assert(false, '$settings.name is not implemented');
        return null;
      },
    );
  }
}
