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
  static const double _itemExtent = 200.0;
  static const int _scrollDurationPerLetter = 320;
  static const int _scrollDelay = 1000;

  late FixedExtentScrollController _controller;

  void _goToHomeRoute() async {
    final preferences = await SharedPreferences.getInstance();
    bool forgetMeNot = preferences.getBool('forget-me-not') ?? false;
    int scrollValue = forgetMeNot ? preferences.getInt('scroll-value') ?? 0 : 0;

    Navigator.pushReplacementNamed(
      context,
      '/home',
      arguments: ScreenArguments(
        scrollValue: scrollValue,
      ),
    );
  }

  void _handleSplashAnimation() async {
    final preferences = await SharedPreferences.getInstance();

    final bool shortOnTime = preferences.getBool('short-on-time') ?? false;

    if (shortOnTime) {
      Future.delayed(
        const Duration(milliseconds: _scrollDelay),
        () {
          _goToHomeRoute();
        },
      );
    } else {
      final int length = widget.text.length;

      Future.delayed(
        const Duration(milliseconds: _scrollDelay),
        () {
          _controller
              .animateToItem(
            length - 1,
            duration: Duration(milliseconds: _scrollDurationPerLetter * length),
            curve: Curves.easeInOutSine,
          )
              .then(
            (_) {
              _goToHomeRoute();
            },
          );
        },
      );
    }
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
    const double borderWidth = 8.0;

    return Scaffold(
      body: Center(
        child: Stack(
          children: [
            RotatedBox(
              quarterTurns: -1,
              child: ListWheelScrollView.useDelegate(
                overAndUnderCenterOpacity: 0.0,
                physics: const NeverScrollableScrollPhysics(),
                controller: _controller,
                itemExtent: _itemExtent,
                childDelegate: ListWheelChildBuilderDelegate(
                  childCount: widget.text.length,
                  builder: (BuildContext context, int index) {
                    return RotatedBox(
                      quarterTurns: 1,
                      child: AspectRatio(
                        aspectRatio: 1.0,
                        child: FittedBox(
                          child: Text(
                            widget.text[index],
                            style: const TextStyle(
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
                itemExtent: _itemExtent,
                children: <Widget>[
                  AspectRatio(
                    aspectRatio: 1.0,
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(
                          width: borderWidth,
                          color: Theme.of(context).primaryColor,
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
