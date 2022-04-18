import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';

import 'package:ticker/helpers/screen_arguments.dart';

import 'package:ticker/widgets/square_fitted_box.dart';
import 'package:ticker/widgets/box_decorations.dart';

import 'package:ticker/helpers/theme_data_change_notifier.dart';

class SplashScreen extends StatefulWidget {
  final String text;
  final BuildContext context;

  const SplashScreen({
    required this.text,
    required this.context,
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
    await Provider.of<ThemeDataChangeNotifier>(widget.context, listen: false)
        .retrieveIndexTheme();

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

    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Stack(
          alignment: AlignmentDirectional.center,
          children: [
            const RoundedBackground(
              size: itemExtent,
              color: Colors.white,
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
                      child: SquareFittedBox(
                        child: index == 0
                            ? const Icon(
                                Icons.chevron_right_rounded,
                                color: Colors.black87,
                              )
                            : Text(
                                widget.text[index - 1],
                                style: const TextStyle(
                                  color: Colors.black87,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                      ),
                    );
                  },
                ),
              ),
            ),
            const RoundedBorder(
              size: itemExtent,
              color: Colors.black87,
            ),
          ],
        ),
      ),
    );
  }
}
