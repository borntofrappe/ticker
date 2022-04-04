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
              flex: 3,
              child: Wheels(),
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
                        // count down
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
                        // count up
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

class Wheels extends StatelessWidget {
  final int count;
  const Wheels({
    Key? key,
    this.count = 3,
  }) : super(key: key);

  static const int _digits = 10;
  static const double _margin = 8.0;

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double itemExtent = min(200.0, (width - 2 * _margin * count) / count);

    return Row(
      children: List<Widget>.generate(
        count,
        (index) => Expanded(
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: _margin),
            child: Wheel(
              count: _digits,
              itemExtent: itemExtent,
            ),
          ),
        ),
      ),
    );
  }
}

class Wheel extends StatelessWidget {
  final int count;
  final double itemExtent;

  const Wheel({
    Key? key,
    required this.count,
    required this.itemExtent,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Stack(
        children: [
          ListWheelScrollView(
            overAndUnderCenterOpacity: 0.0,
            itemExtent: itemExtent,
            children: List<Widget>.generate(
              count,
              (index) => Item(
                digit: index,
              ),
            ),
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
