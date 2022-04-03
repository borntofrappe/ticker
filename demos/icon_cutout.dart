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
        backgroundColor: Colors.red[200],
        body: const Center(
          child: IconCutout(icon: Icons.chevron_right),
        ),
      ),
    );
  }
}

class IconCutout extends StatelessWidget {
  final IconData icon;
  final double size;
  final Color color;

  const IconCutout({
    Key? key,
    required this.icon,
    this.size = 42.0,
    this.color = Colors.black,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      blendMode: BlendMode.srcOut,
      shaderCallback: (bounds) =>
          LinearGradient(colors: [color, color]).createShader(bounds),
      child: Icon(
        icon,
        size: size,
      ),
    );
  }
}
