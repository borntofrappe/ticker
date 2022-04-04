import 'package:flutter/material.dart';

PageRouteBuilder<dynamic> slideToRoute(Widget child) {
  return PageRouteBuilder(
    pageBuilder: (BuildContext context, Animation animation,
            Animation secondaryAnimation) =>
        child,
    transitionDuration: const Duration(
      milliseconds: 500,
    ),
    transitionsBuilder: (BuildContext context, Animation animation,
        Animation secondaryAnimation, Widget child) {
      Offset begin = const Offset(1.0, 0.0);
      Offset end = Offset.zero;
      Curve curve = Curves.decelerate;

      Animatable<Offset> animatable = Tween(
        begin: begin,
        end: end,
      ).chain(
        CurveTween(
          curve: curve,
        ),
      );

      return SlideTransition(
        position: animation.drive(animatable),
        child: child,
      );
    },
  );
}