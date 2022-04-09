import 'package:flutter/material.dart';
import 'package:ticker/widgets/custom_button.dart';
import 'dart:math';
import 'dart:ui';

class Home extends StatelessWidget {
  const Home({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: const [
            Navigation(),
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
          // Navigator.pushNamed(context, '/settings');
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

class Wheels extends StatelessWidget {
  final int count;
  const Wheels({Key? key, this.count = 3}) : super(key: key);

  static double margin = 4.0;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        double width = constraints.maxWidth;
        double height = constraints.maxHeight;
        double itemExtent =
            min(200.0, (min(width, height) - 2 * margin * count) / count);

        double maxWidth = (itemExtent + margin * 2) * count;

        return Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: maxWidth,
            ),
            child: Row(
              children: List<Widget>.generate(
                count,
                (index) => Expanded(
                  child: Container(
                    margin: EdgeInsets.symmetric(horizontal: margin),
                    child: Wheel(itemExtent: itemExtent),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class Wheel extends StatelessWidget {
  final double itemExtent;

  const Wheel({Key? key, required this.itemExtent}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Stack(
        children: [
          ListWheelScrollView(
            overAndUnderCenterOpacity: 0,
            itemExtent: itemExtent,
            children: List<Widget>.generate(
              10,
              (index) => Item(
                digit: index,
              ),
            ),
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
    this.digit,
    this.borderWidth,
    Key? key,
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
              // scroll wheels
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
              // scroll wheels
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
