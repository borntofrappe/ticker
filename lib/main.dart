import 'package:flutter/material.dart';
import 'package:ticker/routes/home.dart';
import 'package:ticker/routes/settings.dart';
import 'package:ticker/helpers/slide_to_route.dart';
import 'dart:ui';

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
        iconTheme: const IconThemeData(
          size: 32.0,
        ),
        fontFamily: 'Inter',
        textTheme: const TextTheme(
          headline1: TextStyle(fontSize: 24.0),
          headline2: TextStyle(fontSize: 12.0),
          headline3: TextStyle(
            fontSize: 16.0,
            fontWeight: FontWeight.w700,
          ),
          subtitle1: TextStyle(
            fontSize: 12.0,
            color: Colors.black54,
          ),
          button: TextStyle(
            fontSize: 64.0,
            fontWeight: FontWeight.w700,
            fontFeatures: [
              FontFeature.caseSensitiveForms(),
            ],
          ),
        ).apply(
          displayColor: Colors.black87,
          bodyColor: Colors.black87,
        ),
      ),
      home: const Home(),
      onGenerateRoute: (RouteSettings settings) {
        if (settings.name == '/settings') {
          return slideToRoute(const Settings());
        }

        assert(false, '${settings.name} is not implemented');
        return null;
      },
    );
  }
}
