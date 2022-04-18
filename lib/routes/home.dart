import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:ticker/widgets/custom_button.dart';
import 'package:ticker/widgets/square_fitted_box.dart';
import 'package:ticker/widgets/box_decorations.dart';

import 'package:ticker/helpers/screen_arguments.dart';

import 'dart:math';
import 'dart:ui';

const int _digits = 10;
const double _borderRadiusRatio = 1 / 6;

class HomeChangeNotifier extends ChangeNotifier {
  bool _forgetMeNot = false;
  List<FixedExtentScrollController> _controllers = [];

  void init(List<FixedExtentScrollController> controllers) async {
    _controllers = [];
    for (FixedExtentScrollController controller in controllers) {
      _controllers.add(controller);
    }

    final preferences = await SharedPreferences.getInstance();
    _forgetMeNot = preferences.getBool('forget-me-not') ?? false;
  }

  void scroll(int direction) {
    int scrollDurationPerItem = 150;
    int scrollDelay = 0;
    int saveScrollValueDelay = 0;

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
        Duration(milliseconds: scrollDelay),
        () {
          controller.animateToItem(
            controller.selectedItem + 1 * direction,
            duration: Duration(milliseconds: scrollDurationPerItem),
            curve: Curves.easeInOutQuad,
          );
        },
      );

      scrollDelay += scrollDurationPerItem ~/ 3;
      saveScrollValueDelay += scrollDurationPerItem;
    } while (index > 0 &&
        ((direction == 1 && _controllers[index].selectedItem % _digits == 0) ||
            (direction == -1 && _controllers[index].selectedItem == 1)));

    if (_forgetMeNot) {
      Future.delayed(
        Duration(milliseconds: saveScrollValueDelay),
        () {
          saveScrollValue();
        },
      );
    }
  }

  void scrollWheel(int index, [int direction = -1]) {
    int scrollDuration = 150;
    int saveScrollValueDelay = scrollDuration;

    FixedExtentScrollController controller = _controllers[index];
    int selectedItem = controller.selectedItem;

    if (direction == -1 && selectedItem == 0) {
      controller.jumpToItem(_digits);
    } else if (direction == 1 && selectedItem == _digits) {
      controller.jumpToItem(0);
    }

    controller.animateToItem(
      controller.selectedItem + 1 * direction,
      duration: Duration(milliseconds: scrollDuration),
      curve: Curves.easeInOutQuad,
    );

    if (_forgetMeNot) {
      Future.delayed(
        Duration(milliseconds: saveScrollValueDelay),
        () {
          saveScrollValue();
        },
      );
    }
  }

  void saveScrollValue() async {
    final preferences = await SharedPreferences.getInstance();

    preferences.setInt(
      'scroll-value',
      getScrollValue(),
    );
  }

  int getScrollValue() {
    int value = 0;
    int index = _controllers.length - 1;

    while (index >= 0) {
      int digit = (_digits - _controllers[index].selectedItem) % _digits;
      value += digit * pow(10, _controllers.length - index - 1).toInt();

      index--;
    }
    return value;
  }

  int getCount() {
    return _controllers.length;
  }

  void setSavingPreference(forgetMeNot) {
    _forgetMeNot = forgetMeNot;
  }
}

class Home extends StatelessWidget {
  final int count;
  final int scrollValue;

