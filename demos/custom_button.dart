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
      body: SafeArea(
        child: Column(
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: const <Widget>[
                Text('Outlined button with text'),
                CustomOutlinedButton(
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
                  size: 64.0,
                  color: Colors.black87,
                  overlayColor: Colors.black12,
                  borderWidth: 2.0,
                ),
              ],
            ),
            const SizedBox(height: 8.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: const <Widget>[
                Text('Outlined button with icon'),
                CustomOutlinedButton(
                  child: Icon(
                    Icons.chevron_right,
                    size: 32.0,
                    color: Colors.black87,
                  ),
                  size: 32.0,
                  color: Colors.black87,
                  overlayColor: Colors.black12,
                  borderWidth: 1.0,
                ),
              ],
            ),
            const SizedBox(height: 32.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: const <Widget>[
                Text('Elevated button with text'),
                CustomElevatedButton(
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
                  size: 64.0,
                  color: Colors.black87,
                  overlayColor: Colors.black12,
                  borderWidth: 2.0,
                ),
              ],
            ),
            const SizedBox(height: 8.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: const <Widget>[
                Text('Elevated button with icon'),
                CustomElevatedButton(
                  child: AspectRatio(
                    aspectRatio: 1.0,
                    child: FittedBox(
                      child: Icon(
                        Icons.chevron_right,
                        size: 32.0,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                  size: 32.0,
                  color: Colors.black87,
                  overlayColor: Colors.black12,
                  borderWidth: 1.0,
                ),
              ],
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
    return SizedBox(
      width: size,
      height: size,
      child: OutlinedButton(
        style: ButtonStyle(
          padding: MaterialStateProperty.all(EdgeInsets.zero),
          shape: MaterialStateProperty.all(const BeveledRectangleBorder()),
          side: MaterialStateProperty.all(
            BorderSide(
              color: color,
              width: borderWidth,
            ),
          ),
          overlayColor: MaterialStateProperty.resolveWith(
            (states) {
              return states.contains(MaterialState.pressed)
                  ? overlayColor
                  : null;
            },
          ),
        ),
        child: child,
        onPressed: () {
          // worth it?
        },
      ),
    );
  }
}

class CustomElevatedButton extends StatelessWidget {
  final Widget child;
  final double size;
  final Color color;
  final Color overlayColor;
  final double borderWidth;

  const CustomElevatedButton({
    Key? key,
    required this.child,
    required this.size,
    required this.color,
    required this.overlayColor,
    required this.borderWidth,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: ElevatedButton(
        style: ButtonStyle(
          padding: MaterialStateProperty.all(EdgeInsets.zero),
          backgroundColor: MaterialStateProperty.all(Colors.transparent),
          shadowColor: MaterialStateProperty.all(Colors.transparent),
          elevation: MaterialStateProperty.all(0.0),
          overlayColor: MaterialStateProperty.resolveWith(
            (states) {
              return states.contains(MaterialState.pressed)
                  ? overlayColor
                  : null;
            },
          ),
        ),
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(
              color: color,
              width: borderWidth,
            ),
          ),
          width: size,
          height: size,
          child: child,
        ),
        onPressed: () {
          // worth it?
        },
      ),
    );
  }
}
