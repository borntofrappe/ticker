import 'package:flutter/material.dart';

const double _borderRadiusRatio = 1 / 6;
const double _borderWidthRatio = 1 / 20;

class RoundedBackground extends StatelessWidget {
  final double size;
  final Color? color;

  const RoundedBackground({
    Key? key,
    required this.size,
    this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: color ?? Theme.of(context).colorScheme.background,
        borderRadius: BorderRadius.all(
          Radius.circular(size * _borderRadiusRatio),
        ),
      ),
      width: size,
      height: size,
    );
  }
}

class RoundedBorder extends StatelessWidget {
  final double size;
  final Color? color;

  const RoundedBorder({
    Key? key,
    required this.size,
    this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          width: size * _borderWidthRatio,
          color: color ?? Theme.of(context).colorScheme.primary,
        ),
        borderRadius: BorderRadius.all(
          Radius.circular(size * _borderRadiusRatio),
        ),
      ),
      width: size,
      height: size,
    );
  }
}
