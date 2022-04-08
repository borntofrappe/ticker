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
  const Home({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: const [
            CustomOutlinedButton(
              size: 32.0,
              color: Colors.black87,
              overlayColor: Colors.black12,
              borderWidth: 2.0,
              child: Icon(
                Icons.chevron_right,
                size: 32.0,
                color: Colors.black87,
              ),
            ),
            CustomOutlinedButton(
              size: 64.0,
              color: Colors.black87,
              overlayColor: Colors.black12,
              borderWidth: 2.0,
              child: AspectRatio(
                aspectRatio: 1.0,
                child: FittedBox(
                  child: Text(
                    '+',
                    style: TextStyle(
                      color: Colors.black87,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CustomOutlinedButton extends StatelessWidget {
  final Widget child;
  final double size;
  final Color color;
  final Color overlayColor;
  final double borderWidth;

  const CustomOutlinedButton({
    Key? key,
    required this.child,
    required this.size,
    required this.color,
    required this.overlayColor,
    required this.borderWidth,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      style: ButtonStyle(
        padding: MaterialStateProperty.all(EdgeInsets.zero),
        minimumSize: MaterialStateProperty.all(Size(size, size)),
        maximumSize: MaterialStateProperty.all(Size(size, size)),
        shape: MaterialStateProperty.all(const BeveledRectangleBorder()),
        side: MaterialStateProperty.all(
          BorderSide(
            color: color,
            width: borderWidth,
          ),
        ),
        overlayColor: MaterialStateProperty.resolveWith(
          (states) {
            return states.contains(MaterialState.pressed) ? overlayColor : null;
          },
        ),
      ),
      child: child,
      onPressed: () {
        // worth it?
      },
    );
  }
}
