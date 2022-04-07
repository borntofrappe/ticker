import 'package:flutter/material.dart';
import 'package:ticker/widgets/squared_outlined_button.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:math';
import 'package:ticker/helpers/screen_arguments.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  static const int _count = 3;
  static const int _digits = 10;

  static const double _margin = 8.0;

  static const int _initialDuration = 2000;
  static const int _initialDelay = 250;
  static const int _scrollDuration = 125 * _count;

  late List<FixedExtentScrollController> _controllers;

  @override
  void initState() {
    super.initState();

    _controllers = List<FixedExtentScrollController>.generate(
        _count, (_) => FixedExtentScrollController());

    WidgetsBinding.instance?.addPostFrameCallback((_) {
      _optionallyGetValue();
    });
  }

  @override
  void dispose() {
    for (FixedExtentScrollController controller in _controllers) {
      controller.dispose();
    }

    super.dispose();
  }

  int _computeValue() {
    int value = 0;
    int index = _controllers.length - 1;

    while (index >= 0) {
      int digit = (_digits - _controllers[index].selectedItem) % _digits;
      value += digit * pow(10, _controllers.length - index - 1).toInt();

      index--;
    }
    return value;
  }

  void _optionallyGetValue() async {
    final instance = await SharedPreferences.getInstance();

    bool hasSharedPreferences = instance.getBool('shared-preferences') ?? false;
    if (hasSharedPreferences) {
      int value = instance.getInt('value') ?? 0;
      if (value > 0) {
        _scrollTo(value);
      }
    }
  }

  void _optionallyUpdateValue() async {
    final instance = await SharedPreferences.getInstance();

    bool hasSharedPreferences = instance.getBool('shared-preferences') ?? false;
    if (hasSharedPreferences) {
      instance.setInt('value', _computeValue());
    }
  }

  void _scrollTo(int value) {
    int duration = _initialDuration ~/ _controllers.length;
    int delay = _initialDelay;

    int index = _controllers.length - 1;

    while (value > 0 && index >= 0) {
      int digit = value % _digits;

      if (digit > 0) {
        FixedExtentScrollController controller = _controllers[index];
        controller.jumpToItem(_digits);

        Future.delayed(
          Duration(milliseconds: delay),
          () {
            controller.animateToItem(
              _digits - digit,
              duration: Duration(milliseconds: duration),
              curve: Curves.easeInOutQuad,
            );
          },
        );

        delay += duration - (duration ~/ _digits);
      }

      value = value ~/ _digits;
      index--;
    }
  }

  void _scroll(int direction) {
    direction *= -1;
    int duration = _scrollDuration ~/ _controllers.length;
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
        Duration(
          milliseconds: delay,
        ),
        () {
          controller.animateToItem(
            controller.selectedItem + 1 * direction,
            duration: Duration(milliseconds: duration),
            curve: Curves.decelerate,
          );
        },
      );

      delay += duration ~/ 3;
    } while (index > 0 &&
        ((direction == 1 && _controllers[index].selectedItem % _digits == 0) ||
            (direction == -1 && _controllers[index].selectedItem == 1)));

    Future.delayed(
      const Duration(
        milliseconds: _scrollDuration,
      ),
      () {
        _optionallyUpdateValue();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double itemExtent = min(200.0, (width - 2 * _margin * _count) / _count);
    double borderWidth = itemExtent * 0.04;
    double iconSize = Theme.of(context).iconTheme.size ?? 32.0;

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            ListTile(
              trailing: SquaredOutlinedButton(
                padding: const EdgeInsets.all(0.0),
                onPressed: () {
                  Navigator.pushNamed(
                    context,
                    '/settings',
                    arguments: ScreenArguments(
                      count: _count,
                      value: _computeValue(),
                    ),
                  );
                },
                size: iconSize,
                borderWidth: iconSize * 0.04,
                child: const Icon(
                  Icons.chevron_right,
                ),
              ),
            ),
            Expanded(
              flex: 3,
              child: Row(
                children: _controllers
                    .map(
                      (controller) => Expanded(
                        child: Container(
                          margin:
                              const EdgeInsets.symmetric(horizontal: _margin),
                          child: Wheel(
                            controller: controller,
                            count: _digits,
                            itemExtent: itemExtent,
                            borderWidth: borderWidth,
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
                      size:
                          Theme.of(context).textTheme.button?.fontSize ?? 64.0,
                      borderWidth: borderWidth / 2,
                      child: Text(
                        '-',
                        style: Theme.of(context).textTheme.button,
                      ),
                      onPressed: () {
                        _scroll(-1);
                      },
                    ),
                    SquaredOutlinedButton(
                      size:
                          Theme.of(context).textTheme.button?.fontSize ?? 64.0,
                      borderWidth: borderWidth / 2,
                      child: Text(
                        '+',
                        style: Theme.of(context).textTheme.button,
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
        ),
      ),
    );
  }
}

class Wheel extends StatelessWidget {
  final int count;
  final double itemExtent;
  final double borderWidth;
  final FixedExtentScrollController controller;

  const Wheel({
    Key? key,
    required this.count,
    required this.itemExtent,
    required this.borderWidth,
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
                borderWidth: borderWidth,
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
                    fontWeight: FontWeight.w700,
                    color: Theme.of(context).primaryColor,
                  ),
                )
              : null,
        ),
      ),
    );
  }
}
