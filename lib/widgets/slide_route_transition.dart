import 'package:flutter/material.dart';

class SlideRouteTransition extends PageRouteBuilder {
  final Widget child;

  SlideRouteTransition({required this.child})
      : super(
            transitionDuration: const Duration(milliseconds: 250),
            pageBuilder: (BuildContext context, Animation animation,
                    Animation secondaryAnimation) =>
                child);

  @override
  Widget buildTransitions(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation, Widget child) {
    return SlideTransition(
      position: Tween<Offset>(
        begin: const Offset(1.0, 0.0),
        end: Offset.zero,
      ).animate(animation),
      child: child,
    );
  }
}
