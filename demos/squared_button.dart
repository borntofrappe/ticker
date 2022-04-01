import 'package:flutter/material.dart';

void main() {
  runApp(const App());
}

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: SquaredButton(
            character: '+',
            size: 128.0,
            borderWidth: 8.0,
            onPressed: () {
              print('Do something');
            },
          ),
        ),
      ),
    );
  }
}

class SquaredButton extends StatefulWidget {
  final double size;
  final double borderWidth;
  final String character;
  final void Function()? onPressed;

  const SquaredButton({
    Key? key,
    this.size = 64.0,
    this.borderWidth = 4.0,
    required this.character,
    required this.onPressed,
  }) : super(key: key);

  @override
  State<SquaredButton> createState() => _SquaredButtonState();
}

class _SquaredButtonState extends State<SquaredButton> {
  @override
  Widget build(BuildContext context) {
    final String character = widget.character;
    final double size = widget.size;
    final double borderWidth = widget.borderWidth;
    final void Function()? onPressed = widget.onPressed;

    return Material(
      shape: const BeveledRectangleBorder(),
      child: Ink(
        child: SizedBox(
          width: size,
          height: size,
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(width: borderWidth, color: Colors.black87),
            ),
            child: TextButton(
              style: TextButton.styleFrom(
                primary: Colors.black,
              ),
              child: FittedBox(
                child: Text(
                  character,
                  style: TextStyle(
                    color: Colors.black87,
                    fontSize: size,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              onPressed: onPressed,
            ),
          ),
        ),
      ),
    );
  }
}
