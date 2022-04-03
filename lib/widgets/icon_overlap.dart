import 'package:flutter/material.dart';

class IconOverlap extends StatelessWidget {
  final Color backgroundColor;
  final Color foregroundColor;
  final IconData backgroundIcon;
  final IconData foregroundIcon;
  final double size;
  final double foregroundScale;

  const IconOverlap({
    Key? key,
    this.backgroundColor = Colors.black,
    this.foregroundColor = Colors.white,
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
            color: foregroundColor,
            size: size,
          ),
        )
      ],
    );
  }
}
