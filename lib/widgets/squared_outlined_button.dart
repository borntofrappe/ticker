import 'package:flutter/material.dart';

class SquaredOutlinedButton extends StatelessWidget {
  final double size;
  final Widget child;
  final void Function() onPressed;
  final EdgeInsetsGeometry? padding;

  const SquaredOutlinedButton({
    Key? key,
    required this.size,
    required this.child,
    required this.onPressed,
    this.padding,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: AspectRatio(
        aspectRatio: 1.0,
        child: OutlinedButton(
          style: OutlinedButton.styleFrom(
            padding: padding,
            primary: Theme.of(context).primaryColor,
            shape: const BeveledRectangleBorder(),
            side: BorderSide(
              color: Theme.of(context).primaryColor,
              width: size * 0.04,
            ),
          ),
          onPressed: onPressed,
          child: FittedBox(
            child: child,
          ),
        ),
      ),
    );
  }
}
