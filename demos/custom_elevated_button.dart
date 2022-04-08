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
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: const <Widget>[
          CustomElevatedButton(
            size: 64.0,
            color: Colors.black87,
            overlayColor: Colors.black12,
            borderWidth: 4.0,
            child: Text(
              '+',
              style: TextStyle(
                color: Colors.black87,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          CustomElevatedButton(
            size: 64.0,
            color: Colors.black87,
            overlayColor: Colors.black12,
            borderWidth: 4.0,
            child: Icon(
              Icons.add,
              size: 64.0,
              color: Colors.black87,
            ),
          ),
        ],
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
    return ElevatedButton(
      style: ButtonStyle(
        padding: MaterialStateProperty.all(EdgeInsets.zero),
        minimumSize: MaterialStateProperty.all(Size(size, size)),
        maximumSize: MaterialStateProperty.all(Size(size, size)),
        backgroundColor: MaterialStateProperty.all(Colors.transparent),
        shadowColor: MaterialStateProperty.all(Colors.transparent),
        elevation: MaterialStateProperty.all(0.0),
        overlayColor: MaterialStateProperty.resolveWith(
          (states) {
            return states.contains(MaterialState.pressed) ? overlayColor : null;
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
        child: FittedBox(
          child: child,
        ),
      ),
      onPressed: () {
        // worth it?
      },
    );
  }
}
