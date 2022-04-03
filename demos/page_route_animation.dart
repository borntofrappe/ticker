import 'package:flutter/material.dart';

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
          // return MaterialPageRoute(
          //   builder: (BuildContext context) => const Settings(),
          // );
          return PageRouteBuilder(
            pageBuilder: (BuildContext context, Animation animation,
                    Animation secondaryAnimation) =>
                const Settings(),
            transitionDuration: const Duration(
              milliseconds: 500,
            ),
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
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ElevatedButton(
          child: const Text('Slide to settings'),
          onPressed: () {
            Navigator.pushNamed(context, '/settings');
          },
        ),
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
        backgroundColor: Colors.grey[700],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: TextButton(
          child: const Text('Slide back home'),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
    );
  }
}
