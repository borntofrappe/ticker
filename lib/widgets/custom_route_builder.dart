import 'package:flutter/material.dart';

class CustomRouteBuilder extends PageRouteBuilder {
  final Widget child;

  CustomRouteBuilder({required this.child})
      : super(
          pageBuilder: (BuildContext context, Animation animation,
                  Animation secondaryAnimation) =>
              child,
          transitionDuration: const Duration(milliseconds: 400),
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
