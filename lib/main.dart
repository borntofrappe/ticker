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
  final int columns;
  const Ticker({
    Key? key,
    this.columns = 3,
  }) : super(key: key);

  @override
  State<Ticker> createState() => _TickerState();
}

class _TickerState extends State<Ticker> {
  late List<FixedExtentScrollController> _controllers;

  @override
  void initState() {
    super.initState();

    _controllers = List<FixedExtentScrollController>.generate(
        widget.columns, (_) => FixedExtentScrollController());
  }

  @override
  void dispose() {
    for (FixedExtentScrollController controller in _controllers) {
      controller.dispose();
    }

    super.dispose();
  }

  void _scroll(int direction) {
    direction *= -1;

    int index = _controllers.length;

    do {
      index -= 1;

      FixedExtentScrollController controller = _controllers[index];

      if (direction == -1 && controller.selectedItem == 0) {
        controller.jumpToItem(digits);
      } else if (direction == 1 && controller.selectedItem == digits) {
        controller.jumpToItem(0);
      }

      controller.animateToItem(controller.selectedItem + 1 * direction,
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeInOutSine);
    } while (index > 0 &&
        ((direction == 1 && _controllers[index].selectedItem % digits == 0) ||
            (direction == -1 && _controllers[index].selectedItem == 1)));
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: Row(
            children: _controllers
                .map((controller) => Expanded(
                      child: Center(
                        child: ListWheelScrollView(
                          controller: controller,
                          physics: const NeverScrollableScrollPhysics(),
                          itemExtent: 200.0,
                          children: List<Widget>.generate(
                            digits + 1,
                            (index) => FittedBox(
                              child: Text(
                                (index % digits).toString(),
                              ),
                            ),
                          ).reversed.toList(),
                        ),
                      ),
                    ))
                .toList(),
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
