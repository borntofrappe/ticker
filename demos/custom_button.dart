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
        highlightColor: Colors.black12,
      ),
      home: const Home(),
    );
  }
}

class Home extends StatelessWidget {
  const Home({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            CustomButton(
              onPressed: () {},
              child: const Text(
                '+',
              ),
              size: 64.0,
              borderWidth: 2.0,
            ),
            const SizedBox(height: 16.0),
            CustomButton(
              onPressed: () {},
              child: const Icon(
                Icons.chevron_right,
              ),
              size: 32.0,
              borderWidth: 1.0,
              showOverlay: false,
            ),
          ],
        ),
      ),
    );
  }
}

class CustomButton extends StatelessWidget {
  final VoidCallback onPressed;
  final Widget child;
  final double size;
  final double borderWidth;
  final bool showOverlay;

  const CustomButton({
    Key? key,
    required this.onPressed,
    required this.child,
    required this.size,
    required this.borderWidth,
    this.showOverlay = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: OutlinedButton(
        onPressed: onPressed,
        child: AspectRatio(
          aspectRatio: 1.0,
          child: FittedBox(
            child: child,
          ),
        ),
        style: ButtonStyle(
          padding: MaterialStateProperty.all(EdgeInsets.zero),
          shape: MaterialStateProperty.all(const BeveledRectangleBorder()),
          side: MaterialStateProperty.all(
            BorderSide(
              color: Theme.of(context).primaryColor,
              width: borderWidth,
            ),
          ),
          overlayColor: showOverlay
              ? MaterialStateProperty.resolveWith(
                  (states) {
                    return states.contains(MaterialState.pressed)
                        ? Theme.of(context).highlightColor
                        : null;
                  },
                )
              : MaterialStateProperty.all(Colors.transparent),
        ),
      ),
    );
  }
}
