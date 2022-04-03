import 'package:flutter/material.dart';

void main() {
  runApp(const App());
}

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: Scaffold(
        body: Center(
          child: IconOverlap(),
        ),
      ),
    );
  }
}

class IconOverlap extends StatelessWidget {
  final Color backgroundColor;
  final Color foreGroundColor;
  final IconData backgroundIcon;
  final IconData foregroundIcon;
  final double size;
  final double foregroundScale;

  const IconOverlap({
    Key? key,
    this.backgroundColor = Colors.black,
    this.foreGroundColor = Colors.white,
    this.backgroundIcon = Icons.square,
    this.foregroundIcon = Icons.chevron_right,
    this.size = 42.0,
    this.foregroundScale = 1,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Icon(
          backgroundIcon,
          color: backgroundColor,
          size: size,
        ),
        Transform.scale(
          scale: foregroundScale,
          child: Icon(
            foregroundIcon,
            color: foreGroundColor,
            size: size,
          ),
        )
      ],
    );
  }
}
