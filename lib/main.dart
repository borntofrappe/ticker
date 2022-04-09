import 'package:flutter/material.dart';

// import 'package:ticker/routes/splash_screen.dart';
import 'package:ticker/routes/home.dart';
import 'package:ticker/routes/settings.dart';

import 'package:ticker/helpers/slide_to_route.dart';

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
        fontFamily: 'Inter',
      ),

      /* TODO: add splash screen instead of Home()
      home: const SplashScreen(
        text: 'Ticker',
      )
      */
      home: const Home(),
      onGenerateRoute: (RouteSettings settings) {
        if (settings.name == '/home') {
          return slideToRoute(
            const Home(),
            const Duration(
              seconds: 1,
            ),
          );
        } else if (settings.name == '/settings') {
          return slideToRoute(
            const Settings(),
          );
        }

        assert(false, '$settings.name is not implemented');
        return null;
      },
    );
  }
}
