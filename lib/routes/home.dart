import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:ticker/widgets/custom_button.dart';

import 'dart:math';
import 'dart:ui';

const int _digits = 10;

class WheelsChangeNotifier extends ChangeNotifier {
  List<FixedExtentScrollController> _controllers = [];

  void initialize(List<FixedExtentScrollController> controllers) {
    _controllers = [];
    for (FixedExtentScrollController controller in controllers) {
      _controllers.add(controller);
    }
  }

  void scroll(int direction) {
    int duration = 400 ~/ _controllers.length;
    int delay = 0;

    direction *= -1;

    int index = _controllers.length;

    do {
      index -= 1;

      FixedExtentScrollController controller = _controllers[index];
      int selectedItem = controller.selectedItem;

      if (direction == -1 && selectedItem == 0) {
        controller.jumpToItem(_digits);
      } else if (direction == 1 && selectedItem == _digits) {
        controller.jumpToItem(0);
      }

      Future.delayed(
        Duration(milliseconds: delay),
        () {
          controller.animateToItem(
            controller.selectedItem + 1 * direction,
            duration: Duration(milliseconds: duration),
            curve: Curves.easeInOutQuad,
          );
        },
      );

      delay += duration ~/ 3;
    } while (index > 0 &&
        ((direction == 1 && _controllers[index].selectedItem % _digits == 0) ||
            (direction == -1 && _controllers[index].selectedItem == 1)));
  }
}

class Home extends StatelessWidget {
  const Home({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const Navigation(),
            Expanded(
              child: ChangeNotifierProvider(
                create: (_) => WheelsChangeNotifier(),
                child: Column(
                  children: const <Widget>[
                    Expanded(
                      flex: 3,
                      child: Wheels(),
                    ),
                    Expanded(
                      flex: 2,
                      child: Buttons(),
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

class Navigation extends StatelessWidget {
  const Navigation({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      trailing: CustomButton(
        onPressed: () {
          Navigator.pushNamed(context, '/settings');
        },
        child: const Icon(
          Icons.chevron_right,
          size: 32.0,
          color: Colors.black87,
        ),
        size: 32.0,
        color: Colors.black87,
        overlayColor: Colors.black12,
        borderWidth: 1.0,
      ),
    );
  }
}

class Wheels extends StatefulWidget {
  final int count;
  final int value;

  const Wheels({
    Key? key,
    this.count = 3,
    this.value = 0,
  }) : super(key: key);

  @override
  State<Wheels> createState() => _WheelsState();
}

class _WheelsState extends State<Wheels> {
  List<FixedExtentScrollController> _controllers = [];

  @override
  void initState() {
    super.initState();

    _controllers = List<FixedExtentScrollController>.generate(
      widget.count,
      (_) => FixedExtentScrollController(),
    );

    WidgetsBinding.instance?.addPostFrameCallback(
      (_) {
        int value = widget.value;
        if (value > 0) {
          Future.delayed(
            const Duration(seconds: 1),
            () {
              _scrollTo(widget.value);
            },
          );
        }
      },
    );
  }

  @override
  void dispose() {
    for (FixedExtentScrollController controller in _controllers) {
      controller.dispose();
    }

    super.dispose();
  }

  void _scrollTo(value) {
    int duration = 2000 ~/ _controllers.length;
    int delay = 0;

    int index = _controllers.length - 1;

    while (value > 0 && index >= 0) {
      int digit = value % _digits;

      FixedExtentScrollController controller = _controllers[index];

      controller.jumpToItem(_digits);

      Future.delayed(
        Duration(milliseconds: delay),
        () {
          controller.animateToItem(
            _digits - digit,
            duration: Duration(milliseconds: duration),
            curve: Curves.easeInOutCubic,
          );
        },
      );

      delay += duration - (duration ~/ 2);

      value = value ~/ _digits;
      index--;
    }
  }

  @override
  Widget build(BuildContext context) {
    const double margin = 4.0;

    Provider.of<WheelsChangeNotifier>(context, listen: false)
        .initialize(_controllers);

    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        double width = constraints.maxWidth;
        double height = constraints.maxHeight;
        double itemExtent = min(
            200.0,
            (min(width, height) - 2 * margin * _controllers.length) /
                _controllers.length);

        double maxWidth = (itemExtent + margin * 2) * _controllers.length;

        return Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: maxWidth,
            ),
            child: Row(
              children: _controllers
                  .map(
                    (controller) => Expanded(
                      child: Container(
                        margin: const EdgeInsets.symmetric(horizontal: margin),
                        child: Wheel(
                          itemExtent: itemExtent,
                          controller: controller,
                        ),
                      ),
                    ),
                  )
                  .toList(),
            ),
          ),
        );
      },
    );
  }
}

class Wheel extends StatelessWidget {
  final double itemExtent;
  final FixedExtentScrollController controller;

  const Wheel({
    Key? key,
    required this.itemExtent,
    required this.controller,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Stack(
        children: [
          ListWheelScrollView(
            overAndUnderCenterOpacity: 0,
            physics: const NeverScrollableScrollPhysics(),
            controller: controller,
            itemExtent: itemExtent,
            children: List<Widget>.generate(
              _digits + 1,
              (index) => Item(
                digit: index % _digits,
              ),
            ).reversed.toList(),
          ),
          ExcludeSemantics(
            child: ListWheelScrollView(
              itemExtent: itemExtent,
              children: <Widget>[
                Item(
                  borderWidth: itemExtent * 0.04,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class Item extends StatelessWidget {
  final int? digit;
  final double? borderWidth;

  const Item({
    Key? key,
    this.digit,
    this.borderWidth,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1,
      child: Container(
        decoration: borderWidth != null
            ? BoxDecoration(
                border: Border.all(
                  width: borderWidth ?? 0,
                  color: Theme.of(context).primaryColor,
                ),
              )
            : null,
        child: FittedBox(
          child: digit != null
              ? Text(
                  '$digit',
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                  ),
                )
              : null,
        ),
      ),
    );
  }
}

class Buttons extends StatelessWidget {
  const Buttons({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(
        maxWidth: 480.0,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          CustomButton(
            onPressed: () {
              Provider.of<WheelsChangeNotifier>(context, listen: false)
                  .scroll(-1);
            },
            child: const AspectRatio(
              aspectRatio: 1.0,
              child: FittedBox(
                child: Text(
                  '-',
                  style: TextStyle(
                    color: Colors.black87,
                    fontWeight: FontWeight.bold,
                    fontFeatures: [
                      FontFeature.caseSensitiveForms(),
                    ],
                  ),
                ),
              ),
            ),
            size: 64.0,
            color: Colors.black87,
            overlayColor: Colors.black12,
            borderWidth: 2.0,
          ),
          CustomButton(
            onPressed: () {
              Provider.of<WheelsChangeNotifier>(context, listen: false)
                  .scroll(1);
            },
            child: const AspectRatio(
              aspectRatio: 1.0,
              child: FittedBox(
                child: Text(
                  '+',
                  style: TextStyle(
                    color: Colors.black87,
                    fontWeight: FontWeight.bold,
                    fontFeatures: [
                      FontFeature.caseSensitiveForms(),
                    ],
                  ),
                ),
              ),
            ),
            size: 64.0,
            color: Colors.black87,
            overlayColor: Colors.black12,
            borderWidth: 2.0,
          ),
        ],
      ),
    );
  }
}
