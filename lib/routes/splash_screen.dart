import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  final String text;

  const SplashScreen({
    Key? key,
    required this.text,
  }) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  static const double _itemExtent = 200.0;
  static const int _scrollDurationPerLetter = 320;

  late FixedExtentScrollController _controller;

  @override
  void initState() {
    super.initState();

    final int length = widget.text.length;

    _controller = FixedExtentScrollController();

    WidgetsBinding.instance!.addPostFrameCallback((_) {
      Future.delayed(const Duration(seconds: 1), () {
        _controller
            .animateToItem(
          length - 1,
          duration: Duration(milliseconds: _scrollDurationPerLetter * length),
          curve: Curves.easeInOutSine,
        )
            .then(
          (_) {
            Navigator.pushReplacementNamed(context, '/home');
          },
        );
      });
    });
  }

  @override
  void dispose() {
    _controller.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
                          width: 8.0,
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
