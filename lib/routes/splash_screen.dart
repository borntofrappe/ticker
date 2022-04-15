import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:ticker/helpers/screen_arguments.dart';

class SplashScreen extends StatefulWidget {
  final String text;
  const SplashScreen({
    required this.text,
    Key? key,
  }) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  static const int _scrollDurationPerItem = 350;
  static const int _scrollDelay = 1000;

  late FixedExtentScrollController _controller;

  void _goToHomeRoute() async {
    final preferences = await SharedPreferences.getInstance();
    bool forgetMeNot = preferences.getBool('forget-me-not') ?? false;

    int count = preferences.getInt('count') ?? 3;
    int scrollValue = forgetMeNot ? preferences.getInt('scroll-value') ?? 0 : 0;

    Navigator.pushReplacementNamed(
      context,
      '/home',
      arguments: ScreenArguments(
        count: count,
        scrollValue: scrollValue,
      ),
    );
  }

  void _handleSplashAnimation() async {
    final preferences = await SharedPreferences.getInstance();

    final bool shortOnTime = preferences.getBool('short-on-time') ?? false;

    Future.delayed(
      const Duration(milliseconds: _scrollDelay),
      () {
        if (shortOnTime) {
          _goToHomeRoute();
        } else {
          final int length = widget.text.length;

          _controller
              .animateToItem(
            length, // there's one more item than there are words, so you are not off by one
            duration: Duration(milliseconds: _scrollDurationPerItem * length),
            curve: Curves.easeInOutQuad,
          )
              .then(
            (_) {
              _goToHomeRoute();
            },
          );
        }
      },
    );
  }

  @override
  void initState() {
    super.initState();

    _controller = FixedExtentScrollController();

    WidgetsBinding.instance!.addPostFrameCallback(
      (_) {
        _handleSplashAnimation();
      },
    );
  }

  @override
  void dispose() {
    _controller.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const double itemExtent = 200.0;
    const double borderWidth = itemExtent / 20;
    const double borderRadius = itemExtent / 6;

    return Scaffold(
      body: Center(
        child: Stack(
          children: [
            ExcludeSemantics(
              child: ListWheelScrollView(
                physics: const NeverScrollableScrollPhysics(),
                itemExtent: itemExtent,
                children: <Widget>[
                  AspectRatio(
                    aspectRatio: 1.0,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.background,
                        borderRadius: const BorderRadius.all(
                          Radius.circular(borderRadius),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            RotatedBox(
              quarterTurns: -1,
              child: ListWheelScrollView.useDelegate(
                overAndUnderCenterOpacity: 0.0,
                physics: const NeverScrollableScrollPhysics(),
                controller: _controller,
                itemExtent: itemExtent,
                childDelegate: ListWheelChildBuilderDelegate(
                  childCount: widget.text.length + 1,
                  builder: (BuildContext context, int index) {
                    return RotatedBox(
                      quarterTurns: 1,
                      child: AspectRatio(
                        aspectRatio: 1.0,
                        child: FittedBox(
                          child: index == 0
                              ? Icon(
                                  Icons.chevron_right_rounded,
                                  color: Theme.of(context).colorScheme.primary,
                                )
                              : Text(
                                  widget.text[index - 1],
                                  style: TextStyle(
                                    color:
                                        Theme.of(context).colorScheme.primary,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
            ExcludeSemantics(
              child: ListWheelScrollView(
                physics: const NeverScrollableScrollPhysics(),
                itemExtent: itemExtent,
                children: <Widget>[
                  AspectRatio(
                    aspectRatio: 1.0,
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Theme.of(context).colorScheme.primary,
                          width: borderWidth,
                        ),
                        borderRadius: const BorderRadius.all(
                          Radius.circular(borderRadius),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
