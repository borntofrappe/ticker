import 'package:flutter/material.dart';
import 'package:ticker/routes/home.dart';
import 'package:ticker/routes/settings.dart';
import 'package:ticker/widgets/custom_route_builder.dart';

void main() {
  runApp(const App());
}

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: const Home(),
      onGenerateRoute: (RouteSettings settings) {
        if (settings.name == '/settings') {
          return CustomRouteBuilder(child: const Settings());
        }

        assert(false, '${settings.name} is not implemented');
        return null;
      },
    );
  }
}
