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
        scaffoldBackgroundColor: Colors.white,
        colorScheme: const ColorScheme.light().copyWith(
          primary: Colors.black87,
          background: Colors.white,
          shadow: Colors.black12,
        ),
        textTheme: const TextTheme(
          headline1: TextStyle(fontSize: 24.0, color: Colors.black87),
          headline2: TextStyle(fontSize: 14.0, color: Colors.black54),
          headline3: TextStyle(
            fontSize: 14.0,
            color: Colors.black87,
            fontWeight: FontWeight.w700,
          ),
          headline4: TextStyle(fontSize: 14.0, color: Colors.black54),
        ),
        fontFamily: 'Inter',
      ),
      home: const SplashScreen(
        text: 'Ticker',
      ),
      onGenerateRoute: (RouteSettings settings) {
        if (settings.name == '/home') {
          final args = settings.arguments as ScreenArguments;
          return slideToRoute(
            Home(
              count: args.count,
              scrollValue: args.scrollValue,
            ),
          );
        } else if (settings.name == '/settings') {
          final args = settings.arguments as ScreenArguments;
          return slideToRoute(
            Settings(
              count: args.count,
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
