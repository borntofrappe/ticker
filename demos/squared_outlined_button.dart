import 'package:flutter/material.dart';

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
      ),
      home: const Home(),
    );
  }
}

class Home extends StatelessWidget {
  const Home({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Theme(
        data: ThemeData(
          outlinedButtonTheme: OutlinedButtonThemeData(
            style: OutlinedButton.styleFrom(
              primary: Theme.of(context).primaryColor,
              shape: const BeveledRectangleBorder(),
              side: BorderSide(
                color: Theme.of(context).primaryColor,
                width: 2.0,
              ),
            ),
          ),
        ),
        child: Center(
          child: SquaredOutlinedButton(
            size: 64.0,
            child: const Text(
              '+',
              style: TextStyle(
                fontSize: 64.0,
              ),
            ),
            onPressed: () {},
          ),
        ),
      ),
    );
  }
}

class SquaredOutlinedButton extends StatelessWidget {
  final double size;
  final Widget child;
  final void Function() onPressed;

  const SquaredOutlinedButton({
    Key? key,
    required this.size,
    required this.child,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: AspectRatio(
        aspectRatio: 1.0,
        child: OutlinedButton(
          onPressed: onPressed,
          child: FittedBox(
            child: child,
          ),
        ),
      ),
    );
  }
}
