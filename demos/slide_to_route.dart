import 'package:flutter/material.dart';

void main() {
  runApp(const App());
}

PageRouteBuilder<dynamic> slideToRoute(Widget child, [Duration? duration]) {
  return PageRouteBuilder(
    pageBuilder: (BuildContext context, Animation animation,
            Animation secondaryAnimation) =>
        child,
    transitionDuration: duration ?? const Duration(milliseconds: 500),
    transitionsBuilder: (BuildContext context, Animation animation,
        Animation secondaryAnimation, Widget child) {
      Offset begin = const Offset(1.0, 0.0);
      Offset end = Offset.zero;
      Curve curve = Curves.easeOutCubic;

      Animatable<Offset> animatable = Tween(
        begin: begin,
        end: end,
      ).chain(
        CurveTween(
          curve: curve,
        ),
      );

      return SlideTransition(
        position: animation.drive(animatable),
        child: child,
      );
    },
  );
}

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: const Home(),
      onGenerateRoute: (RouteSettings settings) {
        if (settings.name == '/settings') {
          return slideToRoute(const Settings());
        }

        assert(false, '$settings.name is not implemented');
        return null;
      },
    );
  }
}

class Home extends StatelessWidget {
  const Home({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.black87,
        elevation: 0.0,
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.chevron_right),
            onPressed: () {
              Navigator.pushNamed(context, '/settings');
            },
          )
        ],
      ),
    );
  }
}

class Settings extends StatelessWidget {
  const Settings({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.black87,
        elevation: 0.0,
      ),
    );
  }
}
