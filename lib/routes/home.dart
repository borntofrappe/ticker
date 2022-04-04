import 'package:flutter/material.dart';
import 'package:ticker/widgets/squared_outlined_button.dart';
import 'dart:math';
import 'dart:ui';

class Home extends StatelessWidget {
  const Home({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            ListTile(
              trailing: SquaredOutlinedButton(
                padding: const EdgeInsets.all(0.0),
                onPressed: () {
                  Navigator.pushNamed(context, '/settings');
                },
                size: 32.0,
                child: Icon(
                  Icons.chevron_right,
                  color: Theme.of(context).primaryColor,
                  size: 32.0,
                ),
              ),
            ),
            const Expanded(
              child: Wheels(),
            ),
          ],
        ),
      ),
    );
  }
}

class Wheels extends StatefulWidget {
  final int count;
  const Wheels({
    Key? key,
    this.count = 3,
  }) : super(key: key);

  @override
  State<Wheels> createState() => _WheelsState();
}

class _WheelsState extends State<Wheels> {
  static const int _digits = 10;
  static const double _margin = 8.0;

  late List<FixedExtentScrollController> _controllers;

  @override
  void initState() {
    super.initState();

    _controllers = List<FixedExtentScrollController>.generate(
        widget.count, (_) => FixedExtentScrollController());
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

    int duration = 500 ~/ _controllers.length;
    int delay = 0;

    int index = _controllers.length;

    do {
      index -= 1;

      FixedExtentScrollController controller = _controllers[index];

      if (direction == -1 && controller.selectedItem == 0) {
        controller.jumpToItem(_digits);
      } else if (direction == 1 && controller.selectedItem == _digits) {
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
        ((direction == 1 && _controllers[index].selectedItem % _digits == 0) ||
            (direction == -1 && _controllers[index].selectedItem == 1)));
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double itemExtent =
        min(200.0, (width - 2 * _margin * widget.count) / widget.count);

    return Column(
      children: [
        Expanded(
          flex: 3,
          child: Row(
            children: _controllers
                .map(
                  (controller) => Expanded(
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: _margin),
                      child: Wheel(
                        controller: controller,
                        count: _digits,
                        itemExtent: itemExtent,
                      ),
                    ),
                  ),
                )
                .toList(),
          ),
        ),
        Expanded(
          flex: 2,
          child: ConstrainedBox(
            constraints: const BoxConstraints(
              maxWidth: 480.0,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                SquaredOutlinedButton(
                  size: 64.0,
                  child: Text(
                    '-',
                    style: TextStyle(
                      color: Theme.of(context).primaryColor,
                      fontSize: 64.0,
                      fontWeight: FontWeight.w700,
                      fontFamily: 'Inter',
                      fontFeatures: const [
                        FontFeature.caseSensitiveForms(),
                      ],
                    ),
                  ),
                  onPressed: () {
                    _scroll(-1);
                  },
                ),
                SquaredOutlinedButton(
                  size: 64.0,
                  child: Text(
                    '+',
                    style: TextStyle(
                      color: Theme.of(context).primaryColor,
                      fontSize: 64.0,
                      fontWeight: FontWeight.w700,
                      fontFamily: 'Inter',
                      fontFeatures: const [
                        FontFeature.caseSensitiveForms(),
                      ],
                    ),
                  ),
                  onPressed: () {
                    _scroll(1);
                  },
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class Wheel extends StatelessWidget {
  final int count;
  final double itemExtent;
  final FixedExtentScrollController controller;

  const Wheel({
    Key? key,
    required this.count,
    required this.itemExtent,
    required this.controller,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Stack(
        children: [
          ListWheelScrollView(
            controller: controller,
            overAndUnderCenterOpacity: 0.0,
            itemExtent: itemExtent,
            children: List<Widget>.generate(
              count + 1,
              (index) => Item(
                digit: index % count,
              ),
            ).reversed.toList(),
          ),
          ListWheelScrollView(
            itemExtent: itemExtent,
            children: <Widget>[
              Item(
                borderWidth: itemExtent * 0.04,
              ),
            ],
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
                  style: TextStyle(
                    color: Theme.of(context).primaryColor,
                    fontWeight: FontWeight.w700,
                    fontFamily: 'Inter',
                  ),
                )
              : null,
        ),
      ),
    );
  }
}
