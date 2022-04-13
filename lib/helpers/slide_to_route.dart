import 'package:flutter/material.dart';

PageRouteBuilder<dynamic> slideToRoute(Widget child, [int? slideDuration]) {
  const int _slideDurationDefault = 500;

  return PageRouteBuilder(
    pageBuilder: (BuildContext context, Animation animation,
            Animation secondaryAnimation) =>
        child,
    transitionDuration:
        Duration(milliseconds: slideDuration ?? _slideDurationDefault),
    transitionsBuilder: (BuildContext context, Animation animation,
        Animation secondaryAnimation, Widget child) {
      Offset begin = const Offset(1.0, 0.0);
      Offset end = Offset.zero;
      Curve curve = Curves.easeInOutCubic;

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
