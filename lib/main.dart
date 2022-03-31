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
  final int count;
  const Ticker({
    Key? key,
    this.columns = 3,
    this.count = 0,
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

    WidgetsBinding.instance?.addPostFrameCallback((_) {
      int duration = 2000 ~/ _controllers.length;
      int delay = 250;

      int count = widget.count;
      int index = _controllers.length - 1;
      while (count > 0 && index >= 0) {
        int digit = count % digits;

        if (digit > 0) {
          FixedExtentScrollController controller = _controllers[index];
          controller.jumpToItem(digits);

          controller.jumpToItem(digits);

          Future.delayed(
              Duration(milliseconds: delay),
              () => controller.animateToItem(
                    digits - digit,
                    duration: Duration(milliseconds: duration),
                    curve: Curves.easeInOutSine,
                  ));

          delay += duration - (duration ~/ digits);
        }

        count = count ~/ digits;
        index--;
      }
    });
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

    int duration = 600 ~/ _controllers.length;
    int delay = 0;

    int index = _controllers.length;

    do {
      index -= 1;

      FixedExtentScrollController controller = _controllers[index];

      if (direction == -1 && controller.selectedItem == 0) {
        controller.jumpToItem(digits);
      } else if (direction == 1 && controller.selectedItem == digits) {
        controller.jumpToItem(0);
      }

      Future.delayed(
        Duration(milliseconds: delay),
        () => controller.animateToItem(
          controller.selectedItem + 1 * direction,
          duration: Duration(milliseconds: duration),
          curve: Curves.easeInOutSine,
        ),
      );

      delay += duration ~/ 3;
    } while (index > 0 &&
        ((direction == 1 && _controllers[index].selectedItem % digits == 0) ||
            (direction == -1 && _controllers[index].selectedItem == 1)));
  }

  @override
  Widget build(BuildContext context) {
    const double itemExtent = 200.0;
    const double padding = 8.0;
    const Color boxStroke = Color(0xff343434);
    const Color boxFill = Color(0xffefefef);
    const Color textFill = Color(0xff343434);

    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(
          maxHeight: 520.0,
        ),
        child: Column(
          children: [
            Expanded(
              flex: 7,
              child: Row(
                children: _controllers
                    .map(
                      (controller) => Expanded(
                        child: Container(
                          margin: const EdgeInsets.symmetric(horizontal: 12.0),
                          child: Stack(
                            children: <Widget>[
                              Center(
                                child: ListWheelScrollView(
                                  overAndUnderCenterOpacity: 0,
                                  controller: controller,
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemExtent: itemExtent,
                                  children: List<Widget>.generate(
                                    digits + 1,
                                    (index) => Container(
                                      decoration: const BoxDecoration(
                                        color: boxFill,
                                      ),
                                      child: FittedBox(
                                        fit: BoxFit.cover,
                                        child: Padding(
                                          padding:
                                              const EdgeInsets.all(padding),
                                          child: Text(
                                            (index % digits).toString(),
                                            style: const TextStyle(
                                              fontFamily: 'Inter',
                                              fontWeight: FontWeight.w700,
                                              color: textFill,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ).reversed.toList(),
                                ),
                              ),
                              ExcludeSemantics(
                                child: Center(
                                  child: ListWheelScrollView(
                                    itemExtent: itemExtent,
                                    children: <Widget>[
                                      Container(
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                            width: 8.0,
                                            color: boxFill,
                                          ),
                                        ),
                                        child: const FittedBox(
                                          fit: BoxFit.cover,
                                          child: Opacity(
                                            opacity: 0,
                                            child: Padding(
                                              padding: EdgeInsets.all(padding),
                                              child: Text('0'),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    )
                    .toList(),
              ),
            ),
            Expanded(
              flex: 3,
              child: ConstrainedBox(
                constraints: const BoxConstraints(
                  maxWidth: 480.0,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: boxFill,
                        border: Border.all(
                          width: 6.0,
                          color: boxStroke,
                        ),
                      ),
                      child: Material(
                        child: Ink(
                          decoration: const ShapeDecoration(
                            shape: BeveledRectangleBorder(),
                            color: boxFill,
                          ),
                          child: IconButton(
                            iconSize: 48.0,
                            onPressed: () => _scroll(-1),
                            icon: const Icon(
                              Icons.remove,
                              color: textFill,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(
                          width: 6.0,
                          color: boxStroke,
                        ),
                      ),
                      child: Material(
                        child: Ink(
                          decoration: const ShapeDecoration(
                            shape: BeveledRectangleBorder(),
                            color: boxFill,
                          ),
                          child: IconButton(
                            iconSize: 48.0,
                            onPressed: () => _scroll(1),
                            icon: const Icon(
                              Icons.add,
                              color: textFill,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
