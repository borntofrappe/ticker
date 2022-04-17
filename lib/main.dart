import 'package:flutter/material.dart';

import 'package:ticker/routes/splash_screen.dart';
import 'package:ticker/routes/home.dart';
import 'package:ticker/routes/settings.dart';

import 'package:ticker/helpers/slide_to_route.dart';
import 'package:ticker/helpers/screen_arguments.dart';

import 'package:ticker/helpers/theme_data_change_notifier.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => ThemeDataChangeNotifier(),
      child: const App(),
    ),
  );
}

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: Provider.of<ThemeDataChangeNotifier>(context).getThemeData(),
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