  const Home({
    Key? key,
    required this.count,
    required this.scrollValue,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ChangeNotifierProvider(
          create: (_) => HomeChangeNotifier(),
          child: Column(
            children: <Widget>[
              const Navigation(),
              Expanded(
                flex: 3,
                child: Wheels(
                  count: count,
                  scrollValue: scrollValue,
                ),
              ),
              const Expanded(
                flex: 2,
                child: Buttons(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class Navigation extends StatelessWidget {
  const Navigation({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const double size = 42.0;

    return ListTile(
      trailing: CustomButton(
        onPressed: () async {
          final bool forgetMeNot = await Navigator.pushNamed(
            context,
            '/settings',
            arguments: ScreenArguments(
              count: Provider.of<HomeChangeNotifier>(context, listen: false)
                  .getCount(),
              scrollValue:
                  Provider.of<HomeChangeNotifier>(context, listen: false)
                      .getScrollValue(),
            ),
          ) as bool;

          Provider.of<HomeChangeNotifier>(context, listen: false)
              .setSavingPreference(forgetMeNot);
        },
        child: Icon(
          Icons.chevron_right_rounded,
          color: Theme.of(context).colorScheme.primary,
          semanticLabel: 'Go to app preferences',
        ),
        size: size,
      ),
    );
  }
}

class Wheels extends StatefulWidget {
  final int count;
  final int scrollValue;

  const Wheels({
    Key? key,
    this.count = 3,
    this.scrollValue = 0,
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

    WidgetsBinding.instance?.addPostFrameCallback((_) {
      int scrollValue = widget.scrollValue;

      if (scrollValue > 0) {
        const int scrollDelay = 750;

        Future.delayed(
          const Duration(milliseconds: scrollDelay),
          () {
            _scrollTo(scrollValue);
          },
        );
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

  void _scrollTo(scrollValue) {
    int value = scrollValue;
    const int scrollDuration = 2000;
    int scrollDurationPerWheel = scrollDuration ~/ _controllers.length;
    int scrollDelay = 0;

    int index = _controllers.length - 1;

    while (value > 0 && index >= 0) {
      int digit = value % _digits;

      FixedExtentScrollController controller = _controllers[index];

      controller.jumpToItem(_digits);

      Future.delayed(
        Duration(milliseconds: scrollDelay),
        () {
          controller.animateToItem(
            _digits - digit,
            duration: Duration(milliseconds: scrollDurationPerWheel),
            curve: Curves.easeInOutCubic,
          );
        },
      );

      scrollDelay += scrollDurationPerWheel ~/ 2;

      value = value ~/ _digits;
      index--;
    }
  }

  @override
  Widget build(BuildContext context) {
    const double margin = 10.0;

    Provider.of<HomeChangeNotifier>(context, listen: false).init(_controllers);

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
                          controller: controller,
                          itemExtent: itemExtent,
                          index: _controllers.indexOf(controller),
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
  final FixedExtentScrollController controller;
  final double itemExtent;
  final int index;

  const Wheel({
    Key? key,
    required this.controller,
    required this.itemExtent,
    required this.index,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Stack(
        alignment: AlignmentDirectional.center,
        children: [
          RoundedBackground(
            size: itemExtent,
          ),
          ListWheelScrollView(
            overAndUnderCenterOpacity: 0,
            physics: const NeverScrollableScrollPhysics(),
            controller: controller,
            itemExtent: itemExtent,
            children: List<Widget>.generate(
              _digits +
                  1, // there's one more item than there are digits to fabricate the closed wheel
              (index) => SquareFittedBox(
                child: Text(
                  '${index % _digits}',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.primary,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ).reversed.toList(),
          ),
          ClipRRect(
            borderRadius: BorderRadius.all(
              Radius.circular(itemExtent *
                  _borderRadiusRatio), // do not know the reason but the border radius tends to be smaller than that of the container
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                highlightColor: Colors.transparent,
                splashColor: Theme.of(context).colorScheme.shadow,
                onTap: () {
                  Provider.of<HomeChangeNotifier>(context, listen: false)
                      .scrollWheel(index);
                },
                child: Ink(
                  child: RoundedBorder(
                    size: itemExtent,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class Buttons extends StatelessWidget {
  const Buttons({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double size = 72.0;

    TextStyle textStyle = TextStyle(
      color: Theme.of(context).colorScheme.primary,
      fontWeight: FontWeight.bold,
      fontSize: size, // fixes horizontal alignment
      fontFeatures: const [
        FontFeature.caseSensitiveForms(),
      ],
    );

    return ConstrainedBox(
      constraints: const BoxConstraints(
        maxWidth: 480.0,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          CustomButton(
            onPressed: () {
              Provider.of<HomeChangeNotifier>(context, listen: false)
                  .scroll(-1);
            },
            child: Text(
              '-',
              style: textStyle,
            ),
            size: size,
          ),
          CustomButton(
            onPressed: () {
              Provider.of<HomeChangeNotifier>(context, listen: false).scroll(1);
            },
            child: Text(
              '+',
              style: textStyle,
            ),
            size: size,
          ),
        ],
      ),
    );
  }
}
