import 'package:flutter/material.dart';

class SquareFittedBox extends StatelessWidget {
  final Widget child;

  const SquareFittedBox({
    Key? key,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1,
      child: FittedBox(
        child: child,
      ),
    );
  }
}
