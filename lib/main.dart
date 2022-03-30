import 'package:flutter/material.dart';

void main() {
  runApp(const App());
}

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: Scaffold(
        body: SafeArea(
          child: Ticker(),
        ),
      ),
    );
  }
}

const digits = 10;

class Ticker extends StatefulWidget {
  const Ticker({Key? key}) : super(key: key);

  @override
  State<Ticker> createState() => _TickerState();
}

class _TickerState extends State<Ticker> {
  late FixedExtentScrollController _controller;

  @override
  void initState() {
    super.initState();

    _controller = FixedExtentScrollController();
  }

  @override
  void dispose() {
    _controller.dispose();

    super.dispose();
  }

  void _scroll(int direction) {
    if(direction == -1 && _controller.selectedItem == 0) {
      _controller.jumpToItem(digits);
    } else if(direction == 1 && _controller.selectedItem == digits) {
      _controller.jumpToItem(0);
    }

    _controller.animateToItem(
        _controller.selectedItem + 1 * direction,
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeInOutSine
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: Center(
            child: ListWheelScrollView(
              controller: _controller,
              physics: const NeverScrollableScrollPhysics(),
              itemExtent: 200.0,
              children: List<Widget>.generate(
                digits + 1,
                    (index) => FittedBox(
                  child: Text(
                    (index % digits).toString(),
                  ),
                ),
              ),
            ),
          ),
        ),
        ConstrainedBox(
            constraints: const BoxConstraints(
              maxWidth: 480.0,
            ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              IconButton(
                onPressed: () => _scroll(-1),
                icon: const Icon(Icons.remove),
              ),
              IconButton(
                onPressed: () => _scroll(1),
                icon: const Icon(Icons.add),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
