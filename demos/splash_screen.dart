import 'package:flutter/material.dart';

void main() {
  runApp(const App());
}

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primaryColor: Colors.black87,
      ),
      home: const SplashScreen(text: 'ticker'),
    );
  }
}

class SplashScreen extends StatefulWidget {
  final String text;
  const SplashScreen({Key? key, this.text = 'Wheeeel!'}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  static const double _itemExtent = 200.0;

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
          duration: Duration(milliseconds: 320 * length),
          curve: Curves.easeInOutSine,
        )
            .then(
          (_) {
            print('Done');
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
                          child: Text(widget.text[index]),
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
