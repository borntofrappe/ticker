import 'package:flutter/material.dart';

import 'package:ticker/routes/splash_screen.dart';

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
      home: const SplashScreen(
        text: 'Ticker',
      ),
    );
  }
}
